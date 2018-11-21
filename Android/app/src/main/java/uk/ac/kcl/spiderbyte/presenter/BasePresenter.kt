package uk.ac.kcl.spiderbyte.presenter

import uk.ac.kcl.spiderbyte.view.BaseView

/**
 * Created by Alin on 08/02/2018.
 */
interface BasePresenter<in V : BaseView> {
    fun onAttach(view : V)
}