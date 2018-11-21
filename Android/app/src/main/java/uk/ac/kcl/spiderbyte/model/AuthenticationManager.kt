/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

import android.accounts.AuthenticatorException
import android.accounts.OperationCanceledException
import android.app.Activity
import android.util.Log
import com.microsoft.identity.client.AuthenticationCallback
import com.microsoft.identity.client.AuthenticationResult
import com.microsoft.identity.client.MsalException
import com.microsoft.identity.client.PublicClientApplication
import java.io.IOException
import uk.ac.kcl.spiderbyte.MainApplication
import uk.ac.kcl.spiderbyte.model.Constants
import uk.ac.kcl.spiderbyte.model.MSALAuthenticationCallback

/**
 * Handles setup of OAuth library in API clients.
 */
class AuthenticationManager private constructor() {
    private var mAuthResult: AuthenticationResult? = null
    private var mActivityCallback: MSALAuthenticationCallback? = null


    /**
     * Returns the access token obtained in authentication
     *
     * @return mAccessToken
     */
    val accessToken: String
        @Throws(AuthenticatorException::class, IOException::class, OperationCanceledException::class)
        get() = mAuthResult!!.getAccessToken()

    val publicClient: PublicClientApplication?
        get() = mPublicClientApplication
    //
    // App callbacks for MSAL
    // ======================
    // getActivity() - returns activity so we can acquireToken within a callback
    // getAuthSilentCallback() - callback defined to handle acquireTokenSilent() case
    // getAuthInteractiveCallback() - callback defined to handle acquireToken() case
    //


    /* Callback method for acquireTokenSilent calls
     * Looks if tokens are in the cache (refreshes if necessary and if we don't forceRefresh)
     * else errors that we need to do an interactive request.
     */
    private/* Successfully got a token, call Graph now *//* Store the authResult *///invoke UI callback
            /* Failed to acquireToken *//* User canceled the authentication */ val authSilentCallback: AuthenticationCallback
        get() = object : AuthenticationCallback {
            override fun onSuccess(authenticationResult: AuthenticationResult?) {
                Log.d(TAG, "Successfully authenticated")
                mAuthResult = authenticationResult
                if (mActivityCallback != null)
                    mActivityCallback!!.onSuccess(mAuthResult!!)
            }

            override fun onError(exception: MsalException) {
                Log.d(TAG, "Authentication failed: " + exception.toString())
                if (mActivityCallback != null)
                    mActivityCallback!!.onError(exception)
            }

            override fun onCancel() {
                Log.d(TAG, "User cancelled login.")
            }
        }


    /* Callback used for interactive request.  If succeeds we use the access
         * token to call the Microsoft Graph. Does not check cache
         */
    private/* Successfully got a token, call graph now *//* Store the auth result *//* Failed to acquireToken *//* User canceled the authentication */ val authInteractiveCallback: AuthenticationCallback
        get() = object : AuthenticationCallback {
            override fun onSuccess(authenticationResult: AuthenticationResult?) {
                Log.d(TAG, "Successfully authenticated")
                Log.d(TAG, "ID Token: " + authenticationResult!!.idToken)
                mAuthResult = authenticationResult
                if (mActivityCallback != null)
                    mActivityCallback!!.onSuccess(mAuthResult!!)
            }

            override fun onError(exception: MsalException) {
                Log.d(TAG, "Authentication failed: " + exception.toString())
                if (mActivityCallback != null)
                    mActivityCallback!!.onError(exception)
            }

            override fun onCancel() {
                Log.d(TAG, "User cancelled login.")
                if (mActivityCallback != null)
                    mActivityCallback!!.onCancel()
            }
        }

    /**
     * Disconnects the app from Office 365 by clearing the token cache, setting the client objects
     * to null, and removing the user id from shred preferences.
     */
    fun disconnect() {
        mPublicClientApplication?.remove(mAuthResult?.user)
        // Reset the AuthenticationManager object
        AuthenticationManager.resetInstance()
    }

    /**
     * Authenticates the user and lets the user authorize the app for the requested permissions.
     * An authentication token is returned via the getAuthInteractiveCalback method
     * @param activity
     * @param authenticationCallback
     */
    fun callAcquireToken(activity: Activity, authenticationCallback: MSALAuthenticationCallback) {
        mActivityCallback = authenticationCallback
        mPublicClientApplication!!.acquireToken(
                activity, Constants.SCOPES, authInteractiveCallback)
    }

    fun callAcquireTokenSilent(user: com.microsoft.identity.client.User, forceRefresh: Boolean, msalAuthenticationCallback: MSALAuthenticationCallback) {
        mActivityCallback = msalAuthenticationCallback
        mPublicClientApplication!!.acquireTokenSilentAsync(Constants.SCOPES, user, null, forceRefresh, authSilentCallback)
    }

    companion object {
        private val TAG = "AuthenticationManager"
        private var INSTANCE: AuthenticationManager? = null
        private var mPublicClientApplication: PublicClientApplication? = null

        val instance: AuthenticationManager?
            @Synchronized get() {
                if (INSTANCE == null) {
                    INSTANCE = AuthenticationManager()
                    if (mPublicClientApplication == null) {
                        mPublicClientApplication = PublicClientApplication(MainApplication.instance)
                    }
                }
                return INSTANCE
            }

        @Synchronized
        fun resetInstance() {
            INSTANCE = null
        }
    }
}