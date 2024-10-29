/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 22, 2011
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
public class DataDictionaryFile
{
	private final String number;
	private final String name;
	private final List<DataDictionaryFileField> fields;
	
	public DataDictionaryFile(String number, String name)
	{
		this.name = name;
		this.number = number;
		this.fields = new ArrayList<DataDictionaryFileField>();
	}

	public String getNumber()
	{
		return number;
	}

	public String getName()
	{
		return name;
	}

	public List<DataDictionaryFileField> getFields()
	{
		return fields;
	}
	
	public void addField(DataDictionaryFileField fileField)
	{
		fields.add(fileField);
	}
	
	public String [] getFieldNumbers()
	{
		String [] result = new String[fields.size()];
		for(int i = 0; i < fields.size(); i++)
		{
			result[i] = fields.get(i).getFieldNumber();
		}
		return result;
	}
}
