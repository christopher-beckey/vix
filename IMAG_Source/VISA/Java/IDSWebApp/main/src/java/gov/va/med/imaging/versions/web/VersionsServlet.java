package gov.va.med.imaging.versions.web;

import java.beans.XMLDecoder;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.ServiceLoader;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.imaging.utils.XmlUtilities;
import org.apache.catalina.Container;
import org.apache.catalina.Host;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.proxy.ids.configuration.IDSProxyConfiguration;
import gov.va.med.imaging.versions.IDSOperationProvider;
import gov.va.med.imaging.versions.ImagingOperation;
import gov.va.med.imaging.versions.ImagingService;
import gov.va.med.imaging.versions.ImagingServicesGenerator;
import gov.va.med.server.tomcat.context.ImagingTomcatContextServlet;

public class VersionsServlet 
extends ImagingTomcatContextServlet
{
	private static final long serialVersionUID = 5615566263398639481L;
	private final static Logger logger = Logger.getLogger(VersionsServlet.class);
	
	private static SortedSet<ImagingService> services = null;

	/**
	 * Constructor of the object.
	 */
	public VersionsServlet() {
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
			throws ServletException, IOException {
		
		response.setContentType("application/xml");
		//response.setContentType("text/plain");
		
		String callerVersion = request.getParameter("callerVersion");
		
		String applicationType = request.getParameter("type");
		
		String applicationVersion = request.getParameter("version");

		//This is to get around problem with P177, this could be removed after 177 is no longer in service
		if (callerVersion == null) 
		{
			callerVersion = "8"; //177, 185 and 201 are using Fed v8
		}
		
		String caller = request.getRemoteAddr();

        logger.debug("Caller: {} callerVersion: {} Application Type: {} Application Version: {}", caller, callerVersion, applicationType, applicationVersion);
		
		outputServicesXml(callerVersion, applicationType, applicationVersion, response);		
	}

	private IDSProxyConfiguration getIdsProxyConfiguration()
	{
		return IDSProxyConfiguration.getIdsProxyConfiguration();
	}


	private void outputServicesXml(String callerVersion, String searchApplicationType,
			String searchVersion, HttpServletResponse response)
	throws IOException
	{
		int caller = Integer.valueOf(callerVersion);
		PrintWriter out = response.getWriter();
		// JMW - added synchronization so the services will only be retrieved once, not a big deal
		// but no reason should be loaded multiple times
		initializeServices();
		StringBuilder sb = new StringBuilder();
		sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		sb.append("<services>");
		for(ImagingService service : services)
		{
			if(includeService(service, searchApplicationType, searchVersion))
			{
				if (caller >= Integer.valueOf(service.getVersion()))
					sb.append(serviceToXmlString(service));
			}
		}
		sb.append("</services>");
		out.println(sb.toString());
		
		out.flush();
		out.close();
	}
	
	private synchronized void initializeServices()
	{
		if(services == null)
		{
			services = getApplicationServices();
		}
	}
	
	/**
	 * Returns a sorted set of the installed Imaging Services in Tomcat
	 * @return
	 */
	private SortedSet<ImagingService> getApplicationServices()
	{
		String webAppPath = this.getServletContext().getRealPath("");
		File curWebAppDir = new File(webAppPath);
		File webAppDir = curWebAppDir.getParentFile();
		
		List<String> webapps = getWebApps();
		SortedSet<ImagingService> serviceSet = new TreeSet<ImagingService>();
		
		for(int i = 0; i < webapps.size(); i++)
		{
			String folder = webAppDir.getAbsolutePath() + webapps.get(i);
			
			List<ImagingService> applicationServices = getApplicationServices(folder);
			if(applicationServices != null)
			{
				serviceSet.addAll(applicationServices);
			}
		}
		
		for(ImagingService service : serviceSet){
            logger.debug("Web App Service: {}\tVersion: {}", service.getApplicationType(), service.getVersion());
		}
		
		// load additional service information from providers		
		ServiceLoader<IDSOperationProvider> idsOperationProviders = ServiceLoader.load(IDSOperationProvider.class);
		for(IDSOperationProvider idsOperationProvider : idsOperationProviders)
		{
            logger.debug("Service: {}   ApplicationType: {}   Version: {}", idsOperationProvider.getClass(), idsOperationProvider.getApplicationType(), idsOperationProvider.getVersion());
			ImagingService imagingService = getImagingService(serviceSet, 
					idsOperationProvider.getApplicationType(), idsOperationProvider.getVersion());
			if(imagingService == null)
			{
                logger.info("Cannot find ImagingService [{}], with version [{}]", idsOperationProvider.getApplicationType(), idsOperationProvider.getVersion());
			}
			else
			{
				imagingService.getOperations().addAll(idsOperationProvider.getImagingOperations());
			}
		}
		
		
		return serviceSet;
	}
	
	private ImagingService getImagingService(SortedSet<ImagingService> imagingServices, 
			String applicationType, String applicationVersion)
	{
		for(ImagingService imagingService : imagingServices)
		{
			if(imagingService.getApplicationType().equals(applicationType) &&
					(imagingService.getVersion().equals(applicationVersion)))
				return imagingService;
		}
		return null;
	}
	
	/**
	 * Checks the filter to see if the Imaging Service should be included in the result set
	 * @param service
	 * @param applicationType
	 * @param applicationVersion
	 * @return
	 */
	private boolean includeService(ImagingService service, String applicationType,
			String applicationVersion)
	{
		if((applicationType != null) && (applicationType.length() > 0))
		{
			if(!applicationType.equals(service.getApplicationType()))
			{
				return false;
			}
		}
		if((applicationVersion != null) && (applicationVersion.length() > 0))
		{
			if(!applicationVersion.equals(service.getVersion()))
			{
				return false;
			}
		}	
		return true;
	}
	
	/**
	 * Converts the Imaging Service to XML output
	 * @param service
	 * @return
	 */
	private StringBuffer serviceToXmlString(ImagingService service)
	{
		StringBuffer buffer = new StringBuffer();		
		buffer.append("<Service type=\"" + service.getApplicationType() + "\" version=\"" + service.getVersion() + "\">");
		buffer.append("<ApplicationPath>" + service.getApplicationPath() + "</ApplicationPath>");		
		for(ImagingOperation operation : service.getOperations())
		{
			buffer.append("<Operation type=\"" + operation.getOperationType() + "\">");
			buffer.append("<OperationPath>" + operation.getOperationPath() + "</OperationPath>");
			buffer.append("</Operation>");
		}		
		buffer.append("</Service>");
		return buffer;
	}
	
	/**
	 * Read the service file (if it exists) in the web application and return the ImagingServices listed
	 * @param applicationPath The full path to the directory of the web application path 
	 * ie: C:\Program Files\Apache Software Foundation\Tomcat 5.5\webapps\ExchangeWebApp
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private List<ImagingService> getApplicationServices(String applicationPath)
	{
		List<ImagingService> services = null;
		
		String filename = StringUtil.cleanString(applicationPath + File.separatorChar + ImagingServicesGenerator.IMAGING_SERVICES_FILENAME);
		
		File file = new File(filename);
		
		if(file.exists())
		{
			// Fortify change: added try-with-resources
			try (FileInputStream fis = new FileInputStream(file)) {
                logger.debug("Reading file [{}]", filename);
				// This might need some additional work because it's stupid
				ArrayList<Object> arrayList = XmlUtilities.deserializeXMLDecoderContent(ArrayList.class, fis);
				services = new ArrayList<ImagingService>();
				for (Object entry : arrayList) {
					services.add((ImagingService) entry);
				}
			}
			catch(Exception e)
			{
                logger.error("Error getting service from application path [{}]", applicationPath, e);
			}
		}
		
		return services;
	}
	
	/**
	 * Gets the list of web applications running in Tomcat
	 * @return
	 */
	private List<String> getWebApps()
	{
		List<String> webApps = new ArrayList<String>();
		Host host = getHost();
		
		Container[] contexts = host.findChildren();
		for(int i = 0; i < contexts.length; i++)
		{
			Container context = contexts[i];
			
			webApps.add(context.getName());
		}
		return webApps;
	}
	

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		super.init();
	}

}
