/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 22, 2017
  Developer:  VHAISLTJAHJB
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
package gov.va.med.imaging.federation.web.v8;

import gov.va.med.imaging.federation.web.v5.FederationDocumentServletV5;

/**
 * @author VHAISLTJAHJB
 *
 */
public class FederationDocumentServletV8
extends FederationDocumentServletV5
{
	private static final long serialVersionUID = 8687506840344397582L;

	@Override
	protected String getWebAppVersion()
	{
		return "V8";
	}

}
