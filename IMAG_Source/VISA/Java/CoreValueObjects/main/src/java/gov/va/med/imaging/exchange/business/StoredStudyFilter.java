package gov.va.med.imaging.exchange.business;

import java.io.Serializable;

import gov.va.med.imaging.StoredStudyFilterURN;

public class StoredStudyFilter
implements Serializable
{
	private static final long serialVersionUID = 1L;

	private StoredStudyFilterURN storedStudyFilterUrn;
	private String name;
	
	
	public StoredStudyFilterURN getStoredStudyFilterUrn() {
		return storedStudyFilterUrn;
	}
	public void setStoredStudyFilterUrn(StoredStudyFilterURN storedStudyFilterUrn) {
		this.storedStudyFilterUrn = storedStudyFilterUrn;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	
}
