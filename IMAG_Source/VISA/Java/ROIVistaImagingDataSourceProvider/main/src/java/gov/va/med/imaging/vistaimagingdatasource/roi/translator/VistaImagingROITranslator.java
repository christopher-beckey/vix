/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 17, 2012
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
package gov.va.med.imaging.vistaimagingdatasource.roi.translator;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.roi.queue.DicomExportQueue;
import gov.va.med.imaging.roi.queue.DicomExportQueueURN;
import gov.va.med.imaging.roi.queue.NonDicomExportQueue;
import gov.va.med.imaging.roi.queue.NonDicomExportQueueURN;
import gov.va.med.imaging.url.vista.StringUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
public class VistaImagingROITranslator
{
	public static boolean translateExportQueueRequestResult(String vistaResult)
	throws MethodException
	{
		if(vistaResult.startsWith("0"))
			throw new MethodException("Error exporting image, " + vistaResult);
		return true;
	}
	
	public static List<NonDicomExportQueue> translateNonDicomExportQueues(RoutingToken routingToken, String vistaResult)
	throws MethodException
	{
		List<NonDicomExportQueue> result = new ArrayList<NonDicomExportQueue>();
		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		//String statusLine = lines[0].trim();
		for(int i = 1; i < lines.length; i++)
		{
			result.add(translateNonDicomExportQueue(routingToken, lines[i].trim()));
		}
		return result;
	}
	
	private static NonDicomExportQueue translateNonDicomExportQueue(RoutingToken routingToken, String line)
	throws MethodException
	{
		try
		{
			String [] pieces = StringUtils.Split(line, StringUtils.CARET);
			
			String queueId = pieces[1];
			String networkLocation = pieces[2];
			String physicalReference = pieces[3];
			String location = pieces[4];
			
			NonDicomExportQueueURN queueUrn = 
				NonDicomExportQueueURN.create(routingToken.getRepositoryUniqueId(), queueId);
			return new NonDicomExportQueue(queueUrn, networkLocation, physicalReference, location);
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
		}
	}
	
	public static List<DicomExportQueue> translateDicomExportQueues(RoutingToken routingToken, String vistaResult)
	throws MethodException
	{
		List<DicomExportQueue> result = new ArrayList<DicomExportQueue>();
		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		//String statusLine = lines[0].trim();
		for(int i = 1; i < lines.length; i++)
		{
			result.add(translateDicomExportQueue(routingToken, lines[i].trim()));
		}
		return result;
	}
	
	private static DicomExportQueue translateDicomExportQueue(RoutingToken routingToken, String line)
	throws MethodException
	{
		try
		{
			String [] pieces = StringUtils.Split(line, StringUtils.CARET);
			
			String queueId = pieces[0];
			String serviceName = pieces[1];
			String ipAddress = pieces[2];
			int port = Integer.parseInt(pieces[3]);
			String location = pieces[4];
			
			DicomExportQueueURN queueUrn = 
				DicomExportQueueURN.create(routingToken.getRepositoryUniqueId(), queueId);
			return new DicomExportQueue(queueUrn, serviceName, ipAddress, port, location);
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
		}
	}

	
	public static List<String> translateCommunityCareProviders(String vistaResult)
	throws MethodException
	{
		List<String> result = new ArrayList<String>();
		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		for(int i = 1; i < lines.length; i++)
		{
			result.add(lines[i].trim());
		}
		return result;
	}
	
}
