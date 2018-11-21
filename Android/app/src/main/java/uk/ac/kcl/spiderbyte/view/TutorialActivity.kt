package uk.ac.kcl.spiderbyte.view

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity

/**
 * Created by Dimitris on 15/03/2018.
 */
class TutorialActivity: AppCompatActivity() {

    /**
     * @param savedInstanceState : Bundle, saved instance of previous state of the fragment
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val prefManager = PrefManager(applicationContext)

        // Make first time launch TRUE
        prefManager.isFirstTimeLaunch = true

        // Starts WelcomeActivity from Tutorial Activity
        startActivity(Intent(this@TutorialActivity, WelcomeActivity::class.java))
        finish()
    }
}


