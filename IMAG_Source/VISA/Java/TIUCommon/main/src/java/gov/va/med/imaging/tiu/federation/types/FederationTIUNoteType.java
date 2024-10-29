package gov.va.med.imaging.tiu.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.rest.types.RestStringType;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public class FederationTIUNoteType {

	private RestStringType noteUrn;
	private String title;
	private String keyWord;
	private String noteClass;

	
	public FederationTIUNoteType(RestStringType noteUrn, String title, String keyWord, String noteClass) {
		super();
		this.noteUrn = noteUrn;
		this.title = title;
		this.keyWord = keyWord;
		this.noteClass = noteClass;
	}
	
	public FederationTIUNoteType() {
		super();
	}



	public String getTitle() {
		return title;
	}

	public String getKeyWord() {
		return keyWord;
	}

	public String getNoteClass() {
		return noteClass;
	}

	public RestStringType getNoteUrn() {
		return noteUrn;
	}

	public void setNoteUrn(RestStringType noteUrn) {
		this.noteUrn = noteUrn;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}

	public void setNoteClass(String noteClass) {
		this.noteClass = noteClass;
	}

	
}
