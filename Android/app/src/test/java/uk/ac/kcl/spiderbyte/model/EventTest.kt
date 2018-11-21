package uk.ac.kcl.spiderbyte.model

import org.junit.Assert
import org.junit.Test

/**
 * Created by Dimitris on 29/03/2018.
 */
class EventTest {
    private var eventTest: Event? = Event()
    @Test
    fun isTrueEventWithAllFields() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(true, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutTitle() {
        eventTest?.title = ""
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutDescription() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = ""
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutDay() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = ""
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutStartTime() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = ""
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutEndTime() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = ""
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutLocation() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = ""
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutTitleAndDescription() {
        eventTest?.title = ""
        eventTest?.desc = ""
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutTitleAndDay() {
        eventTest?.title = ""
        eventTest?.desc = "TestDesc"
        eventTest?.day = ""
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutTitleAndStartTime() {
        eventTest?.title = ""
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = ""
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutTitleAndEndTime() {
        eventTest?.title = ""
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = ""
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutTitleAndLocation() {
        eventTest?.title = ""
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = ""
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutDescAndDay() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = ""
        eventTest?.day = ""
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutDescAndStartTime() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = ""
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = ""
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutDescAndEndTime() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = ""
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = ""
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutDescAndLocation() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = ""
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = ""
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutDayAndStartTime() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = ""
        eventTest?.starttime = ""
        eventTest?.endtime = "03:00"
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutDayAndEndTime() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = ""
        eventTest?.starttime = "02:00"
        eventTest?.endtime = ""
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutDayAndLocation() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = ""
        eventTest?.starttime = "02:00"
        eventTest?.endtime = "03:00"
        eventTest?.location = ""
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutStartTimeAndEndTime() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = ""
        eventTest?.endtime = ""
        eventTest?.location = "TestLocation"
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutStartTimeAndLocation() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = ""
        eventTest?.endtime = "03:00"
        eventTest?.location = ""
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutEndTimeAndLocation() {
        eventTest?.title = "TestTitle"
        eventTest?.desc = "TestDesc"
        eventTest?.day = "2019-02-02"
        eventTest?.starttime = "02:00"
        eventTest?.endtime = ""
        eventTest?.location = ""
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
    @Test
    fun isFalseEventWithoutAllFields() {
        eventTest?.title = ""
        eventTest?.desc = ""
        eventTest?.day = ""
        eventTest?.starttime = ""
        eventTest?.endtime = ""
        eventTest?.location = ""
        Assert.assertEquals(false, eventTest?.isValidEvent())
    }
}