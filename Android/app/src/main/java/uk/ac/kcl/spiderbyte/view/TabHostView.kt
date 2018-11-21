package uk.ac.kcl.spiderbyte.view

import android.support.v7.widget.SearchView
import android.support.v7.widget.Toolbar
import android.view.Menu

/**
 * Created by Alin on 08/02/2018.
 */
interface TabHostView : BaseView {
    fun getToolBar() : Toolbar
    fun getTabTitle(tagTab : String) : String
    fun setTab(str: String)
    fun getMenu(): Menu
    fun getCurrentTab(): String
    fun setCurrentTab(tab: String)
    fun getAnnouncementListView(): AnnouncementListView
    fun getCalendarView(): CalendarView
    fun getSearchView(): SearchView
}