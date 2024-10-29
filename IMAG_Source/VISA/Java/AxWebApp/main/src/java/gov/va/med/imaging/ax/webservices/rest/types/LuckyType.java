/**
 * 
 */
package gov.va.med.imaging.ax.webservices.rest.types;

// import gov.va.med.imaging.exchange.business.ComparableUtil;
// import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;


/**
 * @author VACOTITTOC
 *
 * This is a test
 */
@XmlRootElement (name="Lucky")
public class LuckyType
{
//	private static final long serialVersionUID = -4029416178345334605L;
//	private final static Logger logger = Logger.getLogger(Instance.class);
	    
	protected String word; // default is ""
    protected Integer number; // default is 0
	protected String message; // default is ""
	
	public LuckyType()
	{
		word = message = "";
		number=0;
	}

    public LuckyType (String word, Integer number, String mesg) 
    {
    	this.setNumber(number);
    	this.setWord(word);
    	this.setMessage(mesg);
    }


    public Integer getNumber() {
		return this.number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

    public String getWord() {
        return this.word;
    }

    public void setWord(String word) {
        this.word = word;
    }

     public String getMessage() {
        return this.message;
    }

     public void setMessage(String message) {
        this.message = message;
    }
	
}
