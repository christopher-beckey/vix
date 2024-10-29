package gov.va.med.imaging.viewer.business;

public enum ImageFilterField 
{
	FILTERIEN("0"),
	FILTERNAME(".01"),
	PACKAGEINDEX("1"),
	CLASSINDEX("2"),
	TYPEINDEX("3"),
	EVENTINDEX("4"),
	SPECIALTIESINDEX("5"),
	DATEFROM("6"),
	DATETHROUGH("7"),
	RELATIVERANGE("8"),
	ORIGIN("9"),
	IMAGESTATUS("10"),
	DESCRIPTIONCONTAINS("11"),
	CAPTUREDBY("12"),
	USECAPTUREDATES("13"),
	DAYRANGE("14"),
	COLUMNWIDTHS("15"),
	PERCENT("16");
	
	private String fieldNumber;
	
	public String getFieldNumber()
	{
		return fieldNumber;
		
	}
	
	private ImageFilterField(String fieldNumber)
	{
		this.fieldNumber = fieldNumber;
	}

}
