/**
 * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.datasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;
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
@SPI(description="This SPI defines operations providing access to raw Viewer Imaging RPCs")
public interface ViewerImagingDataSourceSpi
extends VersionableDataSourceSpi
{
	public abstract List<DeleteImageUrnResult> deleteImages(
			RoutingToken globalRoutingToken,
			List<DeleteImageUrn> imageUrns)
	throws MethodException, ConnectionException;
	
	public abstract List<FlagSensitiveImageUrnResult> flagImagesAsSensitive(
			RoutingToken globalRoutingToken,
			List<FlagSensitiveImageUrn> imageUrns)
	throws MethodException, ConnectionException;

	public abstract List<LogAccessImageUrnResult> logImageAccessByUrns(
			RoutingToken globalRoutingToken,
			String patientIcn,
			String patientDfn,
			List<LogAccessImageUrn> imageUrns)
	throws MethodException, ConnectionException;
	
	public abstract List<TreatingFacilityResult> getTreatingFacilities(
			RoutingToken globalRoutingToken,
			String patientIcn,
			String patientDfn)
	throws MethodException, ConnectionException;
	
	/**
	 * Retrieve User information based on user id
	 * @param globalRoutingToken
	 * @param User Id
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public String getUserInformationByUserId(RoutingToken globalRoutingToken, String userId)
    throws MethodException, ConnectionException;

	/**
	 * Retrieve User information based on user id
	 * @param globalRoutingToken
	 * @param fromDate
	 * @param throughDate
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract List<CaptureUserResult> getCaptureUsers(
			RoutingToken globalRoutingToken, 
			String appFlag,
			String fromDate,
			String throughDate)
    throws MethodException, ConnectionException;

	/**
	 * Retrieve Image Filter Definitions for a user id/All user
	 * @param globalRoutingToken
	 * @param userId
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract List<ImageFilterResult> getImageFilters(
			RoutingToken globalRoutingToken, 
			String userId)
    throws MethodException, ConnectionException;

	/**
	 * Retrieve Image Filter Definition Detail for a filterIen/FilterName/user
	 * @param globalRoutingToken
	 * @param filterIen
	 * @param filterName
	 * @param userId
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract List<ImageFilterFieldValue> getImageFilterDetail(
			RoutingToken routingToken, 
			String filterIen,
			String filterName, 
			String userId)
    throws MethodException, ConnectionException;

	/**
	 * Delete Image Filter Definition for filterIen
	 * @param globalRoutingToken
	 * @param filterIen
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract String deleteImageFilter(RoutingToken routingToken, String filterIen)
    throws MethodException, ConnectionException;

	/**
	 * Save Image Filter Definition
	 * @param globalRoutingToken
	 * @param imageFilterFieldValues
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract String saveImageFilter(RoutingToken routingToken,
			List<ImageFilterFieldValue> imageFilterFieldValues)
    throws MethodException, ConnectionException;
	
	/**
	 * Get QA Review Reports
	 * @param globalRoutingToken
	 * @param userId
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract List<QAReviewReportResult> getQAReviewReports(RoutingToken routingToken,
			String userId)
    throws MethodException, ConnectionException;
	
	/**
	 * Get QA Review Reports
	 * @param globalRoutingToken
	 * @param flags
	 * @param fromDate
	 * @param throughDate
	 * @param mque
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract String getQAReviewReportData(RoutingToken routingToken,
			String flags,
			String fromDate,
			String throughDate,
			String mque)
    throws MethodException, ConnectionException;

	/**
	 * Set Image Properties
	 * @param globalRoutingToken
	 * @param imageProperties
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract String setImageProperties(
			RoutingToken routingToken, 
			List<ImageProperty> imageProperties)
    throws MethodException, ConnectionException;

	/**
	 * Get Image Properties
	 * @param globalRoutingToken
	 * @param imageIEN
	 * @param props
	 * @param flags
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract List<ImageProperty> getImageProperties(
			RoutingToken routingToken, 
			String imageIEN, 
			String props,
			String flags)
    throws MethodException, ConnectionException;

}
