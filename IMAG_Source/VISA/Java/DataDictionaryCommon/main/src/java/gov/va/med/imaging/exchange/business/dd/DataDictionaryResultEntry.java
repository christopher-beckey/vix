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

import java.util.ArrayList;
import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DataDictionaryResultEntry
{
	private final String ien;
	private final List<DataDictionaryResultEntryField> fields = 
		new ArrayList<DataDictionaryResultEntryField>();
	
	public DataDictionaryResultEntry(String ien)
	{
		super();
		this.ien = ien;
	}

	public String getIen()
	{
		return ien;
	}

	public List<DataDictionaryResultEntryField> getFields()
	{
		return fields;
	}
	
	public void addField(DataDictionaryResultEntryField field)
	{
		this.fields.add(field);
	}
	
	/*
	private final String result;

	public DataDictionaryResultEntry(String result)
	{
		super();
		this.result = result;
	}

	public String getResult()
	{
		return result;
	}*/
}
