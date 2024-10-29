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
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.storage.StorageBusinessRouter;
import gov.va.med.imaging.core.router.storage.StorageContext;
import gov.va.med.imaging.core.router.storage.StorageDataSourceRouter;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.spring.SpringContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomReconstitutionException;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomUtilitiesTGAFileException;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomUtilitiesTextFileException;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomUtilitiesTextFileExtractionException;
import gov.va.med.imaging.dicom.utilities.reconstitution.interfaces.IDicomReconstitution;
import gov.va.med.imaging.exchange.business.dicom.DicomInstanceUpdateInfo;
import gov.va.med.imaging.exchange.business.dicom.InstanceStorageInfo;
import gov.va.med.imaging.exchange.business.storage.ArtifactSourceInfo;
import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;

import java.io.IOException;
import java.io.InputStream;

import gov.va.med.logging.Logger;

/**
 * This Router command creates a VistA Imaging Dicom Dataset object.  The VistA HIS updates, containing
 * changes to the Patient/Study information is fetched from the Data Source.  The necessary DICOM objects
 * are fetched via streams.  
 * 
 * If the object is saved as a DICOM Object Part10 file, a VI DICOM Dataset object is created and 
 * the Patient/Study information is update in the VI DICOM Dataset object.  
 * 
 * If the object is saved as a .TGA file, the .tga and .txt files are reconstituted together to recreate
 * a VI DICOM Dataset object.  The VI DICOM Dataset object is updated with the Patient/Study information.
 *  
 * 
 * @author vhaiswpeterb
 *
 */
public class GetDicomDataSetCommandImpl 
extends AbstractDicomCommandImpl<IDicomDataSet> {

	private static final long serialVersionUID = -1142213180361233430L;
	private static Logger logger = Logger.getLogger(GetDicomDataSetCommandImpl.class);
    private static final InternalDicomRouter internalrouter = InternalDicomContext.getRouter();

	private InstanceStorageInfo instanceInfo = null;

	
	public GetDicomDataSetCommandImpl(InstanceStorageInfo instance) {
		this.instanceInfo = instance;
	}

	@Override
	public IDicomDataSet callSynchronouslyInTransactionContext()
			throws ConnectionException, MethodException {
		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router Command {}", Thread.currentThread().getId(), this.getClass().getName());}
		
		IDicomDataSet dds = null;
		IDicomReconstitution reconstitutor = (IDicomReconstitution)SpringContext.getContext().getBean("Reconstitution");
		StorageBusinessRouter storageRouter = StorageContext.getBusinessRouter();
		//Using the objectIndentifier, call GetDicomInstanceUpdateInfo router command.
		//	This will return various tags with updated information from VistA HIS.
		DicomInstanceUpdateInfo hisChanges = internalrouter.getDicomInstanceUpdateInfo(this.instanceInfo);
		
		//Determine if Instance is .tga or .dcm.
		//IF .dcm, request it from Storage API to get stream.  Take the stream and
		//	create a IDicomDataSet object to return.
		String type = this.instanceInfo.getType();
		String identifier= null;
		if(type.equals("NEW")){
			//Get the one stream necessary.
			identifier = this.instanceInfo.getArtifactKey();
			ArtifactSourceInfo artifact = new ArtifactSourceInfo(type, identifier, 
					this.instanceInfo.getNetworkIENUsername(), 
					this.instanceInfo.getNetworkIENPassword());
			InputStream dcmStream = storageRouter.getResolvedArtifactStream(artifact);
			SizedInputStream sizedDCMStream = null;
			
			// Fortify change: reworked try/catch and added finally block to close streams
			try {
				sizedDCMStream = new SizedInputStream(dcmStream, dcmStream.available());
				dds = reconstitutor.updateDicomObject(sizedDCMStream, hisChanges);
				dds.setName(identifier);
			} catch(IOException ioX) {
                logger.error("{}: Failed to get DCM stream length.\n{}", this.getClass().getName(), ioX.getMessage());
				return null;
			} catch (GenericDicomReconstitutionException gdrX) {
	            logger.error(gdrX.getMessage());
                logger.error("{}: Exception thrown updating DICOM Object with HIS changes.", this.getClass().getName());
	            throw new MethodException(gdrX);
			} finally {
				try { if(dcmStream != null) { dcmStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
				try { if(sizedDCMStream != null) { sizedDCMStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}									
			}
		}
		else if(type.equals("OLD")) {
			//I had to add this because the M RPC was not getting the correct/valid information.  Username and Password
			//	must come from the Imaging Site Parameters, not Network Location.
			StorageDataSourceRouter dataRouter = StorageContext.getDataSourceRouter();
			NetworkLocationInfo nwl = dataRouter.getNetworkLocationDetails(this.instanceInfo.getNetworkIEN());
			this.instanceInfo.setNetworkIENUsername(nwl.getUsername());
			this.instanceInfo.setNetworkIENPassword(nwl.getPassword());

			identifier = this.instanceInfo.getObjectIdentifier();
			if(this.instanceInfo.getObjectStorageIdentifier().endsWith(".DCM")){
				//Get the one stream necessary.
				ArtifactSourceInfo artifact = new ArtifactSourceInfo(type,
						this.instanceInfo.getObjectStorageIdentifier(), 
						this.instanceInfo.getNetworkIENUsername(), 
						this.instanceInfo.getNetworkIENPassword());
				InputStream dcmStream = storageRouter.getResolvedArtifactStream(artifact);
				//CSABA -I don't need a sized stream. Not reading bytes.  What should be the default bytesize?
				SizedInputStream sizedDCMStream = null;
				
				// Fortify change: reworked try/catch and added finally block to close streams
				try {
					sizedDCMStream = new SizedInputStream(dcmStream, dcmStream.available());
					dds = reconstitutor.updateDicomObject(sizedDCMStream, hisChanges);
					dds.setName(identifier);
				} catch(IOException ioX){
                    logger.error("{}: Failed to get DCM stream length.\n{}", this.getClass().getName(), ioX.getMessage());
					return null;
				} catch (GenericDicomReconstitutionException gdrX){
		            logger.error(gdrX.getMessage());
                    logger.error("{}: Exception thrown updating DICOM Object with HIS changes.", this.getClass().getName());
		            throw new MethodException(gdrX);
				} finally {
					try { if(dcmStream != null) { dcmStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
					try { if(sizedDCMStream != null) { sizedDCMStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}					
				}
			}
			
			//IF .tga, request both .tga and .txt from Storage API to get two streams.
				//Take the two streams and RECONSTITUTE into a IDicomDataSet object.
			//P116 - Modify to accept .tga and .big independent of case sensitivity.
			if((this.instanceInfo.getObjectStorageIdentifier().endsWith(".TGA")) 
					|| (this.instanceInfo.getObjectStorageIdentifier().endsWith(".BIG"))) {
				//Get the two streams necessary.
				ArtifactSourceInfo tgaArtifact = new ArtifactSourceInfo(type,
						this.instanceInfo.getObjectStorageIdentifier(),
						this.instanceInfo.getNetworkIENUsername(), 
						this.instanceInfo.getNetworkIENPassword());
				InputStream tgaStream = storageRouter.getResolvedArtifactStream(tgaArtifact);
				SizedInputStream sizedTGAStream = null;
				
				// Fortify change: added finally block to close streams
				try {
					sizedTGAStream = new SizedInputStream(tgaStream, tgaStream.available());
				} catch(IOException ioX) {
                    logger.error("{}: Failed to get TGA stream length.\n{}", this.getClass().getName(), ioX.getMessage());
					return null;
				} finally {
					try { if(tgaStream != null) { tgaStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
					try { if(sizedTGAStream != null) { sizedTGAStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
				}
				
				ArtifactSourceInfo txtArtifact = new ArtifactSourceInfo(type, 
							this.instanceInfo.getObjectSupportedTextStorageIdentifier(),
							this.instanceInfo.getNetworkIENUsername(), 
							this.instanceInfo.getNetworkIENPassword());
				
				InputStream txtStream = storageRouter.getResolvedArtifactStream(txtArtifact);
				SizedInputStream sizedTXTStream = null;
				
				// Fortify change: reworked try/catch and added finally block to close streams
				try {
					sizedTXTStream = new SizedInputStream(txtStream, txtStream.available());
					dds = reconstitutor.assembleDicomObject(sizedTXTStream, sizedTGAStream, hisChanges);
					dds.setName(identifier);
				} catch(IOException ioX) {
                    logger.error("{}: Failed to get TXT stream length.\n{}", this.getClass().getName(), ioX.getMessage());
					return null;
				} catch (GenericDicomUtilitiesTextFileException gdutfX) {
		            logger.error(gdutfX.getMessage());
                    logger.error("{}: Exception thrown during reconsititution of DICOM Object while accessing Text file.", this.getClass().getName());
		            throw new MethodException(gdutfX);
				} catch (GenericDicomUtilitiesTextFileExtractionException gdutfeX) {
		            logger.error(gdutfeX.getMessage());
                    logger.error("{}: Exception thrown during reconsititution of DICOM Object while extracting Text file.", this.getClass().getName());
		            throw new MethodException(gdutfeX);
				} catch (GenericDicomUtilitiesTGAFileException gdutgafX) {
		            logger.error(gdutgafX.getMessage());
                    logger.error("{}: Exception thrown during reconsititution of DICOM Object while accessing TGA file.", this.getClass().getName());
		            throw new MethodException(gdutgafX);
				} finally {
					try { if(txtStream != null) { txtStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
					try { if(sizedTXTStream != null) { sizedTXTStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
				}
			} else {
			throw new MethodException("Artifact location is unknown.");
			}
		}
		
		//Return the IDicomDataSet object.
		return dds;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	protected String parameterToString() {
		// TODO Auto-generated method stub
		return null;
	}
}
