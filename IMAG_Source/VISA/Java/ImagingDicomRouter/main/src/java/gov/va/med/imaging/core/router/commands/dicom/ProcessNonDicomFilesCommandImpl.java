/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: 
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswpeterb
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

package gov.va.med.imaging.core.router.commands.dicom;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.commands.AbstractDicomCommandImpl;
import gov.va.med.imaging.core.router.storage.StorageContext;
import gov.va.med.imaging.core.router.storage.StorageDataSourceRouter;
import gov.va.med.imaging.dicom.DicomContext;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.Part10Files;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.DicomStorageResults;
import gov.va.med.imaging.exchange.business.dicom.DicomUid;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.NonDicomFile;
import gov.va.med.imaging.exchange.business.dicom.importer.Order;
import gov.va.med.imaging.exchange.business.dicom.importer.Reconciliation;
import gov.va.med.imaging.exchange.business.dicom.importer.Series;
import gov.va.med.imaging.exchange.business.dicom.importer.Study;
import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;
import gov.va.med.imaging.utils.ExceptionUtilities;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Iterator;

import gov.va.med.logging.Logger;

import com.lbs.DCS.DCM;
import com.lbs.DCS.DCSException;
import com.lbs.DCS.DicomDataSet;
import com.lbs.DCS.DicomFileInput;
import com.lbs.DCS.DicomFileOutput;
import com.lbs.DCS.DicomOBElement;
import com.lbs.DCS.UID;

@RouterCommandExecution(asynchronous = true, distributable = false)
public class ProcessNonDicomFilesCommandImpl extends
		AbstractDicomCommandImpl<Boolean> {

	private static final long serialVersionUID = -6437742324303531927L;
	private final String studyUid;
	private final ImporterWorkItem importerWorkItem;
	private final Reconciliation reconciliation;
	private final InstrumentConfig instrumentConfig;
	private final Patient patient;
	private final Study study;
	private final Order order;
	
	private NetworkLocationInfo networkLocationInfo;
	private StorageCredentials storageCredentials;
	SmbStorageUtility smbStorageUtility;

	
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
    private static final InternalDicomRouter router = InternalDicomContext.getRouter();	
    private static final StorageDataSourceRouter storageRouter = StorageContext.getDataSourceRouter();	
    
	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * @param router
	 * @param asynchronousMethodProcessor
	 */
	public ProcessNonDicomFilesCommandImpl(
			String studyUid,
			ImporterWorkItem importerWorkItem,
			Reconciliation reconciliation, 
			InstrumentConfig instrumentConfig)
	{
		super();
		this.studyUid = studyUid;
		this.importerWorkItem = importerWorkItem;
		this.reconciliation = reconciliation;
		this.instrumentConfig = instrumentConfig;
		
		this.patient = reconciliation.getPatient();
		this.order = reconciliation.getOrder();
		this.study = reconciliation.getStudy();
		
	}

	@Override
	public Boolean callSynchronouslyInTransactionContext() throws MethodException, ConnectionException 
	{
		// If there are no Non-DICOM files, just return
		if (getReconciliation().getNonDicomFiles() == null)
		{
			return true;
		}
		
		// Set up network objects
		String networkLocationIen = Integer.toString(importerWorkItem.getWorkItemDetailsReference().getNetworkLocationIen());
		networkLocationInfo = StorageContext.getDataSourceRouter().getNetworkLocationDetails(networkLocationIen);
		storageCredentials = (StorageCredentials)networkLocationInfo;
		smbStorageUtility = new SmbStorageUtility();
		
		// Get the local working directory
		String localWorkingDirectory = getLocalWorkingDirectory();

		// Create a new Series UID
		DicomUid dicomUid = router.getDicomUid(order.getAccessionNumber(), 
				DicomServerConfiguration.getConfiguration().getSiteId(), 
				IMPORTER_INSTRUMENT, 
				SERIES_UID_TYPE);
		
		String seriesUid = dicomUid.getValue();

		String sopInstanceUid = "";
		
		
		for (Iterator<NonDicomFile> nonDicomFileIterator = getReconciliation().getNonDicomFiles().iterator(); nonDicomFileIterator.hasNext();)
		{
			NonDicomFile nonDicomFile = nonDicomFileIterator.next();
			
			DicomFileInput dicomFileHandle = null;
			IDicomDataSet dds = null;

			try
			{
				// Create a new SOP Instance UID (making sure it's not a duplicate of the previous one...
				sopInstanceUid = getNewSopInstanceUid(sopInstanceUid);
				if(logger.isDebugEnabled()){
                    logger.debug("Newly created SOP Instance UID = {}", sopInstanceUid);}

				// Get the file names
				String stagedPath = getStagedPath(networkLocationInfo, nonDicomFile);
				String localNonDicomFilePath = getLocalNonDicomFilePath(localWorkingDirectory, nonDicomFile);
				String localDicomFilePath = getLocalDicomFilePath(localNonDicomFilePath);
	
				// Copy the file to a local temp directory
				if(logger.isDebugEnabled()){
                    logger.debug("Copying Non-DICOM file to local path: {}", localNonDicomFilePath);}
				copyFileToLocalStorage(stagedPath, localNonDicomFilePath);
				
				// Convert the local file to DICOM
				if(logger.isDebugEnabled()){logger.debug("Converting the local non-DICOM file to DICOM, and sending it to the HDIG for import.");}
				convertNonDicomFileToDicom(localNonDicomFilePath, localDicomFilePath, seriesUid, sopInstanceUid);
				
				// Open the DICOM file
				dds = Part10Files.readLocalDicomFile(localDicomFilePath, dicomFileHandle);
				
				String aet = dds.getSourceAET();
				DicomAE dicomAE = DicomContext.getRouter().getRemoteAE(DicomAE.searchMode.REMOTE_AE, aet, config.getSiteId());

				//Pass to the PostDicomInstance command.
	    		DicomStorageResults results = router.postDicomInstance(dds, dicomAE, instrumentConfig, 
	    				null, 0, true, study.getOriginIndex());
				
				// Clean up: delete the staged file, local files, and NonDicomFile instance
				deleteStagedNonDicomFile(stagedPath);
				deleteLocalTempFiles(localNonDicomFilePath, localDicomFilePath);
				nonDicomFileIterator.remove();
			}
			catch(Exception e)
			{
				storeAndLogImportException(nonDicomFile, e);
			}
			finally
			{
				if (dicomFileHandle != null)
				{
					try
					{
						dicomFileHandle.close(true);
					}
					catch(DCSException e)
					{
						logger.error("Failed to close DICOM object file", e);
					}
				}
			}
		}
		
		// Delete the local staging root directory
        // Fortify change: added string cleaning and changing to deployed destination file separator     
		delete(new File(StringUtil.toSystemFileSeparator(StringUtil.cleanString(localWorkingDirectory))));
		
		logger.info("Finished processing Non-DICOM files.");
		return true;
		
	}
	
	private void storeAndLogImportException(NonDicomFile nonDicomFile, Exception e) 
	{
		String errorMessage = e.getMessage() + "\n" + ExceptionUtilities.convertExceptionToString(e); 
		nonDicomFile.setImportErrorMessage(errorMessage);
		nonDicomFile.setImportedSuccessfully(false);
		logger.error(errorMessage, e);
	}


	/**
	 * @param sopInstanceUid
	 * @return
	 * @throws ConnectionException 
	 * @throws MethodException 
	 */
	private String getNewSopInstanceUid(String previousSopInstanceUid) throws MethodException, ConnectionException 
	{
		DicomUid dicomUid = router.getDicomUid(order.getAccessionNumber(), 
				DicomServerConfiguration.getConfiguration().getSiteId(), 
				IMPORTER_INSTRUMENT, 
				SOP_INSTANCE_UID_TYPE);
		
		String newSopInstanceUid = dicomUid.getValue();
		
		if(!newSopInstanceUid.equals(previousSopInstanceUid))
		{
			return newSopInstanceUid;
		}
		else
		{
			// If the generated sop instance uid is the same as the previous one, sleep for a second and call the
			// M routine again. It will generate duplicates if it is called more than once in a single second.
			try 
			{
				Thread.sleep(1000);
				
			} 
			catch (InterruptedException e) 
			{
				logger.info(e);
			}
			
			return getNewSopInstanceUid(previousSopInstanceUid);
		}
	}

	private void convertNonDicomFileToDicom(String localNonDicomFilePath, String localDicomFilePath, String seriesUid, String sopInstanceUid) 
	{
		FileInputStream fis = null;
        DicomFileOutput dfo = null;

        try
        {
        	byte[] bytes;

            DicomDataSet dds = new DicomDataSet();
            
         // Fortify change: added string cleaning and changing to deployed destination file separator
            File file = new File(StringUtil.toSystemFileSeparator(StringUtil.cleanString(localNonDicomFilePath)));
            
            long pdf_file_length = file.length();
            fis = new FileInputStream( file );

            //if true it's even length
            if ((pdf_file_length & 1) == 0)
            {
                bytes = new byte[(int)pdf_file_length];
            }
            else
            {
                //it's ok to pad .pdf data with a null.
                bytes = new byte[(int)pdf_file_length + 1];
            }
            
            fis.read(bytes, 0, (int) pdf_file_length);
            
            DicomOBElement encap_doc_e = new DicomOBElement(DCM.E_ENCAPSULATED_DOCUMENT, bytes);

            dds.insert(encap_doc_e);
            dds.insert(DCM.E_SOPCLASS_UID, UID.ENCAPSULATED_PDF_STORAGE);
            dds.insert(DCM.E_STUDY_INSTANCE_UID, studyUid);
            dds.insert(DCM.E_SERIES_INSTANCE_UID, seriesUid);
            dds.insert(DCM.E_SOPINSTANCE_UID, sopInstanceUid);
            dds.insert(DCM.E_PATIENTS_NAME, patient.getPatientName());
            dds.insert(DCM.E_PATIENTS_SEX, patient.getPatientSex().toDicomString());
            dds.insert(DCM.E_PATIENT_ID, patient.getSsn());
            dds.insert(DCM.E_PATIENTS_BIRTH_DATE,patient.getDob().toString());
            dds.insert(DCM.E_ACCESSION_NUMBER, order.getAccessionNumber());
            dds.insert(DCM.E_MODALITY, "DOC");
            dds.insert(DCM.E_CONVERSION_TYPE, "SD");
            dds.insert(DCM.E_MIME_TYPE_ENCAPSULATED_DOCUMENT, "application/pdf");
            
            // Fortify change: added string cleaning and changing to deployed destination file separator 
            // Not on list but did it anyway
            dfo = new DicomFileOutput(StringUtil.toSystemFileSeparator(StringUtil.cleanString(localDicomFilePath)), UID.TRANSFERLITTLEENDIANEXPLICIT, true);
            
            dfo.writeDataSet(dds);
        }
        catch (Exception e)
        {
            logger.error(e.getMessage(), e);
        }
        finally
        {
            try
            {
                if( dfo != null)
                    dfo.close();
                if( fis != null )
                    fis.close();
            }
            catch( Exception e )
            {
	            logger.error(e.getMessage(), e);
            }
        }
	}

	
	private void delete(File file) 
	{
		if (file.isDirectory()) 
		{
			for (File child : file.listFiles())
			{
				delete(child);
			}
		}

		file.delete();
	}

	private void deleteLocalTempFiles(String localNonDicomFilePath, String localDicomFilePath) {
		
		// Fortify change: added string cleaning and changing to deployed destination file separator
		File localNonDicomFile = new File(StringUtil.toSystemFileSeparator(StringUtil.cleanString(localNonDicomFilePath)));
		localNonDicomFile.delete();
		
		// Fortify change: added string cleaning and changing to deployed destination file separator
		File localDicomFile = new File(StringUtil.toSystemFileSeparator(StringUtil.cleanString(localDicomFilePath)));
		localDicomFile.delete();
	}

	private void deleteStagedNonDicomFile(String stagedPath) throws IOException 
	{
		try 
		{
            // Fortify change: added string cleaning and changing to deployed destination file separator 
            // Not on list but did it anyway
			smbStorageUtility.deleteFile(StringUtil.toSystemFileSeparator(StringUtil.cleanString(stagedPath)), storageCredentials);
		} 
		catch (Exception e) 
		{
            logger.warn("Error deleting staged file [{}]: {}", stagedPath, e.getStackTrace());
		}
	}
		
	private void copyFileToLocalStorage(String stagedPath, String localNonDicomFilePath) throws MethodException, ConnectionException
	{
		try 
		{
            // Fortify change: added string cleaning and changing to deployed destination file separator 
            // Not on list but did it anyway
			String tmpStagedPath = StringUtil.toSystemFileSeparator(StringUtil.cleanString(stagedPath));
			String tmpLocalNonDicomFilePath = StringUtil.toSystemFileSeparator(StringUtil.cleanString(localNonDicomFilePath));
			smbStorageUtility.copyRemoteFileToLocalFile(tmpStagedPath, tmpLocalNonDicomFilePath, storageCredentials);
		} 
		catch (IOException e) 
		{
            logger.error("Error moving file [{}] to [{}]: {}", stagedPath, localNonDicomFilePath, e.getStackTrace());
			throw new MethodException(e);
		}
	
	}
	
	private String getStagedPath(NetworkLocationInfo networkLocationInfo, NonDicomFile nonDicomFile) throws MethodException, ConnectionException
	{
		// Get the server path
		String serverPath = networkLocationInfo.getPhysicalPath();
		if (!serverPath.endsWith("\\"))
		{
			serverPath += "\\";
		}
			
		// Get the media bundle path
		String mediaBundleStagingRootDirectory = importerWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory();
		if (!mediaBundleStagingRootDirectory.endsWith("\\"))
		{
			mediaBundleStagingRootDirectory += "\\";
		}
		
		// Build the full server path
		return serverPath + mediaBundleStagingRootDirectory + "NonDicom\\" + nonDicomFile.getName(); 

	}

	private String getLocalWorkingDirectory()
	{
		String localWorkingDirectory = DicomServerConfiguration.getConfiguration().getDicomCorrectFolder();
		if (!localWorkingDirectory.endsWith("\\"))
		{
			localWorkingDirectory += "\\";
		}
		
		localWorkingDirectory += importerWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory();
		if (!localWorkingDirectory.endsWith("\\"))
		{
			localWorkingDirectory += "\\";
		}
		
		return localWorkingDirectory;
	}

	private String getLocalNonDicomFilePath(String localWorkingDirectory, NonDicomFile nonDicomFile)
	{

		String localNonDicomFilePath = localWorkingDirectory + nonDicomFile.getName();
		return localNonDicomFilePath;
	}
	
	private String getLocalDicomFilePath(String localNonDicomFilePath)
	{
		return localNonDicomFilePath + ".dcm";
	}

	/**
	 * @return the reconciliation
	 */
	public Reconciliation getReconciliation() {
		return reconciliation;
	}

	@Override
	protected String parameterToString() {
		return "";
	}
	
	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}

	/**
	 * @return the instrumentConfig
	 */
	public InstrumentConfig getInstrumentConfig() {
		return instrumentConfig;
	}

	/**
	 * @return the studyUid
	 */
	public String getStudyUid() {
		return studyUid;
	}


}
