/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 4, 2012
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
package gov.va.med.imaging.roi.web;


import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.notifications.email.NotificationEmailConfiguration;

/**
 * @author VHAISWWERFEJ
 *
 */
public class UpdateInvalidCredentialsEmailNotificationServlet
extends HttpServlet
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 800520069145198347L;
	private final static Logger logger = Logger.getLogger(UpdateInvalidCredentialsEmailNotificationServlet.class);

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		try
		{
			
			String email = request.getParameter("email");
			logger.info("Updating Invalid Credentials Email Notification email addresses");			
			NotificationEmailConfiguration emailConfiguration = NotificationEmailConfiguration.getConfiguration();			
			emailConfiguration.setRecipientsForNotificationType(NotificationTypes.InvalidServiceAccountCredentials, email);
			emailConfiguration.storeConfiguration();
			FacadeConfigurationFactory.getConfigurationFactory().clearConfiguration(NotificationEmailConfiguration.class);
			
			response.sendRedirect("ConfigureEmail.jsp?result=Successfully updated Email Notification addresses");
		}
		catch(Exception ex)
		{
            logger.error("Error updating Invalid Credentials Email Notification email addresses, {}", ex.getMessage(), ex);
			String validLoc = "ConfigureEmail.jsp?error=Error updating Email Notification addresses, " + ex.getMessage();	
			response.sendRedirect(StringUtil.cleanString(validLoc));
		}
	}
}
