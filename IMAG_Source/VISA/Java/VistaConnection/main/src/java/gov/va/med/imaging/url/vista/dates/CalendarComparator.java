package gov.va.med.imaging.url.vista.dates;

import java.util.Calendar;
import java.util.Comparator;

public class CalendarComparator implements Comparator {

	private int precision;

	public CalendarComparator() {
		this.precision = Calendar.MILLISECOND;
	}

	public CalendarComparator(int precision) {
		this.precision = precision;
	}

	public int compare(Object o1, Object o2) {
		return compare((Calendar) o1, (Calendar) o2);
	}

	public int compare(Calendar c1, Calendar c2) {
		switch (precision) {
			case Calendar.SECOND :
				if (compare(c1, c2, Calendar.YEAR) == 0
					&& compare(c1, c2, Calendar.MONTH) == 0
					&& compare(c1, c2, Calendar.DATE) == 0
					&& compare(c1, c2, Calendar.HOUR) == 0
					&& compare(c1, c2, Calendar.MINUTE) == 0)
					return compare(c1, c2, Calendar.SECOND);
			case Calendar.MINUTE :
				if (compare(c1, c2, Calendar.YEAR) == 0
					&& compare(c1, c2, Calendar.MONTH) == 0
					&& compare(c1, c2, Calendar.DATE) == 0
					&& compare(c1, c2, Calendar.HOUR) == 0)
					return compare(c1, c2, Calendar.MINUTE);
			case Calendar.HOUR :
				if (compare(c1, c2, Calendar.YEAR) == 0
					&& compare(c1, c2, Calendar.MONTH) == 0
					&& compare(c1, c2, Calendar.DATE) == 0)
					return compare(c1, c2, Calendar.HOUR);
			case Calendar.DATE :
				if (compare(c1, c2, Calendar.YEAR) == 0 && compare(c1, c2, Calendar.MONTH) == 0)
					return compare(c1, c2, Calendar.DATE);
			case Calendar.MONTH :
				if (compare(c1, c2, Calendar.YEAR) == 0)
					return compare(c1, c2, Calendar.MONTH);
			case Calendar.YEAR :
				if (compare(c1, c2, Calendar.ERA) == 0)
					return compare(c1, c2, Calendar.YEAR);
			case Calendar.MILLISECOND :
			default :
				if (c1.equals(c2))
					return 0;
				else if (c1.before(c2))
					return -1;
				else
					return 1;
		}
	}

	private int compare(Calendar c1, Calendar c2, int field) {
		int val1 = c1.get(field);
		int val2 = c2.get(field);
		if (val1 == val2)
			return 0;
		else if (val1 < val2)
			return -1;
		else
			return 1;
	}
}
