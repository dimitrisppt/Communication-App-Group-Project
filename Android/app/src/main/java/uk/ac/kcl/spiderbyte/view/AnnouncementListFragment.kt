package uk.ac.kcl.spiderbyte.view

import android.content.ContentValues
import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.content.Intent
import android.support.v7.widget.CardView
import android.util.Log
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import com.firebase.ui.database.FirebaseRecyclerAdapter
import com.firebase.ui.database.FirebaseRecyclerOptions
import uk.ac.kcl.spiderbyte.R
import uk.ac.kcl.spiderbyte.model.Announcement
import android.widget.*
import com.google.firebase.database.*
import me.gujun.android.taggroup.TagGroup
import uk.ac.kcl.spiderbyte.MainApplication
import uk.ac.kcl.spiderbyte.presenter.AnnouncementClickListener
import uk.ac.kcl.spiderbyte.presenter.TagListener
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.Transaction
import com.google.firebase.database.MutableData
import com.google.firebase.database.DatabaseReference




/**
 * Creates a fragment that holds a list of announcements.
 */
class AnnouncementListFragment : Fragment(), AnnouncementListView, TagView  {

    private var databaseReference: DatabaseReference? = null
    private var firebaseRecyclerAdapter: FirebaseRecyclerAdapter<Announcement, AnnouncementViewHolder>? = null
    private var recyclerView: RecyclerView? = null
    private var layoutManager: LinearLayoutManager? = null
    private var noAnnouncementTextView: TextView? = null
    private var noAnnouncementImageView: ImageView? = null
    private var announcementCard: CardView? = null
    private var mTagGroup: TagGroup? = null
    private var postListener : ValueEventListener? = null
    private var activeTag: MutableList<String> = arrayListOf("General") as MutableList<String>
    private lateinit var rootView: View
    private lateinit var availableAnnouncements: ArrayList<String>
    private lateinit var postReference : DatabaseReference


    /**
     * Called when the view is being created to instantiate variables and user interface
     *
     * @param inflater : LayoutInflater, is used to inflate views in the fragment
     * @param container : ViewGroup, the parent view that the fragment is attached to
     * @param savedInstanceState : Bundle, saved instance of previous state of the fragment
     * @return View : the fragment view
     */
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        super.onCreateView(inflater, container, savedInstanceState)
        rootView = inflater.inflate(R.layout.fragment_announcement_list, container, false)

        postReference = FirebaseDatabase.getInstance().reference
                .child("announcements")

        databaseReference = FirebaseDatabase.getInstance().reference
        recyclerView = rootView.findViewById(R.id.announcementList)
        announcementCard = rootView.findViewById(R.id.announcement_card)
        recyclerView!!.setHasFixedSize(true)

        noAnnouncementTextView = rootView.findViewById(R.id.no_announcements_available)
        noAnnouncementTextView!!.visibility = View.GONE
        noAnnouncementImageView = rootView.findViewById(R.id.ic_frown)
        noAnnouncementImageView!!.visibility = View.GONE

        setupTags(rootView)
        checkUserIsRegistered( FirebaseDatabase.getInstance().reference.child("app-users"))

        return rootView
    }

    /**
     * Called when the fragment's activity has been created and this fragment's view hierarchy instantiated
     *
     * @param savedInstanceState : Bundle, saved instance of previous state of the fragment
     */
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        layoutManager = LinearLayoutManager(activity)
        recyclerView!!.layoutManager = layoutManager
        fetchFirebaseData()
    }

    /**
     *  function used to sort the order of announcements
     *
     *  @param databaseReference : DatabaseReference, used to access data from the database
     *  @return Query, gets data from the database
     */
    private fun getQuery(databaseReference: DatabaseReference): Query {
        when {
            getViewApplication().getDataManager().getAnnouncementSort() == 1 -> {
                return databaseReference.child("announcements").orderByChild("priority")
            }
            getViewApplication().getDataManager().getAnnouncementSort() == 2 -> {
                return databaseReference.child("announcements").orderByChild("title")
            }
            getViewApplication().getDataManager().getAnnouncementSort() == 3 -> {
                return databaseReference.child("announcements").orderByChild("author")
            }

        }
        return databaseReference.child("announcements")
    }

    /**
     * Check if the student is registered on Firebase as an application user.
     */
    private fun checkUserIsRegistered(postRef: DatabaseReference) {
        postRef.runTransaction(object : Transaction.Handler {
            override fun doTransaction(mutableData: MutableData): Transaction.Result {
                val appUsers : Map<String, ArrayList<String>> = mutableData.value as Map<String, ArrayList<String>>?
                        ?: return Transaction.success(mutableData)

                if(appUsers["Android"]!!.isNotEmpty() && appUsers["Android"]!!.contains("none")) {
                    appUsers["Android"]!!.set(0, getViewApplication().getDataManager().getEmail())
                }
                else {
                    if (!appUsers["Android"]!!.contains(getViewApplication().getDataManager().getEmail())) {
                        appUsers["Android"]!!.add(getViewApplication().getDataManager().getEmail())
                    }
                }

                // Set value and report transaction success
                mutableData.setValue(appUsers)
                return Transaction.success(mutableData)
            }

            override fun onComplete(databaseError: DatabaseError?, b: Boolean,
                                    dataSnapshot: DataSnapshot) {
                // Transaction completed
                Log.d("OnComplete", "postTransaction:onComplete:$databaseError")
            }
        })
    }


    /**
     * Called when the fragment becomes visible to the user
     */
    override fun onStart() {
        super.onStart()

        val postListener = object : ValueEventListener {
            override fun onDataChange(dataSnapshot: DataSnapshot) {
            }

            override fun onCancelled(databaseError: DatabaseError) {
                Log.w(ContentValues.TAG, "loadPost:onCancelled", databaseError.toException())
                Toast.makeText(this@AnnouncementListFragment.context, "Failed to load announcement list",
                        Toast.LENGTH_SHORT).show()
            }
        }
        postReference.addValueEventListener(postListener)
        this.postListener = postListener


        if (firebaseRecyclerAdapter != null) {
            firebaseRecyclerAdapter!!.startListening()
        }
    }


    /**
     * Called when the fragment stops being visible to the user
     */
    override fun onStop() {
        super.onStop()
        if (firebaseRecyclerAdapter != null) {
            firebaseRecyclerAdapter!!.stopListening()
        }
    }


    /**
     * called to go to the details page of an announcement
     *
     * @param postKey : String, I.D of an announcement
     */
    override fun displayAnnouncementDetail(postKey : String?) {
        val intent = Intent(activity, AnnouncementDetailActivity::class.java)
        intent.putExtra(getString(R.string.postKey), postKey)
        startActivity(intent)
    }

    /**
     * When there are no vilisible announcements to display, sets up the no announcement Text and Image
     *
     * @param itemCount : Int, number of visible announcements
     */
    override fun setupNoAnnouncementTextView(itemCount: Int) {
        if (itemCount == 0) {
            noAnnouncementTextView!!.visibility = View.VISIBLE
            noAnnouncementImageView!!.visibility = View.VISIBLE

        } else {
            noAnnouncementTextView!!.visibility = View.GONE
            noAnnouncementImageView!!.visibility = View.GONE
        }
    }

    /**
     * Called to set up initial active announcement tags
     *
     * @param rootView : View, the fragment view
     */
    override fun setupTags(rootView: View) {
        mTagGroup = rootView.findViewById(R.id.tag_group)
        val tags : MutableList<String> = arrayListOf("General", "Important", "Careers", "Modules")
        mTagGroup!!.setTags(tags)

        val tagListener = TagListener<AnnouncementListFragment>()
        tagListener.onAttach(this)
        mTagGroup!!.setOnTagClickListener(tagListener)
    }

    /**
     *  Called when a tag is clicked to toggle announcement tags between active and inactive
     *
     *  @param tag : String, tag to be toggled
     */
    override fun groupAnnouncements(tag: String) {
        if(!activeTag.contains(tag)){
            activeTag.add(tag)
            Toast.makeText(this.context,
                    (tag + " has been added")
                    , Toast.LENGTH_SHORT).show()
        }else{
            activeTag.remove(tag)
            Toast.makeText(this.context,
                    (tag + " has been removed")
                    , Toast.LENGTH_SHORT).show()
        }



        fetchFirebaseData()
    }



    /**
     * Refreshes the data from Firebase database
     */
    override fun fetchFirebaseData() {

        // Retrieves the query from Firebase
        val postsQuery = getQuery(databaseReference!!)
        val options = FirebaseRecyclerOptions.Builder<Announcement>()
                .setQuery(postsQuery, Announcement::class.java)
                .build()
        firebaseRecyclerAdapter?.stopListening()
        availableAnnouncements = arrayListOf<String>()
        firebaseRecyclerAdapter = object : FirebaseRecyclerAdapter<Announcement, AnnouncementViewHolder>(options) {

            /**
             * @param viewGroup : The view group is an instance of the base class for layouts and views containers.
             * @param i : The position of view item
             */
            override fun onCreateViewHolder(viewGroup: ViewGroup, i: Int): AnnouncementViewHolder {
                val inflater = LayoutInflater.from(viewGroup.context)
                return AnnouncementViewHolder(inflater.inflate(R.layout.list_annonucements, viewGroup, false))
            }

            /**
             * @param viewHolder : A viewHolder describes an item view and metadata about its place within the RecyclerView
             * @param position : Position of each viewHolder
             * @param model : Using Announcement as the model of the view
             */
            override fun onBindViewHolder(viewHolder: AnnouncementViewHolder, position: Int, model: Announcement) {

                // Displays the announcement depending on the selected tag, or the result from the search bar
                if (activeTag.contains(firebaseRecyclerAdapter!!.snapshots[position].tag) && (firebaseRecyclerAdapter!!.snapshots[position].mailingList.contains("all")
                        || firebaseRecyclerAdapter!!.snapshots[position].mailingList.contains(getViewApplication().getDataManager().getEmail()))
                        && (firebaseRecyclerAdapter!!.snapshots[position].title.contains(getViewApplication().getDataManager().getSearchQueryText().toString())
                        || firebaseRecyclerAdapter!!.snapshots[position].author.contains(getViewApplication().getDataManager().getSearchQueryText().toString())
                        || firebaseRecyclerAdapter!!.snapshots[position].dateTime.contains(getViewApplication().getDataManager().getSearchQueryText().toString())
                        || getViewApplication().getDataManager().getSearchQueryText().isNullOrBlank())) {

                    val postRef = getRef(position)
                    val postKey = postRef.key
                    availableAnnouncements.add(postKey)
                    setupNoAnnouncementTextView(availableAnnouncements.size)
                    viewHolder.itemView.findViewById<CardView>(R.id.announcement_card).bringToFront()
                    val announcementClickListener = AnnouncementClickListener<AnnouncementListView>(postKey)
                    announcementClickListener.onAttach(this@AnnouncementListFragment as AnnouncementListView)
                    viewHolder.itemView.setOnClickListener(announcementClickListener)
                    viewHolder.bindToPost(model)
                  
                // Hides the announcements
                } else {
                    viewHolder.itemView.findViewById<CardView>(R.id.announcement_card).layoutParams.height = 0
                    val lp = FrameLayout.LayoutParams(0,0,0)
                    viewHolder.itemView.findViewById<CardView>(R.id.announcement_card).layoutParams = lp
                    viewHolder.itemView.findViewById<CardView>(R.id.announcement_card).visibility = View.GONE
                }
            }

            override fun onDataChanged() {
                super.onDataChanged()
                setupNoAnnouncementTextView(availableAnnouncements.size)
            }
        }
        firebaseRecyclerAdapter?.startListening()
        recyclerView!!.adapter = firebaseRecyclerAdapter
    }

    override fun getViewApplication(): MainApplication = activity?.application as MainApplication

}

