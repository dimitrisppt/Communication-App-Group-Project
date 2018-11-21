package uk.ac.kcl.spiderbyte.view

import android.view.View

/**
 * Created by Dimitris on 22/03/2018.
 */
interface TagView: BaseView {
    fun setupTags(rootView: View)
    fun groupAnnouncements(tag: String)
}