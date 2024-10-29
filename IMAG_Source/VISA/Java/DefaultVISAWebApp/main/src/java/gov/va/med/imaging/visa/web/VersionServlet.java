/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 25, 2013
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
package gov.va.med.imaging.visa.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.health.VixServerHealth;
import gov.va.med.imaging.health.VixServerHealthProperties;
import gov.va.med.imaging.visa.VisaWebContext;

/**
 * @author VHAISWWERFEJ
 *
 */
public class VersionServlet
extends HttpServlet
{
	private static final long serialVersionUID = -7706451439324981820L;
	private final static Logger LOGGER = Logger.getLogger(VersionServlet.class);
	
	private final static String responseContentType = "text/xml";

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		try
		{
			PrintWriter writer = response.getWriter();
			writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
			VixServerHealth serverHealth = VisaWebContext.getRouter().getVixServerHealth(null);
			String version = serverHealth.getVixServerHealthProperties().get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_VERSION);
			response.setContentType(responseContentType);
			writer.write("<version>" + version + "</version>");
			writer.flush();
			writer.close();
		}
		catch(Exception ex)
		{
			String msg = "VersionServlet.doGet() --> Error loading VIX Server Health: " + ex.getMessage();
			LOGGER.error(msg);
			throw new ServletException(msg, ex);
		}
	}
}
