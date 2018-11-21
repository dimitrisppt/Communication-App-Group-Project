package uk.ac.kcl.spiderbyte.view

import android.app.Activity

/**
 * Created by Dimitris on 10/02/2018.
 */
interface LoginView: BaseView {
    fun showLoginErrorUI(message: String?)
    fun resetUIForLogin()
    fun createLoginIntent()
    fun getContextActivity() : Activity
    fun showLoginInProgressUI()
}