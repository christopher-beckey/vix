/**
 * 
 */
package gov.va.med.imaging.presentation.state.rest.types;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


/**
 * @author William Peterson
 *
 */
@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class PresentationStateRecordType implements Serializable{
	

	private static final long serialVersionUID = 8033157210478470345L;
	
	@XmlElement(name = "studyid")
	private String pStateStudyUID = null;

	@XmlElement(name = "pstateuid")
	private String pStateUID = null;
	
	@XmlElement(name = "name")
	private String pStateName = null;
	
	@XmlElement(name = "source")
	private String pStateSource = null;
	
	@XmlElement(name = "data")
	private String pStateData = null;
	
	@XmlElement(name = "duz")
	private String duz = null;
	
	@XmlElement(name = "timestamp")
	private String timeStamp = null;
	
	
	private boolean includeDeleted = false;
	private boolean includeOtherUsers = true;
	private boolean includeDetails = false;
	
	public PresentationStateRecordType()
	{
		super();
	}
	

	public PresentationStateRecordType(String studyUID, String pStateUID, 
			String pStateName, String source, String data,
			String duz, String timeStamp) {
		super();
		this.pStateStudyUID = studyUID;
		this.pStateUID = pStateUID;
		this.pStateName = pStateName;
		this.pStateSource = source;
		this.pStateData = data;
		this.duz = duz;
		this.timeStamp = timeStamp;
	}


	public String getPStateUID() {
		return pStateUID;
	}


	public String getPStateStudyUID() {
		return pStateStudyUID;
	}


	public String getPStateSource() {
		return pStateSource;
	}


	public String getPStateData() {
		return pStateData;
	}

	public boolean isIncludeDeleted() {
		return includeDeleted;
	}

	public boolean isIncludeOtherUsers() {
		return includeOtherUsers;
	}

	public boolean isIncludeDetails() {
		return includeDetails;
	}

	public String getPStateName() {
		return pStateName;
	}


	@Override
	public String toString() {
		
		boolean hasData = this.pStateData != null ? true : false;
		
		return "PresentationStateRecordType [pStateStudyUID=" + pStateStudyUID
				+ ", pStateUID=" + pStateUID + ", pStateName=" + pStateName
				+ ", pStateSource=" + pStateSource + ", pStateData="
				+ hasData + ", duz=" + duz + ", timeStamp=" + timeStamp
				+ ", includeDeleted=" + includeDeleted + ", includeOtherUsers="
				+ includeOtherUsers + ", includeDetails=" + includeDetails
				+ "]";
	}



}
