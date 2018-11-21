package uk.ac.kcl.spiderbyte.view

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import uk.ac.kcl.spiderbyte.R

import kotlinx.android.synthetic.main.activity_announcement_detail.*
import android.widget.Toast
import android.content.ContentValues.TAG
import android.content.DialogInterface
import android.content.Intent
import android.graphics.BitmapFactory
import android.support.design.widget.FloatingActionButton
import android.support.v7.app.AlertDialog
import android.util.Base64
import android.util.Log
import android.view.View
import android.widget.ImageView

import android.widget.TextView
import br.tiagohm.markdownview.MarkdownView
import com.github.clans.fab.FloatingActionMenu
import com.google.firebase.database.*
import uk.ac.kcl.spiderbyte.MainApplication
import uk.ac.kcl.spiderbyte.model.Announcement
import com.google.firebase.database.DataSnapshot
import com.google.firebase.internal.FirebaseAppHelper
import uk.ac.kcl.spiderbyte.model.Event
import uk.ac.kcl.spiderbyte.presenter.EventClickListener
import uk.ac.kcl.spiderbyte.presenter.PdfClickListener



class AnnouncementDetailActivity : AppCompatActivity(), AnnouncementDetailView, PdfView {

    private var postKey : String? = null
    private lateinit var postReference : DatabaseReference
    private lateinit var eventReference : DatabaseReference
    private var postListener : ValueEventListener? = null
    private var eventInfoListener : ValueEventListener? = null
    private lateinit var announcementAuthor : TextView
    private lateinit var announcementTitle : TextView
    private lateinit var announcementBody : MarkdownView
    private lateinit var announcementImage : ImageView
    private lateinit var pdfButton : com.github.clans.fab.FloatingActionButton
    private lateinit var eventButton : com.github.clans.fab.FloatingActionButton
    private var pdfURL : String? = "https://stormy-reef-95988.herokuapp.com/listAnnouncements/pdf/"
    private var pdfContent: String? = null
    private var announcementHasEvent: Boolean? = null
    private lateinit var floatingActionMenu: FloatingActionMenu
    private var eventTitle: String? = null
    private var eventDescription: String? = null
    private var eventLocation: String? = null
    private var eventStartTime: String? = null
    private var eventEndTime: String? = null


    /**
     * Called when the view is being created to instantiate variables and user interface
     *
     * @param savedInstanceState : Bundle, saved instance of previous state
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_announcement_detail)
        toolbar.title = ""
        setSupportActionBar(toolbar)

        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        postKey = intent.getStringExtra(getString(R.string.postKey))
        Log.d("Key", postKey)
        if (postKey == null) {
            Toast.makeText(this, "Announcement details could not be loaded", Toast.LENGTH_LONG).show()
            throw IllegalArgumentException("Post key not found")
        }
        postReference = FirebaseDatabase.getInstance().reference
                .child("announcements").child(postKey)


        // Connects the xml files with the code
        announcementAuthor = findViewById(R.id.announcement_author)
        announcementTitle = findViewById(R.id.announcement_title)
        announcementBody = findViewById(R.id.announcement_content)
        announcementImage = findViewById(R.id.post_author_photo)
        pdfButton = findViewById(R.id.pdf_button)
        eventButton = findViewById(R.id.event_button)
        floatingActionMenu = findViewById(R.id.floating_menu)

        pdfURL += postKey
        pdfURL += ".pdf"

        // Creates an instance of the listener and attaches it to the PDF floating button
        val pdfButtonListener = PdfClickListener<AnnouncementDetailActivity>()
        pdfButtonListener.onAttach(this)
        pdfButton.setOnClickListener(pdfButtonListener)

        // Creates an instance of the listener and attaches it to the Event floating button
        val eventButtonListener = EventClickListener<AnnouncementDetailActivity>()
        eventButtonListener.onAttach(this)
        eventButton.setOnClickListener(eventButtonListener)
    }

    /**
     * Called when the fragment becomes visible to the user
     */
    override fun onStart() {
        super.onStart()
        val postListener = object : ValueEventListener {
            override fun onDataChange(dataSnapshot: DataSnapshot) {

                val announcement = dataSnapshot.getValue(Announcement::class.java)

                // Initialises the TextViews with the data from Firebase
                announcementAuthor.text = announcement?.author
                announcementTitle.text = announcement?.title
                announcementBody.loadMarkdown(announcement?.content)
                pdfContent = announcement?.pdf
                announcementHasEvent = announcement?.hasEvent
                // Converts a Base64 string to an array of Bytes
                var imageAsBytes = Base64.decode(announcement?.photoB64, Base64.DEFAULT)
                announcementImage.setImageBitmap(BitmapFactory.decodeByteArray(imageAsBytes,0, imageAsBytes.size))

                if (pdfContent.equals("")) {
                    pdfButton.visibility = View.GONE
                }

                if (announcementHasEvent == false) {
                    eventButton.visibility = View.GONE

                } else {

                    eventReference = FirebaseDatabase.getInstance().reference
                            .child("event").child(postKey)
                    val eventListener = object : ValueEventListener {

                        /**
                         * @param dataSnapshot : Contains data from a Firebase Database location,
                         *                       any time you read Database data, you receive the data
                         *                       as a DataSnapshot.
                         */
                        override fun onDataChange(dataSnapshot: DataSnapshot) {
                            val event = dataSnapshot.getValue(Event::class.java)

                            // Initialises the TextViews with the data from Firebase
                            eventTitle = event?.title
                            eventLocation = event?.location
                            eventStartTime = event?.starttime
                            eventEndTime = event?.endtime
                            eventDescription = event?.desc

                        }

                        /**
                         * @param databaseError : Instances of DatabaseError are passed to callbacks when an operation failed,
                         *                        they contain a description of the specific error that occurred.
                         */
                        override fun onCancelled(databaseError: DatabaseError) {
                            Log.w(TAG, "loadEvent:onCancelled", databaseError.toException())
                            Toast.makeText(this@AnnouncementDetailActivity, "Failed to load event",
                                    Toast.LENGTH_SHORT).show()
                        }
                    }
                    eventReference.addValueEventListener(eventListener)
                    eventInfoListener = eventListener

                }

                if (announcementHasEvent == false && pdfContent.equals("")) {
                    floatingActionMenu.visibility = View.GONE
                }
            }

            /**
             * @param databaseError : Instances of DatabaseError are passed to callbacks when an operation failed,
             *                        they contain a description of the specific error that occurred.
             */
            override fun onCancelled(databaseError: DatabaseError) {
                Log.w(TAG, "loadPost:onCancelled", databaseError.toException())
                Toast.makeText(this@AnnouncementDetailActivity, "Failed to load announcement",
                        Toast.LENGTH_SHORT).show()
            }
        }
        postReference.addValueEventListener(postListener)
        this.postListener = postListener
    }

    /**
     * Called when the fragment stops being visible to the user
     */
    override fun onStop() {
        super.onStop()
        if (postListener != null) {
            postReference.removeEventListener(postListener)
        }
    }
  
    /**
     * Called when pdf button is clicked to set up the PdfViewActivity
     */
    override fun setupDialogAlert() {
        val builder = AlertDialog.Builder(this@AnnouncementDetailActivity)
        builder.setTitle(eventTitle)
        builder.setMessage(eventLocation + "\n" + eventStartTime + " - " + eventEndTime + "\n" + eventDescription)
        val positiveText = "Close"
        builder.setPositiveButton(positiveText,
                object:DialogInterface.OnClickListener {
                    override fun onClick(dialog:DialogInterface, which:Int) {
                        if (eventInfoListener != null) {
                            eventReference.removeEventListener(eventInfoListener)
                        }
                    }
                })
        val dialog = builder.create()
        dialog.show()
    }

    /**
     * Creates the activity that hosts the PDF.
     */
    override fun setupPdfView() {
        PdfViewActivity.url = pdfURL
        val pdfActivity = Intent(this@AnnouncementDetailActivity, PdfViewActivity::class.java)
        this@AnnouncementDetailActivity.startActivity(pdfActivity)
    }

    override fun getViewApplication(): MainApplication = application as MainApplication

}

