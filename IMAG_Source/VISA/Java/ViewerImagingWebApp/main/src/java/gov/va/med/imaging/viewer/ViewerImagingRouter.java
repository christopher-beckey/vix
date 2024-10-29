/**
 * Date Created: May 18, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer;

import java.util.List;


import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.ImageAccessReason;
import gov.va.med.imaging.exchange.enums.ImageAccessReasonType;
import gov.va.med.imaging.viewer.business.CaptureUserResult;
import gov.va.med.imaging.viewer.business.DeleteImageUrn;
import gov.va.med.imaging.viewer.business.DeleteImageUrnResult;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrn;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrnResult;
import gov.va.med.imaging.viewer.business.ImageFilterFieldValue;
import gov.va.med.imaging.viewer.business.ImageFilterResult;
import gov.va.med.imaging.viewer.business.ImageProperty;
import gov.va.med.imaging.viewer.business.LogAccessImageUrn;
import gov.va.med.imaging.viewer.business.LogAccessImageUrnResult;
import gov.va.med.imaging.viewer.business.QAReviewReportResult;
import gov.va.med.imaging.viewer.business.TreatingFacilityResult;

/**
 * @author vhaisltjahjb
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface ViewerImagingRouter
extends FacadeRouter
{
	@FacadeRouterMethod(asynchronous=false, commandClassName="DeleteImagesCommand")
	public abstract List<DeleteImageUrnResult> deleteImages(
			RoutingToken routingToken, 
			List<DeleteImageUrn> imageUrns)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetImageAccessReasonListCommand")
	public abstract List<ImageAccessReason> getImageAccessReasonList(RoutingToken routingToken,
			List<ImageAccessReasonType> reasonTypes)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PutImagesAsSensitiveCommand")
	public abstract List<FlagSensitiveImageUrnResult> flagImagesAsSensitive(
			RoutingToken routingToken, 
			List<FlagSensitiveImageUrn> imageUrns)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PutLogImageAccessByUrnsCommand")
	public abstract List<LogAccessImageUrnResult> logImageAccessByUrns(
			RoutingToken routingToken, 
			String patientIcn,
			String patientDfn,
			List<LogAccessImageUrn> imageUrns)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetUserInformationByUserIdCommand")
	public abstract String getUserInformationByUserId(
			RoutingToken routingToken, 
			String userId)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetUserKeysCommand")
	public abstract List<String> getUserKeys(
			RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostImageAccessEventCommand")
	public abstract void logImageAccessEvent(ImageAccessLogEvent event) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTreatingFacilitiesCommand")
	public abstract List<TreatingFacilityResult> getTreatingFacilities(
			RoutingToken routingToken, 
			String patientIcn,
			String patientDfn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetCvixTreatingFacilitiesCommand")
	public abstract List<TreatingFacilityResult> getCvixTreatingFacilities(
			RoutingToken routingToken, 
			String patientIcn,
			String patientDfn)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetCaptureUsersCommand")
	public abstract List<CaptureUserResult> getCaptureUsers(
			RoutingToken routingToken, 
			String appFlag,
			String fromDate,
			String throughDate)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetImageFiltersCommand")
	public abstract List<ImageFilterResult> getImageFilters(
			RoutingToken routingToken,
			String userId)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetImageFilterDetailCommand")
	public abstract List<ImageFilterFieldValue> getImageFilterDetail(
			RoutingToken routingToken, 
			String filterIen, 
			String filterName, 
			String userId)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="PostSaveImageFilterCommand")
	public abstract String saveImageFilter(
			RoutingToken routingToken,
			List<ImageFilterFieldValue> imageFilterValues) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="DeleteImageFilterCommand")
	public abstract String deleteImageFilter(
			RoutingToken routingToken, 
			String filterIen)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetQAReviewReportsCommand")
	public abstract List<QAReviewReportResult> getQAReviewReports(
			RoutingToken routingToken, 
			String userId)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetQAReviewReportDataCommand")
	public abstract String getQAReviewReportData(
			RoutingToken routingToken, 
			String flags,
			String fromDate,
			String throughDate,
			String mque
			)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="PostImagePropertiesCommand")
	public abstract String setImageProperties(
			RoutingToken routingToken, 
			List<ImageProperty> imageProperties)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetImagePropertiesCommand")
	public abstract List<ImageProperty> getImageProperties(
			RoutingToken routingToken, 
			String imageIEN, 
			String props,
			String flags)
	throws MethodException, ConnectionException;
}
