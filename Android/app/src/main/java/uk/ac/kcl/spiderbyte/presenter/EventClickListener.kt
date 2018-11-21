package uk.ac.kcl.spiderbyte.presenter

import android.view.View
import uk.ac.kcl.spiderbyte.view.AnnouncementDetailView

/**
 * Created by Dimitris on 28/03/2018.
 *
 * Creates a listener that is connected to AnnouncementDetailView and on click creates a DialogAlert.
 */
class EventClickListener<V: AnnouncementDetailView> : Presenter<V>(), View.OnClickListener {

    /**
     * @param view
     */
    override fun onClick(view: View?) {
        getView()?.setupDialogAlert()
    }
}