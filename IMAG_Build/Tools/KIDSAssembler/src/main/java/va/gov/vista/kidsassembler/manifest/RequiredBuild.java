package va.gov.vista.kidsassembler.manifest;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;

@XmlAccessorType(XmlAccessType.FIELD)
public class RequiredBuild {
	@XmlAttribute(name = "name")
	protected String name;
	
	@XmlAttribute(name = "action")
	protected String action;

	public String getAction() {
		return action;
	}

	public String getName() {
		return name;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public void setName(String name) {
		this.name = name;
	}
}
