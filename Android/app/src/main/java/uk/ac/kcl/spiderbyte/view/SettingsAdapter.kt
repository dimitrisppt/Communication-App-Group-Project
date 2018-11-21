package uk.ac.kcl.spiderbyte.view

import android.content.Context
import android.content.Intent
import android.graphics.Typeface
import android.support.v7.widget.RecyclerView
import android.util.TypedValue
import android.view.Gravity
import android.view.LayoutInflater
import android.view.ViewGroup
import android.view.View
import android.widget.TextView
import android.widget.Toast
import uk.ac.kcl.spiderbyte.R
import uk.ac.kcl.spiderbyte.model.Settings


/**
 * Created by Dimitris on 08/03/2018.
 */
class SettingsAdapter(context: Context, settings: List<Settings>): RecyclerView.Adapter<SettingsAdapter.ViewHolder>() {

    /**
     * @param parent
     * @param viewType
     *
     * @return ViewHolder(contactView)
     */
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val context = parent.context
        val inflater = LayoutInflater.from(context)
        val contactView = inflater.inflate(R.layout.settings_items, parent, false)

        return ViewHolder(contactView)
    }

    /**
     * @return mSettings.size
     */
    override fun getItemCount(): Int {
        return mSettings.size
    }

    /**
     * @param viewHolder
     * @param position
     */
    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {
        // Get the data model based on position
        val settings = mSettings.get(position)

        val settingIconTextView = viewHolder.iconTextView
        createTextViewForIcon(position, settingIconTextView)

        // Set item views based on your views and data model
        val headerTextView = viewHolder.headerTextView
        headerTextView.text = settings.header

        val bodyTextView = viewHolder.bodyTextView
        bodyTextView.text = settings.body

        viewHolder.bind(settings)

    }


    private fun createTextViewForIcon(position: Int, textView: TextView) {
        val font = Typeface.createFromAsset(this.mContext.assets, "fa.otf")

        textView.apply {
            gravity = Gravity.CENTER_HORIZONTAL
            typeface = font

            return when (position) {
                0 -> {  text = "\uf007"
                        setTextSize(TypedValue.COMPLEX_UNIT_SP, 15F)
                        setTextColor(resources.getColor(R.color.colorAccent)) }
                1 -> {  text = "\uf0e0"
                        setTextSize(TypedValue.COMPLEX_UNIT_SP, 15F)
                        setTextColor(resources.getColor(R.color.colorAccent)) }
                2 -> {  text = "\uf27a"
                    setTextSize(TypedValue.COMPLEX_UNIT_SP, 15F)
                    setTextColor(resources.getColor(R.color.colorAccent)) }
                3 -> {  text = "\uf05a"
                        setTextSize(TypedValue.COMPLEX_UNIT_SP, 15F)
                        setTextColor(resources.getColor(R.color.colorAccent)) }
                4 -> {  text = "\uf01e"
                    setTextSize(TypedValue.COMPLEX_UNIT_SP, 15F)
                    setTextColor(resources.getColor(R.color.colorAccent)) }
                5 -> {  text = "\uf126"
                    setTextSize(TypedValue.COMPLEX_UNIT_SP, 15F)
                    setTextColor(resources.getColor(R.color.colorAccent)) }
                else -> text = ""
            }
        }
    }



    // Provide a direct reference to each of the views within a data item
    // Used to cache the views within the item layout for fast access
    inner class ViewHolder(itemView:View): RecyclerView.ViewHolder(itemView) {
        // Your holder should contain a member variable
        // for any view that will be set as you render a row
        var iconTextView: TextView
        var headerTextView: TextView
        var bodyTextView: TextView

        init{
            iconTextView = itemView.findViewById(R.id.setting_icon) as TextView
            headerTextView = itemView.findViewById(R.id.user_header) as TextView
            bodyTextView = itemView.findViewById(R.id.user_body) as TextView
        }

        fun bind(settingListItem: Settings) {
            itemView.isClickable
            itemView.setOnClickListener(View.OnClickListener {
                when {
                    settingListItem.header.equals("Tutorial") -> {
                        createTutorialActivity()
                    }
                    settingListItem.header.equals("Feedback") -> {
                        createFeedbackActivity()
                    }
                    settingListItem.header.equals("About") -> {
                        createAboutActivity()
                    }
                }
            })

        }
    }

    // Store a member variable for the contacts
    private val mSettings:List<Settings>
    // Store the context for easy access
    private val mContext:Context

    init{
        mSettings = settings
        mContext = context
    }

    fun createTutorialActivity() {
        val tutorialActivity = Intent(this@SettingsAdapter.mContext, TutorialActivity::class.java)
        this@SettingsAdapter.mContext.startActivity(tutorialActivity)
    }

    fun createFeedbackActivity() {
        val feedbackActivity = Intent(this@SettingsAdapter.mContext, FeedbackActivity::class.java)
        this@SettingsAdapter.mContext.startActivity(feedbackActivity)
    }

    fun createAboutActivity() {
        val aboutActivity = Intent(this@SettingsAdapter.mContext, AboutActivity::class.java)
        this@SettingsAdapter.mContext.startActivity(aboutActivity)
    }

}