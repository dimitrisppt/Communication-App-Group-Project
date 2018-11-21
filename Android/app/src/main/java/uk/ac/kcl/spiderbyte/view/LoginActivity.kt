/**
 * Created by Dimitris on 10/02/2018.
 */
package uk.ac.kcl.spiderbyte.view

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.ProgressBar
import android.widget.Toast

import uk.ac.kcl.spiderbyte.MainApplication

import uk.ac.kcl.spiderbyte.R
import uk.ac.kcl.spiderbyte.model.DataManager
import uk.ac.kcl.spiderbyte.presenter.AuthenticationListener
import uk.ac.kcl.spiderbyte.presenter.LoginListener





/**
 * Starting activity of the app. Handles the connection to Office 365.
 * When it first starts it only displays a button to Connect to Office 365.
 * If there are no cached tokens, the user is required to sign in to Office 365.
 * If there are cached tokens, the app tries to reuse them.
 * The activity redirects the user to the SendMailActivity upon successful connection.
 */
class LoginActivity : AppCompatActivity(), LoginView {


    private var loginButton: Button? = null
    private var loginProgressBar: ProgressBar? = null
    private lateinit var dataManager: DataManager


    /**
     * Called when the view is being created to instantiate variables and user interface
     *
     * @param savedInstanceState : Bundle, saved instance of previous state
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)
        setupData()
        setupView()
    }

    /**
     * instantiates data manager
     */
    private fun setupData() {
        dataManager = DataManager()
    }

    /**
     * instantiates login view
     */
    private fun setupView() {

        loginButton = findViewById(R.id.loginButton)
        loginProgressBar = findViewById(R.id.loginProgressBar)
        val authenticationListener = AuthenticationListener<LoginActivity>()
        authenticationListener.onAttach(this)
        val loginListener = LoginListener<LoginActivity>()
        loginListener.onAttach(this)
        loginButton?.setOnClickListener(loginListener)

    }

    /**
     * instantiates intent
     */
    override fun createLoginIntent() {

        val loginIntent = Intent(this@LoginActivity, TabHostActivity::class.java)
        this@LoginActivity.startActivity(loginIntent)

    }


    /**
     * Handles redirect response from https://login.microsoftonline.com/common and
     * notifies the MSAL library that the user has completed the authentication
     * dialog
     * @param requestCode
     * @param resultCode
     * @param data
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        super.onActivityResult(requestCode, resultCode, data)
        if (AuthenticationManager
                        .instance?.publicClient != null) {
            AuthenticationManager
                    .instance?.publicClient!!
                    .handleInteractiveRequestRedirect(requestCode, resultCode, data)
        }
    }

    /**
     * When called, resets login page and displays the login button
     */
    override fun resetUIForLogin() {
        loginButton!!.visibility = View.VISIBLE
        loginButton!!.isEnabled = true
        loginButton!!.text = (getString(R.string.login_text))
        loginProgressBar!!.visibility = View.GONE
    }

    /**
     * When called hides the login button and shows a loading circle.
     * Should be called after clicking on the login button
     */
    override fun showLoginInProgressUI() {
        loginButton!!.isEnabled = false
        loginButton!!.text = (getString(R.string.connecting_text))
        loginProgressBar!!.visibility = View.VISIBLE
    }

    /**
     * When called reset's login page
     * and shows a toast stating that the app wasn't able to connect to microsoft
     */
    override fun showLoginErrorUI(message: String?) {
        resetUIForLogin()
        Toast.makeText(
                this@LoginActivity,
                R.string.connect_toast_text_error,
                Toast.LENGTH_LONG).show()
        Log.d("MSAL Error", "Could not connect to Microsoft: $message")
    }


    override fun getContextActivity() = this
    override fun getViewApplication(): MainApplication = application as MainApplication


    companion object {

        private val TAG = "LoginActivity"
    }

}