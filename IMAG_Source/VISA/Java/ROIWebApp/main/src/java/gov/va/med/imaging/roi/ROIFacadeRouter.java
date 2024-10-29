/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 22, 2012
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
package gov.va.med.imaging.roi;

import java.io.InputStream;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.roi.queue.DicomExportQueue;
import gov.va.med.imaging.roi.CCPHeader;
import gov.va.med.imaging.roi.queue.AbstractExportQueueURN;
import gov.va.med.imaging.roi.queue.NonDicomExportQueue;

/**
 * @author VHAISWWERFEJ
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface ROIFacadeRouter
extends FacadeRouter
{
	@FacadeRouterMethod(asynchronous=false, commandClassName="ProcessReleaseOfInformationRequestCommand")
	public abstract ROIWorkItem processReleaseOfInformationRequest(StudyURN []studyUrns)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="ProcessReleaseOfInformationRequestCommand")
	public abstract ROIWorkItem processReleaseOfInformationRequest(StudyURN []studyUrns, AbstractExportQueueURN exportQueueUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="ProcessReleaseOfInformationRequestCommand")
	public abstract ROIWorkItem processReleaseOfInformationRequest(StudyURN []studyUrns, 
			AbstractExportQueueURN exportQueueUrn, List<CCPHeader> ccpHeaders, String includeNonDicom, String includeReport)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetROIWorkItemByGuidCommand")
	public abstract ROIWorkItem getRoiRequest(String guid, boolean includeExtendedInformation)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetActiveROIRequestWorkItemsCommand")
	public abstract List<WorkItem> getActiveROIRequests()
	throws MethodException, ConnectionException;

	/**
	 * This calls the sync version of the command (which calls the async command) to process ROI Requests in the queue immediately
	 */
	@FacadeRouterMethod(asynchronous=false, commandClassName="ProcessROIPeriodicRequestsSyncCommand")
	public abstract void processROIPeriodicRequests()
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostROIChangeWorkItemStatusCommand")
	public abstract Boolean postROIChangeWorkItemStatus(String guid, ROIStatus newStatus)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetROIDisclosureByGuidCommand")
	public abstract InputStream getROIDisclosure(PatientIdentifier patientIdentifier, GUID guid)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="ProcessOldUnfinishedROIRequestsCommand")
	public abstract void processOldUnfinishedROIRequests()
	throws ConnectionException, MethodException;
	
	/**
	 * This calls the sync version of the command (which calls the async method) to process a single ROI work item
	 * @param guid
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@FacadeRouterMethod(asynchronous=false, commandClassName="ProcessROIWorkItemSyncCommand")
	public abstract void processROIWorkItem(String guid)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetDicomExportQueueListCommand")
	public abstract List<DicomExportQueue> getDicomExportQueues()
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetDicomCcpExportQueueListCommand")
	public abstract List<DicomExportQueue> getDicomCcpExportQueues()
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetNonDicomExportQueueListCommand")
	public abstract List<NonDicomExportQueue> getNonDicomExportQueues()
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostROICancelWorkItemCommand")
	public abstract Boolean cancelROIWorkItem(String guid)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetROIWorkItemsByUserCommand")
	public abstract List<WorkItem> getUserROIRequests()
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="DeleteROIWorkItemsByUserCommand")	
	public abstract Boolean deleteUserROIWorkItems()
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetROICommunityCareProvidersCommand")
	public abstract List<String> getCommunityCareProviders()
	throws MethodException, ConnectionException;

}
