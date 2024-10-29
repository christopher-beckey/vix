package gov.va.med.imaging.exchange.business.taglib.artifactsource;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.imaging.BaseWebFacadeRouter;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.exchange.business.taglib.exceptions.MissingRequiredArgumentException;

import java.util.Collection;

import javax.servlet.jsp.JspException;

import gov.va.med.logging.Logger;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class TreatingFacilitySiteCollectionTag 
extends AbstractArtifactSourceCollectionTag
{
	private static final long serialVersionUID = 1L;

	private static final Logger LOGGER = Logger.getLogger(TreatingFacilitySiteCollectionTag.class);
	private String patientIcn;
	private String siteNumber;

	public String getPatientIcn()
    {
    	return this.patientIcn;
    }

	public void setPatientIcn(String patientIcn)
    {
    	this.patientIcn = patientIcn;
    }

	public String getSiteNumber()
    {
    	return this.siteNumber;
    }

	public void setSiteNumber(String siteNumber)
    {
    	this.siteNumber = siteNumber;
    }

	@Override
	protected Collection<ResolvedArtifactSource> getArtifactSources() 
	throws JspException, MissingRequiredArgumentException
	{
		// Fortify coding
		String patientIcn = getPatientIcn();
		if(patientIcn == null || patientIcn.length() < 1)
		{
			String msg = "TreatingFacilitySiteCollectionTag.getArtifactSources() --> The patient ICN is required but was not provided.";
			LOGGER.error(msg);
			throw new MissingRequiredArgumentException(msg);
		}
		
		// Fortify coding
		String siteNumber = getSiteNumber();
		if(siteNumber == null || siteNumber.length() < 1)
		{
			String msg = "TreatingFacilitySiteCollectionTag.getArtifactSources() --> The site number is required but was not provided.";
			LOGGER.error(msg);
			throw new MissingRequiredArgumentException(msg);
		}
    	
    	try 
    	{
        	BaseWebFacadeRouter router = null;
        	
    		try
    		{
    			router = FacadeRouterUtility.getFacadeRouter(BaseWebFacadeRouter.class);
    		} 
    		catch (Exception x)
    		{
                LOGGER.error("TreatingFacilitySiteCollectionTag.getArtifactSources() --> Unable to get BaseWebFacadeRouter implementation:{}", x.getMessage());
    			throw new JspException("TreatingFacilitySiteCollectionTag.getArtifactSources() --> Unable to get BaseWebFacadeRouter implementation", x);
    		}
    		
    		return router.getTreatingSites( 
    			RoutingTokenImpl.createVARadiologySite(siteNumber),
    			PatientIdentifier.icnPatientIdentifier(patientIcn)
    		);
    	}
    	catch(Exception ex)
    	{
            LOGGER.error("TreatingFacilitySiteCollectionTag.getArtifactSources() --> Unable to get a collection of ResolvedArtifactSource:{}", ex.getMessage());
			throw new JspException("TreatingFacilitySiteCollectionTag.getArtifactSources() --> Unable to get a collection of ResolvedArtifactSource", ex);
    	}
    }
}
