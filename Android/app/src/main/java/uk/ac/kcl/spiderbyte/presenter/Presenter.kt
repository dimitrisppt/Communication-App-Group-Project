package uk.ac.kcl.spiderbyte.presenter

import uk.ac.kcl.spiderbyte.view.BaseView

/**
 * Created by Alin on 08/02/2018.
 */
open class Presenter<V : BaseView> : BasePresenter<V> {
    private var view : V? = null
    override fun onAttach(view: V) {
        this.view = view
    }
    fun getView() : V? {
        return view
    }
}