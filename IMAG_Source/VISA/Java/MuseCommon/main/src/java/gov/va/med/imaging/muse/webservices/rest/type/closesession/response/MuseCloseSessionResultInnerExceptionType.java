package gov.va.med.imaging.muse.webservices.rest.type.closesession.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name="InnerException")
public class MuseCloseSessionResultInnerExceptionType
implements Serializable{
	
	private static final long serialVersionUID = 8671230493360549196L;

	@XmlElement(name="InnerException", type=MuseCloseSessionResultInnerExceptionType.class)
	private MuseCloseSessionResultInnerExceptionType innerException = null;
	
	@XmlElement(name="HelpLink")
	private String helpLink = null;
	
	@XmlElement(name="Message")
	private String message  = null;
	
	@XmlElement(name="MiddleTierStatusValueInt")
	private Integer middleTierStatusValueInt = 0;
	
	@XmlElement(name="MiddleTierStatusValueStr")
	private String middleTierStatusValueStr = null;
	
	@XmlElement(name="Source")
	private String source = null;
	
	@XmlElement(name="StackTrace")
	private String stackTrace = null;

	/**
	 * @return the innerException
	 */
	public MuseCloseSessionResultInnerExceptionType getInnerException() {
		return innerException;
	}


	/**
	 * @return the helpLink
	 */
	public String getHelpLink() {
		return helpLink;
	}

	/**
	 * @return the message
	 */
	public String getMessage() {
		return message;
	}

	/**
	 * @return the middleTierStatusValueInt
	 */
	public Integer getMiddleTierStatusValueInt() {
		return middleTierStatusValueInt;
	}

	/**
	 * @return the middleTierStatusValueStr
	 */
	public String getMiddleTierStatusValueStr() {
		return middleTierStatusValueStr;
	}

	/**
	 * @return the source
	 */
	public String getSource() {
		return source;
	}

	/**
	 * @return the stackTrace
	 */
	public String getStackTrace() {
		return stackTrace;
	}
}



