package gov.va.med.imaging.mix.webservices.rest.types.v1;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VACOTITTOC
 *
 * This ShallowStudy class is for MIX pass 1 level 1 query support, a brief summary of an ImagingStudy record added to FHIR DiagnosticReport (as ImagingStudy models are is only a reference), JSON tailored
 * Cardinality: Patient 1..* DiagnosticReport 0..* ImagingStudy 0..* Series 0..* Instance
 */
@XmlRootElement (name="ShallowStudy")
public class ShallowStudy implements Serializable, Comparable<ShallowStudy> 
{	
//	private static final long serialVersionUID = -5185851367113539916L;
	private String started;				// when study started (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format)
    private String procedure;			// Type of procedure performed -- not maintained for exchange, available from VistA!
	private Integer numberOfSeries;		// R! -- supposed to match series SET size
	private Integer numberOfInstances;	// R! -- supposed to match sum of Instance SET sizes from all series SET
	private ModCodeType[] modalityList;		// One or more Modalities separated by ','
	private String uid;					// R! DICOM Study UID -- To non-VA requester a morphed studyURN is given (built-in VA site number, etc.) 

	public ShallowStudy()
	{
		started = uid  =  procedure = "";
		modalityList = null;
		numberOfSeries = 0;
		numberOfInstances = 0;
	}

	/**
	 * Create a new ShallowStudy
	 * @param sIUID DICOM Study UID -- To non-VA requester a morphed studyURN is given (built-in VA site number, etc.)
	 * @param sAccN AccessionNumber -- hooks studies to one report, that is one order (max 16/DICOM)
	 * @param sID the Study's ID string (max 16 in DICOM)
	 * @param sOrder Placer Order number - not maintained
	 * @param mtysInStd One or more Modalities in study in a CodingType array
	 * @param sRef Referring physician - not maintained for exchange
	 * @param sProc Type of procedure performed -- not maintained for exchange
	 */
	public ShallowStudy(String sDT, String sProc, Integer numSer, Integer numInst, ModCodeType[] mtysInStd, String sIUID)
	{
		this.started = sDT;
		this.procedure = sProc;
		this.modalityList = mtysInStd;
		this.numberOfSeries = 0;
		this.numberOfInstances = 0;
		this.uid = sIUID;
	}

	public String getStarted() {
		return started;
	}

	public void setStarted(String startDateTime) {
		this.started = startDateTime;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String studyUID) {
		this.uid = studyUID;
	}

	public ModCodeType[] getModalityList() {
		return modalityList;
	}

	public void setModalitiesInStudy(ModCodeType[] modsInStudy) {
		this.modalityList = modsInStudy;
	}

	public String getProcedure() {
		return procedure;
	}

	public void setProcedure(String procedure) {
		this.procedure = procedure;
	}
	
	public Integer getNumberOfSeries() {
		return numberOfSeries;
	}

	public void setNumberOfSeries(Integer numberOfSeries) {
		this.numberOfSeries = numberOfSeries;
	}

	public Integer getNumberOfInstances() {
		return numberOfInstances;
	}

	public void setNumberOfInstances(Integer numberOfInstances) {
		this.numberOfInstances = numberOfInstances;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() 
	{
		return "StudyUID [" + this.uid + "]; Procedure=" + this.procedure + "; Modalities=" + this.modalityList + 
			"; -- #Series=" + this.numberOfSeries + " #Instances=" + this.numberOfInstances + ";";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((uid == null) ? 0 : uid.hashCode());
		result = prime * result
				+ ((modalityList == null) ? 0 : modalityList.hashCode());
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
		final ShallowStudy other = (ShallowStudy) obj;
		if (uid == null) {
			if (other.uid != null)
				return false;
		} else if (!uid.equals(other.uid))
			return false;
		if (modalityList == null) {
			if (other.modalityList != null)
				return false;
		} else if (!modalityList.equals(other.modalityList))
			return false;
		return true;
	}	
	
	@Override
	public int compareTo(ShallowStudy that) 
	{
		return this.uid.compareTo(that.uid);
	}
}
