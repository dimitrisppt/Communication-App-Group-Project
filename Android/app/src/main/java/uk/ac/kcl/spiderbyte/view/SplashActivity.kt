package uk.ac.kcl.spiderbyte.view

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity

/**
 * Created by Dimitris on 15/03/2018.
 */
class SplashActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Starts Welcome tutorial activity
        startActivity(Intent(this@SplashActivity, WelcomeActivity::class.java))
        finish()
    }
}
