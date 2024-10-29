package gov.va.med.imaging.dicom.email;

public class DicomEmailInfo 
{
	private DicomEmailType messageType;
	private DicomLevel dicomLevel;
	private String messageId;
	
	public DicomEmailInfo(DicomEmailType messageType, DicomLevel dicomLevel, String messageId) 
	{
		this.messageType = messageType;
		this.dicomLevel = dicomLevel;
		this.messageId = messageId;
	}
	
	public DicomEmailType getMessageType() {
		return messageType;
	}
	public DicomLevel getDicomLevel() {
		return dicomLevel;
	}
	public String getMessageId() {
		return messageId;
	}
}
