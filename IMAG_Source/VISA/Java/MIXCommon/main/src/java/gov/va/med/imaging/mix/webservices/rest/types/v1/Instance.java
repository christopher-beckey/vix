/**
 * 
 */
package gov.va.med.imaging.mix.webservices.rest.types.v1;

import gov.va.med.imaging.exchange.business.ComparableUtil;
//import gov.va.med.imaging.exchange.enums.ObjectOrigin;
//import gov.va.med.imaging.exchange.enums.ObjectStatus;



import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.logging.Logger;

/**
 * @author VACOTITTOC
 *
 * This Instance class is for FHIR ImagingStudy model support (referring to the equivalent DICOM Instance term)
 * Cardinality: Patient 1..* DiagnosticReport 0..* ImagingStudy 0..* Series 0..* Instance
 */
@XmlRootElement (name="Instance")
public class Instance 
implements Serializable, Comparable<Instance> 
{
//	private static final long serialVersionUID = -4029416178345334605L;
//	private final static Logger logger = Logger.getLogger(Instance.class);
	    
    protected Integer number; // DICOM Instance sequence number in Series
	protected String uid; 	  // R! DICOM SOP Instance UID (for VA a '.' separated imageURN carrying site (Station) Number segment, image IEN, study IEN and patient ICN!)
    protected String sopClass;// R! DICOM SOP class UID -- how to get it from VA legacy? - null?
    protected String type; 	  // type of instance (image, ...) - unused?
    protected String title;   // Description of instance - unused
    protected String content; // attachment - content of instance - unused!
    
	public Instance()
	{
		uid = sopClass = type = title = content = null;
		number=null;
	}

	/**
     * 
     */
    public Instance (Integer number, String uid, String sopClass, String type, String title, String content) 
    {
//    	Instance instance = new Instance();
		
    	this.setNumber(number);
    	this.setUid(uid);
    	this.setSopClass(sopClass);
    	this.setType(type);
    	this.setTitle(title);
    	this.setContent(content);
		
//		return instance;
    }


    public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

    /**
     * @return the title
     */
    public String getTitle() {
        return title;
    }

    /**
     * @param title the title (description) to set
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * @return the SOP Class UID
     */
    public String getSopClass() {
        return sopClass;
    }

    /**
     * @param sopClassUid the SOP Class UID to set
     */
    public void setSopClass(String sopClassUid) {
        this.sopClass = sopClassUid;
    }

    /**
     * @return the type
     */
    public String getType() {
        return type;
    }

    /**
     * @param type the type of instance to set
     */
    public void setType(String type) {
        this.type = type;
    }


	/**
	 * @return the uid
	 */
	public String getUid() {
		return uid;
	}

	/**
	 * @param uid the uid of the Instance to set
	 */
	public void setUid(String uid) {
		this.uid = uid;
	}

    public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	

	@Override
	public String toString() 
	{
		String output = "";
		output += "Instance Properties:\n";
		output += "uid: " + uid + "\n";
		output += "sopClass: " + sopClass + "\n";
		output += "type: " + type + "\n";
		output += "title: " + title + "\n";
		output += "content: " + content + "\n";
		
		return output;
	}

	/**
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object arg0) 
	{
		if(arg0 instanceof Instance) 
		{
			Instance that = (Instance)arg0;
			
			// if the intance uids are equal then the rest better be equal, nonetheless it is 
			// compared here to assure that .equals and .compareTo are strictly compatible
			if(	this.uid != null && this.uid.equals(that.uid) &&
				this.getNumber() != null && (this.getNumber() == that.getNumber())) 
			{
				return true;
			}
		}
		return false;
	}
	
	/**
	 * The natural sort order of Image instances is:
	 * 1.) decreasing by procedure date
	 * 2.) increasing by site number
	 * 3.) increasing by study IEN
	 * 4.) increasing by group IEN (series)
	 * 5.) increasing by image IEN
	 * 
	 * @see java.lang.Comparable#compareTo(java.lang.Object)
	 */
	@Override
	public int compareTo(Instance that) 
	{
		int cumulativeCompare = 0;
		
		cumulativeCompare = ComparableUtil.compare(this.uid, that.uid, false);
		if(cumulativeCompare != 0)
			return cumulativeCompare;
		
		cumulativeCompare = this.getNumber() - that.getNumber();
		if(cumulativeCompare != 0)
			return cumulativeCompare;
			
		cumulativeCompare = ComparableUtil.compare(this.getSopClass(), that.getSopClass(), true);
		if(cumulativeCompare != 0)
			return cumulativeCompare;

		cumulativeCompare = ComparableUtil.compare(this.getType(), that.getType(), true);
		if(cumulativeCompare != 0)
			return cumulativeCompare;
		
		cumulativeCompare = ComparableUtil.compare(this.getTitle(), that.getTitle(), true);
		if(cumulativeCompare != 0)
			return cumulativeCompare;
		
		cumulativeCompare = ComparableUtil.compare(this.getContent(), that.getContent(), true);
		if(cumulativeCompare != 0)
			return cumulativeCompare;
		
		return 0;
	}
	
}
