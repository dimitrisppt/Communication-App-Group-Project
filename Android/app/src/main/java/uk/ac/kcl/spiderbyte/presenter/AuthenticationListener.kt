package uk.ac.kcl.spiderbyte.presenter

import android.content.ContentValues.TAG
import uk.ac.kcl.spiderbyte.view.LoginView
import android.util.Log
import java.io.IOException
import AuthenticationManager
import com.microsoft.identity.client.*
import uk.ac.kcl.spiderbyte.model.MSALAuthenticationCallback


/**
 * Created by Dimitris on 19/02/2018.
 *
 * Creates a listener for authentication that enables the users to sign in
 * using there existing Microsoft office emails.
 */
class AuthenticationListener<V : LoginView> : Presenter<V>(), MSALAuthenticationCallback {

    /**
     * @param view Attaches the listener to the current view
     */
    override fun onAttach(view: V) {
        super.onAttach(view)
        // Gets the function from DataManager
        getView()?.getViewApplication()?.getDataManager()?.setAuthenticationListener(this)
    }

    /**
     * @param authenticationResult Returns the user data if the function succeeded.
     */
    override fun onSuccess(authenticationResult: AuthenticationResult) {
        try {
            getView()?.getViewApplication()?.getDataManager()?.setName(authenticationResult.user.name)
            getView()?.getViewApplication()?.getDataManager()?.setEmail(authenticationResult.user.displayableId)
        } catch (npe: NullPointerException) {
            Log.e(TAG, npe.message)
        }

        getView()?.createLoginIntent()

        Thread(Runnable { getView()?.resetUIForLogin() })

    }

    /**
     * @param exception Resets login's activity UI
     */
    override fun onError(exception: MsalException) {
        // Check the exception type.
        when (exception) {
            is MsalClientException -> getView()?.showLoginErrorUI(exception.toString())
            is MsalServiceException -> getView()?.showLoginErrorUI(exception.toString())
            is MsalUiRequiredException -> {
                // This explicitly indicates that developer needs to prompt the user, it could be refresh token is expired, revoked
                // or user changes the password; or it could be that no token was found in the token cache.
                val mgr = AuthenticationManager.instance

                mgr!!.callAcquireToken(getView()?.getViewApplication()?.getDataManager()?.getContextActivity()!!, this)
            }
        }

    }

    /**
     * @param exception Shows Login error view
     */
    override fun onError(exception: Exception) {
        getView()?.showLoginErrorUI(exception.toString())
    }

    override fun onCancel() {
        getView()?.showLoginErrorUI("")
    }

}
