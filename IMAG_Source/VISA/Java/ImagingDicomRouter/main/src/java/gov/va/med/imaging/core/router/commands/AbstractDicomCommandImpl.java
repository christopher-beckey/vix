/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.datasource.DicomApplicationEntityDataSourceSpi;
import gov.va.med.imaging.datasource.DicomDataSourceSpi;
import gov.va.med.imaging.datasource.DicomImporterDataSourceSpi;
import gov.va.med.imaging.datasource.DicomQueryRetrieveDataSourceSpi;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.exchange.business.dicom.exceptions.DicomException;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemDetails;
import gov.va.med.imaging.exchange.business.dicom.importer.SopInstance;
import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;
import gov.va.med.imaging.router.commands.dicom.provider.DicomCommandContext;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;

import java.io.IOException;

import gov.va.med.logging.Logger;

import com.thoughtworks.xstream.XStreamException;

/**
 * An abstract superclass of Exam-related commands, grouped because there is significant
 * overlap in the Exam commands that is contained here.
 * 
 * @author vhaiswlouthj
 *
 */
public abstract class AbstractDicomCommandImpl<R extends Object> 
extends AbstractCommandImpl<R>
{
	protected static final String originalAttributeSequenceTag = "0400,0561";
    private static Logger logger = Logger.getLogger(AbstractDicomCommandImpl.class);

    protected static final String IMPORTER_INSTRUMENT = "IMPORTER";
    protected static final String STUDY_UID_TYPE = "STUDY";
    protected static final String SERIES_UID_TYPE = "SERIES";
    protected static final String SOP_INSTANCE_UID_TYPE = "SOP";
    
	/**
	 * @param commandContext - the context available to the command
	 */
	public AbstractDicomCommandImpl()
	{
		super();
	}
	
	protected void insertToOriginalAttributeSequence(IDicomDataSet dds, String tagInSeq, String tagValue, String context) {
		try {
			dds.insertDicomElement(originalAttributeSequenceTag, tagInSeq, tagValue);
		} catch (DicomException de) {
			// do high level log only, Detailed Error logged on lower level
            logger.error("Inserting ({}) with UID {} to Original Attribute sequence Failed {}", tagInSeq, tagValue, context);
		}
	}

	@Override
	public boolean equals(Object obj)
	{
		// Check objectEquivalence
		if (this == obj)
		{
			return true;
		}
		
		// Check that classes match
		if (getClass() != obj.getClass())
		{
			return false;
		}
		
		return areClassSpecificFieldsEqual(obj);
		
	}

	protected abstract boolean areClassSpecificFieldsEqual(Object obj);

	public boolean areFieldsEqual(Object field1, Object field2)
	{
		// Check the study URN
		if (field1 == null)
		{
			if (field2 != null)
			{
				return false;
			}
		} 
		else if (!field1.equals(field2))
		{
			return false;
		}
		
		return true;
	}
	
	protected DicomStorageDataSourceSpi getDicomStorageService()
	{
		return ((DicomCommandContext)getCommandContext()).getDicomStorageService();
	}

	protected DicomDataSourceSpi getDicomService()
	{
		return ((DicomCommandContext)getCommandContext()).getDicomService();
	}
	
	protected DicomApplicationEntityDataSourceSpi getDicomApplicationEntityService()
	{
		return ((DicomCommandContext)getCommandContext()).getDicomApplicationEntityService();
	}
	
	protected DicomImporterDataSourceSpi getDicomImporterService()
	{
		return ((DicomCommandContext)getCommandContext()).getDicomImporterService();
	}
	
	protected DicomQueryRetrieveDataSourceSpi getDicomQueryRetrieveService()
	{
		return ((DicomCommandContext)getCommandContext()).getDicomQueryRetrieveService();
	}
	
	
	protected static String getServerPath(NetworkLocationInfo networkLocationInfo) 
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


	protected static String getMediaBundleRootPath(String mediaBundleStagingRootDirectory) 
	{
		// Get the media bundle path
		if (!mediaBundleStagingRootDirectory.endsWith("\\"))
		{
			mediaBundleStagingRootDirectory += "\\";
		}
		return mediaBundleStagingRootDirectory; 		
	}
	
	protected String getInstancePath(NetworkLocationInfo networkLocationInfo,
			String mediaBundleStagingRootDirectory, 
		    SopInstance instance) 
	throws MethodException, ConnectionException 
	{
		String fullPath = getMediaBundlePath(networkLocationInfo, mediaBundleStagingRootDirectory) + instance.getFilePath();
		fullPath = "\\" + fullPath.replace("\\\\", "\\");

		return fullPath;
	}

	protected static String getMediaBundlePath(NetworkLocationInfo networkLocationInfo,
			String mediaBundleStagingRootDirectory) 
	throws MethodException, ConnectionException 
	{
		String serverPath = getServerPath(networkLocationInfo);
		String mediaBundleRootPath = serverPath + getMediaBundleRootPath(mediaBundleStagingRootDirectory);

		return mediaBundleRootPath;
	}
	
	protected static String getWorkItemDetailsXmlPath(NetworkLocationInfo networkLocationInfo, String mediaBundleStagingRootDirectory) 
	throws MethodException, ConnectionException 
	{
		String mediaBundleRootPath = getMediaBundlePath(networkLocationInfo, mediaBundleStagingRootDirectory);
		return mediaBundleRootPath + "ImporterWorkItemDetails.xml";
	}
	
	
	protected static void writeWorkItemDetailsToDisk(NetworkLocationInfo networkLocationInfo, ImporterWorkItem importerWorkItem, String mediaBundleStagingRootDirectory) 
	throws MethodException, ConnectionException, IOException 
	{
		StorageCredentials credentials = (StorageCredentials)networkLocationInfo;
		
		String workItemDetailsXmlPath = getWorkItemDetailsXmlPath(networkLocationInfo, mediaBundleStagingRootDirectory);
		workItemDetailsXmlPath = "\\" + workItemDetailsXmlPath.replace("\\\\", "\\");

		SmbStorageUtility util = new SmbStorageUtility();
		
		// Delete the file first if it already exists: SMB can't overwrite...
		if (util.fileExists(workItemDetailsXmlPath, credentials))
		{
			if(logger.isDebugEnabled()){logger.debug("Found an existing workItemDetails file. Deleting it before replacing");}
			util.deleteFile(workItemDetailsXmlPath, credentials);
		}
		
		// Write out the udpated work item details object...
		if(logger.isDebugEnabled()){logger.debug("Writing updated workItemDetails file.");}
		util.writeStringToFile(importerWorkItem.serializeDetailsToXml(), 
							   workItemDetailsXmlPath, 
							   credentials);
		
	}
	
	protected ImporterWorkItemDetails readWorkItemDetailsFromDisk(NetworkLocationInfo networkLocationInfo, 
																	ImporterWorkItem importerWorkItem, 
																	String mediaBundleStagingRootDirectory) 
	throws MethodException, ConnectionException, IOException 
	{
		String workItemDetailsXmlPath = getWorkItemDetailsXmlPath(networkLocationInfo, mediaBundleStagingRootDirectory);
		
		SmbStorageUtility util = new SmbStorageUtility();
		String detailsXml = util.readFileAsString(workItemDetailsXmlPath, (StorageCredentials)networkLocationInfo);
		ImporterWorkItemDetails details= null;
		try{
			details = importerWorkItem.deserializeDetailsFromXml(detailsXml);
		}
		catch(XStreamException xsX){
			throw new MethodException(xsX.getMessage(), xsX);
		}
		return details;
	}

}
