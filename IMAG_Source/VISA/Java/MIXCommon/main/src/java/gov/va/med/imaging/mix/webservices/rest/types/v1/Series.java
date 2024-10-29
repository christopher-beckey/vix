package gov.va.med.imaging.mix.webservices.rest.types.v1;

// import gov.va.med.MockDataGenerationField;
import gov.va.med.imaging.GUID;

// import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import javax.xml.bind.annotation.XmlRootElement;

import java.io.Serializable;
import java.util.*;
/**
 * @author VACOTITTOC
 *
 * This Series class is for FHIR ImagingStudy model support (referring to the equivalent DICOM Series term)
 * Cardinality: Patient 1..* DiagnosticReport 0..* ImagingStudy 0..* Series 0..* Instance
 */
@XmlRootElement (name="Series")
public class Series
implements Serializable, /* Iterable<Instance>, */ Comparable<Series>
{
//	private static final long serialVersionUID = -7467740571635450273L;
	private Integer number=null; 	// Numeric identifier of this series
	private ModCodeType modality; 	// R! string representation of a modality (CT, CR, MR, etc) that created this series
	private String uid;			// R! DICOM Series UID (64)
	private String description;	// max 64 inDICOM -- -- not in SOAP exchange
	private String availability; // ONLINE | OFFLINE | NEARLINE | UNAVAILABLE -- only ONLINE data is maintained for exchange
	private String url; 		// Location of the referenced instance(s) -- not maintained, not in SOAP exchange
	private String bodySite; 	// Body part examined (ENUM) -- not maintained -- not in SOAP exchange
	private String laterality; 	// 'L' or 'R': body part laterality -- not in SOAP exchange
	private String started;		// when series acquisition started (yyyy-MM-ddTHH:MI:SS+HH:MI -- UTC format)
	// here are the Read Only attributes; they have Getters only and must be set only internally by DB API call
	private Integer numberOfInstances;	//R! -- supposed to match instances SET size
	private Instance[] instances;
//	private List<Instance> instances = new ArrayList<Instance>(); // *** should be Sorted List?
//	private SortedSet<Instance> instances = new TreeSet<Instance>(new InstanceComparator());
	
	public Series()
	{
		uid = url = bodySite = laterality = started = null;
		modality = null;
		number=null;
		availability = "ONLINE";
		numberOfInstances=0;
		instances = new Instance[0];
	}
	
//	/**
//	 * @param number Series Number
//	 * @param modality type of DICOM Modality that created this Series
//	 * @param uid the DICOM Series UID (max 64)
//	 * @param description the description of the Series
//	 * @param availability must be set to "ONLINE"
//	 * @param url where series is physically located -- not supported
//	 * @param bodySite body part examined (ENUM) -- not maintained
//	 * @param laterality 'L' or 'R': body part laterality -- not maintained
//	 * @param startDateTime  when series acquisition started (YYYY-MM-DDTHH:MI:SS+HH:MI) UTC based JSON date
//	 * @return Series
//	 */
//	public Series(Integer number, String modality, String uid, String description, String availability, String url, String bodySite, 
//			String laterality, String startDateTime)
//	{
////		Series series = new Series();
//		
//		this.setNumber(number);
//		this.setModality(modality);
//		this.setUid(uid);
//		this.setDescription(description);
//		this.setAvailability(availability);
//		this.setUrl(url);
//		this.setBodySite(bodySite);
//		this.setLaterality(laterality);
//		this.setStarted(startDateTime);
//		this.instances = new InstancesType();
//		
////		return series;
//	}
	
	public int getNumberOfInstances()
	{
		return numberOfInstances; // this.instances.size();
	}
	
//	@Deprecated
//	public Set<Instance> getImages() 
//	{
//		return Collections.unmodifiableSet(instances);
//	}
		
//	public void replaceInstance(Instance oldInstance, Instance newInstance)
//	{
//		instances.remove(oldInstance);
//		instances.add(newInstance);
//	}
//	
	/**
	 * Add instance to the Series as a child.
	 * @param image
	 */
	public void addInstance(Instance instance) 
	{
		synchronized(instances)
		{
			Instance [] instancesInList = this.instances;
			int numItems = 0;
			if (instancesInList.length==0) {
				instancesInList = new Instance[1];
			} else {
				numItems=instancesInList.length;
			}
			Instance [] instancesOutList = new Instance[numItems+1];
			// copy In list to Out one first
			for (int i=0; i<numItems; i++) {
				instancesInList[i] = instancesOutList[i];
			}
			instancesOutList[numItems] = instance;
			this.instances = instancesOutList;

			numberOfInstances++;
		}
	}

//	/**
//	 * Appends all of the instances in the given Set to the Series as children.
//	 * @param images
//	 */
//	public void addInstances(List<Instance> instances) 
//	{
//		synchronized(this.instances)
//		{
//			this.instances.addAll(instances);
//			numberOfInstances += instances.size();
//		}
//	}

//	@Override
//	public Iterator<Instance> iterator()
//	{
//		return instances.iterator();
//	}

	public static Series createMockSeries(Integer number) {
		Series series = new  Series();
		series.uid = new GUID().toShortString();
		series.number = number;
		return series;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		String output = "Series Details:  \t Series UID [" + this.uid + "]\t Series Number [" + this.number + "]\n"
			+ "modality [" + this.modality + "]\t Contains " + (((this.instances!=null) && (this.instances!=null))?instances.length:0) + " instances\n";
//		Iterator<Instance> imageIter = instances.iterator();
//		while(imageIter.hasNext()) {
		for (int i=0; i<numberOfInstances; i++) {
			Instance instance = this.instances[i];
			output += "\t  UID[" + (instance == null ? "<null instance>" : "" + instance.getUid()) + 
				"] \t Instance#[" + (instance == null ? "<ni>" : "" + instance.getNumber()) + 
				"] \n";
		}
		
		return output;
	}

	public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

	/**
	 * Returns the string representation of a modality (CT, CR, MR, etc)
	 */
	public ModCodeType getModality() {
		return modality;
	}

	/**
	 * @param modality Sets the string representation of a modality (CT, CR, MR, etc)
	 */
	public void setModality(ModCodeType modality) {
		this.modality = modality;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getAvailability() {
		return availability;
	}

	public void setAvailability(String availability) {
		this.availability = availability;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getBodySite() {
		return bodySite;
	}

	public void setBodySite(String bodySite) {
		this.bodySite = bodySite;
	}

	public String getLaterality() {
		return laterality;
	}

	public void setLaterality(String laterality) {
		this.laterality = laterality;
	}

	public String getStarted() {
		return started;
	}

	public void setStarted(String startDateTime) {
		this.started = startDateTime;
	}

	public Instance[] getInstance() { // use single (not plural) for REST JSOJN translation's sake
		return instances;
	}

	public void setInstances(Instance[] instances) {
		this.instances = instances;
		if ((this.instances!=null) && (this.instances.length!=0))
			this.numberOfInstances = this.instances.length;
		else
			this.numberOfInstances = 0;
	}
	@Override
	public int compareTo(Series that) 
	{
		return this.uid.compareTo(that.uid);
	}
}
