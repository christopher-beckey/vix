/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 23, 2009
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
package gov.va.med.imaging.federation.web;

import javax.servlet.http.HttpServletRequest;

import gov.va.med.imaging.http.exceptions.HttpHeaderParseException;
import gov.va.med.imaging.wado.query.WadoRequest;
import gov.va.med.imaging.wado.query.exceptions.WadoQueryComplianceException;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationExamImageServlet 
extends AbstractFederationExamImageServlet
{
	private static final long serialVersionUID = 8415069384905058624L;

	@Override
	protected String getWebAppVersion()
	{
		return "";
	}

	@Override
	protected WadoRequest createParsedWadoRequest(HttpServletRequest request)
			throws HttpHeaderParseException, WadoQueryComplianceException
	{
		return WadoRequest.createParsedPatch83VFTPCompliantWadoRequest(request);
	}	
}
