package va.gov.vista.kidsbundler.manifest;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;

@XmlAccessorType(XmlAccessType.FIELD)
public class Patch {
	@XmlAttribute(name = "name")
	protected String name;
	
	@XmlAttribute(name = "export")
	protected String export;

	public String getExport() {
		return export;
	}

	public String getName() {
		return name;
	}

	public void setExport(String export) {
		this.export = export;
	}

	public void setName(String name) {
		this.name = name;
	}
}

