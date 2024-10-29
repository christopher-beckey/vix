/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 9, 2012
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

import gov.va.med.imaging.exchange.business.Study;

import java.util.List;

/**
 * @author VHAISWWERFEJ
 * @deprecated
 *
 */
public class ROIRequest
{
	private final String guid;
	private List<Study> studies;
	private List<ROIImage> images;
	
	public ROIRequest(String guid)
	{
		super();
		this.guid = guid;
	}

	public List<Study> getStudies()
	{
		return studies;
	}

	public void setStudies(List<Study> studies)
	{
		this.studies = studies;
	}

	public List<ROIImage> getImages()
	{
		return images;
	}

	public void setImages(List<ROIImage> images)
	{
		this.images = images;
	}

	public String getGuid()
	{
		return guid;
	}
}
