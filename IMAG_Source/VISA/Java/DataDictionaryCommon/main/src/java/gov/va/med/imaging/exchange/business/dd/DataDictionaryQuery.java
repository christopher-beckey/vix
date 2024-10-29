/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 12, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.exchange.business.dd;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DataDictionaryQuery
extends AbstractDataDictionaryQuery
{
	private final int maximumResults;
	private final String moreParameter;
	
	public DataDictionaryQuery(String fileNumber, String[] fields,
			int maximumResults, String moreParameter)
	{
		super(fileNumber, fields);
		this.maximumResults = maximumResults;
		this.moreParameter = moreParameter;
	}
	
	public DataDictionaryQuery(String fileNumber, String[] fields,
			int maximumResults)
	{
		this(fileNumber, fields, maximumResults, null);
	}
	
	public DataDictionaryQuery(String fileNumber, String[] fields)
	{
		this(fileNumber, fields, Integer.MAX_VALUE, null);
	}
	
	public int getMaximumResults()
	{
		return maximumResults;
	}
	
	public boolean isMaxSpecified()
	{
		return maximumResults < Integer.MAX_VALUE;
	}

	public String getMoreParameter()
	{
		return moreParameter;
	}
	
	public boolean isMoreParameterSpecified()
	{
		return moreParameter != null;
	}
}
