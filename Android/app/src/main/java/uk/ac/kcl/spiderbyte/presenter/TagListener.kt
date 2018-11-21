package uk.ac.kcl.spiderbyte.presenter

import android.util.Log
import me.gujun.android.taggroup.TagGroup
import uk.ac.kcl.spiderbyte.view.TagView

/**
 * Created by Dimitris on 22/03/2018.
 *
 * Creates a listener for Tags selection that shows only relevant content.
 */
class TagListener<V : TagView> : TagGroup.OnTagClickListener, Presenter<V>() {

    /**
     * @param tag
     */
    override fun onTagClick(tag: String?) {
        getView()?.groupAnnouncements(tag!!)
    }
}