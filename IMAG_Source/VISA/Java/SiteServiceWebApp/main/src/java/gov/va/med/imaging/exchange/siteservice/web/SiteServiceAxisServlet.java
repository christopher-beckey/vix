/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 9, 2011
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
package gov.va.med.imaging.exchange.siteservice.web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.axis.handlers.soap.SOAPService;
import gov.va.med.logging.Logger;

/**
 * This overrides the default service info to redirect the user to the web page
 * that shows the information in the site service
 * 
 * @author VHAISWWERFEJ
 *
 */
public class SiteServiceAxisServlet
extends org.apache.axis.transport.http.AxisServlet
{
	private static final long serialVersionUID = -8959586609980206690L;
	
	private final static Logger logger = 
		Logger.getLogger(SiteServiceAxisServlet.class);
	

	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		
		// EN1^XUSBSE2(URL_"/getSite?siteID="_STNNUM,.RESULTS)
		boolean handled = false;
		
		String pathInfo = request.getPathInfo();
		if(pathInfo != null)
		{
			boolean exchangeSiteService = (pathInfo.startsWith("/ImagingExchangeSiteService.asmx"));
			if(pathInfo.endsWith("/getSite"))
			{
				handled = true;
				SiteServiceXmlTranslator.outputSite(request, response, exchangeSiteService);
			}
			else if(pathInfo.endsWith("/getSites"))
			{
				handled = true;
				SiteServiceXmlTranslator.outputSites(request, response, exchangeSiteService);				
			}
			else if((pathInfo.endsWith("/getVHA")) || (pathInfo.endsWith("/getImagingExchangeSites")))
			{
				handled = true;
				SiteServiceXmlTranslator.outputVha(request, response, exchangeSiteService);				
			}
			else if(pathInfo.endsWith("/getVISN"))
			{
				handled = true;
				SiteServiceXmlTranslator.outputVisn(request, response, exchangeSiteService);
			}
		}
		if(!handled)
			super.doGet(request, response);
	}
	
	protected void reportServiceInfo(HttpServletResponse response,
			PrintWriter writer, SOAPService service, String serviceName)
	{
		String redirectPage = response.encodeRedirectURL("ExchangeSiteService");
        try 
        {
            response.sendRedirect(redirectPage);
        } 
        catch (IOException e) 
        {
        	writer.write(e.getMessage());
        	logger.error(e);
        }  
		
	}
}
