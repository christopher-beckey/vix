/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 26, 2012
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
package gov.va.med.imaging.image.web;

import javax.servlet.http.HttpServletRequest;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.configuration.ImagingFacadeConfiguration;
import gov.va.med.imaging.image.ImageContextHolder;
import gov.va.med.imaging.wado.AbstractBasePhotoIdImageServlet;

/**
 * @author VHAISWWERFEJ
 *
 */
public class PhotoIdServlet
extends AbstractBasePhotoIdImageServlet
{
	private static final long serialVersionUID = -5790844571737848060L;

	@Override
	protected String getWebAppName()
	{
		return "Image Web App";
	}

	@Override
	protected String getWebAppVersion()
	{
		return "V1";
	}

	@Override
	protected String getSiteNumber(HttpServletRequest request)
	throws MethodException
	{
		PhotoIdRequestPieces requestPieces = parsePieces(request);
		if(requestPieces == null)
			return null;
		return requestPieces.getSiteId();
	}

	@Override
	protected PatientIdentifier getPatientIdentifier(HttpServletRequest request)
	throws MethodException
	{
		PhotoIdRequestPieces requestPieces = parsePieces(request);
		if(requestPieces == null)
			return null;
		return requestPieces.getPatientIdentifier();
	}

	@Override
	protected Boolean getRemote(HttpServletRequest request) throws MethodException {
		PhotoIdRequestPieces requestPieces = parsePieces(request);
		if(requestPieces == null)
			return false;
		return requestPieces.getRemote();
	}

	@Override
	public String getUserSiteNumber()
	{
		// user site number is used for image logging which isn't done for photo ID - not needed here
		return null;
	}
	
	private PhotoIdRequestPieces parsePieces(HttpServletRequest request)
	throws MethodException
	{
		String pathInfo = request.getPathInfo();
		if(pathInfo == null || pathInfo.isEmpty())
		{
			return null;
		}		
 		
		pathInfo = pathInfo.substring(1);
		String[] resourceIds = pathInfo.split("/");
		// support /local/{patientDfn} and /icn/{siteId}/{patientIcn}
		if(resourceIds.length == 2)
		{
			// /local/{patientDfn}
			if("local".equals(resourceIds[0]))
			{
				String dfn = resourceIds[1];
				String siteNumber = getLocalSiteNumber();
				return new PhotoIdRequestPieces(siteNumber, PatientIdentifier.dfnPatientIdentifier(dfn, siteNumber));
			}
		}
		if(resourceIds.length == 3)
		{
			if("icn".equals(resourceIds[0]))
			{
				String siteNumber = resourceIds[1];
				String patientIcn = resourceIds[2];
				return new PhotoIdRequestPieces(siteNumber, PatientIdentifier.icnPatientIdentifier(patientIcn));
			}
			else if("id".equals(resourceIds[0]))
			{
				String siteNumber = resourceIds[1];
				String patientId = resourceIds[2];
				PatientIdentifier patientIdentifier;
				try {
					patientIdentifier = PatientIdentifier.fromString(patientId);
				} catch (PatientIdentifierParseException e) {
					throw new MethodException("Patient Identifier Parse Exception.");
				}
				if(patientIdentifier.getPatientIdentifierType() == PatientIdentifierType.dfn)
				{
					if(ImagingFacadeConfiguration.getConfiguration().isEnterpriseEnabled())
					{
						throw new MethodException("Cannot retrieve photo ID using DFN from enterprise application");
					}
					String localSiteNumber = getLocalSiteNumber();
					if(!localSiteNumber.equals(siteNumber))
					{
						throw new MethodException("Cannot retrieve photo ID using DFN from non-local site");
					}
				}
				return new PhotoIdRequestPieces(siteNumber, patientIdentifier);
			}
			else if("remote".equals(resourceIds[0]))
			{
				//"icn" and "id" doesn't implement federation. Code complexity making it difficult to add Federation to the existing service.
				//This new "remote" implement federation and work with local as well
				//Support /remote/{siteId}/{patientIcn}
				String siteNumber = resourceIds[1];
				String patientIcn = resourceIds[2];
				return new PhotoIdRequestPieces(siteNumber, PatientIdentifier.icnPatientIdentifier(patientIcn), true);
			}
		}
        getLogger().warn("Photo ID PathInfo [{}] does not meet known request parameters", pathInfo);
		return null;
	}
	
	private String getLocalSiteNumber()
	{
		return ImageContextHolder.getAwivClientContext().getApplicationConfiguration().getLocalSiteNumber();
	}
	
	class PhotoIdRequestPieces
	{
		private Boolean remote;
		private String siteId;
		private PatientIdentifier patientIdentifier;
		
		PhotoIdRequestPieces()
		{
			super();
		}

		public PhotoIdRequestPieces(String siteId,
				PatientIdentifier patientIdentifier,
				Boolean remote)
		{
			super();
			this.siteId = siteId;
			this.patientIdentifier = patientIdentifier;
			this.remote = remote;
		}

		public PhotoIdRequestPieces(String siteId,
				PatientIdentifier patientIdentifier)
		{
			this(siteId, patientIdentifier, false);
		}

		public Boolean getRemote()
		{
			return remote;
		}

		public String getSiteId()
		{
			return siteId;
		}

		public void setSiteId(String siteId)
		{
			this.siteId = siteId;
		}

		public PatientIdentifier getPatientIdentifier()
		{
			return patientIdentifier;
		}

		public void setPatientIdentifier(PatientIdentifier patientIdentifier)
		{
			this.patientIdentifier = patientIdentifier;
		}
	}

}
