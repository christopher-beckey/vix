/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 26, 2012
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
package gov.va.med.imaging.roi.commands.facade;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.storage.DataSourceImageInputStream;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.queue.AbstractExportQueueURN;

/**
 * @author VHAISWWERFEJ
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface ROICommandsRouter
extends FacadeRouter
{
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="PostImageAnnotationsDataSourceCommand")
	public abstract DataSourceInputStream burnImageAnnotationDetails(InputStream inputStream, ImageFormat imageFormat,
			ImageAnnotationDetails imageAnnotationDetails)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="GetMergeImageOutputStreamDataSourceCommand")
	public abstract OutputStream getMergeImageOutputStream(String groupIdentifier, String imageIdentifier, 
			ImageFormat imageFormat, String objectDescription)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="GetMergeObjectsResponseDataSourceCommand")
	public abstract DataSourceImageInputStream getMergeObjectsResponse(String groupIdentifier, Patient patient)
	throws ConnectionException, MethodException;
	
	/**
	 * Loads the list of images into the workItem (does not actually retrieve any images)
	 * @param workItem
	 * @return
	 * @throws ConnectionException
	 * @throws MethodException
	 */
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="ProcessROIGetStudyImagesCommand")
	public abstract ROIWorkItem processROIGetStudyImages(ROIWorkItem workItem)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="ProcessROICacheStudyImagesCommand")
	public abstract ROIWorkItem processROICacheStudyImages(ROIWorkItem workItem)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="ProcessROIAnnotateStudyImageCommand")
	public abstract ROIWorkItem processROIAnnotateStudyImages(ROIWorkItem workItem)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="ProcessROIMergeImagesCommand")
	public abstract ROIWorkItem processROIMergeImages(ROIWorkItem workItem)
	throws ConnectionException, MethodException;
	
	/**
	 * Initiates an async immediate request to process ROI requests in the queue
	 */
	@FacadeRouterMethod(asynchronous=true, isChildCommand=true, commandClassName="ProcessROIPeriodicRequestsCommand")
	public abstract void processROIPeriodicRequests();
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="GetROIWorkItemByGuidCommand")
	public abstract ROIWorkItem getROIWorkItem(String guid)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="PostReleaseOfInformationRequestDataSourceCommand")
	public abstract WorkItem postReleaseOfInformationRequest(WorkItem workItem)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="ProcessOldUnfinishedROIRequestsCommand")
	public abstract void processOldUnfinishedROIRequests()
	throws ConnectionException, MethodException;
	
	/**
	 * Process a specific work item async from its current state to completion
	 * @param guid
	 */
	@FacadeRouterMethod(asynchronous=true, isChildCommand=true, commandClassName="ProcessROIWorkItemCommand")
	public abstract void processROIWorkItem(String guid);

	/**
	 * Queue the specified imaging study for export using the specified queue
	 * @param exportQueueUrn
	 * @param imagingUrn
	 * @param exportPriority
	 */
	@FacadeRouterMethod(asynchronous=true, isChildCommand=true, commandClassName="PostExportQueueRequestCommand")
	public abstract void postExportQueueRequest(AbstractExportQueueURN exportQueueUrn, AbstractImagingURN imagingUrn, int exportPriority);
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="GetROIWorkItemsByUserCommand")
	public abstract List<WorkItem> getROIWorkItemsByUser()
	throws ConnectionException, MethodException;
}
