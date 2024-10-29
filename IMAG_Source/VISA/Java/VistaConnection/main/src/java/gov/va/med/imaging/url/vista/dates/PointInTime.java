package gov.va.med.imaging.url.vista.dates;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.TimeZone;

public class PointInTime 
implements Serializable, Cloneable, Comparable<PointInTime> 
{

	private Calendar calendar;
	private Precision precision;
    private DateFormat fmt;

	//Kluge for .NET/Vista DOB
	private String sDay;
	private String sMonth;
	private String sYear;

    public PointInTime() {
        calendar = new GregorianCalendar();
    }

	public PointInTime(Date date) {
		calendar = new GregorianCalendar();
		calendar.setTime(date);
		precision = Precision.MILLISECOND;
	}

	public PointInTime(Calendar c) {
		calendar = c;
		precision = Precision.MILLISECOND;
	}

	public PointInTime(int year) {
		initCalendar();
		setYear(year);
		precision = Precision.YEAR;
	}

	public PointInTime(int year, int month) {
		initCalendar();
		setYear(year);
		setMonth(month);
		precision = Precision.MONTH;
	}

	public PointInTime(int year, int month, int date) {
		initCalendar();
		setYear(year);
		setMonth(month);
		setDate(date);
		precision = Precision.DATE;
	}

	public PointInTime(int year, int month, int date, int hour) {
		initCalendar();
		setYear(year);
		setMonth(month);
		setDate(date);
		setHour(hour);
		precision = Precision.HOUR;
	}

	public PointInTime(int year, int month, int date, int hour, int minute) {
		initCalendar();
		setYear(year);
		setMonth(month);
		setDate(date);
		setHour(hour);
		setMinute(minute);
		precision = Precision.MINUTE;
	}

	public PointInTime(int year, int month, int date, int hour, int minute, int second) {
		initCalendar();
		setYear(year);
		setMonth(month);
		setDate(date);
		setHour(hour);
		setMinute(minute);
		setSecond(second);
		precision = Precision.SECOND;
	}

	public PointInTime(int year, int month, int date, int hour, int minute, int second, int millisecond) {
		initCalendar();
		precision = Precision.MILLISECOND;
		setYear(year);
		setMonth(month);
		setDate(date);
		setHour(hour);
		setMinute(minute);
		setSecond(second);
		setMillisecond(millisecond);
	}

	private void initCalendar() {
		calendar = new GregorianCalendar();
		calendar.clear();
	}

	public int getYear() {
		if (!isYearSet())
			throw new ImprecisePointInTimeException(this);
		try 
		{
			return calendar.get(Calendar.YEAR);
		} 
		catch (Exception ex) 
		{
			return Integer.parseInt(this.sYear);
		}
	}

	public int getMonth() {
		if (!isMonthSet())
			throw new ImprecisePointInTimeException(this);
		try 
		{
			return calendar.get(Calendar.MONTH) + 1;
		} 
		catch (Exception ex) 
		{
			return Integer.parseInt(this.sMonth);
		}
	}

	public int getDate() {
		if (!isDateSet())
			throw new ImprecisePointInTimeException(this);
		try 
		{
			return calendar.get(Calendar.DATE);
		} 
		catch (Exception ex) 
		{
			return Integer.parseInt(this.sDay);
		}
	}

	public int getHour() {
		if (!isHourSet())
			throw new ImprecisePointInTimeException(this);
		return calendar.get(Calendar.HOUR_OF_DAY);
	}

	public int getMinute() {
		if (!isMinuteSet())
			throw new ImprecisePointInTimeException(this);
		return calendar.get(Calendar.MINUTE);
	}

	public int getSecond() {
		if (!isSecondSet())
			throw new ImprecisePointInTimeException(this);
		return calendar.get(Calendar.SECOND);
	}

	public int getMillisecond() {
		if (!isMillisecondSet())
			throw new ImprecisePointInTimeException(this);
		return calendar.get(Calendar.MILLISECOND);
	}

	public boolean isYearSet() 
	{
		return Precision.YEAR.compareTo(getPrecision()) <= 0;
	}

	public boolean isMonthSet() {
		return Precision.MONTH.compareTo(getPrecision()) <= 0;
	}

	public boolean isDateSet() {
		return Precision.DATE.compareTo(getPrecision()) <= 0;
	}

	public boolean isHourSet() {
		return Precision.HOUR.compareTo(getPrecision()) <= 0;
	}

	public boolean isMinuteSet() {
		return Precision.MINUTE.compareTo(getPrecision()) <= 0;
	}

	public boolean isSecondSet() {
		return Precision.SECOND.compareTo(getPrecision()) <= 0;
	}

	public boolean isMillisecondSet() {
		return Precision.MILLISECOND.compareTo(getPrecision()) <= 0;
	}

	private void setYear(int year) {
		calendar.set(Calendar.YEAR, year);
		this.sYear = String.valueOf(year);
	}

	private void setMonth(int month) {
		calendar.set(Calendar.MONTH, month - 1);
		this.sMonth = String.valueOf(month);
	}

	private void setDate(int date) {
		calendar.set(Calendar.DATE, date);
		this.sDay = String.valueOf(date);
	}

	public void setHour(int hour) {
		calendar.set(Calendar.HOUR_OF_DAY, hour);
	}

	public void setMinute(int minute) {
		calendar.set(Calendar.MINUTE, minute);
	}

	public void setSecond(int second) {
		calendar.set(Calendar.SECOND, second);
	}

	private void setMillisecond(int millisecond) {
		calendar.set(Calendar.MILLISECOND, millisecond);
	}

	public PointInTime add(ElapsedTime d) {
		addDays(d.getDays());
		addHours(d.getHours());
		addMinutes(d.getMinutes());
		addSeconds(d.getSeconds());
		addMilliseconds(d.getMilliseconds());
		return this;
	}

	public PointInTime addDays(int days) {
		if (isDateSet())
			calendar.add(Calendar.DATE, days);
		return this;
	}

	public PointInTime addHours(int hours) {
		if (isHourSet())
			calendar.add(Calendar.HOUR_OF_DAY, hours);
		return this;
	}

	public PointInTime addMinutes(int minutes) {
		if (isMinuteSet())
			calendar.add(Calendar.MINUTE, minutes);
		return this;
	}

	public PointInTime addSeconds(int seconds) {
		if (isSecondSet())
			calendar.add(Calendar.SECOND, seconds);
		return this;
	}

	public PointInTime addMilliseconds(int milliseconds) {
		if (isMillisecondSet())
			calendar.add(Calendar.MILLISECOND, milliseconds);
		return this;
	}

	public ElapsedTime subtract(PointInTime t) {
		if (!getPrecision().equals(t.getPrecision()))
			throw new ImprecisePointInTimeException(lessPrecise(this, t));
		//long elapsedTime = this.calendar.getTimeInMillis() - t.calendar.getTimeInMillis();
		long elapsedTime = this.calendar.get(Calendar.MILLISECOND) - t.calendar.get(Calendar.MILLISECOND);
		return new ElapsedTime(elapsedTime);
	}

	public PointInTime subtract(ElapsedTime d) {
		addDays(-d.getDays());
		addHours(-d.getHours());
		addMinutes(-d.getMinutes());
		addSeconds(-d.getSeconds());
		addMilliseconds(-d.getMilliseconds());
		return this;
	}

	public IntervalOfTime promote() {
		PointInTime low = createLow();
		PointInTime high = createHigh();
		return new IntervalOfTime(low, high);
	}

	private PointInTime createLow() {
		if (Precision.YEAR.equals(getPrecision())) {
			return new PointInTime(getYear(), 1, 1, 0, 0, 0, 0);
		} else if (Precision.MONTH.equals(getPrecision())) {
			return new PointInTime(getYear(), getMonth(), 1, 0, 0, 0, 0);
		} else if (Precision.DATE.equals(getPrecision())) {
			return new PointInTime(getYear(), getMonth(), getDate(), 0, 0, 0, 0);
		} else if (Precision.HOUR.equals(getPrecision())) {
			return new PointInTime(getYear(), getMonth(), getDate(), getHour(), 0, 0, 0);
		} else if (Precision.MINUTE.equals(getPrecision())) {
			return new PointInTime(getYear(), getMonth(), getDate(), getHour(), getMinute(), 0, 0);
		} else if (Precision.SECOND.equals(getPrecision())) {
			return new PointInTime(getYear(), getMonth(), getDate(), getHour(), getMinute(), getSecond(), 0);
		} else {
			return (PointInTime) clone();
		}
	}

	private PointInTime createHigh() {
		Calendar c = (Calendar) this.calendar.clone();
		if (Precision.YEAR.equals(getPrecision())) {
			c.add(Calendar.YEAR, 1);
		} else if (Precision.MONTH.equals(getPrecision())) {
			c.add(Calendar.MONTH, 1);
		} else if (Precision.DATE.equals(getPrecision())) {
			c.add(Calendar.DATE, 1);
		} else if (Precision.HOUR.equals(getPrecision())) {
			c.add(Calendar.HOUR, 1);
		} else if (Precision.MINUTE.equals(getPrecision())) {
			c.add(Calendar.MINUTE, 1);
		} else if (Precision.SECOND.equals(getPrecision())) {
			c.add(Calendar.SECOND, 1);
		} else {
			c.add(Calendar.MILLISECOND, 1);
		}
		return new PointInTime(c);
	}

	public TimeZone getTimeZone() {
		return calendar.getTimeZone();
	}

	public int compareTo(PointInTime t) 
	{
		if (getPrecision().equals(t.getPrecision())) {
			return compareTo(t, getPrecision());
		} else {
			PointInTime leastPrecise = lessPrecise(this, t);
			return compareTo(t, leastPrecise.getPrecision());
		}
	}

	private int compareTo(PointInTime t, Precision p) {
		Comparator comparator = createCalendarComparator(p);
		return comparator.compare(calendar, t.calendar);
	}

	private Comparator createCalendarComparator(Precision p) {
		if (Precision.MILLISECOND.equals(p)) {
			return new CalendarComparator(Calendar.MILLISECOND);
		} else if (Precision.SECOND.equals(p)) {
			return new CalendarComparator(Calendar.SECOND);
		} else if (Precision.MINUTE.equals(p)) {
			return new CalendarComparator(Calendar.MINUTE);
		} else if (Precision.HOUR.equals(p)) {
			return new CalendarComparator(Calendar.HOUR_OF_DAY);
		} else if (Precision.DATE.equals(p)) {
			return new CalendarComparator(Calendar.DATE);
		} else if (Precision.MONTH.equals(p)) {
			return new CalendarComparator(Calendar.MONTH);
		} else {
			return new CalendarComparator(Calendar.YEAR);
		}
	}

	public boolean equals(Object obj) {
		if (obj == null)
			throw new NullPointerException();
		if (!(obj instanceof PointInTime))
			return false;
		PointInTime t = (PointInTime) obj;
		if (!getPrecision().equals(t.getPrecision()))
			return false;
		if (getYear() != t.getYear())
			return false;
		if (isMonthSet() != t.isMonthSet())
			return false;
		if (!isMonthSet())
			return true;
		if (getMonth() != t.getMonth())
			return false;
		if (isDateSet() != t.isDateSet())
			return false;
		if (!isDateSet())
			return true;
		if (getDate() != t.getDate())
			return false;
		if (isHourSet() != t.isHourSet())
			return false;
		if (!isHourSet())
			return true;
		if (getHour() != t.getHour())
			return false;
		if (isMinuteSet() != t.isMinuteSet())
			return false;
		if (!isMinuteSet())
			return true;
		if (getMinute() != t.getMinute())
			return false;
		if (isSecondSet() != t.isSecondSet())
			return false;
		if (!isSecondSet())
			return true;
		if (getSecond() != t.getSecond())
			return false;
		return true;
	}

	public int hashCode() {
		return calendar.hashCode();
	}

	public String toString() {
		if (Precision.MILLISECOND.equals(getPrecision())) {
			return new SimpleDateFormat("yyyyMMddHHmmss.SSS").format(calendar.getTime());
		} else if (Precision.SECOND.equals(getPrecision())) {
			return new SimpleDateFormat("yyyyMMddHHmmss").format(calendar.getTime());
		} else if (Precision.MINUTE.equals(getPrecision())) {
			return new SimpleDateFormat("yyyyMMddHHmm").format(calendar.getTime());
		} else if (Precision.HOUR.equals(getPrecision())) {
			return new SimpleDateFormat("yyyyMMddHH").format(calendar.getTime());
		} else if (Precision.DATE.equals(getPrecision())) {
			return new SimpleDateFormat("yyyyMMdd").format(calendar.getTime());
		} else if (Precision.MONTH.equals(getPrecision())) {
			return new SimpleDateFormat("yyyyMM").format(calendar.getTime());
		} else {
			return new SimpleDateFormat("yyyy").format(calendar.getTime());
		}
	}

	public Precision getPrecision() {
		return precision;
	}

	public void setPrecision(Precision precision) {
		if (precision.compareTo(this.precision) < 0)
			this.precision = precision;
	}

	public Object clone() {
		try {
			PointInTime t = (PointInTime) super.clone();
			t.calendar = (Calendar) t.calendar.clone();
			return t;
		} catch (CloneNotSupportedException e) {
			return null; // should never occur
		}
	}

	public boolean before(PointInTime t) {
		return compareTo(t) < 0;
	}

	public boolean after(PointInTime t) {
		return compareTo(t) > 0;
	}

	private static PointInTime lessPrecise(PointInTime t1, PointInTime t2) {
		if (t2.getPrecision().lessThan(t1.getPrecision()))
			return t2;
		return t1;
	}

	public Calendar getCalendar() {
		return calendar;
	}

    public static boolean isValidDate(int year, int month, int date) {
        GregorianCalendar calendar = new GregorianCalendar();
        calendar.clear();
        calendar.setLenient(false);
        calendar.set(year,--month,date);
        try {
            calendar.getTime();
            return true;
        } catch (Exception ex) {
            return false;
        }
    }

    public String toDateString() {
        if (Precision.MILLISECOND.equals(getPrecision())) {
            return new SimpleDateFormat("MM/dd/yyyy").format(calendar.getTime());
        } else if (Precision.SECOND.equals(getPrecision())) {
            return new SimpleDateFormat("MM/dd/yyyy").format(calendar.getTime());
        } else if (Precision.MINUTE.equals(getPrecision())) {
            return new SimpleDateFormat("MM/dd/yyyy").format(calendar.getTime());
        } else if (Precision.HOUR.equals(getPrecision())) {
            return new SimpleDateFormat("MM/dd/yyyy").format(calendar.getTime());
        } else if (Precision.DATE.equals(getPrecision())) {
            return new SimpleDateFormat("MM/dd/yyyy").format(calendar.getTime());
        } else if (Precision.MONTH.equals(getPrecision())) {
			return this.sMonth + "/00/" + this.sYear;
            //return new SimpleDateFormat("MM/00/yyyy").format(calendar.getTime());
        } else if (Precision.YEAR.equals(getPrecision())) {
			return "00/00/" + this.sYear;
			//return "00/00/" + new SimpleDateFormat("yyyy").format(calendar.getTime());
        } else
			return "";
    }

}
