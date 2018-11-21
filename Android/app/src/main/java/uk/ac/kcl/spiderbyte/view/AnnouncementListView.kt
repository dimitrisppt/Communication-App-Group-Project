package uk.ac.kcl.spiderbyte.view

/**
 * Created by Alin on 08/02/2018.
 */
interface AnnouncementListView : BaseView {
    fun displayAnnouncementDetail(postKey : String?)
    fun setupNoAnnouncementTextView(itemCount: Int)
    fun fetchFirebaseData()
}