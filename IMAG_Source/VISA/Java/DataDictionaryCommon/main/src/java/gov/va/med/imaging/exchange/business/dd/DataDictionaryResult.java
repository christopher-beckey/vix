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

import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DataDictionaryResult
{
	private final DataDictionaryQuery dataDictionaryQuery;
	private final List<DataDictionaryResultEntry> results;
	private final boolean more;
	private final String moreParameter;
	
	public DataDictionaryResult(DataDictionaryQuery dataDictionaryQuery,
			List<DataDictionaryResultEntry> results, boolean more,
			String moreParameter)
	{
		super();
		this.dataDictionaryQuery = dataDictionaryQuery;
		this.results = results;
		this.more = more;
		this.moreParameter = moreParameter;
	}
	
	public DataDictionaryResult(DataDictionaryQuery dataDictionaryQuery,
			List<DataDictionaryResultEntry> results)
	{
		super();
		this.dataDictionaryQuery = dataDictionaryQuery;
		this.results = results;
		this.more = false;
		this.moreParameter = null;
	}

	public DataDictionaryQuery getDataDictionaryQuery()
	{
		return dataDictionaryQuery;
	}

	public List<DataDictionaryResultEntry> getResults()
	{
		return results;
	}

	public boolean isMore()
	{
		return more;
	}

	public String getMoreParameter()
	{
		return moreParameter;
	}
	
	

}
