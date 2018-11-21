package uk.ac.kcl.spiderbyte.view

import android.content.Context
import android.content.SharedPreferences

/**
 * Created by Dimitris on 15/03/18.
 *
 * Handles the application installation.
 * Creates the application welcome tutorial only the first
 * time of the app installation.
 */
class PrefManager(internal var _context: Context) {
    internal var pref: SharedPreferences
    internal var editor: SharedPreferences.Editor

    // Shared preference mode
    internal var PRIVATE_MODE = 0

    var isFirstTimeLaunch: Boolean
        get() = pref.getBoolean(IS_FIRST_TIME_LAUNCH, true)
        set(isFirstTime) {
            editor.putBoolean(IS_FIRST_TIME_LAUNCH, isFirstTime)
            editor.commit()
        }

    init {
        pref = _context.getSharedPreferences(PREF_NAME, PRIVATE_MODE)
        editor = pref.edit()
    }

    companion object {
        // Shared preferences file name
        private val PREF_NAME = "androidhive-welcome"

        private val IS_FIRST_TIME_LAUNCH = "IsFirstTimeLaunch"
    }

}
