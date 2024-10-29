/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian
 *
 */
@XmlRootElement(name="studies")
public class ViewerStudyStudiesType
{
	private ViewerStudyStudyType [] study;

	/**
	 * @param study
	 */
	public ViewerStudyStudiesType(ViewerStudyStudyType[] study)
	{
		super();
		this.study = study;
	}
	
	public ViewerStudyStudiesType()
	{
		super();
	}

	/**
	 * @return the study
	 */
	public ViewerStudyStudyType[] getStudy()
	{
		return study;
	}

	/**
	 * @param study the study to set
	 */
	public void setStudy(ViewerStudyStudyType[] study)
	{
		this.study = study;
	}

}
