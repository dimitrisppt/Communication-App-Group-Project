package uk.ac.kcl.spiderbyte.view

import android.content.Intent
import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.Toast
import uk.ac.kcl.spiderbyte.BuildConfig
import uk.ac.kcl.spiderbyte.MainApplication
import uk.ac.kcl.spiderbyte.R
import uk.ac.kcl.spiderbyte.model.Settings
import uk.ac.kcl.spiderbyte.presenter.LogoutListener


class SettingsFragment : Fragment(), SettingsView {

    private var logoutButton: Button? = null
    private lateinit var rootView : View
    var versionName = BuildConfig.VERSION_NAME

    /**
     * Called when the view is being created to instantiate variables and user interface
     *
     * @param inflater : LayoutInflater, is used to inflate views in the fragment
     * @param container : ViewGroup, the parent view that the fragment is attached to
     * @param savedInstanceState : Bundle, saved instance of previous state of the fragment
     * @return View : the fragment view
     */
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        rootView = inflater.inflate(R.layout.fragment_settings, container, false)
        setupView()

        val logoutListener = LogoutListener<SettingsFragment>()
        logoutListener.onAttach(this)
        logoutButton?.setOnClickListener(logoutListener)

        return rootView
    }

    /**
     * Initialises logout button and calls setupSettings
     */
    private fun setupView() {
        logoutButton = rootView.findViewById<Button>(R.id.logoutButton)
        setupSettings()
    }

    /**
     * Called on click of logout button.
     * Logs user out and redirects to login page
     */
    override fun onLogoutRedirect() {
        val loginRedirectIntent = Intent(this@SettingsFragment.context, LoginActivity::class.java)
        this@SettingsFragment.startActivity(loginRedirectIntent)
        Toast.makeText(this@SettingsFragment.context, getString(R.string.disconnect_toast_text), Toast.LENGTH_LONG).show()
    }

    /**
     * Initialises settings text for use in recyclerview adapter
     */
    private fun setupSettings() {

        val rvSettings = rootView.findViewById(R.id.settingsList) as RecyclerView
        rvSettings.isNestedScrollingEnabled = false

        val settings = ArrayList<Settings>()
        val nameSetting:Settings = Settings("Name",(activity?.application as MainApplication).getDataManager().getName())
        val emailSetting:Settings = Settings("Email",(activity?.application as MainApplication).getDataManager().getEmail())
        val tutorialSetting:Settings = Settings("Tutorial", "Show tutorial again")

        val reportSetting:Settings = Settings("Feedback","Report a problem")
        val aboutSetting:Settings = Settings("About","More information")
        val versionSetting:Settings = Settings("Version", versionName)

        settings.add(nameSetting)
        settings.add(emailSetting)
        settings.add(reportSetting)
        settings.add(aboutSetting)
        settings.add(tutorialSetting)
        settings.add(versionSetting)

        val adapter = SettingsAdapter(this.context!!, settings)
        rvSettings.adapter = adapter
        rvSettings.layoutManager = LinearLayoutManager(this.context)

    }

    override fun getViewApplication(): MainApplication = activity?.application as MainApplication
}
