package uk.ac.kcl.spiderbyte.model

/**
 * Created by Alin on 09/02/2018.
 */
import android.annotation.TargetApi
import android.app.job.JobParameters
import android.app.job.JobService
import android.os.Build
import android.util.Log


@TargetApi(Build.VERSION_CODES.LOLLIPOP)
class FirebaseJobService : JobService() {

    override fun onStartJob(jobParameters: JobParameters): Boolean {
        return false
    }

    override fun onStopJob(jobParameters: JobParameters): Boolean {
        return false
    }

}