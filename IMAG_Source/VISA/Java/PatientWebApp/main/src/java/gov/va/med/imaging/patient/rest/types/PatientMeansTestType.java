package gov.va.med.imaging.patient.rest.types;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAILTJAHJB
 *
 */
@XmlRootElement
public class PatientMeansTestType 
{
	private int code;
	private String message;

	
	public PatientMeansTestType()
	{
		super();
	}
	
	
	public PatientMeansTestType(int code, String message)
	{
		super();
		this.code = code;
		this.message = message;
	}
	
	public int getCode()
	{
		return code;
	}
	
	public void setCode(int code)
	{
		this.code = code;
	}
	
	public String getMessage()
	{
		return message;
	}

	public void setMessage(String message)
	{
		this.message = message;
	}
}
