/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 15, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.federation;

import java.util.List;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.HealthSummaryURN;
import gov.va.med.PatientIdentifier;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.ImageAnnotationURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.ImagingLogEvent;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Division;
import gov.va.med.imaging.exchange.business.ElectronicSignatureResult;
import gov.va.med.imaging.exchange.business.HealthSummaryType;
import gov.va.med.imaging.exchange.business.ImageAccessReason;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.PatientMeansTestResult;
import gov.va.med.imaging.exchange.business.PatientPhotoIDInformation;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.UserInformation;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotation;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationSource;
import gov.va.med.imaging.exchange.business.vistarad.ActiveExams;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.business.vistarad.ExamImages;
import gov.va.med.imaging.exchange.business.vistarad.ExamSite;
import gov.va.med.imaging.exchange.business.vistarad.PatientRegistration;
import gov.va.med.imaging.exchange.enums.ImageAccessReasonType;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;

/**
 * @author vhaiswwerfej
 *
 */
@FacadeRouterInterface(extendsClassName="gov.va.med.imaging.ImagingBaseWebFacadeRouterImpl")
@FacadeRouterInterfaceCommandTester
public interface FederationRouter 
extends gov.va.med.imaging.ImagingBaseWebFacadeRouter 
{
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientSensitivityLevelCommand")
	public abstract PatientSensitiveValue getPatientSensitiveValue(RoutingToken routingToken, String patientIcn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudiesByCprsIdentifierCommand")
	public abstract List<Study> getStudiesByCprsIdentifier(String patientIcn, RoutingToken routingToken, CprsIdentifier cprsIdentifier)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudiesByCprsIdentifierAndFilterCommand")
	public abstract List<Study> getStudiesByCprsIdentifierAndFilter(
			String patientIcn, 
			RoutingToken routingToken, 
			CprsIdentifier cprsIdentifier,
			StudyFilter filter)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientRegistrationCommand")
	public abstract PatientRegistration getNextPatientRegistration(RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetRelevantPriorCptCodesCommand")
	public abstract String[] getRelevantPriorCptCodes(RoutingToken routingToken, String cptCode)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetActiveWorklistCommand")
	public abstract ActiveExams getActiveWorklist(RoutingToken routingToken, String listDescriptor)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamCommand")
	public abstract Exam getExam(StudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamSiteBySiteNumberCommand")
	public abstract ExamSite getExamSite(RoutingToken routingToken, String patientIcn, Boolean forceRefresh,
			Boolean forceImagesFromJb)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetFullyLoadedExamSiteBySiteNumberCommand")
	public abstract ExamSite getFullyLoadedExamSite(RoutingToken routingToken, String patientIcn, 
			boolean forceRefresh, boolean forceImagesFromJb)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamReportCommand")
	public abstract String getExamReport(StudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamRequisitionReportCommand")
	public abstract String getExamRequisitionReport(StudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamImagesByStudyUrnCommand")
	public abstract ExamImages getExamImages(StudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostExamAccessEventCommand")
	public abstract Boolean postExamAccessEvent(RoutingToken routingToken, String inputParameter)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PrefetchExamImagesCommand")
	public abstract void prefetchExamImages(StudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="ProcessSiteServiceCacheRefreshCommand")
	public abstract void refreshSiteServiceCache()
	throws MethodException, ConnectionException;
	
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetFullyLoadedArtifactResultsBySiteNumberCommand")
	public abstract ArtifactResults getFullyLoadedPatientArtifactResultsFromSite(RoutingToken routingToken, 
			PatientIdentifier patientIdentifier, 
			StudyFilter filter, 
			boolean includeRadiology,
			boolean includeDocuments)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyOnlyArtifactResultsBySiteNumberCommand")
	public abstract ArtifactResults getStudyOnlyPatientArtifactResultsFromSite(RoutingToken routingToken, 
			PatientIdentifier patientIdentifier, 
			StudyFilter filter, 
			boolean includeRadiology,
			boolean includeDocuments)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyWithImagesArtifactResultsBySiteNumberCommand")
	public abstract ArtifactResults getStudyWithImagesPatientArtifactResultsFromSite(RoutingToken routingToken, 
			PatientIdentifier patientIdentifier, 
			StudyFilter filter, 
			boolean includeRadiology,
			boolean includeDocuments)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyWithReportArtifactResultsBySiteNumberCommand")
	public abstract ArtifactResults getStudyWithReportPatientArtifactResultsFromSite(RoutingToken routingToken, 
			PatientIdentifier patientIdentifier, 
			StudyFilter filter, 
			boolean includeRadiology,
			boolean includeDocuments)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PrefetchPatientStudiesCommand")
	public abstract Boolean prefetchPatientStudies(RoutingToken routingToken, PatientIdentifier patientIdentifier, 
			StudyFilter filter, StudyLoadLevel studyLoadLevel)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostSensitivePatientAccessCommand")
	public abstract Boolean postSensitivePatientAccess(RoutingToken routingToken, PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostStudiesByCprsIdentifiersCommand")
	public abstract List<Study> postStudiesByCprsIdentifiers(PatientIdentifier patientIdentifier, RoutingToken routingToken, List<CprsIdentifier> cprsIdentifiers)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="PostStudiesByCprsIdentifiersAndFilterCommand")
	public abstract List<Study> postStudiesByCprsIdentifiersAndFilter(PatientIdentifier patientIdentifier, RoutingToken routingToken, StudyFilter filter, List<CprsIdentifier> cprsIdentifiers)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="PrefetchExamInstanceByImageUrnSyncCommand")
	public abstract Boolean prefetchExamImageInstance(ImageURN imageUrn, 
			ImageFormatQualityList imageFormatQualityList,
			boolean includeTextFile)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PrefetchInstanceByImageUrnSyncCommand")
	public abstract Boolean prefetchImageInstance(ImageURN imageUrn, 
			ImageFormatQualityList imageFormatQualityList)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PrefetchDocumentCommand")
	public abstract Boolean prefetchDocument(GlobalArtifactIdentifier gai)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetImageAnnotationListByImageUrnCommand")
	public abstract List<ImageAnnotation> getImageAnnotations(AbstractImagingURN imagingUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetImageAnnotationDetailsCommand")
	public abstract ImageAnnotationDetails getImageAnnotationDetails(AbstractImagingURN imagingUrn, 
			ImageAnnotationURN imageAnnotationUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostImageAnnotationDetailsCommand")
	public abstract ImageAnnotation storeImageAnnotation(AbstractImagingURN imagingUrn, String annotationDetails,
			String annotationVersion, ImageAnnotationSource annotationSource)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetUserKeysCommand")
	public abstract List<String> getUserKeys(RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetDivisionListCommand")
	public abstract List<Division> getDivisionList(String accessCode, RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetUserInformationFromDataSourceCommand")
	public abstract UserInformation getUserInformation(RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTreatingSitesFromDataSourceCommand")
	public abstract List<String> getTreatingSiteNumbers(RoutingToken routingToken, PatientIdentifier patientIdentifier, 
			boolean includeTrailingCharactersForSite200)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientInformationCommand")
	public abstract Patient getPatientInformation(RoutingToken routingToken, PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientMeansTestCommand")
	public abstract PatientMeansTestResult getPatientMeansTest(RoutingToken routingTokne, PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientIdentificationImageInformationCommand")
	public abstract PatientPhotoIDInformation getPhotoIdInformation(RoutingToken routingToken, PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientIdentificationImageInformationCommand")
	public abstract PatientPhotoIDInformation getPhotoIdInformation(RoutingToken routingToken, 
			PatientIdentifier patientIdentifier, boolean allowCached)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostImagingLogEventCommand")
	public abstract void postImagingLogEvent(ImagingLogEvent imagingLogEvent)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetImageAccessReasonListCommand")
	public abstract List<ImageAccessReason> getImageAccessReasons(RoutingToken routingToken,
			List<ImageAccessReasonType> reasonTypes)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetVerifyElectronicSignatureCommand")
	public abstract ElectronicSignatureResult verifyElectronicSignature(RoutingToken routingToken, String electronicSignature)
	throws MethodException, ConnectionException;	
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetHealthSummaryTypeListCommand")
	public abstract List<HealthSummaryType> getHealthSummaries(RoutingToken routingToken)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientHealthSummaryCommand")
	public abstract String getHealthSummary(HealthSummaryURN healthSummaryUrn, PatientIdentifier patientIdentifier)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetRemoteWorkItemListCommand")
	public abstract List<WorkItem> getRemoteWorkItemList(
			RoutingToken routingToken,
			String idType,
			String patientId,
			String cptCode)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="DeleteRemoteWorkItemCommand")
	public abstract Boolean deleteRemoteWorkItem(
			RoutingToken routingToken,
			String id)
	throws MethodException, ConnectionException;
	
	
}





