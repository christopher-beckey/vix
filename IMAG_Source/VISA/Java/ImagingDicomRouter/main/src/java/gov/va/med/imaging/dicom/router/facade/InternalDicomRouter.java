package gov.va.med.imaging.dicom.router.facade;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.commands.StorageCommitWaiter;
import gov.va.med.imaging.dicom.common.DicomFileMetaInfo;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.utils.Publisher;
import gov.va.med.imaging.dicom.dcftoolkit.common.observer.SubOperationsStatus;
import gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreSCUControl;
import gov.va.med.imaging.exchange.business.dicom.CFindResults;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomCorrectInfo;
import gov.va.med.imaging.exchange.business.dicom.DicomInstanceUpdateInfo;
import gov.va.med.imaging.exchange.business.dicom.DicomMap;
import gov.va.med.imaging.exchange.business.dicom.DicomStorageResults;
import gov.va.med.imaging.exchange.business.dicom.DicomUid;
import gov.va.med.imaging.exchange.business.dicom.InstanceFile;
import gov.va.med.imaging.exchange.business.dicom.InstanceStorageInfo;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;
import gov.va.med.imaging.exchange.business.dicom.MoveCommandObserver;
import gov.va.med.imaging.exchange.business.dicom.PatientRef;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyInfo;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyLookupResults;
import gov.va.med.imaging.exchange.business.dicom.ProcedureRef;
import gov.va.med.imaging.exchange.business.dicom.SCWorkItemQueryParameters;
import gov.va.med.imaging.exchange.business.dicom.SOPInstance;
import gov.va.med.imaging.exchange.business.dicom.Series;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;
import gov.va.med.imaging.exchange.business.dicom.Study;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckInfo;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckResult;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckResults;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.Order;
import gov.va.med.imaging.exchange.business.dicom.importer.OrderFilter;
import gov.va.med.imaging.exchange.business.dicom.importer.Reconciliation;
import gov.va.med.imaging.exchange.business.dicom.rdsr.Dose;

import java.io.InputStream;
import java.nio.channels.ReadableByteChannel;
import java.util.HashSet;
import java.util.List;
import java.util.concurrent.LinkedBlockingQueue;

/**
 * 
 * @author vhaiswlouthj
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface InternalDicomRouter 
extends FacadeRouter
{

	//
	// Patient/Study Lookup
	//
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public PatientStudyLookupResults getPatientStudyLookupResults(PatientStudyInfo patientStudyInfo)
		throws MethodException, ConnectionException;

	//
	// UID Checking
	//
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public UIDCheckResult getStudyUIDCheckResult(UIDCheckInfo uidCheckInfo) 
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public UIDCheckResult getSeriesUIDCheckResult(UIDCheckInfo uidCheckInfo) 
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public UIDCheckResult getSOPInstanceUIDCheckResult(UIDCheckInfo uidCheckInfo) 
		throws MethodException, ConnectionException;
	
	//
	//
	// UID Generation
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public DicomUid getDicomUid(String accessionNumber,
			String siteId,
			String instrument,
			String type) 
	throws MethodException, ConnectionException;

	//
	// Storage Entry points
	//

	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Boolean postDicomCorrect(IDicomDataSet dds, 
			DicomAE dicomAE,
			PatientStudyLookupResults patientStudyLookupResults,
			InstrumentConfig instrument, 
			boolean isNetworkImport,
			String originIndex,
			InputStream inputStream) 
		throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Boolean postDicomInstanceTo2005(IDicomDataSet dds, 
			DicomAE dicomAE, 
			InstrumentConfig instrument, 
			ReadableByteChannel instanceChannel, 
			InputStream inputStream, 
			String originIndex) 
		throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Boolean postDicomInstanceToNewStructure(IDicomDataSet dds, 
			DicomAE dicomAE, 
			PatientStudyLookupResults patientStudyLookupResults, 
			UIDCheckResults uidCheckResults, 
			InstrumentConfig instrument, 
			int iodValidationStatus, 
			ReadableByteChannel instanceChannel, 
			InputStream inputStream, 
			String originIndex) 
		throws MethodException, ConnectionException;

	//
	// Storage Commit Entry point
	//

	@FacadeRouterMethod(asynchronous=false)
	public StorageCommitWorkItem postStoreCommitWorkItem(StorageCommitWorkItem scWI) 
		throws MethodException, ConnectionException;
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public List<StorageCommitWorkItem> getStoreCommitWorkItemList(SCWorkItemQueryParameters parameters) 
		throws MethodException, ConnectionException;
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public StorageCommitWorkItem getStoreCommitWorkItem(String scWIID, Boolean doProcess) 
		throws MethodException, ConnectionException;
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Boolean postStoreCommitWorkItemStatus(String scWIID, String status) 
		throws MethodException, ConnectionException;
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Boolean postDeleteStoreCommitWorkItem(String scWIID) 
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Integer postSendSCResponse(StorageCommitWorkItem scWI, StorageCommitWaiter scWaiter) 
			throws MethodException, ConnectionException;
		

	/**
	 * Used by DICOMCorrect
	 */
	@FacadeRouterMethod(asynchronous=false)
	public DicomStorageResults postDicomInstance(IDicomDataSet dds, 
			DicomAE dicomAE, 
			InstrumentConfig instrument, 
			DicomFileMetaInfo metaData, 
			int iodValidationStatus, 
			boolean isAlreadyReconciled, 
			String originIndex) 
		throws MethodException, ConnectionException;
	
	//
	// Entity CRUD
	//
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public PatientRef getOrCreatePatientRef(PatientRef patientRef) 
		throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public ProcedureRef getOrCreateProcedureRef(PatientRef patientRef, ProcedureRef procedureRef) 
		throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Study getOrCreateStudy(PatientRef patientRef, ProcedureRef procedureRef, Study study) 
		throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Series getOrCreateSeries(Study study, Series series, Integer iodValidationStatus) 	
		throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public SOPInstance postSOPInstance(Series series, SOPInstance sopInstance)
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public InstanceFile postInstanceFile(SOPInstance sopInstance, InstanceFile instanceFile)
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Series getTIUPointer(Series series) 	
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Boolean deleteStudyAndSeriesCache() 	
		throws MethodException, ConnectionException;


	//
	// DICOM Correct
	//
//	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
//	public DicomCorrectInfo postDicomCorrectEntry(DicomCorrectInfo dicomCorrectInfo)
//		throws MethodException, ConnectionException;
//
//	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
//	public List<DicomCorrectEntry> getDicomCorrectEntryList(DicomCorrectEntry dicomCorrectEntry)
//		throws MethodException, ConnectionException;
//	
//	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
//	public Boolean deleteDicomCorrectEntry(DicomCorrectEntry dicomCorrectEntry)
//		throws MethodException, ConnectionException;
//	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Integer getDicomCorrectCount(DicomCorrectInfo dicomCorrectInfo)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public Boolean processNonDicomFiles(String studyUid,
			ImporterWorkItem importerWorkItem,
			Reconciliation reconciliation, 
			InstrumentConfig instrumentConfig)	
	throws MethodException, ConnectionException;

	//
	//Query/Retrieve SCP
	//

	@FacadeRouterMethod(asynchronous=true, isChildCommand=true)
	public void postCFindResults(CFindResults results, DicomAE dicomAE, HashSet<DicomMap> mappingSet, 
			LinkedBlockingQueue<IDicomDataSet> queue, IDicomDataSet lastBag)
			throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=true, isChildCommand=true)
	public void postDicomDataSet(DicomAE remoteAE, IStoreSCUControl scu, 
			LinkedBlockingQueue<IDicomDataSet> queue, Publisher subOperationsPublisher, 
			SubOperationsStatus subOperationsStatus, MoveCommandObserver cancelMove) 
			throws MethodException, ConnectionException;
		
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public DicomInstanceUpdateInfo getDicomInstanceUpdateInfo(InstanceStorageInfo instanceStorageInfo) 
			throws MethodException, ConnectionException;


	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public abstract List<Order> getOrderListForPatient(OrderFilter orderFilter) 
	throws MethodException, ConnectionException;

	// Radiation Dose Structured Report Processing
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public void postRadiationDose(PatientRef patient, ProcedureRef procedure, 
			Study study, Series series, Dose dose)
			throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, isChildCommand=true)
	public void processRadiationDose(IDicomDataSet dds, PatientRef patient, ProcedureRef procedure, Study study, Series series)
			throws MethodException, ConnectionException;
	


}
