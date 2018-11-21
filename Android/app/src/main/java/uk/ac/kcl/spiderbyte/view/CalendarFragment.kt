package uk.ac.kcl.spiderbyte.view

import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v7.widget.CardView
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.text.TextUtils.split
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.TextView
import com.applandeo.materialcalendarview.CalendarView
import com.applandeo.materialcalendarview.EventDay
import uk.ac.kcl.spiderbyte.R
import com.firebase.ui.database.FirebaseRecyclerAdapter
import com.firebase.ui.database.FirebaseRecyclerOptions
import com.firebase.ui.database.ObservableSnapshotArray
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.Query
import uk.ac.kcl.spiderbyte.MainApplication
import uk.ac.kcl.spiderbyte.model.Event
import java.util.*
import kotlin.collections.ArrayList


class CalendarFragment : Fragment(), uk.ac.kcl.spiderbyte.view.CalendarView{

    private lateinit var rootView : View
    private lateinit var calendarView: View
    private var databaseReference: DatabaseReference? = null
    private var firebaseRecyclerAdapter: FirebaseRecyclerAdapter<Event, EventViewHolder>? = null
    private var recyclerView: RecyclerView? = null
    private var noEventTextView: TextView? = null
    private var noEventImageView: ImageView? = null
    private var layoutManager: LinearLayoutManager? = null
    private var clickedDate: Calendar? = Calendar.getInstance()

    /**
     * Called when the view is being created to instantiate variables and user interface
     *
     * @param inflater : LayoutInflater, is used to inflate views in the fragment
     * @param container : ViewGroup, the parent view that the fragment is attached to
     * @param savedInstanceState : Bundle, saved instance of previous state of the fragment
     * @return View : the fragment view
     */
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        super.onCreateView(inflater, container, savedInstanceState)
        rootView = inflater.inflate(R.layout.fragment_calendar, container, false)


        calendarView = rootView.findViewById<View>(R.id.calendarView) as CalendarView
        recyclerView = rootView.findViewById(R.id.eventList)
        databaseReference = FirebaseDatabase.getInstance().reference

        noEventTextView = rootView.findViewById(R.id.no_events_available)
        noEventTextView!!.visibility = View.GONE
        noEventImageView = rootView.findViewById(R.id.ic_frown_events)
        noEventImageView!!.visibility = View.GONE

        val calendar = Calendar.getInstance()
        (calendarView as CalendarView).setDate(calendar)

        return rootView
    }

    /**
     * Called to display list of events
     */
    private fun displayEventView() {
        recyclerView!!.visibility = View.VISIBLE
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
     *  function used to sort the order of events
     *
     *  @param databaseReference : DatabaseReference, used to access data from the database
     *  @return Query, gets data from the database
     */
    private fun getQuery(databaseReference: DatabaseReference): Query {
        when {
            getViewApplication().getDataManager().getEventSort() == 1 -> {
                return databaseReference.child("event").orderByChild("dateTime")
            }
            getViewApplication().getDataManager().getEventSort() == 2 -> {
                return databaseReference.child("event").orderByChild("title")
            }
            getViewApplication().getDataManager().getEventSort() == 3 -> {
                return databaseReference.child("event").orderByChild("location")
            }
        }
        return databaseReference.child("event")
    }

    /**
     * Called when the fragment becomes visible to the user
     */
    override fun onStart() {
        super.onStart()
        if (firebaseRecyclerAdapter != null) {
            firebaseRecyclerAdapter!!.startListening()
        }

        (calendarView as CalendarView).setOnDayClickListener({ eventDay->
            clickedDate = eventDay.calendar
            displayEventView()
            fetchFirebaseData()
        })
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
     * When there are no vilisible announcements to display, sets up the no announcement Text and Image
     *
     * @param itemCount : Int, number of visible announcements
     */
    override fun setupNoEventTextView(itemCount: Int) {
        if (itemCount == 0) {
            noEventTextView!!.visibility = View.VISIBLE
            noEventImageView!!.visibility = View.VISIBLE
        } else {
            noEventTextView!!.visibility = View.GONE
            noEventImageView!!.visibility = View.GONE
        }
    }

    /**
     * for search so there is no clicked date
     */
    override fun eraseClickedDay() {
        clickedDate = null
    }


    override fun getViewApplication(): MainApplication = activity?.application as MainApplication

    /**
     * Adds icons below the days in which the user have events
     *
     * @param eventArray : ObservableSnapshotArray<Event>, array of event snapshots
     * @param calendarView : CalendarView, View of the calendar. Used in this function to add icons to days
     */
    private fun addCalendarDecorator(eventArray: ObservableSnapshotArray<Event>, calendarView: CalendarView){
        val events = ArrayList<EventDay>()
        for(event in eventArray){
            if(event.mailingList.contains("all") || event.mailingList.contains(getViewApplication().getDataManager().getEmail())){
                val dateString = event.day
                if (!dateString.isBlank()){
                    val list = split(dateString,"-")
                    val year = list[0].toInt()
                    val month = list[1].toInt()
                    val day = list [2].toInt()
                    val calendarTemp = Calendar.getInstance()
                    calendarTemp.set(year,month-1,day)

                    val eventDay = EventDay(calendarTemp,R.drawable.ic_notifications_black_24dp)
                    events.add(eventDay)
                }
            }
        }
        calendarView.setEvents(events)
    }


    /**
     * called to refresh data and redo filtering
     */
    override fun fetchFirebaseData() {
        val postsQuery = getQuery(databaseReference!!)
        val options = FirebaseRecyclerOptions.Builder<Event>()
                .setQuery(postsQuery, Event::class.java)
                .build()
        firebaseRecyclerAdapter?.stopListening()
        var eventNum = 0
        firebaseRecyclerAdapter = object : FirebaseRecyclerAdapter<Event, EventViewHolder>(options) {


            override fun onBindViewHolder(holder: EventViewHolder, position: Int, model: Event) {

                //filter for email and search
                if((firebaseRecyclerAdapter!!.snapshots[position].mailingList.contains("all") || firebaseRecyclerAdapter!!.snapshots[position].mailingList.contains(getViewApplication().getDataManager().getEmail()))
                        && (firebaseRecyclerAdapter!!.snapshots[position].title.contains(getViewApplication().getDataManager().getSearchQueryText().toString())
                                || firebaseRecyclerAdapter!!.snapshots[position].desc.contains(getViewApplication().getDataManager().getSearchQueryText().toString())
                                || firebaseRecyclerAdapter!!.snapshots[position].day.contains(getViewApplication().getDataManager().getSearchQueryText().toString())
                                || firebaseRecyclerAdapter!!.snapshots[position].location.contains(getViewApplication().getDataManager().getSearchQueryText().toString())
                                || getViewApplication().getDataManager().getSearchQueryText().isNullOrBlank())){

                    //filter for empty search to set clicked date to current time
                    if(getViewApplication().getDataManager().getSearchQueryText().isNullOrBlank() && clickedDate == null){
                        clickedDate = Calendar.getInstance()
                    }

                    if(!(clickedDate == null)){ //filter so only events taking place on clicked date are shown
                        val dateList = getItem(position).day.split("-")
                        val year = dateList[0].toInt()
                        val month = dateList[1].toInt()
                        val day = dateList[2].toInt()
                        val calendarTemp = Calendar.getInstance()
                        calendarTemp.set(year,month-1,day,0,0,0)
                        val calTempList = calendarTemp.time.toString().split(" ")
                        val clickedList = clickedDate!!.time.toString().split(" ")
                        if(clickedList[0] == calTempList[0] && clickedList[1] == calTempList[1] && clickedList[2] == calTempList[2] && clickedList[5] == calTempList[5]){
                            eventNum++
                            holder.itemView.findViewById<CardView>(R.id.event_card).visibility = View.VISIBLE
                            holder.bindToPost(model)

                        }else{ //hides events
                            holder.itemView.findViewById<CardView>(R.id.event_card).layoutParams.height = 0
                            val lp = FrameLayout.LayoutParams(0,0,0)
                            holder.itemView.findViewById<CardView>(R.id.event_card).layoutParams = lp
                            holder.itemView.findViewById<CardView>(R.id.event_card).visibility = View.GONE
                        }
                    }else{ //for non empty search so event's aren't filtered out by clicked date
                        eventNum++
                        holder.itemView.findViewById<CardView>(R.id.event_card).visibility = View.VISIBLE
                        holder.bindToPost(model)
                    }
                } else { //hides events
                    holder.itemView.findViewById<CardView>(R.id.event_card).visibility = View.GONE
                    val lp = FrameLayout.LayoutParams(0,0,0)
                    holder.itemView.findViewById<CardView>(R.id.event_card).layoutParams = lp
                    holder.itemView.findViewById<CardView>(R.id.event_card).layoutParams.height = 0
                }
                setupNoEventTextView(eventNum)
            }


            override fun onCreateViewHolder(viewGroup: ViewGroup, i: Int): EventViewHolder {
                val inflater = LayoutInflater.from(viewGroup.context)
                addCalendarDecorator(snapshots, calendarView as CalendarView)
                return EventViewHolder(inflater.inflate(R.layout.list_events, viewGroup, false))
            }
        }
        firebaseRecyclerAdapter?.startListening()
        recyclerView!!.adapter = firebaseRecyclerAdapter
    }

}
