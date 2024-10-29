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
package gov.va.med.imaging.roi.datasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.roi.queue.DicomExportQueue;
import gov.va.med.imaging.roi.queue.AbstractExportQueueURN;
import gov.va.med.imaging.roi.queue.NonDicomExportQueue;

/**
 * @author VHAISWWERFEJ
 *
 */
@SPI(description="The service provider interface for getting the list of export queues and to send an item to a queue")
public interface ExportQueueDataSourceSpi
extends VersionableDataSourceSpi
{
	public List<DicomExportQueue> getDicomExportQueues(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException;
	
	public List<DicomExportQueue> getDicomCcpExportQueues(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException;

	public List<NonDicomExportQueue> getNonDicomExportQueues(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException;
	
	public boolean exportImages(AbstractExportQueueURN queueUrn, AbstractImagingURN imagingUrn, int priority)
	throws MethodException, ConnectionException;

}
