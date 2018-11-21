package uk.ac.kcl.spiderbyte.presenter

import android.util.Log
import uk.ac.kcl.spiderbyte.view.TabHostView

/**
 * Created by Aakash on 23/03/2018.
 */
class SearchListener<V: TabHostView>: android.support.v7.widget.SearchView.OnQueryTextListener, Presenter<V>(){


    override fun onQueryTextSubmit(query: String): Boolean {
        getView()?.getViewApplication()?.getDataManager()?.setSearchQueryText(query)
        if(getView()?.getCurrentTab() == "0"){
            getView()?.getAnnouncementListView()?.fetchFirebaseData()
        }else{
            getView()?.getCalendarView()?.eraseClickedDay()
            getView()?.getCalendarView()?.fetchFirebaseData()
        }
        return true
    }


    override fun onQueryTextChange(query: String): Boolean {
        getView()?.getViewApplication()?.getDataManager()?.setSearchQueryText(query)
        if(getView()?.getCurrentTab() == "0"){
            getView()?.getAnnouncementListView()?.fetchFirebaseData()
        }else{
            getView()?.getCalendarView()?.eraseClickedDay()
            getView()?.getCalendarView()?.fetchFirebaseData()
        }
        return true
    }
}