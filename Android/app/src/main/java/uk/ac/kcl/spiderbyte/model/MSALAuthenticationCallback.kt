package uk.ac.kcl.spiderbyte.model

/**
 * Created by Alin on 18/03/2018.
 */
import com.microsoft.identity.client.AuthenticationResult
import com.microsoft.identity.client.MsalException

interface MSALAuthenticationCallback {
    fun onSuccess(authenticationResult: AuthenticationResult)
    fun onError(exception: MsalException)
    fun onError(exception: Exception)
    fun onCancel()
}