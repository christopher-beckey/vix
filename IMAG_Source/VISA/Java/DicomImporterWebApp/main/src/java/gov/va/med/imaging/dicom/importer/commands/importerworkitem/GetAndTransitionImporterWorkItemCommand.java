/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 26, 2010
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
package gov.va.med.imaging.dicom.importer.commands.importerworkitem;

import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.storage.StorageContext;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.core.router.worklist.WorkListRouter;
import gov.va.med.imaging.dicom.importer.commands.AbstractDicomImporterCommand;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemDetails;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemDetailsReference;
import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;

/**
 * @author vhaiswlouthj
 *
 */
public class GetAndTransitionImporterWorkItemCommand 
extends AbstractDicomImporterCommand<WorkItem, String>
{
	private final String interfaceVersion;
	private final int workItemId;
	private final String expectedStatus;
	private final String newStatus;
	private final String updatingUser;
	private final String updatingApplication;
	
	public GetAndTransitionImporterWorkItemCommand(int workItemId, String expectedStatus, String newStatus, String updatingUser, String updatingApplication, String interfaceVersion)
	{
		super("getAndTransitionImporterWorkItemCommand");
		this.workItemId = workItemId;
		this.expectedStatus = expectedStatus;
		this.newStatus = newStatus;
		this.updatingUser = updatingUser;
		this.updatingApplication = updatingApplication;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected WorkItem executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		WorkListRouter router = WorkListContext.getRouter();		
		WorkItem workItem = router.getAndTransitionWorkItem(getWorkItemId(), getExpectedStatus(), getNewStatus(), getUpdatingUser(), getUpdatingApplication());
		setEntriesReturned(workItem == null ? 0 : 1);
		return workItem;
	}


	@Override
	public String getInterfaceVersion() 
	{
		return this.interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "";
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(WorkItem workItem) 
	throws TranslationException 
	{
		// Build the shallow work item
		ImporterWorkItem importerWorkItem = ImporterWorkItem.buildShallowImporterWorkItem(workItem);
		
		// Read the ImporterWorkItemDetails from disk
		NetworkLocationInfo networkLocationInfo = getNetworkLocationInfo(importerWorkItem);
		ImporterWorkItemDetails workItemDetails = readWorkItemDetailsFromDisk(networkLocationInfo, importerWorkItem);
		
		// Rebuild the full work item
		importerWorkItem = ImporterWorkItem.buildFullImporterWorkItem(workItem, workItemDetails);
		
    	return ImporterUtils.getXStream().toXML(importerWorkItem);
	}
	
	private NetworkLocationInfo getNetworkLocationInfo(ImporterWorkItem importerWorkItem) 
	{
		NetworkLocationInfo networkLocationInfo = null;
		try
		{
			String networkLocationIen = Integer.toString(importerWorkItem.getWorkItemDetailsReference().getNetworkLocationIen());
			networkLocationInfo = StorageContext.getDataSourceRouter().getNetworkLocationDetails(networkLocationIen);
		}
		catch (Exception e)
		{
			getLogger().warn("GetAndTransitionImporterWorkItemCommand.getNetworkLocationInfo() --> Exception: " + e.getMessage());
		}
		return networkLocationInfo;
	}

	public int getWorkItemId()
	{
		return workItemId;
	}

	public String getExpectedStatus() {
		return expectedStatus;
	}

	public String getNewStatus() {
		return newStatus;
	}

	
	protected String getServerPath(NetworkLocationInfo networkLocationInfo) 
	throws MethodException, ConnectionException 
	{
		// Get the server path
		String serverPath = networkLocationInfo.getPhysicalPath();
		if (!serverPath.endsWith("\\"))
		{
			serverPath += "\\";
		}
		
		return serverPath;
		
	}


	protected String getMediaBundleRootPath(ImporterWorkItemDetailsReference workItemDetailsReference) 
	{
		// Get the media bundle path
		String mediaBundleRootPath = workItemDetailsReference.getMediaBundleStagingRootDirectory();
		if (!mediaBundleRootPath.endsWith("\\"))
		{
			mediaBundleRootPath += "\\";
		}
		
		return mediaBundleRootPath; 
		
	}
	
	protected String getMediaBundlePath(NetworkLocationInfo networkLocationInfo,
		    							   ImporterWorkItemDetailsReference workItemDetailsReference) 
	throws MethodException, ConnectionException 
	{
		String serverPath = getServerPath(networkLocationInfo);
		String mediaBundleRootPath = serverPath + getMediaBundleRootPath(workItemDetailsReference);

		return mediaBundleRootPath;
	}
	
	protected String getWorkItemDetailsXmlPath(NetworkLocationInfo networkLocationInfo, ImporterWorkItem workItem) 
	throws MethodException, ConnectionException 
	{
		String mediaBundleRootPath = getMediaBundlePath(networkLocationInfo, workItem.getWorkItemDetailsReference());
		return mediaBundleRootPath + "ImporterWorkItemDetails.xml";
	}
	
	
	protected ImporterWorkItemDetails readWorkItemDetailsFromDisk(NetworkLocationInfo networkLocationInfo, ImporterWorkItem importerWorkItem) 
	{
		ImporterWorkItemDetails details = null;
		
		try
		{
			String workItemDetailsXmlPath = getWorkItemDetailsXmlPath(networkLocationInfo, importerWorkItem);
			
			SmbStorageUtility util = new SmbStorageUtility();
			String detailsXml = util.readFileAsString(workItemDetailsXmlPath, (StorageCredentials)networkLocationInfo);
			details = importerWorkItem.deserializeDetailsFromXml(detailsXml);
		}
		catch (Exception e)
		{
			getLogger().warn("GetAndTransitionImporterWorkItemCommand.readWorkItemDetailsFromDisk() --> Exception: " + e.getMessage());
		}
		
		return details;
	}

	public String getUpdatingUser() {
		return updatingUser;
	}

	public String getUpdatingApplication() {
		return updatingApplication;
	}
}
