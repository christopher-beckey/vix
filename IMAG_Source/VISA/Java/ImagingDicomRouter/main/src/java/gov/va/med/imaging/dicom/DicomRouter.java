package gov.va.med.imaging.dicom;

import java.util.List;
import java.util.Observer;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.common.DicomFileMetaInfo;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.interfaces.IFindSCPResponseCallback;
import gov.va.med.imaging.exchange.business.EmailMessage;
import gov.va.med.imaging.exchange.business.dicom.CFindResults;
import gov.va.med.imaging.exchange.business.dicom.CMoveResults;
import gov.va.med.imaging.exchange.business.dicom.DGWEmailInfo;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomInstanceSet;
import gov.va.med.imaging.exchange.business.dicom.DicomRequestParameters;
import gov.va.med.imaging.exchange.business.dicom.DicomStorageResults;
import gov.va.med.imaging.exchange.business.dicom.InstanceStorageInfo;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;
import gov.va.med.imaging.exchange.business.dicom.ModalityConfig;
import gov.va.med.imaging.exchange.business.dicom.MoveCommandObserver;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;
import gov.va.med.imaging.exchange.business.dicom.UIDActionConfig;
import gov.va.med.imaging.exchange.business.dicom.rdsr.Dose;
import gov.va.med.imaging.exchange.business.WorkItem;

/**
 * 
 * @author vhaiswlouthj
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface DicomRouter extends FacadeRouter
{
	@FacadeRouterMethod(asynchronous=false)
	public CFindResults getCFindResults(DicomRequestParameters request)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false)
	public Boolean processCFindResults(CFindResults results, DicomAE dicomAE, IFindSCPResponseCallback cFindCallback)
			throws MethodException, ConnectionException;
	
	@Deprecated
	@FacadeRouterMethod(asynchronous=false)
	public String getStudyDetails(String studyId) 
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public MoveCommandObserver processCMoveResults(String storeAETitle, DicomRequestParameters request, Observer scpListener)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false)
	public CMoveResults getCMoveResults(DicomRequestParameters request)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=true)
	public void postDicomInstanceSet(String storeAETitle, DicomInstanceSet instances, Observer scpListener, 
		MoveCommandObserver cancelMove) 
		throws MethodException, ConnectionException;	
	
	@FacadeRouterMethod(asynchronous=false)
	public IDicomDataSet getDicomDataSet(InstanceStorageInfo instance) 
			throws MethodException, ConnectionException;
	
	@Deprecated
	@FacadeRouterMethod(asynchronous=false)
	public String getImageDetails(String image) 
		throws MethodException, ConnectionException;
	
	//
	// Configuration-related router methods
	//	
	@FacadeRouterMethod(asynchronous=false)
	public DicomAE getRemoteAE(DicomAE.searchMode findMode, String aeTitle, String siteNumber)
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public DicomAE getRemoteServiceAE(RoutingToken routingToken, DicomAE.searchMode findMode, String aeTitle, String siteNumber)
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public Boolean getModalityDeviceAuthenticated(String manufacturer, String model, String softwareVersion)
		throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false)
	public Boolean getDicomGatewayConfig() 
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public List<InstrumentConfig> getDgwInstrumentList(String hostName) 
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public List<ModalityConfig> getDgwModalityList(String hostName) 
		throws MethodException, ConnectionException;

//	@FacadeRouterMethod(asynchronous=false)
//	public List<SourceAESecurityConfig> getSourceAESecurityMatrix() 
//		throws MethodException, ConnectionException;
//
	@FacadeRouterMethod(asynchronous=false)
	public DGWEmailInfo getDgwEmailInfo(String hostName) 
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public List<UIDActionConfig> getDgwUIDActionTable(String type, String subType, String action) 
		throws MethodException, ConnectionException;

	//
	// Storage
	//
	@FacadeRouterMethod(asynchronous=false)
	public DicomStorageResults postDicomInstance(
			IDicomDataSet dds, 
			DicomAE dicomAE, 
			InstrumentConfig instrument, 
			DicomFileMetaInfo metaData, 
			int iodValidationStatus) 
		throws MethodException, ConnectionException;

	//
	// Storage Commit
	//
	@FacadeRouterMethod(asynchronous=false)
	public Integer postDicomStorageCommit(
			StorageCommitWorkItem sCWI,
			DicomAE dicomAE, 
			InstrumentConfig instrument) 
		throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false)
	public Integer postDicomStorageCommitResponse(StorageCommitWorkItem sCWI) 
		throws MethodException, ConnectionException;	
	

	//
	// Email Queueing
	//
	@FacadeRouterMethod(asynchronous=false)
	public Boolean postToEmailQueue(EmailMessage email, String scpContext)
		throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false)
	public List<Dose> getRadiationDoseDetails(String patientDfn, String accessionNumber)
			throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetAEListDataSourceCommand")
	public abstract List<DicomAE> getAEList(RoutingToken routingToken)
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=true, commandClassName="PostDicomObjectFileCommand")
	public abstract void postDicomObjectFile(RoutingToken routingToken, String dicomFileSpec);

	@FacadeRouterMethod(asynchronous=true, commandClassName="PostDicomObjectFilesToListedAEsCommand")
	public abstract void postDicomObjectFilesToListedAEs(RoutingToken routingToken, List<String> dicomFiles);
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostToAEDataSourceCommand")
	public abstract void postToAE(RoutingToken routingToken, DicomAE aet, List<String> dicomFiles)
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetDicomReportTextCommand")
	public String getDicomReportText(RoutingToken routingToken, WorkItem workItem) 
		throws MethodException, ConnectionException;

}
