package gov.va.med.imaging.dd.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="dataDictionaryFileField")
public class DataDictionaryFileFieldType
{	
	private String fieldNumber;
	private String fieldName;
	private String pointerFileNumber;
	
	public DataDictionaryFileFieldType()
	{
		super();
	}
	
	public DataDictionaryFileFieldType(String fieldNumber, String fieldName)
	{
		super();
		this.fieldNumber = fieldNumber;
		this.fieldName = fieldName;
	}
	
	@XmlElement(name="number")
	public String getFieldNumber()
	{
		return fieldNumber;
	}
	
	public void setFieldNumber(String fieldNumber)
	{
		this.fieldNumber = fieldNumber;
	}
	
	@XmlElement(name="name")
	public String getFieldName()
	{
		return fieldName;
	}
	
	public void setFieldName(String fieldName)
	{
		this.fieldName = fieldName;
	}

	public void setPointerFileNumber(String filePointerNumber) {
		this.pointerFileNumber = filePointerNumber;
	}

	public String getPointerFileNumber() {
		return pointerFileNumber;
	}
}
