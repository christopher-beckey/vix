/**
 * 
 */
package gov.va.med.imaging.mix.webservices.rest.types.v1;

// import gov.va.med.imaging.exchange.business.ComparableUtil;
// import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

// import gov.va.med.logging.Logger;

/**
 * @author VHAISATITTOC
 *
 * This is a test
 */
@XmlRootElement (name="DASCacheId")
public class DASCacheIdType
{
//	private static final long serialVersionUID = -4029416178345334605L;
//	private final static Logger logger = Logger.getLogger(Instance.class);
	    
	protected String longDocId; // default is ""
	
	public DASCacheIdType()
	{
		longDocId = "";
	}

//    public DASCacheIdType (String longDocId) 
//    {
//    	this.setLongDocId(longDocId);
//    }
//
     public String getLongDocId() {
        return this.longDocId;
    }

     public void setLongDocId(String longDocId) {
        this.longDocId = longDocId;
    }
	
}
