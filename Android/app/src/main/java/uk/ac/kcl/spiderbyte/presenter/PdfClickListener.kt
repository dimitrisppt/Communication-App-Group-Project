package uk.ac.kcl.spiderbyte.presenter

import android.view.View
import uk.ac.kcl.spiderbyte.view.PdfView

/**
 * Created by Dimitris on 25/03/2018.
 *
 * Creates a listener for PDF floating button and enables the users to see PDF files.
 */
class PdfClickListener<V: PdfView> : Presenter<V>(), View.OnClickListener {

    /**
     * @param view
     */
    override fun onClick(view: View?) {
        getView()?.setupPdfView()
    }
}