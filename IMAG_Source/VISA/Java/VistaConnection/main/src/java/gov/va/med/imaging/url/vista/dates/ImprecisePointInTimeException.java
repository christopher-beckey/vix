package gov.va.med.imaging.url.vista.dates;


public class ImprecisePointInTimeException extends RuntimeException {

	private PointInTime t;

	public ImprecisePointInTimeException(PointInTime t) {
		super("the specified point in time was not precise enough to support the requested operation");
		this.t = t;
	}
	
	public PointInTime getPointInTime() {
		return t;
	}
}
