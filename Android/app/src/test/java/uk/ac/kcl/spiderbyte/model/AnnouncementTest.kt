package uk.ac.kcl.spiderbyte.model

import org.junit.Test

import org.junit.Assert.*

/**
 * Created by Alin on 20/02/2018.
 */
class AnnouncementTest {
    private var announcementTest: Announcement? = Announcement()
    @Test
    fun isTrueAnnouncementWithAllFields() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(true, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutAuthor() {
        announcementTest?.author = ""
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutTitle() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = ""
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutContent() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = ""
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutDateTime() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = ""
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutTag() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = ""
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutPhoto() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = ""
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutAuthorAndTitle() {
        announcementTest?.author = ""
        announcementTest?.title = ""
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutAuthorAndContent() {
        announcementTest?.author = ""
        announcementTest?.title = "TestTitle"
        announcementTest?.content = ""
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutAuthorAndDateTime() {
        announcementTest?.author = ""
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutAuthorAndTag() {
        announcementTest?.author = ""
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = ""
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutAuthorAndPhotoB64() {
        announcementTest?.author = ""
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = ""
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutTitleAndContent() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = ""
        announcementTest?.content = ""
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutTitleAndDateTime() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = ""
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = ""
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutTitleAndTag() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = ""
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = ""
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutTitleAndPhotoB64() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = ""
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = ""
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutContentAndDateTime() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = ""
        announcementTest?.dateTime = ""
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutContentAndTag() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = ""
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = ""
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutContentAndPhotoB64() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = ""
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = ""
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutDateTimeAndTag() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = ""
        announcementTest?.tag = ""
        announcementTest?.photoB64 = "TestPhotoB64"
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutDateTimeAndPhotoB64() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = ""
        announcementTest?.tag = "General"
        announcementTest?.photoB64 = ""
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutTagAndPhotoB64() {
        announcementTest?.author = "TestAuthor"
        announcementTest?.title = "TestTitle"
        announcementTest?.content = "TestContent"
        announcementTest?.dateTime = "2018-03-29 05:33:21"
        announcementTest?.tag = ""
        announcementTest?.photoB64 = ""
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }
    @Test
    fun isFalseAnnouncementWithoutAllFields() {
        announcementTest?.author = ""
        announcementTest?.title = ""
        announcementTest?.content = ""
        announcementTest?.dateTime = ""
        announcementTest?.tag = ""
        announcementTest?.photoB64 = ""
        assertEquals(false, announcementTest?.isValidAnnouncement())
    }

}