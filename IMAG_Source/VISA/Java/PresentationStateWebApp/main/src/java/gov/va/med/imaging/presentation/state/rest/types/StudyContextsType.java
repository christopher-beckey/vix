package gov.va.med.imaging.presentation.state.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Budy Tjahjo
 *
 */

@XmlRootElement(name="studyContexts")
public class StudyContextsType {
	private String[] studyContexts;

	public StudyContextsType() {
		super();
	}
		
	public StudyContextsType(String[] studyContexts)
	{
		super();
		this.studyContexts = studyContexts;
	}

	@XmlElement(name="studyContext")
	public String[] studyContexts()
	{
		return studyContexts;
	}

	public void setStudyContexts(String[] studyContexts)
	{
		this.studyContexts = studyContexts;
	}

	public String[] getStudyContexts()
	{
		return studyContexts;
	}

}
