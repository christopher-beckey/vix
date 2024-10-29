package gov.va.med.imaging.vixserverhealth.web;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.health.VixServerHealth;
import gov.va.med.imaging.health.VixServerHealthSource;
import gov.va.med.imaging.vixserverhealth.ImagingVixServerHealthContext;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * Servlet to provide an XML output of the current VIX server health properties.
 * @author vhaiswwerfej
 *
 */
public class VixServerHealthServlet 
extends HttpServlet 
{

	private static final long serialVersionUID = 2171558046494448856L;
	private final static String responseContentType = "text/xml";
	private final static Logger logger = Logger.getLogger(VixServerHealthServlet.class);

	/**
	 * Constructor of the object.
	 */
	public VixServerHealthServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException 
	{
		List<VixServerHealthSource> sources = new ArrayList<VixServerHealthSource>();
		for(VixServerHealthSource vixServerHealthSource : VixServerHealthSource.values())
		{
			String value = request.getParameter(vixServerHealthSource.name());
			if("true".equalsIgnoreCase(value))
			{
				sources.add(vixServerHealthSource);
			}
		}
		
		// if no sources selected, default to all (for backwards compatibility)
		if(sources.size() == 0)
		{
			for(VixServerHealthSource source : VixServerHealthSource.values())
			{
				sources.add(source);
			}
		}
		
		
		response.setContentType(responseContentType);
		PrintWriter out = response.getWriter();
		try
		{
			VixServerHealth serverHealth = 
				ImagingVixServerHealthContext.getRouter().getVixServerHealth(sources.toArray(new VixServerHealthSource[sources.size()]));
			String serverHealthXml = serverHealth.toXml();
            logger.debug("Server Health: {}", serverHealthXml);
			out.print(serverHealthXml);			
			out.flush();
			out.close();
		}
		catch(MethodException mX)
		{
			logger.error("Error getting VIX server health", mX);
			throw new ServletException(mX);
		}
		catch(ConnectionException cX)
		{
			logger.error("Error getting VIX server health", cX);
			throw new IOException(cX);
		}
		// just in case...
		catch(Exception eX)
		{
			logger.error("Error getting VIX server health", eX);
			throw new ServletException(eX);
		}
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() 
	throws ServletException 
	{
		super.init();
	}

}
