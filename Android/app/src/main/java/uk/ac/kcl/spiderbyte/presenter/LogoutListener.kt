package uk.ac.kcl.spiderbyte.presenter

import android.view.View
import android.view.View.OnClickListener
import uk.ac.kcl.spiderbyte.view.SettingsView


/**
 * Created by Dimitris on 12/02/2018.
 *
 * Creates a listener for logout button and enables the users to logout from the application.
 */
class LogoutListener<V : SettingsView> : Presenter<V>(), OnClickListener {

    /**
     * @param v Adds functionality to Logout button
     */
    override fun onClick(v: View?) {
        getView()?.getViewApplication()?.getDataManager()?.disconnect()
        getView()?.onLogoutRedirect()
    }

}