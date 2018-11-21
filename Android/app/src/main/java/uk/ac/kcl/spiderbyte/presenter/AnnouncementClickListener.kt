package uk.ac.kcl.spiderbyte.presenter

import android.view.View
import uk.ac.kcl.spiderbyte.view.AnnouncementListView

/**
 * Created by Alin on 14/02/2018.
 */
class AnnouncementClickListener<V : AnnouncementListView>(postKey: String?) : View.OnClickListener, Presenter<V>() {
    private var postKey : String? = postKey
    override fun onClick(v: View?) {
        getView()?.displayAnnouncementDetail(postKey = this.postKey)
    }
}