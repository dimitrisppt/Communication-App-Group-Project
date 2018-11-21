package uk.ac.kcl.spiderbyte.view

/**
 * Created by Alin on 17/03/2018.
 */


/**
 * Provides functions to implement in CalendarFragment
 */
interface CalendarView : BaseView {
    fun setupNoEventTextView(itemCount: Int)
    fun eraseClickedDay()
    fun fetchFirebaseData()
}