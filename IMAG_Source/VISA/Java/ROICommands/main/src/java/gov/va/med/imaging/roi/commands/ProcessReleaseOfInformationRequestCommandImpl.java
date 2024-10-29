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
package gov.va.med.imaging.roi.commands;

import java.util.List;

//import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.roi.CCPHeader;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.ROIValues;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIWorkItemMessage;
import gov.va.med.imaging.roi.ROIWorkItemTag;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;
import gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics;
import gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration;
import gov.va.med.imaging.roi.queue.AbstractExportQueueURN;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * Add an entry to the queue to process an ROI request. 
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ProcessReleaseOfInformationRequestCommandImpl
extends AbstractCommandImpl<ROIWorkItem>
{
	private static final long serialVersionUID = 714653519743453511L;
	private final StudyURN [] studyUrns;
	private final AbstractExportQueueURN exportQueueUrn;
	private final List<CCPHeader> ccpHeaders;
	private final String includeNonDicom;
	private final String includeReport;
	
	public ProcessReleaseOfInformationRequestCommandImpl(StudyURN [] studyUrns, 
			AbstractExportQueueURN exportQueueUrn, List<CCPHeader> ccpHeaders, String includeNonDicom, String includeReport)
	{
		super();
		this.studyUrns = studyUrns;
		this.exportQueueUrn = exportQueueUrn;
		this.ccpHeaders = ccpHeaders;
		this.includeNonDicom = includeNonDicom;
		this.includeReport = includeReport;
	}
	
	public ProcessReleaseOfInformationRequestCommandImpl(StudyURN [] studyUrns, 
			AbstractExportQueueURN exportQueueUrn)
	{
		this(studyUrns, exportQueueUrn, null, null, null);
	}

	public ProcessReleaseOfInformationRequestCommandImpl(StudyURN [] studyUrns)
	{
		this(studyUrns, null);
	}

	public StudyURN[] getStudyUrns()
	{
		return studyUrns;
	}

	public AbstractExportQueueURN getExportQueueUrn()
	{
		return exportQueueUrn;
	}

	@Override
	public ROIWorkItem callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		getLogger().info("Initiating ROI disclosure for the following studies:");
		if(getStudyUrns() != null)
		{
			for(StudyURN studyUrn : getStudyUrns())
			{
				getLogger().info("\t" + studyUrn.toStringCDTP());
			}
		}
		
		String [] ids = validateStudyRequests();
		
		String siteId = 
			getCommandContext().getLocalSite().getArtifactSource().createRoutingToken().getRepositoryUniqueId();
		// at this point we've already checked to make sure all patient ICNs are the same, so this is safe to do
		String patientId = studyUrns[0].getPatientId();
		PatientIdentifierType patientIdentifierType = studyUrns[0].getPatientIdentifierTypeOrDefault();
		String guid = new GUID().toString();
		TransactionContext transactionContext = TransactionContextFactory.get();
		String userDuz = transactionContext.getDuz();
		transactionContext.setUrn(guid);
		
		WorkItem workItem = new WorkItem(ROIValues.ROI_WORKITEM_TYPE, 
				(ccpHeaders != null) && (ccpHeaders.size() > 0) ? ROIValues.ROI_WORKITEM_SUBTYPE_CCP : ROIValues.ROI_WORKITEM_SUBTYPE,		
				ROIStatus.NEW.getStatus(), 
				siteId,
				userDuz, "ROIWebApp");
		workItem.setMessage( ROIWorkItemMessage.toXml(ids));
		if(patientIdentifierType == PatientIdentifierType.icn)
			workItem.addTag(ROIWorkItemTag.patientIcn.getTagName(), patientId);
		else
			workItem.addTag(ROIWorkItemTag.patientDfn.getTagName(), patientId);
		workItem.addTag(ROIWorkItemTag.guid.getTagName(), guid);
		workItem.addTag(ROIWorkItemTag.retryCount.getTagName(), "0");
		// M code doesn't like empty string values for tags, if the export queue is not provided, don't create the tag
		if(getExportQueueUrn() != null)
			workItem.addTag(ROIWorkItemTag.exportQueue.getTagName(), exportQueueUrn.toString());
		
		Patient patient = ImagingContext.getRouter().getPatientInformation(getRoutingToken(), 
				new PatientIdentifier(patientId, patientIdentifierType));
		workItem.addTag(ROIWorkItemTag.patientName.getTagName(), patient.getPatientName());
		workItem.addTag(ROIWorkItemTag.filteredPatientSsn.getTagName(), patient.getFilteredSsn());
		workItem.addTag(ROIWorkItemTag.userDuz.getTagName(), userDuz);
		
		if (ccpHeaders != null) {
			for (CCPHeader header : ccpHeaders) {
				workItem.addTag(ROIWorkItemTag.ccpHeader.getTagName(), header.getHeader());
			}
		}
		
		workItem.addTag(ROIWorkItemTag.includeNonDicom.getTagName(), includeNonDicom);
		workItem.addTag(ROIWorkItemTag.includeReport.getTagName(), includeReport);
		
		WorkItem newWorkItem = 
			ROICommandsContext.getRouter().postReleaseOfInformationRequest(workItem);
		if(ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration().isProcessWorkItemImmediately())
		{
			ROICommandsContext.getRouter().processROIWorkItem(guid);
		}
		
		ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureRequests();
		
		return new ROIWorkItem(newWorkItem);
	}
	
	private String [] validateStudyRequests()
	throws MethodException
	{
		if(studyUrns == null)
			throw new MethodException("Null study IDs provided, there must be at least 1 study Id requested");
		if(studyUrns.length == 0)
			throw new MethodException("Empty list of Study IDs provided, there must be at least 1 study Id requested");
		String patientId = null;
		String [] urns = new String[studyUrns.length];
		int i = 0;
		for(StudyURN studyUrn : studyUrns)
		{
			if(studyUrn.getRepositoryUniqueId() == null)
				throw new MethodException("Null site ID in study ID");
			if(studyUrn.getPatientId() == null)
				throw new MethodException("Null patient ID in study ID");
			if(patientId == null)
				patientId = studyUrn.getPatientId();
			else
			{
				if(!patientId.equals(studyUrn.getPatientId()))
					throw new MethodException("Patient IDs for studies do not all match - cannot process");
			}
					
			urns[i] = studyUrn.toStringCDTP();
			i++;
		}
		return urns;
	}

	@Override
	public boolean equals(Object obj)
	{
		return false;
	}

	@Override
	protected String parameterToString()
	{
		//return getStudyUrn().toString();
		return "";
	}

}
