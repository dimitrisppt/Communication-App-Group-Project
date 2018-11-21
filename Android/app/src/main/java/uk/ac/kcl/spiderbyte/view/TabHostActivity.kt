package uk.ac.kcl.spiderbyte.view



import android.app.SearchManager
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import android.support.design.widget.TabLayout
import android.support.v4.app.Fragment
import android.support.v4.app.FragmentManager
import android.support.v4.app.FragmentPagerAdapter
import android.support.v4.view.ViewPager
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.SearchView
import android.support.v7.widget.Toolbar
import android.util.Log
import android.util.TypedValue
import android.view.Gravity
import android.view.Menu
import android.view.MenuItem
import android.view.inputmethod.EditorInfo
import android.widget.TextView
import android.widget.Toast
import uk.ac.kcl.spiderbyte.MainApplication
import uk.ac.kcl.spiderbyte.R
import uk.ac.kcl.spiderbyte.presenter.MenuItemClickListener
import uk.ac.kcl.spiderbyte.presenter.SearchListener
import uk.ac.kcl.spiderbyte.presenter.TabChangeListener
import java.util.*

/**
 * Created by Alin on 08/02/2018.
 */
class TabHostActivity : AppCompatActivity(), TabHostView {
    override fun setTab(str: String)  {
        selectedTab = str
    }
    private lateinit var toolbar: Toolbar
    private lateinit var tabLayout: TabLayout
    private lateinit var viewPager: ViewPager
    private lateinit var appMenu: Menu
    private lateinit var searchView: SearchView
    private var menuItem : ArrayList<MenuItem> = ArrayList()
    private var selectedTab: String = ""
    private lateinit var announcementListFragment: AnnouncementListFragment
    private lateinit var calendarFragment: CalendarFragment
    private lateinit var settingsFragment: SettingsFragment
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setCurrentTab("0")
        setContentView(R.layout.activity_tabhost)
        checkUserLoggedIn()
        checkKCLUser()
        setupToolBar()
        setupViewPager()
        setupTabLayout()
    }
    override fun getMenu() : Menu = appMenu
    /**
     * Redirect user to login activity if there is no email attached to the current session.
     */
    private fun checkUserLoggedIn() {
        if(getViewApplication().getDataManager().getEmail().isEmpty()) {
            getViewApplication().getDataManager().disconnect()
            onLogoutRedirect()
        }
    }

    /**
     * Logout users that are not King's College Lonodon students.
     */
    private fun checkKCLUser() {
        if(!getViewApplication().getDataManager().getEmail().endsWith("@kcl.ac.uk")) {
            getViewApplication().getDataManager().disconnect()
            onLogoutRedirect()
        }
    }

    /**
     * Intent with termination login activity.
     */
    private fun onLogoutRedirect() {
        val loginRedirectIntent = Intent(this, LoginActivity::class.java)
        this.startActivity(loginRedirectIntent)
        Toast.makeText(this, getString(R.string.unauthorized_toast_text), Toast.LENGTH_LONG).show()
    }

    /**
     * Setup Toolbar and initial title
     */
    private fun setupToolBar() {
        toolbar = findViewById<Toolbar>(R.id.toolbar)
        toolbar.title = getString(R.string.announcements)
        setSupportActionBar(toolbar)
        toolbar.setTitleTextColor(Color.WHITE)
    }

    /**
     * Create TextView from Icon for the tabs.
     */
    private fun createTextViewForTab(icon : String) : TextView {
        val textView = TextView(this)
        val font =  Typeface.createFromAsset(assets, "fa.otf")
        textView.apply {
            gravity = Gravity.CENTER_HORIZONTAL
            typeface = font
            text = icon
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 25F)
            setTextColor(Color.WHITE)
        }
        return textView
    }

    /**
     * Update tabs to have a tag and an icon.
     */
    private fun setupTab(index : Int, icon : String) {
        tabLayout.getTabAt(index)?.apply {
            customView = createTextViewForTab(icon)
            tag = index.toString()
        }
    }

    /**
     * Setup the view pager, containing the fragments of the tabs.
     */
    private fun setupViewPager() {
        viewPager = findViewById<ViewPager>(R.id.viewpager)

        val adapter = ViewPagerAdapter(supportFragmentManager)

        announcementListFragment = AnnouncementListFragment()
        calendarFragment = CalendarFragment()
        settingsFragment = SettingsFragment()
        adapter.addFragment(this.announcementListFragment)
        adapter.addFragment(this.calendarFragment)
        adapter.addFragment(this.settingsFragment)


        viewPager.adapter = adapter
    }

    /**
     * Setup tab layout with icons and tab change listener.
     */
    private fun setupTabLayout() {
        tabLayout = findViewById<TabLayout>(R.id.tabs)
        tabLayout.setupWithViewPager(viewPager)

        setupTab(0, "\uf0a1")
        setupTab(1, "\uF073")
        setupTab(2, "\uF013")

        val tabListener = TabChangeListener<TabHostActivity>()
        tabListener.onAttach(this)
        tabLayout.addOnTabSelectedListener(tabListener)
    }

    /**
     * Create functionality for sorting and searching through announcements and events.
     */
    override fun onCreateOptionsMenu(menu : Menu) : Boolean{
        menuInflater.inflate(R.menu.appbarmenu, menu)
        appMenu = menu
        menuItem.add(menu.add(Menu.NONE, 1, Menu.NONE,"Sort by date"))
        menuItem.add(menu.add(Menu.NONE, 2, Menu.NONE,"Sort alphabetically"))
        menuItem.add(menu.add(Menu.NONE, 3, Menu.NONE,"Sort by author"))
        val menuListener = MenuItemClickListener<TabHostActivity>()
        menuListener.onAttach(this)
        menuItem[0].setOnMenuItemClickListener(menuListener)
        menuItem[1].setOnMenuItemClickListener(menuListener)
        menuItem[2].setOnMenuItemClickListener(menuListener)

        val searchManager = getSystemService(Context.SEARCH_SERVICE) as SearchManager
        searchView = menu.findItem(R.id.action_search).actionView as android.support.v7.widget.SearchView

        val searchableInfo = searchManager.getSearchableInfo(componentName)

        searchView.imeOptions = EditorInfo.IME_FLAG_NO_EXTRACT_UI
        searchView.backgroundTintMode
        searchView.setSearchableInfo(searchableInfo)
        searchView.setIconifiedByDefault(false)

        val searchListener = SearchListener<TabHostView>()
        searchListener.onAttach(this)
        searchView.setOnQueryTextListener(searchListener)

       return super.onCreateOptionsMenu(menu)

    }

    /**
     * View Pager adapter contains a list of the fragments included in the tabs.
     */
    class ViewPagerAdapter : FragmentPagerAdapter {
        var fList = ArrayList<Fragment>()

        constructor(manager: FragmentManager) : super(manager)
        override fun getItem(position: Int): Fragment {
            return fList.get(position)
        }

        override fun getCount(): Int {
            return fList.size
        }

        fun addFragment(fragment: Fragment) {
            fList.add(fragment)
        }

        override fun getPageTitle(position: Int): CharSequence? {
            return null
        }

    }
    override fun getToolBar() = toolbar
    override fun getTabTitle(tabTag : String) : String {
        return when(tabTag) {
            "0" -> getString(R.string.announcements)
            "1" -> getString(R.string.calendar)
            "2" -> getString(R.string.settings)
            else -> ""
        }
    }

    override fun getSearchView(): SearchView = searchView

    override fun getAnnouncementListView(): AnnouncementListView = announcementListFragment

    override fun getCalendarView(): CalendarView = calendarFragment

    override fun getCurrentTab(): String = selectedTab

    override fun setCurrentTab(tab: String) {
        selectedTab = tab
    }
    override fun getViewApplication(): MainApplication = application as MainApplication
}