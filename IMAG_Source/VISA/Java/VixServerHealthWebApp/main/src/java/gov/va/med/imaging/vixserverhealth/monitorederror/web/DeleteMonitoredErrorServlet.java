/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 28, 2013
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
package gov.va.med.imaging.vixserverhealth.monitorederror.web;

import gov.va.med.imaging.monitorederrors.MonitoredErrorConfiguration;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DeleteMonitoredErrorServlet
extends AbstractMonitoredErrorServlet
{
	private static final long serialVersionUID = -2928170159518049307L;

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		String [] monitoredErrorsToDelete = request.getParameterValues("monitoredErrors");
		MonitoredErrorConfiguration configuration =
				MonitoredErrorConfiguration.getMonitoredConfiguration();
		List<String> monitoredErrors = configuration.getMonitoredErrors();
		List<String> newErrors = new ArrayList<String>();
		for(int i = 0; i < monitoredErrors.size(); i++)
		{
			boolean toDelete = false;
			for(String monitoredErrorToDelete : monitoredErrorsToDelete)
			{
				if(monitoredErrorToDelete.equals(i + ""))
				{
					toDelete = true;
					break;
				}
			}
			if(!toDelete)
				newErrors.add(monitoredErrors.get(i));
		}
		configuration.getMonitoredErrors().clear();
		configuration.getMonitoredErrors().addAll(newErrors);
		updateMonitoredErrorConfiguration(configuration);
		
		response.sendRedirect("ConfigureMonitoredErrors.jsp");
	}
}
