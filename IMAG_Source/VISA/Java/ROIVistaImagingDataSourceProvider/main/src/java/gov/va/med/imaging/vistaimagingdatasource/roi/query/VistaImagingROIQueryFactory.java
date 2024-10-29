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
package gov.va.med.imaging.vistaimagingdatasource.roi.query;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.roi.queue.DicomExportQueueURN;
import gov.va.med.imaging.roi.queue.AbstractExportQueueURN;
import gov.va.med.imaging.url.vista.VistaQuery;

/**
 * @author VHAISWWERFEJ
 *
 */
public class VistaImagingROIQueryFactory
{
	private final static String RPC_MAG_GET_DICOM_QUEUE_LIST = "MAG GET DICOM QUEUE LIST";	
	private final static String RPC_MAG_GET_DICOM_CCP_QUEUE_LIST = "MAG GET DICOM CCP QUEUE LIST";	
	private final static String RPC_MAG_GET_NON_DICOM_QUEUE_LIST = "MAG GET NONDICOM QUEUE LIST";
	private final static String MAG_SEND_IMAGE = "MAG SEND IMAGE";
	
	public static VistaQuery createGetDicomQueuesQuery(RoutingToken routingToken)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_GET_DICOM_QUEUE_LIST);
		query.addParameter(VistaQuery.LITERAL, routingToken.getRepositoryUniqueId());
		return query;
	}
	
	public static VistaQuery createGetDicomCcpQueuesQuery(RoutingToken routingToken)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_GET_DICOM_CCP_QUEUE_LIST);
		query.addParameter(VistaQuery.LITERAL, routingToken.getRepositoryUniqueId());
		return query;
	}

	public static VistaQuery createGetNonDicomQueuesQuery()
	{
		VistaQuery query = new VistaQuery(RPC_MAG_GET_NON_DICOM_QUEUE_LIST);
		return query;
	}
	
	public static VistaQuery createExportImageQuery(AbstractExportQueueURN exportQueueUrn, AbstractImagingURN imagingUrn, int priority)
	{
		VistaQuery query = new VistaQuery(MAG_SEND_IMAGE);
		query.addParameter(VistaQuery.LITERAL, imagingUrn.getImagingIdentifier());
		query.addParameter(VistaQuery.LITERAL, exportQueueUrn.getQueueId());
		query.addParameter(VistaQuery.LITERAL, priority + "");
		if(exportQueueUrn instanceof DicomExportQueueURN)
		{
			query.addParameter(VistaQuery.LITERAL, "2"); // 2 = DICOM
		}
		else
		{
			query.addParameter(VistaQuery.LITERAL, "1"); // 1 = DOS
		}		
		return query;
	}

}
