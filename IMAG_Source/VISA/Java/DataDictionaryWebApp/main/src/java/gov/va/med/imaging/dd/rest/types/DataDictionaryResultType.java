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
package gov.va.med.imaging.dd.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement(name="dataDictionaryResult")
public class DataDictionaryResultType
{
	private DataDictionaryQueryType dataDictionaryQuery;
	private DataDictionaryResultEntryType [] results;
	private boolean more;
	private String moreParameter;
	
	public DataDictionaryResultType()
	{
		super();
	}
	
	public DataDictionaryResultType(DataDictionaryQueryType dataDictionaryQuery,
			DataDictionaryResultEntryType [] results, boolean more,
			String moreParameter)
	{
		super();
		this.dataDictionaryQuery = dataDictionaryQuery;
		this.results = results;
		this.more = more;
		this.moreParameter = moreParameter;
	}

	@XmlElement(name = "query")
	public DataDictionaryQueryType getDataDictionaryQuery()
	{
		return dataDictionaryQuery;
	}

	public void setDataDictionaryQuery(DataDictionaryQueryType dataDictionaryQuery)
	{
		this.dataDictionaryQuery = dataDictionaryQuery;
	}

	@XmlElement(name = "result")
	public DataDictionaryResultEntryType[] getResults()
	{
		return results;
	}

	public void setResults(DataDictionaryResultEntryType[] results)
	{
		this.results = results;
	}

	public boolean isMore()
	{
		return more;
	}

	public void setMore(boolean more)
	{
		this.more = more;
	}

	public String getMoreParameter()
	{
		return moreParameter;
	}

	public void setMoreParameter(String moreParameter)
	{
		this.moreParameter = moreParameter;
	}
}
