package va.gov.vista.kidsbundler.manifest;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "bundle")
@XmlAccessorType(XmlAccessType.PROPERTY)
public class KidsBundlerManifest {
	protected String comment;

	protected String name;		//  "MAG*3.0*Bundle"
	protected List<Patch> patches;
	
	protected String patchName;		//  "VistA Imaging Version 3.0 Patch 87 - DICOM Maintenance V"
	@XmlAttribute
	public String getComment() {
		return comment;
	}
	
	@XmlAttribute
	public String getName() {
		return name;
	}


	@XmlElementWrapper(name = "patches")
	@XmlElement(name = "patch")
	public List<Patch> getPatches() {
		return patches;
	}

	@XmlAttribute
	public String getPatchName() {
		return patchName;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
					 

	public void setName(String name) {
		this.name = name;
	}

	public void setPatches(List<Patch> patches) {
		this.patches = patches;
}

	public void setPatchName(String patchName) {
		this.patchName = patchName;
	}
}
