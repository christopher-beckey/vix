package gov.va.med.imaging.exchange.business.dicom;

import gov.va.med.imaging.exchange.business.PersistentEntity;

import javax.xml.bind.annotation.XmlRootElement;

public class ImporterFilter implements PersistentEntity
{
    private String code;
    
    public ImporterFilter(String code) {
    	super();
		this.code = code;
	}
    
	@Override
	public void setId(int id) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public int getId() {
		// TODO Auto-generated method stub
		return 0;
	}
	
    public String getCode() 
    {
        return code;
    }
    public void setCode(String code) 
    {
        this.code = code;
    }
}
