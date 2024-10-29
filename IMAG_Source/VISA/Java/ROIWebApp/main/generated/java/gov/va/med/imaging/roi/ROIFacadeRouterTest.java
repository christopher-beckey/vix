/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Oct 1, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
 package gov.va.med.imaging.roi;
 
 import java.util.Date;
 import org.apache.logging.log4j.LogManager;
 import org.apache.logging.log4j.Logger;
 import gov.va.med.imaging.*;
 import gov.va.med.imaging.core.interfaces.exceptions.*;
 import gov.va.med.imaging.core.interfaces.router.Command;
 import gov.va.med.imaging.core.interfaces.router.CommandFactory;
 import gov.va.med.imaging.core.CommandFactoryImpl;
 import gov.va.med.imaging.core.interfaces.router.AsynchronousCommandResultListener;
 import gov.va.med.exceptions.ValidationException;
 import javax.annotation.Generated;
 import gov.va.med.imaging.core.interfaces.router.CommandContext;

 import gov.va.med.imaging.exchange.business.*;
 import gov.va.med.imaging.exchange.business.dicom.*;
 import gov.va.med.imaging.exchange.business.vistarad.*;
 import gov.va.med.imaging.artifactsource.*;
 
 /*
 * This is generated code and is recreated on every build.
 * Do not make changes directly in this code, as they will be lost (without warning).
 * Changes may be made to the template that generated this code (FacadeRouterImpl.ftl in
 * the CoreRouterAnnotationProcessor project), such changes will be reflected in
 * all facade router implementations.
 * 
 * This code was generated using FreeMarker, an open-source template processing engine.
 * See http://www.freemarker.org for documentation on the template syntax.
 */
 @Generated(value="gov.va.med.imaging.core.codegenerator.FacadeRouterCodeGenerator")
 public class ROIFacadeRouterTest
 //extends gov.va.med.imaging.core.interfaces.router.AbstractFacadeRouterImpl 
 {
	
 	private Logger logger = LogManager.getLogger(this.getClass());
 	
 	private Logger getLogger()
 	{
 		return logger;
 	}
 	
 	private CommandFactory commandFactory = new CommandFactoryImpl((CommandContext)null);
 	private CommandFactory getCommandFactory()
 	{
 		return commandFactory;
 	}
 
 	/**
 	* The constructor is public so this tester can be created to test
 	*/
 	public ROIFacadeRouterTest()
 	{
 		super();
 	}
 
 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void processReleaseOfInformationRequest(
 			gov.va.med.imaging.StudyURN[] studyUrns
 		 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'ProcessReleaseOfInformationRequestCommand' and parameters 'gov.va.med.imaging.StudyURN[]'.");
	 			boolean result = getCommandFactory().isCommandSupported(
	 				 gov.va.med.imaging.roi.ROIWorkItem.class, 
	 				"ProcessReleaseOfInformationRequestCommand",
	 				"",
 					new Class<?>[]{
				 		 gov.va.med.imaging.StudyURN[].class 
		  			},
 					new Object[]{
				 		studyUrns
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'ProcessReleaseOfInformationRequestCommand' in method 'processReleaseOfInformationRequest' with parameters 'gov.va.med.imaging.StudyURN[]'.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void processReleaseOfInformationRequest(
 			gov.va.med.imaging.StudyURN[] studyUrns
 		 			, gov.va.med.imaging.roi.queue.AbstractExportQueueURN exportQueueUrn
 		 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'ProcessReleaseOfInformationRequestCommand' and parameters 'gov.va.med.imaging.StudyURN[], gov.va.med.imaging.roi.queue.AbstractExportQueueURN'.");
	 			boolean result = getCommandFactory().isCommandSupported(
	 				 gov.va.med.imaging.roi.ROIWorkItem.class, 
	 				"ProcessReleaseOfInformationRequestCommand",
	 				"",
 					new Class<?>[]{
				 		 gov.va.med.imaging.StudyURN[].class, gov.va.med.imaging.roi.queue.AbstractExportQueueURN.class 
		  			},
 					new Object[]{
				 		studyUrns,exportQueueUrn
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'ProcessReleaseOfInformationRequestCommand' in method 'processReleaseOfInformationRequest' with parameters 'gov.va.med.imaging.StudyURN[], gov.va.med.imaging.roi.queue.AbstractExportQueueURN'.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void processReleaseOfInformationRequest(
 			gov.va.med.imaging.StudyURN[] studyUrns
 		 			, gov.va.med.imaging.roi.queue.AbstractExportQueueURN exportQueueUrn
 		 			, java.util.List<gov.va.med.imaging.roi.CCPHeader> ccpHeaders
 		 			, java.lang.String includeNonDicom
 		 			, java.lang.String includeReport
 		 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'ProcessReleaseOfInformationRequestCommand' and parameters 'gov.va.med.imaging.StudyURN[], gov.va.med.imaging.roi.queue.AbstractExportQueueURN, java.util.List, java.lang.String, java.lang.String'.");
	 			boolean result = getCommandFactory().isCommandSupported(
	 				 gov.va.med.imaging.roi.ROIWorkItem.class, 
	 				"ProcessReleaseOfInformationRequestCommand",
	 				"",
 					new Class<?>[]{
				 		 gov.va.med.imaging.StudyURN[].class, gov.va.med.imaging.roi.queue.AbstractExportQueueURN.class, java.util.List.class, java.lang.String.class, java.lang.String.class 
		  			},
 					new Object[]{
				 		studyUrns,exportQueueUrn,ccpHeaders,includeNonDicom,includeReport
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'ProcessReleaseOfInformationRequestCommand' in method 'processReleaseOfInformationRequest' with parameters 'gov.va.med.imaging.StudyURN[], gov.va.med.imaging.roi.queue.AbstractExportQueueURN, java.util.List, java.lang.String, java.lang.String'.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void getRoiRequest(
 			java.lang.String guid
 		 			, boolean includeExtendedInformation
 		 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'GetROIWorkItemByGuidCommand' and parameters 'java.lang.String, boolean'.");
	 			boolean result = getCommandFactory().isCommandSupported(
	 				 gov.va.med.imaging.roi.ROIWorkItem.class, 
	 				"GetROIWorkItemByGuidCommand",
	 				"",
 					new Class<?>[]{
				 		 java.lang.String.class, boolean.class 
		  			},
 					new Object[]{
				 		guid,includeExtendedInformation
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'GetROIWorkItemByGuidCommand' in method 'getRoiRequest' with parameters 'java.lang.String, boolean'.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void getActiveROIRequests(
 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'GetActiveROIRequestWorkItemsCommand' and parameters ''.");
 			boolean result = getCommandFactory().isCollectionCommandSupported(
 				 java.util.List.class, 
 				 gov.va.med.imaging.exchange.business.WorkItem.class, 
 				"GetActiveROIRequestWorkItemsCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);
      
			if(!result)
	  			throw new ValidationException("Cannot create command 'GetActiveROIRequestWorkItemsCommand' in method 'getActiveROIRequests' with parameters ''.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void processROIPeriodicRequests(
 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'ProcessROIPeriodicRequestsSyncCommand' and parameters ''.");
				boolean result = getCommandFactory().isCommandSupported(
	 				 java.lang.Void.class, 
	 				"ProcessROIPeriodicRequestsSyncCommand",
	 				"",
 					new Class<?>[]{
				 		  
		  			},
 					new Object[]{
				 		
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'ProcessROIPeriodicRequestsSyncCommand'.");		  		
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void postROIChangeWorkItemStatus(
 			java.lang.String guid
 		 			, gov.va.med.imaging.roi.ROIStatus newStatus
 		 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'PostROIChangeWorkItemStatusCommand' and parameters 'java.lang.String, gov.va.med.imaging.roi.ROIStatus'.");
	 			boolean result = getCommandFactory().isCommandSupported(
	 				 java.lang.Boolean.class, 
	 				"PostROIChangeWorkItemStatusCommand",
	 				"",
 					new Class<?>[]{
				 		 java.lang.String.class, gov.va.med.imaging.roi.ROIStatus.class 
		  			},
 					new Object[]{
				 		guid,newStatus
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'PostROIChangeWorkItemStatusCommand' in method 'postROIChangeWorkItemStatus' with parameters 'java.lang.String, gov.va.med.imaging.roi.ROIStatus'.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void getROIDisclosure(
 			gov.va.med.PatientIdentifier patientIdentifier
 		 			, gov.va.med.imaging.GUID guid
 		 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'GetROIDisclosureByGuidCommand' and parameters 'gov.va.med.PatientIdentifier, gov.va.med.imaging.GUID'.");
	 			boolean result = getCommandFactory().isCommandSupported(
	 				 java.io.InputStream.class, 
	 				"GetROIDisclosureByGuidCommand",
	 				"",
 					new Class<?>[]{
				 		 gov.va.med.PatientIdentifier.class, gov.va.med.imaging.GUID.class 
		  			},
 					new Object[]{
				 		patientIdentifier,guid
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'GetROIDisclosureByGuidCommand' in method 'getROIDisclosure' with parameters 'gov.va.med.PatientIdentifier, gov.va.med.imaging.GUID'.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void processOldUnfinishedROIRequests(
 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'ProcessOldUnfinishedROIRequestsCommand' and parameters ''.");
				boolean result = getCommandFactory().isCommandSupported(
	 				 java.lang.Void.class, 
	 				"ProcessOldUnfinishedROIRequestsCommand",
	 				"",
 					new Class<?>[]{
				 		  
		  			},
 					new Object[]{
				 		
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'ProcessOldUnfinishedROIRequestsCommand'.");		  		
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void processROIWorkItem(
 			java.lang.String guid
 		 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'ProcessROIWorkItemSyncCommand' and parameters 'java.lang.String'.");
				boolean result = getCommandFactory().isCommandSupported(
	 				 java.lang.Void.class, 
	 				"ProcessROIWorkItemSyncCommand",
	 				"",
 					new Class<?>[]{
				 		 java.lang.String.class 
		  			},
 					new Object[]{
				 		guid
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'ProcessROIWorkItemSyncCommand'.");		  		
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void getDicomExportQueues(
 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'GetDicomExportQueueListCommand' and parameters ''.");
 			boolean result = getCommandFactory().isCollectionCommandSupported(
 				 java.util.List.class, 
 				 gov.va.med.imaging.roi.queue.DicomExportQueue.class, 
 				"GetDicomExportQueueListCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);
      
			if(!result)
	  			throw new ValidationException("Cannot create command 'GetDicomExportQueueListCommand' in method 'getDicomExportQueues' with parameters ''.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void getDicomCcpExportQueues(
 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'GetDicomCcpExportQueueListCommand' and parameters ''.");
 			boolean result = getCommandFactory().isCollectionCommandSupported(
 				 java.util.List.class, 
 				 gov.va.med.imaging.roi.queue.DicomExportQueue.class, 
 				"GetDicomCcpExportQueueListCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);
      
			if(!result)
	  			throw new ValidationException("Cannot create command 'GetDicomCcpExportQueueListCommand' in method 'getDicomCcpExportQueues' with parameters ''.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void getNonDicomExportQueues(
 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'GetNonDicomExportQueueListCommand' and parameters ''.");
 			boolean result = getCommandFactory().isCollectionCommandSupported(
 				 java.util.List.class, 
 				 gov.va.med.imaging.roi.queue.NonDicomExportQueue.class, 
 				"GetNonDicomExportQueueListCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);
      
			if(!result)
	  			throw new ValidationException("Cannot create command 'GetNonDicomExportQueueListCommand' in method 'getNonDicomExportQueues' with parameters ''.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void cancelROIWorkItem(
 			java.lang.String guid
 		 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'PostROICancelWorkItemCommand' and parameters 'java.lang.String'.");
	 			boolean result = getCommandFactory().isCommandSupported(
	 				 java.lang.Boolean.class, 
	 				"PostROICancelWorkItemCommand",
	 				"",
 					new Class<?>[]{
				 		 java.lang.String.class 
		  			},
 					new Object[]{
				 		guid
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'PostROICancelWorkItemCommand' in method 'cancelROIWorkItem' with parameters 'java.lang.String'.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void getUserROIRequests(
 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'GetROIWorkItemsByUserCommand' and parameters ''.");
 			boolean result = getCommandFactory().isCollectionCommandSupported(
 				 java.util.List.class, 
 				 gov.va.med.imaging.exchange.business.WorkItem.class, 
 				"GetROIWorkItemsByUserCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);
      
			if(!result)
	  			throw new ValidationException("Cannot create command 'GetROIWorkItemsByUserCommand' in method 'getUserROIRequests' with parameters ''.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void deleteUserROIWorkItems(
 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'DeleteROIWorkItemsByUserCommand' and parameters ''.");
	 			boolean result = getCommandFactory().isCommandSupported(
	 				 java.lang.Boolean.class, 
	 				"DeleteROIWorkItemsByUserCommand",
	 				"",
 					new Class<?>[]{
				 		  
		  			},
 					new Object[]{
				 		
		  			}
		  		);
		  		if(!result)
		  			throw new ValidationException("Cannot create command 'DeleteROIWorkItemsByUserCommand' in method 'deleteUserROIWorkItems' with parameters ''.");
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void getCommunityCareProviders(
 ) 
 		throws ValidationException
 		{
 			getLogger().info("Searching for command 'GetROICommunityCareProvidersCommand' and parameters ''.");
 			boolean result = getCommandFactory().isCollectionCommandSupported(
 				 java.util.List.class, 
 				 java.lang.String.class, 
 				"GetROICommunityCareProvidersCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);
      
			if(!result)
	  			throw new ValidationException("Cannot create command 'GetROICommunityCareProvidersCommand' in method 'getCommunityCareProviders' with parameters ''.");
 		}

 }