package uk.ac.kcl.spiderbyte.view

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.TextView
import kotlinx.android.synthetic.main.activity_about.view.*
import uk.ac.kcl.spiderbyte.R

/**
 * Created by Dimitris on 21/03/2018.
 *
 * Contains information about the licence of the application.
 */
class AboutActivity: AppCompatActivity() {

    private var aboutTitle: TextView? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_about)
        setupAboutView()
    }

    private fun setupAboutView() {
        aboutTitle = findViewById(R.id.title_textView)
    }
}