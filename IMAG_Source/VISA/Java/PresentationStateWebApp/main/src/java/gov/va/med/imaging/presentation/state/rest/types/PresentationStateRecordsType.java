package gov.va.med.imaging.presentation.state.rest.types;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class PresentationStateRecordsType {

	@XmlElement(name = "pStateRecords")
	private PresentationStateRecordType [] pStateRecords;

	public PresentationStateRecordsType() {
		super();
	}
		
	public PresentationStateRecordsType(PresentationStateRecordType[] psRecords)
	{
		super();
		this.pStateRecords = psRecords;
	}

	public PresentationStateRecordType[] getPStateRecords()
	{
		return pStateRecords;
	}

	public void setPStateRecords(PresentationStateRecordType[] psRecords)
	{
		this.pStateRecords = psRecords;
	}
}
