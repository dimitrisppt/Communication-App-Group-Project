package uk.ac.kcl.spiderbyte.view

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.TextView
import uk.ac.kcl.spiderbyte.R

/**
 * Created by Dimitris on 21/03/2018.
 *
 * Contains feedback information about the application.
 */
class FeedbackActivity: AppCompatActivity() {

    private var feedbackTitle: TextView? = null
    private var feedbackTitleDesc: TextView? = null
    private var feedbackAddressTitle: TextView? = null
    private var feedbackAddressDesc: TextView? = null
    private var feedbackEnquiriesTitle: TextView? = null
    private var feedbackEnquiriesDesc: TextView? = null
    private var feedbackCareersTitle: TextView? = null
    private var feedbackCareersDesc: TextView? = null
    private var feedbackReferenceTitle: TextView? = null
    private var feedbackReferenceDesc: TextView? = null
    private var feedbackTranscriptTitle: TextView? = null
    private var feedbackTranscriptDesc: TextView? = null

    /**
     * @param savedInstanceState : A reference to a Bundle object that is passed into the
     *                             onCreate method of every Android Activity.
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_feedback)
        setupAboutView()
    }

    private fun setupAboutView() {
        feedbackTitle = findViewById(R.id.title_textView)
        feedbackTitleDesc = findViewById(R.id.title_desc_textView)
        feedbackAddressTitle = findViewById(R.id.address_textView)
        feedbackAddressDesc = findViewById(R.id.address_desc_textView)
        feedbackEnquiriesTitle = findViewById(R.id.enquiries_textView)
        feedbackEnquiriesDesc = findViewById(R.id.enquiries_desc_textView)
        feedbackCareersTitle = findViewById(R.id.careers_title_textView)
        feedbackCareersDesc = findViewById(R.id.careers_desc_textView)
        feedbackReferenceTitle = findViewById(R.id.reference_title_textView)
        feedbackReferenceDesc = findViewById(R.id.reference_desc_textView)
        feedbackTranscriptTitle = findViewById(R.id.transcript_title_textView)
        feedbackTranscriptDesc = findViewById(R.id.transcript_desc_textView)
    }
}