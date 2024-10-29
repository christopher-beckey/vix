/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jan 30, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
package gov.va.med.imaging.exchange.business.taglib.patient;

import gov.va.med.RoutingTokenImpl;
import gov.va.med.imaging.BaseWebFacadeRouter;
import gov.va.med.imaging.TransactionContextHelper;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.exchange.business.Patient;

import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TryCatchFinally;

import gov.va.med.logging.Logger;

/**
 * NOTE: this class uses code from the Spring Framework to get the
 * context.  Because we must derive from AbstractStudyListTag and
 * therefore cannot derive from spring's RequestContextAwareTag 
 * we do the stuff that RequestContextAwareTag does for us in the
 * doStartTag() method.
 * 
 * @author VHAISWBECKEC
 * 
 */
public class PatientListTag 
extends AbstractPatientListTag 
implements TryCatchFinally
{
	private static final long serialVersionUID = 1L;

	private  static final Logger LOGGER = Logger.getLogger(PatientListTag.class);
	
	private String siteNumber;
	private String patientName;
	
	// ==============================================================================
	// Properties that may be set from the JSP
	// ==============================================================================
	
	/**
     * @return the siteNumber
     */
    public String getSiteNumber()
    {
    	return this.siteNumber;
    }
    public void setSiteNumber(String siteNumber)
    {
    	this.siteNumber = siteNumber;
    }

	/**
     * @return the patientId
     */
    public String getPatientName()
    {
    	return this.patientName;
    }
    public void setPatientName(String patientName)
    {
    	this.patientName = patientName;
    }
    
	@Override
    protected List<Patient> getPatientList() 
    throws JspException
    {
		// These two "ifs" should throw exception but don't want to change logic here.
		if(this.patientName == null || this.patientName.length() < 1)
			return null;
		
		if(this.siteNumber == null || this.siteNumber.length() < 1)
			return null;

    	try 
    	{
    		
        	BaseWebFacadeRouter router = null;
        	
    		try
    		{
    			router = FacadeRouterUtility.getFacadeRouter(BaseWebFacadeRouter.class);
    		} 
    		catch (Exception x)
    		{
                LOGGER.error("PatientListTag.getPatientList() --> Unable to get BaseWebFacadeRouter implementation: {}", x.getMessage());
    			throw new JspException("PatientListTag.getPatientList() --> Unable to get BaseWebFacadeRouter implementation", x);
    		}
    		
    		TransactionContextHelper.setTransactionContextFields("PatientListTag.getPatientList()", "");
    		return router.getPatientList( getPatientName(), RoutingTokenImpl.createVARadiologySite(this.siteNumber) );
    	}
    	catch(Exception ex)
    	{
            LOGGER.error("JavaLogCollectionTag.getfiles() --> Unable to get list of patient(s): {}", ex.getMessage());
			throw new JspException("JavaLogCollectionTag.getfiles() --> Unable to get list of patient(s)", ex);
    	}
    }
}
