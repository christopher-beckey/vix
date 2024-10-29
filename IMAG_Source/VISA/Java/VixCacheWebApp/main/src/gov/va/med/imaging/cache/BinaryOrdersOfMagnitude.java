/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jun 17, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 * 
 * This class does encapsulates binary orders of magnitude for display
 * purposes ONLY.  The results of parsing and formatting to/from
 * strings is not precise.
 */
package gov.va.med.imaging.cache;

/**
 * @author VHAISWBECKEC
 *
 */
public enum BinaryOrdersOfMagnitude
{
	B("Byte", 1L),
	KB("Kilobyte", 1024L ),
	MB("Megabyte", 1048576L ),
	GB("Gigabyte", 1073741824L ),
	TB("Terabyte", 1099511627776L ),
	PB("Petabyte", 1125899906842624L ),
	EB("Exabyte", 1152921504606846976L );
	
	private final String name;
	private final long value;
	
	BinaryOrdersOfMagnitude(String name, long value)
	{
		this.name = name;
		this.value = value;
	}

	/**
     * @return the name
     */
    public String getName()
    {
    	return name;
    }

	/**
     * @return the value
     */
    public long getValue()
    {
    	return value;
    }
	
	/**
	 * 
	 * @param value
	 * @return
	 */
	public static BinaryOrdersOfMagnitude valueOfIgnoreCase(String value)
	{
		value = value.toUpperCase();
		return BinaryOrdersOfMagnitude.valueOf(value);
	}
	
	/**
	 * 
	 * @param value
	 * @return
	 */
	public static BinaryOrdersOfMagnitude greatestMagnitudeLessThan(long value)
	{
		if( value == 0 )
			return BinaryOrdersOfMagnitude.B;
		
		long absValue = Math.abs(value);
		
		BinaryOrdersOfMagnitude result = BinaryOrdersOfMagnitude.B;
		for(BinaryOrdersOfMagnitude mag : BinaryOrdersOfMagnitude.values())
		{
			if( mag == BinaryOrdersOfMagnitude.B )
				continue;
			if( mag.getValue() > absValue )
				break;
			result = mag;
		}
		
		return result;
	}
	
	/**
	 * 
	 * @param value
	 * @return
	 */
	public static String format(long value)
	{
		return format(value, false);
	}
	
	/**
	 * Take a long value and turn it into a human readable String
	 * in the form: number OrderOfMagnitude
	 * e.g. 1024 -> 1 KB
	 *      
	 * @param value
	 * @return
	 */
	public static String format(long value, boolean longform)
	{
		BinaryOrdersOfMagnitude targetMagnitude = greatestMagnitudeLessThan(value);
		
		long lngValue = value / targetMagnitude.getValue();
			
		StringBuilder sb = new StringBuilder();
		sb.append(lngValue);
		
		sb.append(' ');
		sb.append(longform ? targetMagnitude.getName() : targetMagnitude.toString());
		
		return sb.toString();
	}
}
