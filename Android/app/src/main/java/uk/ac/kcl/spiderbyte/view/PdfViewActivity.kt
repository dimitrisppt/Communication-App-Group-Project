package uk.ac.kcl.spiderbyte.view

import uk.ac.kcl.spiderbyte.R

/**
 * Created by Dimitris on 25/03/2018.
 */

import android.os.AsyncTask
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.util.Log

import com.github.barteksc.pdfviewer.PDFView
import com.github.barteksc.pdfviewer.listener.OnLoadCompleteListener
import com.github.barteksc.pdfviewer.listener.OnPageChangeListener
import com.github.barteksc.pdfviewer.listener.OnPageErrorListener
import com.github.barteksc.pdfviewer.scroll.DefaultScrollHandle
import com.shockwave.pdfium.PdfDocument

import java.io.BufferedInputStream
import java.io.IOException
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL


/**
 * This activity handles the PDF files.
 * It creates the view and hosts the pdf files by interpreting the URL given from Firebase.
 */
class PdfViewActivity : AppCompatActivity(), OnPageChangeListener, OnLoadCompleteListener, OnPageErrorListener {

    var pdfView: PDFView? = null
    private var pageNumber = 0
    private var pdfFileName: String? = null

    companion object {
        var url: String? = null
    }

    /**
     * Called when the view is being created to instantiate variables and user interface
     *
     * @param savedInstanceState : Bundle, saved instance of previous state
     */
    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pdf)
        pdfView = findViewById(R.id.pdfView)

        val pdfStream = PdfStream()

        pdfStream.execute(url)
    }

    /**
     * Status of Internet Communication
     */
    inner class PdfStream: AsyncTask<String, Void, InputStream>() {

        /**
         * Takes an array of strings that should be URL(s) and checks for success
         * then establishes a BufferedInputStream from the url connection and returns it
         *
         * @param p0 : array of String, used to house URL
         * @return BufferedInputStream, input stream that reads from the url's page
         */
        override fun doInBackground(vararg p0: String?): InputStream {
            var inputStream: InputStream? = null

            try {
                val url = URL(p0[0])
                val urlConnection = url.openConnection() as HttpURLConnection
                // Checks if the urlConnection succeeded
                if (urlConnection.responseCode == 200) {
                    inputStream = BufferedInputStream(urlConnection.inputStream)
                }
            }catch (e: IOException) {
                Log.e("Error", "Wrong Input Stream")
            }
            return inputStream!!
        }

        /**
         * Sets the properties of the pdf view
         *
         * @param result : InputStream, used by super
         */
        override fun onPostExecute(result: InputStream?) {
            super.onPostExecute(result)
            pdfView!!.fromStream(result).defaultPage(pageNumber)
                    .onPageChange(this@PdfViewActivity)
                    .enableAnnotationRendering(true)
                    .onLoad(this@PdfViewActivity)
                    .scrollHandle(DefaultScrollHandle(this@PdfViewActivity))
                    .spacing(10) // in dp
                    .onPageError(this@PdfViewActivity)
                    .load()
        }
    }


    /**
     * called when user changes pdf pages
     *
     * @param page : Int, used to update page number in view and format title
     * @param pageCount : Int, total number of pages, used to format title
     */
    override fun onPageChanged(page: Int, pageCount: Int) {
        pageNumber = page
        title = String.format("%s %s / %s", pdfFileName, page + 1, pageCount)
    }

    /**
     *Called when url is loaded, prints Bookmarks Tree
     *
     * @param nbPages : Int, used by overridden method, unused in this case
     */
    override fun loadComplete(nbPages: Int) {
        val meta = pdfView!!.documentMeta
        printBookmarksTree(pdfView!!.tableOfContents, "-")
    }

    /**
     * called in case of a page error, prints to Logcat
     *
     * @param page : Int, page number, used to debug with Logcat
     * @param t : Throwable, used by overridden method, unused in this case
     */
    override fun onPageError(page: Int, t: Throwable?) {
            Log.e("Error", "Cannot load page " + page);
    }

    /**
     * called to print bookmarks
     *
     * @param tree : List of bookmarks, used to print
     * @param sep : String, keeps track of level of tree
     */
    fun printBookmarksTree(tree: List<PdfDocument.Bookmark>, sep: String) {
        for (b in tree) {
            if (b.hasChildren()) {
                printBookmarksTree(b.children, "$sep-")
            }
        }
    }

}


