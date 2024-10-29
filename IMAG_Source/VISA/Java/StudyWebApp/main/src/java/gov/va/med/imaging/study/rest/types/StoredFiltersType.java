package gov.va.med.imaging.study.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="storedFilters")
public class StoredFiltersType 
{

	private StoredFilterType [] storedFilters;
	
	public StoredFiltersType(){
		super();
	}
	
	public StoredFiltersType(StoredFilterType [] storedFilters)
	{
		super();
		this.storedFilters = storedFilters;
	}

	@XmlElement(name = "storedFilter")
	public StoredFilterType[] getStoredFilters() {
		return storedFilters;
	}

	public void setStoredFilters(StoredFilterType[] storedFilters) {
		this.storedFilters = storedFilters;
	}
	
	
}
