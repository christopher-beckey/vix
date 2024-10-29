package gov.va.med.imaging.url.vista.dates;

import java.text.*;
import java.util.Date;

public abstract class PointInTimeFormat extends Format {

	public abstract StringBuffer format(PointInTime t, StringBuffer toAppendTo, FieldPosition fieldPosition);
	public abstract StringBuffer format(Date date, StringBuffer toAppendTo, FieldPosition fieldPosition);
	public abstract PointInTime parse(String source, ParsePosition pos);
	public abstract Date parseDate(String source, ParsePosition pos);

	public PointInTime parse(String source) throws ParseException {
		ParsePosition pos = new ParsePosition(0);
		PointInTime result = parse(source, pos);
		if (pos.getIndex() == 0)
			//throw new ParseException("Unparseable point in time: \"" + source + "\"", pos.getErrorIndex());
			throw new ParseException("Unparseable point in time: \"" + source + "\"", pos.getIndex());
		return result;
	}

	public Date parseDate(String source) throws ParseException {
		ParsePosition pos = new ParsePosition(0);
		Date result = parseDate(source, pos);
		if (pos.getIndex() == 0)
			//throw new ParseException("Unparseable date: \"" + source + "\"", pos.getErrorIndex());
			throw new ParseException("Unparseable date: \"" + source + "\"", pos.getIndex());
		return result;
	}

	public StringBuffer format(Object obj, StringBuffer toAppendTo, FieldPosition pos) {
		if (obj instanceof PointInTime) {
			return format((PointInTime) obj, toAppendTo, pos);
		} else if (obj instanceof Date) {
			return format((Date) obj, toAppendTo, pos);
		} else {
			throw new IllegalArgumentException();
		}
	}

	public Object parseObject(String source, ParsePosition pos) {
		return parse(source, pos);
	}
}
