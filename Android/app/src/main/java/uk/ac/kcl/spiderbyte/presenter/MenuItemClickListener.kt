package uk.ac.kcl.spiderbyte.presenter

import android.view.MenuItem
import uk.ac.kcl.spiderbyte.view.TabHostView

/**
 * Created by Alin on 25/03/2018.
 */
class MenuItemClickListener <V : TabHostView> : Presenter<V>(), MenuItem.OnMenuItemClickListener{
    override fun onMenuItemClick(p0: MenuItem?): Boolean {
        if (getView()?.getCurrentTab() == "0") {
            getView()?.getViewApplication()!!.getDataManager().setAnnouncementSort(p0!!.itemId)
            getView()?.getAnnouncementListView()?.fetchFirebaseData()
        } else {
            getView()?.getViewApplication()!!.getDataManager().setEventSort(p0!!.itemId)
            getView()?.getCalendarView()?.fetchFirebaseData()
        }
        return true
    }
}