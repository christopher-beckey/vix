package gov.va.med.imaging.ax.webservices.rest.types;

import gov.va.med.imaging.ax.webservices.rest.types.DocumentReference;

import javax.xml.bind.annotation.XmlRootElement;

// import java.io.Serializable;
// import java.util.ArrayList;
// import java.util.Iterator;
// import java.util.List;
// import java.util.Date;
// import java.util.SortedSet;
// import java.util.TreeSet;
// import java.util.SortedSet;
// import java.util.TreeSet;

/**
 * @author VACOTITTOC
 *
 * This Bundle class is for FHIR DocumentRefernce bundle response , ***? JSON tailored
 * Cardinality: Bundle 1-1 Patient 1..* DocumentReference
 */
@XmlRootElement(name="Bundle")
public class Bundle // implements Serializable, /* Iterable<Series>,*/ Comparable<ImagingStudy> 
{	
//	private static final long serialVersionUID = -5185851367113539916L;
//	private static final char q = '"';
	private String id; // DocumentReference request transactionID
	private String resourceType; // FHIR "Bundle", used for DocumentReference bundle
	private String type;	     // hardcoded
	private Integer total;		// R! -- the total number of matched "entry"-s (docs of patient)
//	private LinkType link = null; // 
	private Entry[] entry;	// the doc reference content

	public Bundle()
	{
		resourceType="Bundle";
		type = "searchset";
		total=0;
//		link = null;
		entry = new Entry[0];
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getResourceType() {
		return resourceType;
	}

	public void setResourceType(String resourceType) {
		this.resourceType = resourceType;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

//	public LinkType getLink() {
//		return link;
//	}
//
//	public void setLink(LinkType link) {
//		this.link = link;
//	}

	public Entry[] getEntry() {
		return entry;
	}

	public void setEntry(Entry[] entry) {
		this.entry = entry;
	}

	
	/**
	 * Add a series to the Study as a child; increments counters
	 * @param series as a single series
	 */
	public void addEntry(Entry oneEntry) 
	{
		synchronized(this.entry)
		{
			Entry[] docsInList = this.entry;
			int numItems = 0;
			if (entry==null) {
				docsInList = new Entry[1];
			} else {
				numItems = docsInList.length;
			}
			Entry[] docsOutList = new Entry[numItems+1];
			// copy In list to Out one first
			for (int i=0; i<numItems; i++) {
				docsOutList[i] = docsInList[i];
			}
			docsOutList[numItems] = oneEntry;
			this.entry = docsOutList;

			numItems++;
			setTotal(numItems);
		}
	}

}
