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
package gov.va.med.imaging.roi.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.roi.commands.queue.ROIGetDicomCcpExportQueuesCommand;
import gov.va.med.imaging.roi.commands.queue.ROIGetDicomExportQueuesCommand;
import gov.va.med.imaging.roi.commands.queue.ROIGetNonDicomExportQueuesCommand;
import gov.va.med.imaging.roi.rest.types.ROIDicomExportQueueType;
import gov.va.med.imaging.roi.rest.types.ROINonDicomExportQueueType;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

/**
 * @author VHAISWWERFEJ
 *
 */
@Path("exportqueue")
public class ExportQueueService
{
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("dicom")
	public ROIDicomExportQueueType [] getDicomQueues(
			@QueryParam("isccp") String isccp)
	throws MethodException, ConnectionException
	{
		if ((isccp != null) && isccp.equals("1")) {
			return new ROIGetDicomCcpExportQueuesCommand().execute();
		} else {
			return new ROIGetDicomExportQueuesCommand().execute();
		}
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("nondicom")
	public ROINonDicomExportQueueType [] getNonDicomQueues()
	throws MethodException, ConnectionException
	{
		return new ROIGetNonDicomExportQueuesCommand().execute();
	}

}
