package gov.va.med.imaging.study.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="storedFilter")
public class StoredFilterType 
{
	private String id;
	private String name;
	
	public StoredFilterType(){
		super();
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	

}
