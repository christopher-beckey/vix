/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 11, 2013
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.study.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement(name="studiesResult")
public class StudiesResultType
{
	private StudiesType studies;
	private StudySourceErrorsType errors;
	private boolean partialResult;
	
	public StudiesResultType()
	{
		super();
	}

	public StudiesResultType(StudiesType studies, StudySourceErrorsType errors, boolean partialResult)
	{
		super();
		this.studies = studies;
		this.errors = errors;
		this.partialResult = partialResult;
	}

	public StudiesType getStudies()
	{
		return studies;
	}

	public void setStudies(StudiesType studies)
	{
		this.studies = studies;
	}

	public StudySourceErrorsType getErrors()
	{
		return errors;
	}

	public void setErrors(StudySourceErrorsType errors)
	{
		this.errors = errors;
	}
	
	public boolean isPartialResult()
	{
		return partialResult;
	}

	public void setPartialResult(boolean partialResult)
	{
		this.partialResult = partialResult;
	}

	public int getSize()
	{
		if(studies == null)
			return 0;
		if(studies.getStudies() == null)
			return 0;
		return studies.getStudies().length;
	}

}
