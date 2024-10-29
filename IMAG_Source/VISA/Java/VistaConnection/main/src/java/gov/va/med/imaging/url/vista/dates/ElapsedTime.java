package gov.va.med.imaging.url.vista.dates;

import java.io.Serializable;

public class ElapsedTime implements Serializable, Cloneable, Comparable {

	public static final ElapsedTime ZER0 = new ElapsedTime(0);

	private static final long SECONDS_PER_MINUTE = 60;
	private static final long MINUTES_PER_HOUR = 60;
	private static final long HOURS_PER_DAY = 24;
	private static final long MILLISECONDS_PER_SECOND = 1000;
	private static final long MILLISECONDS_PER_MINUTE = SECONDS_PER_MINUTE * MILLISECONDS_PER_SECOND;
	private static final long MILLISECONDS_PER_HOUR = MINUTES_PER_HOUR * MILLISECONDS_PER_MINUTE;
	private static final long MILLISECONDS_PER_DAY = HOURS_PER_DAY * MILLISECONDS_PER_HOUR;

	private long milliseconds;

	public ElapsedTime(long milliseconds) {
		this.milliseconds = milliseconds;
	}

	public ElapsedTime(int hours, int minutes, int seconds) {
		this(0, hours, minutes, seconds);
	}

	public ElapsedTime(int days, int hours, int minutes, int seconds) {
		this.milliseconds = seconds * MILLISECONDS_PER_SECOND;
		this.milliseconds += minutes * MILLISECONDS_PER_MINUTE;
		this.milliseconds += hours * MILLISECONDS_PER_HOUR;
		this.milliseconds += days * MILLISECONDS_PER_DAY;
	}

	/**
	 * Gets the number of whole days in this elapsed time of time.
	 * @return The day component of this elapsed time.
	 */
	public int getDays() {
		return (int) (this.milliseconds / MILLISECONDS_PER_DAY);
	}

	/**
	 * Gets the number of whole hours in this elapsed time of time.
	 * @return The hour component of this elapsed time, between 0 and 23.
	 */
	public int getHours() {
		return (int) (getTotalHours() % HOURS_PER_DAY);
	}

	/**
	 * Gets the number of whole minutes in this elapsed time of time.
	 * @return The minute component of this elapsed time, between 0 and 59.
	 */
	public int getMinutes() {
		return (int) (getTotalMinutes() % MINUTES_PER_HOUR);
	}

	/**
	 * Gets the number of whole seconds in this elapsed time of time.
	 * @return The second component of this elapsed time, between 0 and 59.
	 */
	public int getSeconds() {
		return (int) (getTotalSeconds() % SECONDS_PER_MINUTE);
	}

	/**
	 * Gets the number of whole milliseconds in this elapsed time of time.
	 * @return The millisecond component of this elapsed time, between 0 and 999.
	 */
	public int getMilliseconds() {
		return (int) (getTotalMilliseconds() % MILLISECONDS_PER_SECOND);
	}

	/**
	 * Gets the whole and fractional number of days in this elapsed time of time.
	 * @return The total number of days in this elapsed time expressed as a <code>double</code>.
	 */
	public double getTotalDays() {
		return (double) milliseconds / (double) MILLISECONDS_PER_DAY;
	}

	/**
	 * Gets the whole and fractional number of hours in this elapsed time of time.
	 * @return The total number of hours in this elapsed time expressed as a <code>double</code>.
	 */
	public double getTotalHours() {
		return (double) milliseconds / (double) MILLISECONDS_PER_HOUR;
	}

	/**
	 * Gets the whole and fractional number of minutes in this elapsed time of time.
	 * @return The total number of minuts in this elapsed time expressed as a <code>double</code>.
	 */
	public double getTotalMinutes() {
		return (double) milliseconds / (double) MILLISECONDS_PER_MINUTE;
	}

	/**
	 * Gets the whole and fractional number of seconds in this elapsed time of time.
	 * @return The total number of seconds in this elapsed time expressed as a <code>double</code>.
	 */
	public double getTotalSeconds() {
		return (double) milliseconds / (double) MILLISECONDS_PER_SECOND;
	}

	/**
	 * Gets the total number of milliseconds in this elapsed time of time.
	 * @return The total number of milliseconds in this elapsed time expressed as a <code>long</code>.
	 */
	public long getTotalMilliseconds() {
		return milliseconds;
	}

	public boolean equals(Object obj) {
		if (!(obj instanceof ElapsedTime))
			return false;
		ElapsedTime d = (ElapsedTime) obj;
		return this.milliseconds == d.milliseconds;
	}

	/**
	 * Returns a hash code for this <code>ElapsedTime</code>. The result is
	 * the exclusive OR of the two halves of the primitive
	 * <code>long</code> value held by this <code>ElapsedTime</code>
	 * object. That is, the hashcode is the value of the expression:
	 * <blockquote><pre>
	 * (int)(this.longValue()^(this.longValue()&gt;&gt;&gt;32))
	 * </pre></blockquote>
	 *
	 * @return  a hash code value for this object.
	 */
	public int hashCode() {
		return (int) (milliseconds ^ (milliseconds >>> 32));
	}

	public int compareTo(Object o) {
		ElapsedTime d = (ElapsedTime) o;
		if (milliseconds == d.milliseconds)
			return 0;
		else if (milliseconds > d.milliseconds)
			return 1;
		else
			return -1;
	}

	public boolean lessThan(ElapsedTime d) {
		return compareTo(d) < 0;
	}

	public boolean greaterThan(ElapsedTime d) {
		return compareTo(d) > 0;
	}

	public boolean lessThanOrEqual(ElapsedTime d) {
		return lessThan(d) || equals(d);
	}

	public boolean greaterThanOrEqual(ElapsedTime d) {
		return greaterThan(d) || equals(d);
	}

	/**
	 * Returns a ElapsedTime whose value is (this + d).
	 * @param d value to be added to this ElapsedTime. 
	 * @return this + d 
	 */
	public ElapsedTime add(ElapsedTime d) {
		return new ElapsedTime(this.milliseconds + d.milliseconds);
	}

	/**
	 * Returns a ElapsedTime whose value is (this - d).
	 * @param d value to be subtracted from this ElapsedTime. 
	 * @return this - d 
	 */
	public ElapsedTime subtract(ElapsedTime d) {
		return new ElapsedTime(this.milliseconds - d.milliseconds);
	}

	/**
	 * Returns a ElapsedTime whose value is (this * scalar)
	 * @param scalar A scalar multiplier to be applied to this ElapsedTime
	 * @return this * scalar
	 */
	public ElapsedTime multiply(double scalar) {
		return new ElapsedTime((long) (this.milliseconds * scalar));
	}

	/**
	 * Returns a ElapsedTime whose value is (this / scalar)
	 * @param scalar A scalar divisor to be applied to this ElapsedTime
	 * @return this / scalar
	 */
	public ElapsedTime divide(double scalar) {
		return new ElapsedTime((long) (this.milliseconds / scalar));
	}

	public ElapsedTime duration() {
		return new ElapsedTime(Math.abs(this.milliseconds));
	}

	public ElapsedTime negate() {
		return new ElapsedTime(-this.milliseconds);
	}

	public Object clone() {
		try {
			return super.clone();
		} catch (CloneNotSupportedException e) {
			return null; // should ever occur
		}
	}

	public static ElapsedTime valueOfDays(double days) {
		return null;  // TODO
	}

	public static ElapsedTime valueOfHours(double hours) {
		return null; // TODO
	}

	public static ElapsedTime valueOfMinutes(double minutes) {
		return null; // TODO
	}

	public static ElapsedTime valueOfSeconds(double seconds) {
		return null; // TODO
	}

	public static ElapsedTime valueOfMilliseconds(long milliseconds) {
		return new ElapsedTime(milliseconds);
	}
}
