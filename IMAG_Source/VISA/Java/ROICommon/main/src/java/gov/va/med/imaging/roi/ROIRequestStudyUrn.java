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
 * @deprecated
 * @author VHAISWWERFEJ
 *
 */
public class ROIRequestStudyUrn
{
	private String studyUrn;
	
	public ROIRequestStudyUrn()
	{
		super();
	}
	
	public ROIRequestStudyUrn(String studyUrn)
	{
		this();
		this.studyUrn = studyUrn;
	}

	public String getStudyUrn()
	{
		return studyUrn;
	}

	public void setStudyUrn(String studyUrn)
	{
		this.studyUrn = studyUrn;
	}
	
	private static XStream getXStream()
	{
		XStream xstream = new XStream();
		xstream.aliasField("urn", ROIRequestStudyUrn.class, "studyUrn");
		return xstream;
	}
	
	/*
	public static String toXml(String [] studyIds)
	{
		ROIStudy [] studies = new ROIStudy[studyIds.length];
		for(int i = 0; i < studyIds.length; i++)
		{
			studies[i] = new ROIStudy(studyIds[i]);
		}
		return toXml(studies);
	}*/
	
	public static String toXml(ROIRequestStudyUrn [] studyIds)
	{
		XStream xstream = getXStream();
		return xstream.toXML(studyIds);
	}
	
	public static ROIRequestStudyUrn [] fromXml(String xml)
	{
		XStream xstream = getXStream();
		return (ROIRequestStudyUrn[])xstream.fromXML(xml);
	}

}
