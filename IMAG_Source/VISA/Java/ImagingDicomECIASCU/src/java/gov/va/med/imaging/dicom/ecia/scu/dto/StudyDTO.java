package gov.va.med.imaging.dicom.ecia.scu.dto;

import java.io.Serializable;
import java.util.Arrays;
import java.util.List;

/**
 * Wrapper object for Study data from source.
 * Closely matched with VA StudyType class but could
 * be changed to add more data.  If so, re-generate or add
 * to the three generated methods as well.
 * 
 * DO NOT remove any existing fields.  Will break.
 * 
 * @author Quoc Nguyen
 *
 */
public class StudyDTO implements Serializable 
{	
	/**
	* Determines if a de-serialized file is compatible with this class.
	* Included here as a reminder of its importance.  DO NOT CHANGE.
	*/
	private static final long serialVersionUID = 1116471155622776147L;
		
	private String studyInstanceUID;
	private String studyDescription;
	private String procedureCodeSeq;
	private String procedureCreationDate;
	private String requestedProcedureDescription;
	private String patientId;
	private String patientName;
	private String clinicalTrialSiteId;
	private String clinicalTrialSiteName;
	private int imageCount;
	private int seriesCount;
	private String [] modalitiesInStudy;
	private String specialtyDescription;
	private String reportContent;
	private String studyDate;
	private String studyTime;
	private String institutionName;
	private String reportTextValue;
	private String accessionNumber;

	private List<SeriesDTO> seriesDTOs;
	
//++++++++++++++++ Getters +++++++++++++++++++++++++
	
	public String getStudyInstanceUID() {
		return studyInstanceUID;
	}
	public String getStudyDescription() {
		return studyDescription;
	}
	public String getProcedureCodeSeq() {
		return procedureCodeSeq;
	}
	public String getProcedureCreationDate() {
		return procedureCreationDate;
	}
	public String getRequestedProcedureDescription() {
		return requestedProcedureDescription;
	}
	public String getPatientId() {
		return patientId;
	}
	public String getPatientName() {
		return patientName;
	}
	public String getClinicalTrialSiteId() {
		return clinicalTrialSiteId;
	}
	public String getClinicalTrialSiteName() {
		return clinicalTrialSiteName;
	}
	public int getImageCount() {
		return imageCount;
	}
	public int getSeriesCount() {
		return seriesCount;
	}
	public String [] getModalitiesInStudy() {
		return modalitiesInStudy;
	}
	public String getSpecialtyDescription() {
		return specialtyDescription;
	}
	public String getReportContent() {
		return reportContent;
	}
	public List<SeriesDTO> getSeriesDTOs() {
		return seriesDTOs;
	}
	public String getStudyDate() {
		return studyDate;
	}
	public String getStudyTime() {
		return studyTime;
	}
	public String getInstitutionName() {
		return institutionName;
	}
	public String getReportTextValue() {
		return reportTextValue;
	}
	public String getAccessionNumber() {
		return accessionNumber;
	}

//++++++++++++++++ Setters +++++++++++++++++++++++++
	
	public void setStudyInstanceUID(String studyInstanceUID) {
		this.studyInstanceUID = studyInstanceUID;
	}
	public void setStudyDescription(String studyDescription) {
		this.studyDescription = studyDescription;
	}
	public void setProcedureCodeSeq(String procedureCodeSeq) {
		this.procedureCodeSeq = procedureCodeSeq;
	}
	public void setProcedureCreationDate(String procedureCreationDate) {
		this.procedureCreationDate = procedureCreationDate;
		
		// Hardcoded a date in the future for testing
		//this.procedureCreationDate = procedureCreationDate == null || procedureCreationDate.equals("") ? "20211231" : "" + procedureCreationDate;
	}
	public void setRequestedProcedureDescription(String requestedProcedureDescription) {
		this.requestedProcedureDescription = requestedProcedureDescription;
	}
	public void setPatientId(String patientId) {
		this.patientId = patientId;
	}
	public void setPatientName(String patientName) {
		this.patientName = patientName;
	}
	public void setClinicalTrialSiteId(String clinicalTrialSiteId) {
		this.clinicalTrialSiteId = clinicalTrialSiteId;
	}
	public void setClinicalTrialSiteName(String clinicalTrialSiteName) {
		this.clinicalTrialSiteName = clinicalTrialSiteName;
	}
	public void setImageCount(int imageCount) {
		this.imageCount = imageCount;
	}
	public void setSeriesCount(int seriesCount) {
		this.seriesCount = seriesCount;
	}
	public void setModalitiesInStudy(String [] modalitiesInStudy) {
		this.modalitiesInStudy = modalitiesInStudy;
	}
	public void setSpecialtyDescription(String specialtyDesctiption) {
		this.specialtyDescription = specialtyDesctiption;
	}
	public void setReportContent(String reportContent) {
		this.reportContent = reportContent;
	}
	public void setSeriesDTOs(List<SeriesDTO> seriesDTOs) {
		this.seriesDTOs = seriesDTOs;
	}
	public void setStudyDate(String studyDate) {
		this.studyDate = studyDate;
	}
	public void setStudyTime(String studyTime) {
		this.studyTime = studyTime;
	}
	public void setInstitutionName(String institutionName) {
		this.institutionName = institutionName;
	}
	public void setReportTextValue(String reportTextValue) {
		this.reportTextValue = reportTextValue;
	}
	public void setAccessionNumber(String accessionNumber) {
		this.accessionNumber = accessionNumber;
	}
	

//++++++++++++++++ Eclipse generated codes ++++++++++++++++++++++++

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((accessionNumber == null) ? 0 : accessionNumber.hashCode());
		result = prime * result + ((clinicalTrialSiteId == null) ? 0 : clinicalTrialSiteId.hashCode());
		result = prime * result + ((clinicalTrialSiteName == null) ? 0 : clinicalTrialSiteName.hashCode());
		result = prime * result + imageCount;
		result = prime * result + ((institutionName == null) ? 0 : institutionName.hashCode());
		result = prime * result + Arrays.hashCode(modalitiesInStudy);
		result = prime * result + ((patientId == null) ? 0 : patientId.hashCode());
		result = prime * result + ((patientName == null) ? 0 : patientName.hashCode());
		result = prime * result + ((procedureCodeSeq == null) ? 0 : procedureCodeSeq.hashCode());
		result = prime * result + ((procedureCreationDate == null) ? 0 : procedureCreationDate.hashCode());
		result = prime * result + ((reportContent == null) ? 0 : reportContent.hashCode());
		result = prime * result + ((reportTextValue == null) ? 0 : reportTextValue.hashCode());
		result = prime * result
				+ ((requestedProcedureDescription == null) ? 0 : requestedProcedureDescription.hashCode());
		result = prime * result + seriesCount;
		result = prime * result + ((seriesDTOs == null) ? 0 : seriesDTOs.hashCode());
		result = prime * result + ((specialtyDescription == null) ? 0 : specialtyDescription.hashCode());
		result = prime * result + ((studyDate == null) ? 0 : studyDate.hashCode());
		result = prime * result + ((studyDescription == null) ? 0 : studyDescription.hashCode());
		result = prime * result + ((studyInstanceUID == null) ? 0 : studyInstanceUID.hashCode());
		result = prime * result + ((studyTime == null) ? 0 : studyTime.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		StudyDTO other = (StudyDTO) obj;
		if (accessionNumber == null) {
			if (other.accessionNumber != null)
				return false;
		} else if (!accessionNumber.equals(other.accessionNumber))
			return false;
		if (clinicalTrialSiteId == null) {
			if (other.clinicalTrialSiteId != null)
				return false;
		} else if (!clinicalTrialSiteId.equals(other.clinicalTrialSiteId))
			return false;
		if (clinicalTrialSiteName == null) {
			if (other.clinicalTrialSiteName != null)
				return false;
		} else if (!clinicalTrialSiteName.equals(other.clinicalTrialSiteName))
			return false;
		if (imageCount != other.imageCount)
			return false;
		if (institutionName == null) {
			if (other.institutionName != null)
				return false;
		} else if (!institutionName.equals(other.institutionName))
			return false;
		if (!Arrays.equals(modalitiesInStudy, other.modalitiesInStudy))
			return false;
		if (patientId == null) {
			if (other.patientId != null)
				return false;
		} else if (!patientId.equals(other.patientId))
			return false;
		if (patientName == null) {
			if (other.patientName != null)
				return false;
		} else if (!patientName.equals(other.patientName))
			return false;
		if (procedureCodeSeq == null) {
			if (other.procedureCodeSeq != null)
				return false;
		} else if (!procedureCodeSeq.equals(other.procedureCodeSeq))
			return false;
		if (procedureCreationDate == null) {
			if (other.procedureCreationDate != null)
				return false;
		} else if (!procedureCreationDate.equals(other.procedureCreationDate))
			return false;
		if (reportContent == null) {
			if (other.reportContent != null)
				return false;
		} else if (!reportContent.equals(other.reportContent))
			return false;
		if (reportTextValue == null) {
			if (other.reportTextValue != null)
				return false;
		} else if (!reportTextValue.equals(other.reportTextValue))
			return false;
		if (requestedProcedureDescription == null) {
			if (other.requestedProcedureDescription != null)
				return false;
		} else if (!requestedProcedureDescription.equals(other.requestedProcedureDescription))
			return false;
		if (seriesCount != other.seriesCount)
			return false;
		if (seriesDTOs == null) {
			if (other.seriesDTOs != null)
				return false;
		} else if (!seriesDTOs.equals(other.seriesDTOs))
			return false;
		if (specialtyDescription == null) {
			if (other.specialtyDescription != null)
				return false;
		} else if (!specialtyDescription.equals(other.specialtyDescription))
			return false;
		if (studyDate == null) {
			if (other.studyDate != null)
				return false;
		} else if (!studyDate.equals(other.studyDate))
			return false;
		if (studyDescription == null) {
			if (other.studyDescription != null)
				return false;
		} else if (!studyDescription.equals(other.studyDescription))
			return false;
		if (studyInstanceUID == null) {
			if (other.studyInstanceUID != null)
				return false;
		} else if (!studyInstanceUID.equals(other.studyInstanceUID))
			return false;
		if (studyTime == null) {
			if (other.studyTime != null)
				return false;
		} else if (!studyTime.equals(other.studyTime))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "StudyDTO [studyInstanceUID=" + studyInstanceUID + ", studyDescription=" + studyDescription
				+ ", procedureCodeSeq=" + procedureCodeSeq + ", procedureCreationDate=" + procedureCreationDate
				+ ", requestedProcedureDescription=" + requestedProcedureDescription + ", patientId=" + patientId
				+ ", patientName=" + patientName + ", clinicalTrialSiteId=" + clinicalTrialSiteId
				+ ", clinicalTrialSiteName=" + clinicalTrialSiteName + ", imageCount=" + imageCount + ", seriesCount="
				+ seriesCount + ", modalitiesInStudy=" + Arrays.toString(modalitiesInStudy) + ", specialtyDescription="
				+ specialtyDescription + ", reportContent=" + reportContent + ", studyDate=" + studyDate
				+ ", studyTime=" + studyTime + ", institutionName=" + institutionName + ", reportTextValue="
				+ reportTextValue + ", accessionNumber=" + accessionNumber + ", seriesDTOs=" + seriesDTOs + "]";
	}
}