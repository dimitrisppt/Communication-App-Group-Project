package uk.ac.kcl.spiderbyte.model

/**
 * Created by Alin on 09/02/2018.
 */

data class Announcement(var author : String, var title : String, var content : String, var dateTime: String, var mailingList: ArrayList<String>, var readingList: ArrayList<String>, var tag: String, var photoB64: String, var pdf: String, var hasEvent: Boolean) {

    constructor() : this("", "", "","", arrayListOf<String>(), arrayListOf<String>(), "", "", "", false)
    fun toMap(): Map<String, Any> {
        val fetchResult = mapOf(
                "author" to author,
                "title" to title,
                "content" to content,
                "dateTime" to dateTime,
                "mailingList" to mailingList,
                "readingList" to readingList,
                "tag" to tag,
                "photoB64" to photoB64,
                "pdf" to pdf,
                "hasEvent" to hasEvent)

        return if(isValidAnnouncement()) {
            fetchResult
        }
        else {
            mapOf(
            )
        }
    }

    fun isValidAnnouncement(): Boolean {
        if(author.isNotEmpty() && title.isNotEmpty() && content.isNotEmpty() && dateTime.isNotEmpty() && tag.isNotEmpty() && photoB64.isNotEmpty()) {
            return true
        }
        return false
    }
}