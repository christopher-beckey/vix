package gov.va.med.imaging.facade.configuration;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import java.util.List;

@XmlAccessorType(XmlAccessType.FIELD)
public class ScpModalityList {
    @XmlAttribute
    public String dataSource;
    public String addImageLevelFilter; // additional Image level filtering flag [true, false]

    @XmlElement
    public List<String> modalities;

	public String getDataSource() {
		return dataSource;
	}

	public void setDataSource(String dataSource) {
		this.dataSource = dataSource;
	}

	public String getAddImageLevelFilter() {
		return (addImageLevelFilter==null)?"false":addImageLevelFilter;
	}

	public void setAddImageLevelFilter(String addImageLevelFilter) {
		this.addImageLevelFilter = addImageLevelFilter;
	}

	public List<String> getModalities() {
		return modalities;
	}

	public void setModalities(List<String> modalities) {
		this.modalities = modalities;
	}

	@Override
	public String toString() {
		return "ScpModalityList{" +
				"dataSource='" + dataSource + '\'' +
				",\n addImageLevelFilter='" + addImageLevelFilter + '\'' +
				",\n modalities=" + modalities +
				'}';
	}
}
