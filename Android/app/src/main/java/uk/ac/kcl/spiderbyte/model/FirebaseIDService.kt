package uk.ac.kcl.spiderbyte.model

import com.google.firebase.iid.FirebaseInstanceIdService
import android.util.Log
import com.google.firebase.iid.FirebaseInstanceId



/**
 * Created by Alin on 09/02/2018.
 */
class FirebaseIDService : FirebaseInstanceIdService() {
    override fun onTokenRefresh() {
        val refreshedToken = FirebaseInstanceId.getInstance().token
        sendRegistrationToServer(refreshedToken!!)
    }

    private fun sendRegistrationToServer(refreshedToken: String) {

    }
}