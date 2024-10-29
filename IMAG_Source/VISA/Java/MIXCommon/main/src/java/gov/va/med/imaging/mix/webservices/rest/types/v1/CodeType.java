package gov.va.med.imaging.mix.webservices.rest.types.v1;

import javax.xml.bind.annotation.XmlRootElement;
/**
 * @author vhaisatittoc
 *
 */
@XmlRootElement
public class CodeType
{
	private CodingType [] coding;
	
	public CodeType(CodingType[] coding)
	{
		super();
		this.coding = coding;
	}

	public CodingType[] getCoding()
	{
		return coding;
	}

	public void setCoding(CodingType[] coding)
	{
		this.coding = coding;
	}

}
