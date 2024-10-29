/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 17, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.clinicaldisplay.web;

/**
 * This is a servlet that extends the v3 servlet for retrieving images. The only reason this servlet
 * exists is to provide the correct version number in the query type parameter.
 * 
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayImageAccessServletV5 
extends ClinicalDisplayImageAccessServletV3 
{
	private static final long serialVersionUID = 2102135768551335360L;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.web.ClinicalDisplayImageAccessServletV3#getWepAppName()
	 */
	@Override
	protected String getWepAppName() 
	{
		return "Clinical Display WebApp V5";
	}
}
