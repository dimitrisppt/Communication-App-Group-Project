package uk.ac.kcl.spiderbyte.model

/**
 * Created by Alin on 09/02/2018.
 */
data class Event(var title : String, var desc : String, var day : String, var starttime: String, var endtime: String, var location: String, var mailingList: ArrayList<String> ) {
    constructor() : this("", "", "", "", "", "", arrayListOf<String>())
    fun toMap(): Map<String, Any> {
        val fetchResult = mapOf(
                "title" to title,
                "desc" to desc,
                "day" to day,
                "starttime" to starttime,
                "endtime" to endtime,
                "location" to location,
                "mailingList" to mailingList)
        return if(isValidEvent()) {
            fetchResult
        }
        else {
            mapOf(
            )
        }
    }

    fun isValidEvent(): Boolean {
        if(title.isNotEmpty() && desc.isNotEmpty() && day.isNotEmpty() && starttime.isNotEmpty() && endtime.isNotEmpty() && location.isNotEmpty()) {
            return true
        }
        return false
    }
}