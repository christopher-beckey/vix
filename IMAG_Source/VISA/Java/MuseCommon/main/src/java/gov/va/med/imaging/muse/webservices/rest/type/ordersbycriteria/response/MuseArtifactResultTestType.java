package gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name="Test")
public class MuseArtifactResultTestType 
implements Serializable{

	private static final long serialVersionUID = -7588444860010283845L;

	@XmlElement(name="AcquiringTechId")
	private String acquiringTechId = null;
	@XmlElement(name="AcquisitionTimestamp")	
	private String acquisitionTimestamp = null;
	@XmlElement(name="FormatType")	
	private String formatType = null;
	@XmlElement(name="InjuryClass")	
	private String injuryClass = null;
	@XmlElement(name="LocationId")	
	private String locationId = null;
	@XmlElement(name="LocationName")	
	private String locationName = null;
	@XmlElement(name="OrderingMDId")	
	private String orderingMDId = null;
	@XmlElement(name="OriginalChecksum")	
	private String originalChecksum = null;
	@XmlElement(name="Patient", type=MuseArtifactResultPatientType.class)	
	private MuseArtifactResultPatientType patient = null;
	@XmlElement(name="Priority")	
	private String priority = null;
	@XmlElement(name="ReferringMDId")	
	private String referringMDId = null;
	@XmlElement(name="SubType")	
	private String subType = null;
	@XmlElement(name="TestId")	
	private String testId = null;
	@XmlElement(name="TestIdInt")	
	private Integer testIdInt = 0;
	@XmlElement(name="TestStatusText")	
	private String testStatusText = null;
	@XmlElement(name="TestTypeQualifier")	
	private String testTypeQualifier = null;
	@XmlElement(name="TestTypeText")	
	private String testTypeText = null;
	@XmlElement(name="RestingECG")	
	private String restingECG = null;
	@XmlElement(name="Type")
	private String type = null;
	@XmlElement(name="TheTestStatus")
	private String theTestStatus = null;
	
	/**
	 * @return the acquiringTechId
	 */
	public String getAcquiringTechId() {
		return acquiringTechId;
	}

	/**
	 * @return the acquisitionTimestamp
	 */
	public String getAcquisitionTimestamp() {
		return acquisitionTimestamp;
	}

	/**
	 * @return the formatType
	 */
	public String getFormatType() {
		return formatType;
	}

	/**
	 * @return the injuryClass
	 */
	public String getInjuryClass() {
		return injuryClass;
	}

	/**
	 * @return the locationId
	 */
	public String getLocationId() {
		return locationId;
	}

	/**
	 * @return the locationName
	 */
	public String getLocationName() {
		return locationName;
	}

	/**
	 * @return the orderingMDId
	 */
	public String getOrderingMDId() {
		return orderingMDId;
	}

	/**
	 * @return the originalChecksum
	 */
	public String getOriginalChecksum() {
		return originalChecksum;
	}

	/**
	 * @return the patient
	 */
	public MuseArtifactResultPatientType getPatient() {
		return patient;
	}

	/**
	 * @return the priority
	 */
	public String getPriority() {
		return priority;
	}

	/**
	 * @return the referringMDId
	 */
	public String getReferringMDId() {
		return referringMDId;
	}

	/**
	 * @return the subType
	 */
	public String getSubType() {
		return subType;
	}

	/**
	 * @return the testId
	 */
	public String getTestId() {
		return testId;
	}

	/**
	 * @return the testIdInt
	 */
	public Integer getTestIdInt() {
		return testIdInt;
	}

	/**
	 * @return the testStatusText
	 */
	public String getTestStatusText() {
		return testStatusText;
	}

	/**
	 * @return the testTypeQualifier
	 */
	public String getTestTypeQualifier() {
		return testTypeQualifier;
	}

	/**
	 * @return the testTypeText
	 */
	public String getTestTypeText() {
		return testTypeText;
	}

	/**
	 * @return the restingECG
	 */
	public String getRestingECG() {
		return restingECG;
	}
	
	/**
	 * @return the type
	 */
	public String getType() {
		return type;
	}
	
	/**
	 * @return the theTestStatus
	 */
	public String getTheTestStatus() {
		return theTestStatus;
	}
}
