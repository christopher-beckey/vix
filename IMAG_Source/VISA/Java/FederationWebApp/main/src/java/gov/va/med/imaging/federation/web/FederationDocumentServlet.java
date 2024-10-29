/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 17, 2010
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

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;

import java.io.OutputStream;

/**
 * This servlet is used when moving documents to ensure the appropriate command is called. When the CVIX is 
 * requesting a VA document from a VIX, it will call this servlet to get the document but it provides a VA
 * document URN.  To ensure the getDocument command is called (even though its passing a URN), this servlet
 * overrides FederationImageServlet to ensure the getDocument command is called even though a URN (not just GAI) is
 * provided. For any other request made to this servlet, this defers to its parent functionality.
 * 
 * This servlet will be used on the CVIX when the VIX is requesting DoD documents from the CVIX but in that 
 * case this servlet will defer to FederationImageServlet functionality.  Since the identifier is a GAI, it will
 * already call the appropriate command 
 * 
 * @author vhaiswwerfej
 *
 */
public class FederationDocumentServlet
extends FederationImageServletV4
{

	private static final long serialVersionUID = 8829393877564007317L;

	@Override
	public Long getImage(ImageURN imageUrn,
			ImageFormatQualityList requestedFormatQuality,
			OutputStream outStream, ImageMetadataNotification metadataCallback)
			throws MethodException, ConnectionException
	{
		// override the default functionality to call the appropriate command to get this image
		// as a document rather than as an image
		return getFederationRouter().getDocumentStreamed(imageUrn, outStream, metadataCallback);
	}

	@Override
	public boolean includeTextFile(GlobalArtifactIdentifier gai)
	{
		// no matter what, don't get a text file
		return false;
	}
}
