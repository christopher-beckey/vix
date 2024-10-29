package gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name="Patient")
public class MuseArtifactResultPatientType 
implements Serializable{
	
	private static final long serialVersionUID = -8564981210220896303L;
	@XmlElement(name="DateOfBirth")
	private String dateOfBirth = null;
	@XmlElement(name="FirstName")
	private String firstName = null;
	@XmlElement(name="GenderText")
	private String genderText = null;
	@XmlElement(name="InternalId")
	private String internalId = null;
	@XmlElement(name="LastName")
	private String lastName = null;
	@XmlElement(name="PID")
	private String pID = null;
	@XmlElement(name="RaceText")
	private String raceText = null;
	/**
	 * @return the dateOfBirth
	 */
	public String getDateOfBirth() {
		return dateOfBirth;
	}

	/**
	 * @return the firstName
	 */
	public String getFirstName() {
		return firstName;
	}

	/**
	 * @return the genderText
	 */
	public String getGenderText() {
		return genderText;
	}

	/**
	 * @return the internalId
	 */
	public String getInternalId() {
		return internalId;
	}

	/**
	 * @return the lastName
	 */
	public String getLastName() {
		return lastName;
	}

	/**
	 * @return the pID
	 */
	public String getpID() {
		return pID;
	}

	/**
	 * @return the raceText
	 */
	public String getRaceText() {
		return raceText;
	}	
}
