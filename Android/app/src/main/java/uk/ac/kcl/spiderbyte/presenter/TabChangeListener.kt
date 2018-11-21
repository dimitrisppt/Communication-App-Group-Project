package uk.ac.kcl.spiderbyte.presenter

import android.support.design.widget.TabLayout
import uk.ac.kcl.spiderbyte.R
import uk.ac.kcl.spiderbyte.view.TabHostView

/**
 * Created by Alin on 08/02/2018.
 */
class TabChangeListener<V : TabHostView> : TabLayout.OnTabSelectedListener, Presenter<V>() {
    override fun onTabReselected(tab: TabLayout.Tab?) {
    }

    override fun onTabUnselected(tab: TabLayout.Tab?) {
    }

    private fun setMenuItemsVisible(bool: Boolean) {
        getView()?.getMenu()!!.findItem(R.id.action_search).isVisible = bool
        getView()?.getMenu()!!.findItem(1).isVisible = bool
        getView()?.getMenu()!!.findItem(2).isVisible = bool
        getView()?.getMenu()!!.findItem(3).isVisible = bool
    }
    override fun onTabSelected(tab: TabLayout.Tab?) {

        getView()?.getSearchView()?.setQuery("",false)
        getView()?.getToolBar()?.collapseActionView()


        getView()?.getToolBar()?.title = getView()?.getTabTitle(tab?.tag as String)
        getView()?.setTab(tab?.tag as String)

        if(tab?.tag == "2") {
            setMenuItemsVisible(false)
        }
        else {
            setMenuItemsVisible(true)
            if(tab?.tag == "0") {
                getView()?.getMenu()!!.findItem(3).title = "Sort by author"
                getView()?.getAnnouncementListView()?.fetchFirebaseData()
            }
            else {
                getView()?.getMenu()!!.findItem(3).title = "Sort by venue"
                getView()?.getCalendarView()?.fetchFirebaseData()
            }
        }

    }

}