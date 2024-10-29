/**
 * 
  Property of ISI Group, LLC
  Date Created: May 13, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.hydra.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="studies")
public class HydraStudiesType
{
	private HydraStudyType [] study;
	
	public HydraStudiesType()
	{
		super();
	}

	public HydraStudiesType(HydraStudyType[] study)
	{
		super();
		this.study = study;
	}

	public HydraStudyType[] getStudy()
	{
		return study;
	}

	public void setStudy(HydraStudyType[] study)
	{
		this.study = study;
	}

}
