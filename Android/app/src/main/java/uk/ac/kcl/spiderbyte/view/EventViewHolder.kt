package uk.ac.kcl.spiderbyte.view

import android.widget.TextView
import android.support.v7.widget.RecyclerView
import android.view.View
import org.w3c.dom.Text
import uk.ac.kcl.spiderbyte.R
import uk.ac.kcl.spiderbyte.model.Announcement
import uk.ac.kcl.spiderbyte.model.Event


/**
 * Created by Alin on 09/02/2018.
 */
class EventViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    private var titleView: TextView = itemView.findViewById(R.id.event_title)
    private var descView: TextView = itemView.findViewById(R.id.event_desc)
    private var timeView: TextView = itemView.findViewById(R.id.event_time)
    private var location: TextView = itemView.findViewById(R.id.event_location)
    private var day: TextView = itemView.findViewById(R.id.event_day)

    /**
     * @param event
     */
    fun bindToPost(event: Event) {
        titleView.text = event.title
        descView.text = event.desc
        timeView.text = (event.starttime + " - " + event.endtime)
        location.text = event.location
        day.text = event.day
    }
}