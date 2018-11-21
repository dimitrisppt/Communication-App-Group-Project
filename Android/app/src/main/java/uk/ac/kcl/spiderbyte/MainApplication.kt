package uk.ac.kcl.spiderbyte

import android.app.Application
import com.google.firebase.database.FirebaseDatabase
import uk.ac.kcl.spiderbyte.model.DataManager

/**
 * Created by Alin on 14/02/2018.
 */
class MainApplication : Application() {
    private lateinit var dataManager: DataManager
    override fun onCreate() {
        super.onCreate()
        instance = this
        dataManager = DataManager() // Initialise application data
        FirebaseDatabase.getInstance().setPersistenceEnabled(true) // Activate Firebase offline caching
    }
    fun getDataManager() = dataManager
    companion object {
        lateinit var instance: MainApplication
            private set
    }
}