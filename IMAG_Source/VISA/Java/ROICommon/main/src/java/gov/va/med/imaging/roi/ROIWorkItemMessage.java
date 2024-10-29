/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 10, 2012
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
package gov.va.med.imaging.roi;

import com.thoughtworks.xstream.XStream;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIWorkItemMessage
{
	
	private String [] studyUrns;
	private String errorMessage;
	
	public ROIWorkItemMessage()
	{
		super();
		errorMessage = null;
		studyUrns = null;
	}

	public String[] getStudyUrns()
	{
		return studyUrns;
	}

	public void setStudyUrns(String[] studyUrns)
	{
		this.studyUrns = studyUrns;
	}

	public String getErrorMessage()
	{
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage)
	{
		this.errorMessage = errorMessage;
	}
	
	private static XStream getXStream()
	{
		XStream xstream = new XStream();
		xstream.aliasField("urns", ROIWorkItemMessage.class, "studyUrns");
		xstream.alias("msg", ROIWorkItemMessage.class);
		return xstream;
	}
	
	public static String toXml(String [] studyUrns)
	{
		ROIWorkItemMessage workItemMessage = new ROIWorkItemMessage();
		workItemMessage.setStudyUrns(studyUrns);
		XStream xstream = getXStream();
		return xstream.toXML(workItemMessage);
	}
	
	public static String toXml(ROIWorkItemMessage workItemMessage)
	{
		XStream xstream = getXStream();
		return xstream.toXML(workItemMessage);
	}
	
	public static ROIWorkItemMessage fromXml(String xml)
	{
		XStream xstream = getXStream();
		return (ROIWorkItemMessage)xstream.fromXML(xml);
	}

}
