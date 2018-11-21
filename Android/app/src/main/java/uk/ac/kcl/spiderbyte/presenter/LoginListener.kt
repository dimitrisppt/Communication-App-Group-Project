package uk.ac.kcl.spiderbyte.presenter

import android.view.View
import uk.ac.kcl.spiderbyte.view.LoginView
import com.microsoft.identity.client.MsalClientException
import android.util.Log


/**
 * Created by Dimitris on 12/02/2018.
 *
 * Creates a listener for login button and enables the users to sign in
 * using there existing Microsoft office emails.
 */
class LoginListener<V : LoginView> : Presenter<V>(), View.OnClickListener {

    /**
     * @param v Adds functionality to Login button
     */
    override fun onClick(v: View?) {

        // Gets the context of the current activity from the Data Manager
        getView()?.getViewApplication()?.getDataManager()?.setContextActivity(getView()?.getContextActivity()!!)

        try {
            getView()?.showLoginInProgressUI()
            getView()?.getViewApplication()?.getDataManager()?.connect()

        } catch (e: MsalClientException) {
            getView()?.showLoginErrorUI(e.toString())

        } catch (e: IndexOutOfBoundsException) {
            getView()?.showLoginErrorUI(e.toString())

        } catch (e: IllegalStateException) {
            getView()?.showLoginErrorUI(e.toString())

        } catch (e: Exception) {
            getView()?.showLoginErrorUI(e.toString())
        }
    }
}