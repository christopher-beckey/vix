package gov.va.med.imaging.url.vista.dates;

import java.text.DateFormat;
import java.text.FieldPosition;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class FileManDateFormat extends PointInTimeFormat {

	private static final int MIN_FILE_MAN_DATE_LENGTH = 7;
	private static final int MAX_FILE_MAN_DATE_LENGTH = 14;
	private static final int YEARS_PER_CENTURY = 100;
	private static final int BASE_CENTURY = 17;

	private DateFormat dateFormat;

	public FileManDateFormat() {
		dateFormat = new SimpleDateFormat();
	}

	public PointInTime parse(String source, ParsePosition pos) {
		String src = source.substring(pos.getIndex());
		if (src.length() < MIN_FILE_MAN_DATE_LENGTH || src.length() > MAX_FILE_MAN_DATE_LENGTH) {
			//pos.setErrorIndex(source.length());
			pos.setIndex(source.length());
			return null;
		}
        if (src.length() > MIN_FILE_MAN_DATE_LENGTH && src.length() < MAX_FILE_MAN_DATE_LENGTH) {
            src += "000000".substring(src.length()-MIN_FILE_MAN_DATE_LENGTH-1);
        }
		return (PointInTime) parse(src, pos, new PointInTimeFactory());
	}

	private Object parse(String src, ParsePosition pos, IFactory f) {
		try {
			int years = -1, months = -1, days = -1, hours = -1, minutes = -1, seconds = -1;
			years = Integer.parseInt(src.substring(0, 3)) + BASE_CENTURY * YEARS_PER_CENTURY;
			pos.setIndex(pos.getIndex() + 3);
			months = Integer.parseInt(src.substring(3, 5));
			pos.setIndex(pos.getIndex() + 2);
			days = Integer.parseInt(src.substring(5, 7));
			pos.setIndex(pos.getIndex() + 2);
			if (src.length() > MIN_FILE_MAN_DATE_LENGTH) {
                // skip over the . separator
				hours = Integer.parseInt(src.substring(8, 10));
				pos.setIndex(pos.getIndex() + 3);
			}
			if (src.length() > 10) {
				minutes = Integer.parseInt(src.substring(10, 12));
				pos.setIndex(pos.getIndex() + 2);
			}
			if (src.length() == MAX_FILE_MAN_DATE_LENGTH) {
				seconds = Integer.parseInt(src.substring(12));
				pos.setIndex(pos.getIndex() + 2);
			}
			return f.create(years, months, days, hours, minutes, seconds);
		} catch (NumberFormatException e) {
			//pos.setErrorIndex(pos.getIndex());
			return null;
		}
	}

	public Date parseDate(String source, ParsePosition pos) {
		String src = source.substring(pos.getIndex());
		if (src.length() != MAX_FILE_MAN_DATE_LENGTH) {
			//pos.setErrorIndex(pos.getIndex() + src.length());
			pos.setIndex(pos.getIndex() + src.length());
			return null;
		}
		return (Date) parse(src, pos, new DateFactory());
	}

	public StringBuffer format(PointInTime t, StringBuffer toAppendTo, FieldPosition fieldPosition) {
		appendCentury(t.getYear(), toAppendTo);
		dateFormat = createDateFormat(t.getPrecision());
		return dateFormat.format(t.getCalendar().getTime(), toAppendTo, fieldPosition);
	}

	public StringBuffer format(Date date, StringBuffer toAppendTo, FieldPosition fieldPosition) {
		Calendar c = new GregorianCalendar();
		c.setTime(date);
		appendCentury(c.get(Calendar.YEAR), toAppendTo);
		dateFormat = new SimpleDateFormat("yyMMdd.HHmmss");
		return dateFormat.format(date, toAppendTo, fieldPosition);
	}

	private DateFormat createDateFormat(Precision p) {
		if (Precision.YEAR.equals(p)) {
			return new SimpleDateFormat("yy0000");
		} else if (Precision.MONTH.equals(p)) {
			return new SimpleDateFormat("yyMM00");
		} else if (Precision.DATE.equals(p)) {
			return new SimpleDateFormat("yyMMdd");
		} else if (Precision.HOUR.equals(p)) {
			return new SimpleDateFormat("yyMMdd.HH");
		} else if (Precision.MINUTE.equals(p)) {
			return new SimpleDateFormat("yyMMdd.HHmm");
		} else {
			return new SimpleDateFormat("yyMMdd.HHmmss");
		}
	}

	private void appendCentury(int year, StringBuffer toAppendTo) {
		int century = year / YEARS_PER_CENTURY;
		toAppendTo.append(Integer.toString(century - BASE_CENTURY));
	}

	private interface IFactory {
		Object create(int years, int months, int days, int hours, int minutes, int seconds);
	}

	private static class PointInTimeFactory implements IFactory {

		public Object create(int years, int months, int days, int hours, int minutes, int seconds) {
			if (years != -1 && months <= 0) {
				return new PointInTime(years);
			} else if (days <= 0) {
				return new PointInTime(years, months);
			} else if (days > 0 && hours == -1) {
				return new PointInTime(years, months, days);
			} else if (hours != -1 && minutes == -1) {
				return new PointInTime(years, months, days, hours);
			} else if (hours != -1 && minutes != -1 && seconds == -1) {
				return new PointInTime(years, months, days, hours, minutes);
			} else if (hours != -1 && minutes != -1 && seconds != -1) {
				return new PointInTime(years, months, days, hours, minutes, seconds);
			}
			return null;
		}
	}

	private static class DateFactory implements IFactory {
		public Object create(int years, int months, int days, int hours, int minutes, int seconds) {
			if (years == -1 || months == -1 || days == -1 || hours == -1 || minutes == -1 || seconds == -1)
				return null;
			GregorianCalendar c = new GregorianCalendar(years, months - 1, days, hours, minutes, seconds);
			return c.getTime();
		}
	}
}

