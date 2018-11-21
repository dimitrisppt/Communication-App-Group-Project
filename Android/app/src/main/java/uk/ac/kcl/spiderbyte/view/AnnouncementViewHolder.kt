package uk.ac.kcl.spiderbyte.view

import android.content.Context
import android.graphics.BitmapFactory
import android.widget.TextView
import android.support.v7.widget.RecyclerView
import android.util.Base64
import android.util.Log
import android.view.View
import android.widget.ImageView
import com.applandeo.materialcalendarview.utils.DateUtils
import uk.ac.kcl.spiderbyte.R
import uk.ac.kcl.spiderbyte.model.Announcement
import java.text.SimpleDateFormat
import java.time.LocalDate
import java.util.*
import android.graphics.Bitmap.createScaledBitmap
import android.graphics.Typeface
import uk.ac.kcl.spiderbyte.MainApplication


/**
 * Created by Alin on 09/02/2018.
 */
class AnnouncementViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    private var titleView: TextView = itemView.findViewById(R.id.announcement_title)
    private var authorView: TextView = itemView.findViewById(R.id.announcement_author)
    private var contentView: TextView = itemView.findViewById(R.id.announcement_content)
    private var dateTimeView: TextView = itemView.findViewById(R.id.announcement_dateTime)
    private var photoImageView: ImageView = itemView.findViewById(R.id.post_author_photo)

    /**
     * @param announcement : Retrieves the data from the model which is connected on Firebase Database
     */
    fun bindToPost(announcement: Announcement) {
        titleView.text = announcement.title
        authorView.text = announcement.author
        contentView.text = announcement.content

        if (announcement.readingList.contains(MainApplication.instance.getDataManager().getEmail())) {
            titleView.setTypeface(null, Typeface.NORMAL)
            contentView.setTypeface(null, Typeface.NORMAL)
        }
        else {
            titleView.setTypeface(null, Typeface.BOLD)
            contentView.setTypeface(null, Typeface.BOLD)
        }

        // Converts the date from database in usable format.
        val dateTimeList = announcement.dateTime.split(" ")
        val dateList = dateTimeList[0].split("-")
        val timeList = dateTimeList[1].split(":")
        val year = dateList[0].toInt()
        val month = dateList[1].toInt()
        val day = dateList[2].toInt()
        val hour = timeList[0].toInt()
        val min = timeList[1].toInt()
        val sec = timeList[2].toInt()
        val tempCalendar = Calendar.getInstance()
        tempCalendar.set(year,month-1,day,hour,min,sec)
        val announcementTime = tempCalendar.timeInMillis

        dateTimeView.text = getTimeAgo(announcementTime)

        // Converts a Base64 string to an array of Bytes
        val imageAsBytes = Base64.decode(announcement.photoB64, Base64.DEFAULT)
        photoImageView = itemView.findViewById<ImageView>(R.id.post_author_photo)
        photoImageView.setImageBitmap(BitmapFactory.decodeByteArray(imageAsBytes,0, imageAsBytes.size))

    }

    /**
     * @param time : Gets the time from Firebase and changes its format
     *               to human readable form.
     */
    fun getTimeAgo(time: Long): String {

        val SECOND_MILLIS: Long = 1000
        val MINUTE_MILLIS: Long = 60 * SECOND_MILLIS
        val HOUR_MILLIS: Long = 60 * MINUTE_MILLIS
        val DAY_MILLIS: Long = 24 * HOUR_MILLIS
        val WEEK_MILLIS: Long = 7 * DAY_MILLIS
        val MONTH_MILLIS: Long = 30 * DAY_MILLIS
        val YEAR_MILLIS: Long =  365 * DAY_MILLIS

        val nowCalendar = Calendar.getInstance()
        nowCalendar.timeZone = TimeZone.getDefault()
        val now = nowCalendar.timeInMillis

        val diff = (now + HOUR_MILLIS) - time
        return if (diff < 3 * SECOND_MILLIS) {
            "Just now"
        } else if (diff < 60 * SECOND_MILLIS) {
            (diff / SECOND_MILLIS).toString() + " seconds ago"
        } else if (diff < 2 * MINUTE_MILLIS) {
            "A minute ago"
        } else if (diff < 60 * MINUTE_MILLIS) {
            (diff / MINUTE_MILLIS).toString() + " minutes ago"
        } else if (diff < 120 * MINUTE_MILLIS) {
            "An hour ago"
        } else if (diff < 24 * HOUR_MILLIS) {
            (diff / HOUR_MILLIS).toString() + " hours ago"
        } else if (diff < 48 * HOUR_MILLIS) {
            "Yesterday"
        } else if (diff < 7 * DAY_MILLIS){
            (diff / DAY_MILLIS).toString() + " days ago"
        } else if (diff < 2 * WEEK_MILLIS) {
            "Last week"
        } else if (diff < 4 * WEEK_MILLIS) {
            (diff / WEEK_MILLIS).toString() + " weeks ago"
        } else if (diff < 2 * MONTH_MILLIS) {
            "Last month"
        } else if (diff < 12 * MONTH_MILLIS) {
            (diff / MONTH_MILLIS).toString() + " months ago"
        } else if (diff < 2 * YEAR_MILLIS) {
            "Last year"
        } else {
            (diff / YEAR_MILLIS).toString() + " years ago"
        }
    }




}
