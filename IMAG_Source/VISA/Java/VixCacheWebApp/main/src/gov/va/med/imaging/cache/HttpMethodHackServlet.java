/**
 * 
 */
package gov.va.med.imaging.cache;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * A simple abstract servlet that looks for a "method" parameter
 * a redirects calls to doPut, doOptions, doTrace and doHead
 * if that parameter is set to the respective method name.
 * This is a hack so that HTML applications can use all the
 * HTTP methods.
 * 
 * @author VHAISWBECKEC
 *
 */
public abstract class HttpMethodHackServlet 
extends HttpServlet 
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException 
	{
		String methodHack = request.getParameter("method");
		
		if(methodHack != null)
		{
			if("DELETE".equalsIgnoreCase(methodHack))
			{
				doDelete(request, response);
				return;
			}
			if("HEAD".equalsIgnoreCase(methodHack))
			{
				doHead(request, response);
				return;
			}
			if("OPTIONS".equalsIgnoreCase(methodHack))
			{
				doOptions(request, response);
				return;
			}
			if("PUT".equalsIgnoreCase(methodHack))
			{
				doPut(request, response);
				return;
			}
			if("TRACE".equalsIgnoreCase(methodHack))
			{
				doTrace(request, response);
				return;
			}
		}
		
		super.service(request, response);
	}
}
