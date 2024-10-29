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
 import gov.va.med.imaging.core.interfaces.router.AsynchronousCommandResultListener;
 import javax.annotation.Generated;
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
 public class ROIFacadeRouterImpl
 extends gov.va.med.imaging.core.interfaces.router.AbstractFacadeRouterImpl 
 implements ROIFacadeRouter
 {
	private static ROIFacadeRouterImpl singleton;
 
 	/*
 	* The getSingleton() method is the only way to get a reference to the router facade.
 	*/
 	public static synchronized ROIFacadeRouter getSingleton()
	{
		if(singleton == null)  
			singleton = new ROIFacadeRouterImpl();
		
		return singleton; 
	} 
 
 	private Logger logger = LogManager.getLogger(this.getClass());
 	
 	private Logger getLogger()
 	{
 		return logger;
 	}
 
 	/**
 	* The constructor is protected because the class may be derived from.
 	*/
 	protected ROIFacadeRouterImpl()
 	{
 		super();
 	}
 
 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public gov.va.med.imaging.roi.ROIWorkItem processReleaseOfInformationRequest(
 			gov.va.med.imaging.StudyURN[] studyUrns
 		 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<gov.va.med.imaging.roi.ROIWorkItem> command = (Command<gov.va.med.imaging.roi.ROIWorkItem>)getCommandFactory().createCommand(
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
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("ProcessReleaseOfInformationRequestCommand");
		
      
        gov.va.med.imaging.roi.ROIWorkItem commandResult = getRouter().doSynchronously(command);
				return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public gov.va.med.imaging.roi.ROIWorkItem processReleaseOfInformationRequest(
 			gov.va.med.imaging.StudyURN[] studyUrns
 		 			, gov.va.med.imaging.roi.queue.AbstractExportQueueURN exportQueueUrn
 		 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<gov.va.med.imaging.roi.ROIWorkItem> command = (Command<gov.va.med.imaging.roi.ROIWorkItem>)getCommandFactory().createCommand(
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
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("ProcessReleaseOfInformationRequestCommand");
		
      
        gov.va.med.imaging.roi.ROIWorkItem commandResult = getRouter().doSynchronously(command);
				return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public gov.va.med.imaging.roi.ROIWorkItem processReleaseOfInformationRequest(
 			gov.va.med.imaging.StudyURN[] studyUrns
 		 			, gov.va.med.imaging.roi.queue.AbstractExportQueueURN exportQueueUrn
 		 			, java.util.List<gov.va.med.imaging.roi.CCPHeader> ccpHeaders
 		 			, java.lang.String includeNonDicom
 		 			, java.lang.String includeReport
 		 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<gov.va.med.imaging.roi.ROIWorkItem> command = (Command<gov.va.med.imaging.roi.ROIWorkItem>)getCommandFactory().createCommand(
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
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("ProcessReleaseOfInformationRequestCommand");
		
      
        gov.va.med.imaging.roi.ROIWorkItem commandResult = getRouter().doSynchronously(command);
				return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public gov.va.med.imaging.roi.ROIWorkItem getRoiRequest(
 			java.lang.String guid
 		 			, boolean includeExtendedInformation
 		 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<gov.va.med.imaging.roi.ROIWorkItem> command = (Command<gov.va.med.imaging.roi.ROIWorkItem>)getCommandFactory().createCommand(
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
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("GetROIWorkItemByGuidCommand");
		
      
        gov.va.med.imaging.roi.ROIWorkItem commandResult = getRouter().doSynchronously(command);
				return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.util.List<gov.va.med.imaging.exchange.business.WorkItem> getActiveROIRequests(
 ) 
 		throws MethodException, ConnectionException
 		{
 			Command<java.util.List> command = getCommandFactory().createCollectionCommand(
 				 java.util.List.class, 
 				 gov.va.med.imaging.exchange.business.WorkItem.class, 
 				"GetActiveROIRequestWorkItemsCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);	  		  		
  		
			gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
			  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
			//transactionContext.setCommandClassName("GetActiveROIRequestWorkItemsCommand");
		
      
			java.util.List<gov.va.med.imaging.exchange.business.WorkItem> commandResult = getRouter().doSynchronously(command);
			return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void processROIPeriodicRequests(
 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<java.lang.Void> command = (Command<java.lang.Void>)getCommandFactory().createCommand(
	 				 java.lang.Void.class, 
	 				"ProcessROIPeriodicRequestsSyncCommand",
	 				"",
 					new Class<?>[]{
				 		  
		  			},
 					new Object[]{
				 		
		  			}
		  		);
		  		
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("ProcessROIPeriodicRequestsSyncCommand");
		
		      
		        getRouter().doSynchronously(command);
				return;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.lang.Boolean postROIChangeWorkItemStatus(
 			java.lang.String guid
 		 			, gov.va.med.imaging.roi.ROIStatus newStatus
 		 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<java.lang.Boolean> command = (Command<java.lang.Boolean>)getCommandFactory().createCommand(
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
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("PostROIChangeWorkItemStatusCommand");
		
      
        java.lang.Boolean commandResult = getRouter().doSynchronously(command);
				return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.io.InputStream getROIDisclosure(
 			gov.va.med.PatientIdentifier patientIdentifier
 		 			, gov.va.med.imaging.GUID guid
 		 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<java.io.InputStream> command = (Command<java.io.InputStream>)getCommandFactory().createCommand(
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
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("GetROIDisclosureByGuidCommand");
		
      
        java.io.InputStream commandResult = getRouter().doSynchronously(command);
				return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public void processOldUnfinishedROIRequests(
 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<java.lang.Void> command = (Command<java.lang.Void>)getCommandFactory().createCommand(
	 				 java.lang.Void.class, 
	 				"ProcessOldUnfinishedROIRequestsCommand",
	 				"",
 					new Class<?>[]{
				 		  
		  			},
 					new Object[]{
				 		
		  			}
		  		);
		  		
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("ProcessOldUnfinishedROIRequestsCommand");
		
		      
		        getRouter().doSynchronously(command);
				return;
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
 		throws MethodException, ConnectionException
 		{
	 			Command<java.lang.Void> command = (Command<java.lang.Void>)getCommandFactory().createCommand(
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
		  		
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("ProcessROIWorkItemSyncCommand");
		
		      
		        getRouter().doSynchronously(command);
				return;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.util.List<gov.va.med.imaging.roi.queue.DicomExportQueue> getDicomExportQueues(
 ) 
 		throws MethodException, ConnectionException
 		{
 			Command<java.util.List> command = getCommandFactory().createCollectionCommand(
 				 java.util.List.class, 
 				 gov.va.med.imaging.roi.queue.DicomExportQueue.class, 
 				"GetDicomExportQueueListCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);	  		  		
  		
			gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
			  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
			//transactionContext.setCommandClassName("GetDicomExportQueueListCommand");
		
      
			java.util.List<gov.va.med.imaging.roi.queue.DicomExportQueue> commandResult = getRouter().doSynchronously(command);
			return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.util.List<gov.va.med.imaging.roi.queue.DicomExportQueue> getDicomCcpExportQueues(
 ) 
 		throws MethodException, ConnectionException
 		{
 			Command<java.util.List> command = getCommandFactory().createCollectionCommand(
 				 java.util.List.class, 
 				 gov.va.med.imaging.roi.queue.DicomExportQueue.class, 
 				"GetDicomCcpExportQueueListCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);	  		  		
  		
			gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
			  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
			//transactionContext.setCommandClassName("GetDicomCcpExportQueueListCommand");
		
      
			java.util.List<gov.va.med.imaging.roi.queue.DicomExportQueue> commandResult = getRouter().doSynchronously(command);
			return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.util.List<gov.va.med.imaging.roi.queue.NonDicomExportQueue> getNonDicomExportQueues(
 ) 
 		throws MethodException, ConnectionException
 		{
 			Command<java.util.List> command = getCommandFactory().createCollectionCommand(
 				 java.util.List.class, 
 				 gov.va.med.imaging.roi.queue.NonDicomExportQueue.class, 
 				"GetNonDicomExportQueueListCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);	  		  		
  		
			gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
			  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
			//transactionContext.setCommandClassName("GetNonDicomExportQueueListCommand");
		
      
			java.util.List<gov.va.med.imaging.roi.queue.NonDicomExportQueue> commandResult = getRouter().doSynchronously(command);
			return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.lang.Boolean cancelROIWorkItem(
 			java.lang.String guid
 		 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<java.lang.Boolean> command = (Command<java.lang.Boolean>)getCommandFactory().createCommand(
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
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("PostROICancelWorkItemCommand");
		
      
        java.lang.Boolean commandResult = getRouter().doSynchronously(command);
				return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.util.List<gov.va.med.imaging.exchange.business.WorkItem> getUserROIRequests(
 ) 
 		throws MethodException, ConnectionException
 		{
 			Command<java.util.List> command = getCommandFactory().createCollectionCommand(
 				 java.util.List.class, 
 				 gov.va.med.imaging.exchange.business.WorkItem.class, 
 				"GetROIWorkItemsByUserCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);	  		  		
  		
			gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
			  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
			//transactionContext.setCommandClassName("GetROIWorkItemsByUserCommand");
		
      
			java.util.List<gov.va.med.imaging.exchange.business.WorkItem> commandResult = getRouter().doSynchronously(command);
			return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.lang.Boolean deleteUserROIWorkItems(
 ) 
 		throws MethodException, ConnectionException
 		{
	 			Command<java.lang.Boolean> command = (Command<java.lang.Boolean>)getCommandFactory().createCommand(
	 				 java.lang.Boolean.class, 
	 				"DeleteROIWorkItemsByUserCommand",
	 				"",
 					new Class<?>[]{
				 		  
		  			},
 					new Object[]{
				 		
		  			}
		  		);
				gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
				  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
				//transactionContext.setCommandClassName("DeleteROIWorkItemsByUserCommand");
		
      
        java.lang.Boolean commandResult = getRouter().doSynchronously(command);
				return commandResult;
 		}

 		 	/*
 	* Generated method, modifications will be overwritten when project is built
 	*
 	* The template for this method may be found in FacadeRouterSynchronousCollectionMethodImpl.ftl
 	*/
 	@SuppressWarnings("unchecked")
 	public java.util.List<java.lang.String> getCommunityCareProviders(
 ) 
 		throws MethodException, ConnectionException
 		{
 			Command<java.util.List> command = getCommandFactory().createCollectionCommand(
 				 java.util.List.class, 
 				 java.lang.String.class, 
 				"GetROICommunityCareProvidersCommand",
 				"",
				new Class<?>[]{
				 	 
	  			},
				new Object[]{
			 		
	  			}
	  		);	  		  		
  		
			gov.va.med.imaging.transactioncontext.TransactionContext transactionContext =
			  gov.va.med.imaging.transactioncontext.TransactionContextFactory.get();
			//transactionContext.setCommandClassName("GetROICommunityCareProvidersCommand");
		
      
			java.util.List<java.lang.String> commandResult = getRouter().doSynchronously(command);
			return commandResult;
 		}

 }