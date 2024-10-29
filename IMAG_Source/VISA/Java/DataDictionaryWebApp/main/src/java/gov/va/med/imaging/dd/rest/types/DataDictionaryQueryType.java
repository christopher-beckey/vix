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
import javax.xml.bind.annotation.XmlType;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement(name="dataDictionaryQuery")
@XmlType(propOrder={"fileNumber", "fields", "maximumResults", "moreParameter"})
public class DataDictionaryQueryType
{
	private String fileNumber;
	private String [] fields;
	private int maximumResults;
	private String moreParameter;
	
	public DataDictionaryQueryType()
	{
		super();
	}
	
	public DataDictionaryQueryType(String fileNumber, String[] fields,
			int maximumResults, String moreParameter)
	{
		super();
		this.fileNumber = fileNumber;
		this.fields = fields;
		this.maximumResults = maximumResults;
		this.moreParameter = moreParameter;
	}

	public String getFileNumber()
	{
		return fileNumber;
	}

	public void setFileNumber(String fileNumber)
	{
		this.fileNumber = fileNumber;
	}

	@XmlElement(name = "field")
	public String[] getFields()
	{
		return fields;
	}

	public void setFields(String[] fields)
	{
		this.fields = fields;
	}

	public int getMaximumResults()
	{
		return maximumResults;
	}

	public void setMaximumResults(int maximumResults)
	{
		this.maximumResults = maximumResults;
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
