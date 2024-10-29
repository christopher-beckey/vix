/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 22, 2008
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
package gov.va.med.imaging.versions;

import java.beans.XMLEncoder;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.StringUtil;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ImagingServicesGenerator 
{
	
	public final static String IMAGING_SERVICES_FILENAME = "ImagingServices.xml";

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		if(validateInput(args))
		{
			String directory = args[0];
			List<ImagingService> services = convertServicesInput(args);
			ImagingServicesGenerator generator = new ImagingServicesGenerator();
			generator.generateImagingServiceFile(directory, services);
		}
		else
		{
			displayInputRequiredMessage();
		}
	}
	
	private static List<ImagingService> convertServicesInput(String [] args)
	{
		//public ImagingService(String version, String applicationType,
		//String operationType, String applicationPath, String operationPath) {
		List<ImagingService> services = new ArrayList<ImagingService>();
		for(int i = 1; i < args.length; i+=5)
		{
			String applicationType = args[i];			
			String version = args[i + 1];
			String appicationPath = args[i + 2];
			String operationType = args[i + 3];
			String operationPath = args[i + 4];
			ImagingService service = new ImagingService(version, applicationType, appicationPath);
			services.add(service);
			ImagingOperation operation = new ImagingOperation(operationType, operationPath);
			service.getOperations().add(operation);
		}
		return services;
	}
	
	private static boolean validateInput(String [] args)
	{		
		if(args == null)
		{
			return false;
		}
		else if(args.length <= 1)
		{
			return false;
		}
		int argCount = args.length - 1;
		if((argCount % 5) != 0)
		{
			return false;
		}
		return true;
	}
	
	private static void displayInputRequiredMessage()
	{
		StringBuilder sb = new StringBuilder();		
		sb.append("Invalid input arguments specified. Input must be:\n");
		sb.append("<Directory to output> <Service Type> <Operation Type> <Version> <Application Path> <Operation Path>\n");
		sb.append("[ <Service Type> <Operation Type> <Version> <Application Path> <Operation Path> ...]");
		System.out.println(sb.toString());
	}
	
	public ImagingServicesGenerator()
	{
		super();		
	}
	
	public void generateImagingServiceFile(String directory, List<ImagingService> services)
	{
		File file = new File(StringUtil.cleanString(directory + File.separatorChar + IMAGING_SERVICES_FILENAME));
		
		if(file.exists())
		{
			// Fortify change: added try-with-resources
			try ( FileOutputStream fos = new FileOutputStream(file);
				  XMLEncoder encoder = new XMLEncoder(fos) )
			{
				encoder.writeObject(services);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
	}
}
