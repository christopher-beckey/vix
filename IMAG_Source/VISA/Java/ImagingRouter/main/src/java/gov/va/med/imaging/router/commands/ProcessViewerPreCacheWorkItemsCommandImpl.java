package gov.va.med.imaging.router.commands;

import java.util.*;

import org.apache.commons.lang.time.DateUtils;
import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.facade.InternalContext;
import gov.va.med.imaging.core.router.facade.InternalRouter;
import gov.va.med.imaging.core.router.periodiccommands.PeriodicCommandConfiguration;
import gov.va.med.imaging.core.router.periodiccommands.PeriodicPreCacheConfiguration;
import gov.va.med.imaging.core.router.worklist.InternalWorkListRouter;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.WorkItemFilter;
import gov.va.med.imaging.exchange.business.WorkItemTag;
import gov.va.med.imaging.exchange.business.WorkItemTags;
import gov.va.med.imaging.exchange.business.WorkListTypes;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.notifications.NotificationFacade;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * 
 * @author William Peterson
 *
 */
@RouterCommandExecution(asynchronous = true, distributable = false)
public class ProcessViewerPreCacheWorkItemsCommandImpl 
extends AbstractCommandImpl<Boolean> {

	private static final long serialVersionUID = 1L;
	
	private List<WorkItem> workItems = null;
	private List<WorkItem> localWorkItems = null;
	private List<WorkItem> remoteWorkItems = null;
	private String siteId = null;
	private RoutingToken routingToken = null;
	private SiteConnection connection = null;
	private int startingDaysForDodStudies = PeriodicCommandConfiguration.STARTING_DAYS_FOR_DOD_STUDIES_DEFAULT;
	
	private Logger logger = Logger.getLogger(ProcessViewerPreCacheWorkItemsCommandImpl.class);
    
	public ProcessViewerPreCacheWorkItemsCommandImpl() 
	{
		PeriodicPreCacheConfiguration config = PeriodicPreCacheConfiguration.getConfiguration();
		startingDaysForDodStudies = Integer.parseInt(config.getStartingDaysForDodStudies());
	}
	
	@Override
	public Boolean callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException 
	{
		synchronized(this)
		{
			try
			{
				logger.debug("Entering Pre-caching work items");
				
			    this.routingToken = getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
			    
			    TransactionContext transactionContext = TransactionContextFactory.get();
				siteId = transactionContext.getSiteNumber();
				transactionContext.setServicedSource(siteId);
				if(transactionContext.getTransactionId() == null)
				{
					logger.info("ProcessViewerPreCacheWorkItemsCommandImpl - Generate transaction ID.");
					transactionContext.setTransactionId( (new GUID()).toLongString() );
				}
				
				//get the work item collection from VistA Queue for local processing.
				getPreCacheWorkItems();
		
				//Process local pre-cache work items
				if ((this.getLocalWorkItems() != null) && (this.getLocalWorkItems().size() > 0))
				{
					//send the work item collection (as is) to the Viewer
					sendWorkItemsToViewer(this.getLocalWorkItems());
					
					//if successful (no exceptions), delete work items from VistA Queue.
					deleteWorkItemsFromQueue(this.getLocalWorkItems());
				}
					
				//Process remote pre-cache work items
				if ((this.getRemoteWorkItems() != null) && (this.getRemoteWorkItems().size() > 0))
				{
					//process remote pre-cache work item collection
					try {
						processRemotePreCacheWorkItems();
					} 
					catch (Exception e) 
					{
						logger.error(e.getMessage());
					}
				}
			}
			finally
			{
				logger.debug("Pre-caching work items done");
			}
		}
		
		return false;
	}


	@Override
	public boolean equals(Object obj) 
	{
		return false;
	}

	
	@Override
	public Command<Boolean> getNewPeriodicInstance() throws MethodException {
		ProcessViewerPreCacheWorkItemsCommandImpl command = new ProcessViewerPreCacheWorkItemsCommandImpl();
		command.setPeriodic(true);
		command.setPeriodicExecutionDelay(this.getPeriodicExecutionDelay());
		command.setCommandContext(this.getCommandContext());
		return command;
	}
	
	public List<Class<? extends MethodException>> getFatalPeriodicExceptionClasses()
	{
		List<Class<? extends MethodException>> fatalExceptions = new ArrayList<Class<? extends MethodException>>();
		fatalExceptions.add(InvalidUserCredentialsException.class);
		return fatalExceptions;
	}
	
	/**
	 * This method is called when a periodic command has thrown a fatal exception as defined by the list in getFatalPeriodicExceptionClasses(). At the point when this method is called
	 * the periodic command has already stopped executing and will not execute again.  This method is meant to allow the command to alert someone of the failure (such as by sending 
	 * an email message)
	 * @param t
	 */
	public void handleFatalPeriodicException(Throwable t)
	{
		String subject = "Invalid credentials";
		String message = "The ProcessViewerPreCacheWorkItems periodic command has shut down due to invalid credentials.";
		NotificationFacade.sendNotification(NotificationTypes.InvalidServiceAccountCredentials, subject, message);
	}
	
	@Override
	protected String parameterToString() {
		return "";
	}

	private void getPreCacheWorkItems() 
	throws MethodException, ConnectionException
	{
		InternalWorkListRouter router = WorkListContext.getInternalRouter();
   
		WorkItemFilter filter = new WorkItemFilter();
		filter.setType(WorkListTypes.PreCaching);
		//filter.setPlaceId(getLocalSiteId());
		filter.setStatus("New");
		
		workItems = router.getWorkItemList(filter);
		
		if (workItems != null && workItems.size() > 0)
		{
			// The find call only returns the header - no WorkItemDetails. Get the full raw workitem and convert it to 
			// an WorkItem
			for (WorkItem item : workItems){
				item = router.getAndTransitionWorkItem(item.getId(), item.getStatus(), 
						item.getStatus(), item.getUpdatingUser(), item.getUpdatingApplication());
			}
			
			localWorkItems = new ArrayList<WorkItem>();
			remoteWorkItems = new ArrayList<WorkItem>();

			for (WorkItem item : workItems)
			{
				if (isLocalPrecacheWorkItem(item))
				{
					localWorkItems.add(item);
				}
				else
				{
					remoteWorkItems.add(item);
				}
			}
		}		
	}
	
	private boolean isLocalPrecacheWorkItem(WorkItem item) 
	{
		WorkItemTags tags = item.getTags();
		List<WorkItemTag> workItemTags = tags.getTags();

		for (WorkItemTag tag: workItemTags)
		{
			if (tag.getKey().startsWith("treatingStation"))
				return false;
		}
		
		return true;
	}

	private void sendWorkItemsToViewer(List<WorkItem> workItemList)
	throws MethodException, ConnectionException
	{
		InternalRouter rtr = InternalContext.getRouter();
		//get the local Viewer connection info
		Site site = rtr.getSite(getSiteId());
		Map<String,SiteConnection> connections = site.getSiteConnections();
		if(connections.containsKey(SiteConnection.siteConnectionVVSS)){
			this.connection = connections.get(SiteConnection.siteConnectionVVSS);
		}
		else if(connections.containsKey(SiteConnection.siteConnectionVVS)){
			this.connection = connections.get(SiteConnection.siteConnectionVVS);
		}
		else{
			throw new ConnectionException("No Viewer can be found for this site.");
		}
		
		//call router datasource command for Viewer
		rtr.postViewerPreCacheWorkItems(getRoutingToken(), getConnection(), workItemList);
	}

	private void deleteWorkItemsFromQueue(List<WorkItem> workItemList) throws MethodException, ConnectionException
	{
		InternalWorkListRouter router = WorkListContext.getInternalRouter();
		for (WorkItem item : workItemList){
			router.deleteWorkItem(item.getId());
		}
	}

	//--------------------- REMOTE ---------------------------------
	
	private void processRemotePreCacheWorkItems() 
	throws MethodException, ConnectionException, RoutingTokenFormatException 
	{
		for (WorkItem item : getRemoteWorkItems())
		{
			WorkItemTags tags = item.getTags();
			String patientId = null;
			String idType = null;
			String patientDfn = null;
			String patientIcn = null;
			List<String> treatingStations = new ArrayList<String>();
			String cptCode = null;

			for (WorkItemTag tag: tags.getTags())
			{
				String key = tag.getKey().toLowerCase(Locale.ENGLISH);
				String val = tag.getValue();
				if (key.equals("patientdfn"))
				{
					idType = "DFN";
					patientDfn = val;
				}
				else if (key.equals("patienticn"))
				{
					idType = "ICN";
					patientIcn = val;
				}
				else if (key.startsWith("treatingstation"))
				{
					if (!val.equals(getSiteId()))
						treatingStations.add(val);
				}
				else if (key.equals("cpt"))
				{
					cptCode = val;
				}
			}

			if ((idType == null) || (treatingStations.size() == 0) || (cptCode == null))
				continue;
			
			PatientIdentifier patientIdentifier = null;
			
			if (patientIcn != null) 
			{
				patientId = patientIcn;
				idType = "ICN";
				patientIdentifier = new PatientIdentifier(patientIcn, PatientIdentifierType.icn);
			}
			else
			{
				patientId = patientDfn;
				idType = "DFN";
				patientIdentifier = new PatientIdentifier(patientId, PatientIdentifierType.dfn);
			}
			
			for (String treatingStation : treatingStations)
			{
				try
				{
				
					RoutingToken remoteRoutingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(treatingStation);
					
					logger.debug("...executing ProcessViewerPreCacheWorkItemsCommandImpl.");
					TransactionContext transactionContext = TransactionContextFactory.get();
					transactionContext.setServicedSource(getRoutingToken().toRoutingTokenString());
					transactionContext.setPatientID(patientIdentifier.getValue());
					
					List<WorkItem> remoteWorkItemsToSend = null;
					
					if (ExchangeUtil.isSiteDOD(treatingStation))
					{
						StudyFilter filter = new StudyFilter();
						filter.setMaximumAllowedLevel(PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK);
						filter.setFromDate(DateUtils.addDays(new Date(), -startingDaysForDodStudies));
						filter.setToDate(new Date());
						filter.setIncludeImages(true);
						Boolean includeRadiology = true;
						Boolean includeDocuments = true;
						ArtifactResults artifactResults = ImagingContext.getRouter().getStudyWithImagesPatientArtifactResultsFromSite(
										remoteRoutingToken, patientIdentifier, filter, includeRadiology, includeDocuments);
								
						List<Study> result = new ArrayList<Study>(artifactResults.getStudySetResult().getArtifacts());
						remoteWorkItemsToSend = translateToWorkItems(result);
					}
					else
					{
						//get the workitems from remote site thru federation
						remoteWorkItemsToSend = ImagingContext.getRouter().getRemoteWorkItemList(
								remoteRoutingToken, idType, patientId, cptCode);
					}
					
					//send the work item collection (as is) to the Viewer
					sendWorkItemsToViewer(remoteWorkItemsToSend);
				}
				catch (Exception e)
				{
                    logger.debug("Unable to remote precache for station: {}. Error: {}", treatingStation, e.getMessage());
				}
			}
		}
		
		deleteWorkItemsFromQueue(getRemoteWorkItems());
	}

	private List<WorkItem> translateToWorkItems(List<Study> studies) 
	{
		List<WorkItem> workItems = new ArrayList<WorkItem>();
		
		for(Study study: studies)
		{
			for (Series series : study.getSeries())
			{
				for (Image image : 	series.getImages())
				{
					WorkItem workitem = new WorkItem();
					workitem.setPlaceId(study.getSiteNumber());

					if ((study.getContextId() == null) || study.getContextId().equals(""))
						workitem.addTag("contextid", study.getStudyUrn().toString());
					else
						workitem.addTag("contextid", study.getContextId());

					workitem.addTag("patienticn", study.getPatientId());
					workitem.addTag("studyien", study.getStudyIen());
					workitem.addTag("storage", image.isImageInNewDataStructure() ? "2005" : "");
					workitem.addTag("imageien", image.getIen());
					workitem.addTag("imageshortdescr", image.getDescription());
					workitem.addTag("imagemodality", image.getImageModality());
					workitem.addTag("imagefilename", image.getBigFilename());
					workitem.addTag("imageobjecttype", Integer.toString(image.getImgType()));
					workItems.add(workitem);
				}
			}
		}
		
		return workItems;
	}




//	private void deleteRemoteWorkItemsFromQueue(List<WorkItem> remoteWorkItems) 
//	throws MethodException, ConnectionException, RoutingTokenFormatException
//	{
//		for (WorkItem item : remoteWorkItems)
//		{
//			RoutingToken remoteRoutingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(item.getPlaceId());
//			ImagingContext.getRouter().deleteRemoteWorkItem(remoteRoutingToken, Integer.toString(item.getId()));
//		}
//	}

	public List<WorkItem> getLocalWorkItems() {
		return localWorkItems;
	}


	public List<WorkItem> getRemoteWorkItems() {
		return remoteWorkItems;
	}

	public String getSiteId() {
		return siteId;
	}


	public RoutingToken getRoutingToken() {
		return routingToken;
	}


	public SiteConnection getConnection() {
		return connection;
	}


}
