package gov.va.med.imaging.url.vista.dates;

public final class Precision implements Comparable {

	public static final int YEAR_INT_VALUE = 0;
	public static final int MONTH_INT_VALUE = 1;
	public static final int DATE_INT_VALUE = 2;
	public static final int HOUR_INT_VALUE = 3;
	public static final int MINUTE_INT_VALUE = 4;
	public static final int SECOND_INT_VALUE = 5;
	public static final int MILLISECOND_INT_VALUE = 6;

	public static final Precision YEAR = new Precision("year", YEAR_INT_VALUE);
	public static final Precision MONTH = new Precision("month", MONTH_INT_VALUE);
	public static final Precision DATE = new Precision("date", DATE_INT_VALUE);
	public static final Precision HOUR = new Precision("hour", HOUR_INT_VALUE);
	public static final Precision MINUTE = new Precision("minute", MINUTE_INT_VALUE);
	public static final Precision SECOND = new Precision("second", SECOND_INT_VALUE);
	public static final Precision MILLISECOND = new Precision("millisecond", MILLISECOND_INT_VALUE);

	private String value;
	private int intValue;

	private Precision(String value, int intValue) {
		this.value = value;
		this.intValue = intValue;
	}

	public boolean equals(Object obj) {
		Precision p = (Precision) obj;
		return this.intValue == p.intValue;
	}

	public int hashCode() {
		return value.hashCode();
	}

	public String toString() {
		return value;
	}

	public int compareTo(Object o) {
		Precision p = (Precision) o;
		if (this.intValue == p.intValue)
			return 0;
		else if (this.intValue < p.intValue)
			return -1;
		else
			return 1;
	}

	public boolean lessThan(Precision p) {
		return compareTo(p) < 0;
	}

	public boolean greaterThan(Precision p) {
		return compareTo(p) > 0;
	}

	public static Precision lesser(Precision p1, Precision p2) {
		if (p2.lessThan(p1))
			return p2;
		else
			return p1;
	}

	public static Precision greater(Precision p1, Precision p2) {
		if (p2.greaterThan(p1))
			return p2;
		else
			return p1;
	}
}
