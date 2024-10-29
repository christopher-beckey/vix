/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 11, 2012
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
package gov.va.med.imaging.vixserverhealth.web;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.health.VisaConfiguration;
import gov.va.med.imaging.health.VisaConfigurationType;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class VisaConfigurationServlet
extends HttpServlet
{
	
	private static final long serialVersionUID = 4384305198323399171L;
	private final static String responseContentType = "text/xml";
	private final static Logger logger = Logger.getLogger(VisaConfigurationServlet.class);
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		String configurationType = request.getParameter("configurationType");
		VisaConfigurationType visaConfigurationType = VisaConfigurationType.tomcatLib;
		if(configurationType != null && configurationType.length() > 0)
			visaConfigurationType = VisaConfigurationType.valueOf(configurationType);

		boolean calculateChecksum = false;
		String calculateChecksumParameter = request.getParameter("checksum");
		if(calculateChecksumParameter != null && calculateChecksumParameter.length() > 0)
			calculateChecksum = Boolean.parseBoolean(calculateChecksumParameter);
		
		response.setContentType(responseContentType);
		// Fortify change: moved 'out' into try-with-resources; not on list but fixed anyway
		try( PrintWriter out = response.getWriter() )
		{
			VisaConfiguration visaConfiguration = 
					VisaConfiguration.getVisaConfiguration(visaConfigurationType,
							calculateChecksum);
			
			// Fortify change: added clean string
			out.print(StringUtil.cleanString(visaConfiguration.toXml()));			
			
			out.flush();
			//out.close();
		}
		// just in case...
		catch(Exception eX)
		{
			logger.error("Error getting VIX server health", eX);
			throw new ServletException(eX);
		}
	}

}
