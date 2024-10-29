package va.gov.vista.kidsassembler.manifest;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlTransient;

@XmlAccessorType(XmlAccessType.FIELD)
public class ManifestComponent {
	@XmlAttribute(name = "name")
	protected String name;

	@XmlAttribute(name = "export")
	protected String export;

	@XmlTransient
	protected String content;

	public String getContent() {
		return content;
	}

	public String getExport() {
		return export;
	}

	public String getName() {
		return name;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public void setExport(String export) {
		this.export = export;
	}

	public void setName(String name) {
		this.name = name;
	}
}
