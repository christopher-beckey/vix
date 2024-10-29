package gov.va.med.imaging.url.vista.dates;


public class IntervalOfTime implements Cloneable {

	private PointInTime low;
	private PointInTime high;
	private boolean lowClosed;
	private boolean highClosed;

	public IntervalOfTime(PointInTime low, PointInTime high) {
		this(low, high, true, false);
	}

	public IntervalOfTime(PointInTime low, PointInTime high, boolean lowClosed, boolean highClosed) {
		if (!high.after(low))
			throw new IllegalArgumentException("The high point in time of an interval of time should be after the low point in time");
		this.lowClosed = lowClosed;
		this.highClosed = highClosed;
		setLow(low);
		setHigh(high);
	}

	private void setLow(PointInTime low) {
		if (Precision.MILLISECOND.equals(low.getPrecision())) {
			this.low = (PointInTime) low.clone();
		} else {
			this.low = low.promote().getLow();
		}
	}

	private void setHigh(PointInTime high) {
		if (Precision.MILLISECOND.equals(high.getPrecision())) {
			this.high = (PointInTime) high.clone();
		} else {
			this.high = high.promote().getHigh();
			if (isHighClosed()) {
				this.high.subtract(ElapsedTime.valueOfMilliseconds(1));
			}
		}
	}

	public PointInTime getLow() {
		return low;
	}

	public PointInTime getHigh() {
		return high;
	}

	public PointInTime getCenter() {
		PointInTime center = (PointInTime) getLow().clone();
		return center.add(getWidth().divide(2));
	}

	public ElapsedTime getWidth() {
		return high.subtract(low);
	}

	public boolean isLowClosed() {
		return low != null && lowClosed;
	}
	public boolean isHighClosed() {
		return high != null && highClosed;
	}

	public IntervalOfTime convexHull(IntervalOfTime i) {
		return convexHull(this, i);
	}

	public PointInTime demote() {
		return getCenter();
	}

	public String toString() {
		StringBuffer buffer = new StringBuffer();
		if (isLowClosed()) {
			buffer.append('[');
		} else {
			buffer.append(']');
		}
		buffer.append(getLow().toString());
		buffer.append("..");
		buffer.append(getHigh().toString());
		if (isHighClosed()) {
			buffer.append(']');
		} else {
			buffer.append('[');
		}
		return buffer.toString();
	}

	public boolean contains(PointInTime t) {
		return contains(t.promote());
	}

	public boolean contains(IntervalOfTime i) {
		return getLow().before(i.getLow()) && getHigh().after(i.getLow());
	}

	public Object clone() {
		try {
			IntervalOfTime i = (IntervalOfTime) super.clone();
			i.low = (PointInTime) i.low.clone();
			i.high = (PointInTime) i.high.clone();
			return i;
		} catch (CloneNotSupportedException e) {
			return null; // should never occur 
		}
	}

	public IntervalOfTime intersection(IntervalOfTime i) {
		return intersection(this, i);
	}

	public static IntervalOfTime intersection(IntervalOfTime i1, IntervalOfTime i2) {
		if (i1.getLow().before(i2.getLow())) {
			if (i2.getLow().after(i1.getHigh())) {
				return null;
			} else {
				return new IntervalOfTime(i2.getLow(), i1.getHigh());
			}
		} else {
			if (i1.getLow().after(i2.getHigh())) {
				return null;
			} else {
				return new IntervalOfTime(i1.getLow(), i2.getHigh());
			}
		}
	}

	public static IntervalOfTime convexHull(IntervalOfTime i1, IntervalOfTime i2) {
		return null;
	}
	
	public boolean equals(Object obj) {
		if (!(obj instanceof IntervalOfTime)) return false;
		IntervalOfTime i = (IntervalOfTime) obj;
		return isLowClosed() == i.isLowClosed() && isHighClosed() == i.isHighClosed() && getLow().equals(i.getLow()) && getHigh().equals(i.getHigh());
	}

}
