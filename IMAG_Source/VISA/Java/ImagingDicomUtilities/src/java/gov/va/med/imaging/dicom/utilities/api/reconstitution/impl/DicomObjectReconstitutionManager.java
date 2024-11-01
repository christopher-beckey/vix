/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: September 26, 2005
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWPETERB
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
package gov.va.med.imaging.dicom.utilities.api.reconstitution.impl;

import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.dcftoolkit.common.impl.DicomDataSetImpl;
import gov.va.med.imaging.dicom.utilities.api.reconstitution.interfaces.DicomObjectReconstitutionFacade;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomReconstitutionException;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomUtilitiesTGAFileException;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomUtilitiesTGAFileNotFoundException;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomUtilitiesTextFileException;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomUtilitiesTextFileExtractionException;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomUtilitiesTextFileNotFoundException;
import gov.va.med.imaging.dicom.utilities.impl.BusinessDataSetImpl;
import gov.va.med.imaging.dicom.utilities.interfaces.IBusinessDataSet;
import gov.va.med.imaging.dicom.utilities.reconstitution.impl.DicomReconstitutionImpl;
import gov.va.med.imaging.dicom.utilities.reconstitution.interfaces.IDicomReconstitution;

import java.util.HashMap;

import gov.va.med.logging.Logger;

/**
 *
 * Implementation of the DicomObjectReconstitutionFacade Interface.  This is the 
 * Boundary class to reconstitute a DICOM object based on various files from the Legacy 
 * environment.
 *
 *
 * @author William Peterson
 *
 */
public class DicomObjectReconstitutionManager implements
        DicomObjectReconstitutionFacade {
    private IDicomReconstitution reconstitute = null;

    private static final Logger logger = Logger.getLogger (DicomObjectReconstitutionManager.class);

    
    /**
     * Constructor
     */
    public DicomObjectReconstitutionManager() {
        super();
        this.reconstitute = new DicomReconstitutionImpl();
    }

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.utilities.api.reconstitution.interfaces.DicomObjectReconstitutionFacade#assembleDicomObject(java.lang.String, java.lang.String, java.util.HashMap, boolean)
     */
    public IBusinessDataSet assembleDicomObject(String textFilename,
            String tgaFilename, HashMap<String, String> hisChanges)
            throws GenericDicomReconstitutionException {
        
            try{
                
                IDicomDataSet dds = new DicomDataSetImpl();
                
                dds = reconstitute.assembleDicomObject(textFilename, tgaFilename, hisChanges);
                logger.debug("Assembling DICOM Object via reconstitution with TGA file.");

                return (this.encapsulateDicomDataSet(dds));
            }
            catch(GenericDicomUtilitiesTextFileNotFoundException noText){
                logger.error(noText.getMessage());
                logger.error("{}: \nException thrown while assembling Dicom Object.", this.getClass().getName());
                throw new GenericDicomReconstitutionException(
                        "Failure to assemble Dicom Object.", noText);
            }
            catch(GenericDicomUtilitiesTextFileExtractionException extract){
                logger.error(extract.getMessage());
                logger.error("{}: \nException thrown while assembling Dicom Object.", this.getClass().getName());
                throw new GenericDicomReconstitutionException(
                        "Failure to assemble Dicom Object.", extract);
            }
            catch(GenericDicomUtilitiesTextFileException e){
                logger.error(e.getMessage());
                logger.error("{}: \nException thrown while assembling Dicom Object.", this.getClass().getName());
                throw new GenericDicomReconstitutionException(
                        "Failure to assemble Dicom Object.", e);
            }
            catch(GenericDicomUtilitiesTGAFileException e){
                logger.error(e.getMessage());
                logger.error("{}: \nException thrown while assembling Dicom Object.", this.getClass().getName());
                throw new GenericDicomReconstitutionException(
                        "Failure to assemble Dicom Object.", e);
            }
            catch(GenericDicomUtilitiesTGAFileNotFoundException e){
                logger.error(e.getMessage());
                logger.error("{}: \nException thrown while assembling Dicom Object.", this.getClass().getName());
                throw new GenericDicomReconstitutionException(
                        "Failure to assemble Dicom Object.", e);
            }   
  }

    public byte[] assembleDicomStream(SizedInputStream textStream, 
    		SizedInputStream tgaStream)
    		throws GenericDicomReconstitutionException {
        try{
            byte[] data=null;

            data = reconstitute.assembleDicomStream(textStream, tgaStream);
            logger.debug("Assembling DICOM Object via reconstitution with TGA stream.");

            return (data);
        }
        catch(GenericDicomUtilitiesTextFileNotFoundException noText){
            logger.error("Error: {}", noText.getMessage());
            logger.error("Exception thrown while assembling Dicom Object.");
            throw new GenericDicomReconstitutionException(
                    "Failure to assemble Dicom Object.", noText);
        }
        catch(GenericDicomUtilitiesTextFileExtractionException extract){
            logger.error("Error: {}", extract.getMessage());
            logger.error("Exception thrown while assembling Dicom Object.");
            throw new GenericDicomReconstitutionException(
                    "Failure to assemble Dicom Object.", extract);
        }
        catch(GenericDicomUtilitiesTextFileException e){
            logger.error("Error: {}", e.getMessage());
            logger.error("Exception thrown while assembling Dicom Object.");
            throw new GenericDicomReconstitutionException(
                    "Failure to assemble Dicom Object.", e);
        }
        catch(GenericDicomUtilitiesTGAFileException e){
            logger.error("Error: {}", e.getMessage());
            logger.error("Exception thrown while assembling Dicom Object.");
            throw new GenericDicomReconstitutionException(
                    "Failure to assemble Dicom Object.", e);
        }
        catch(GenericDicomUtilitiesTGAFileNotFoundException e){
            logger.error("Error: {}", e.getMessage());
            logger.error("Exception thrown while assembling Dicom Object.");
            throw new GenericDicomReconstitutionException(
                    "Failure to assemble Dicom Object.", e);
        }    
    }

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.utilities.api.reconstitution.interfaces.DicomObjectReconstitutionFacade#updateDicomObject(String, java.util.HashMap, boolean)
     */
    public IBusinessDataSet updateDicomObject(String dicomFile, HashMap<String, String> hisChanges) 
    							throws GenericDicomReconstitutionException {
        
        IDicomDataSet dds = new DicomDataSetImpl();
        
        dds = reconstitute.updateDicomObject(dicomFile, hisChanges);
        logger.debug("Updating DICOM Object via reconstitution with DICOM file.");
        
        return (this.encapsulateDicomDataSet(dds));
    }

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.utilities.api.reconstitution.interfaces.DicomObjectReconstitutionFacade#updateDicomStream(java.io.InputStream, java.util.HashMap, boolean)
     */
    public byte[] updateDicomStream(SizedInputStream sizedDicomStream, SizedInputStream sizedTextStream) 
    							throws GenericDicomReconstitutionException {
    	
        byte[] data=null;
        data = reconstitute.updateDicomStream(sizedDicomStream, sizedTextStream);
        logger.debug("Updating DICOM Object via reconstitution with DICOM stream.");
        
        return (data);
    }
    
    private IBusinessDataSet encapsulateDicomDataSet(IDicomDataSet dds){

        logger.info("{}: Generic DICOM Layer: ...encapsulating DicomDataSet to pass back to Business Layer.", this.getClass().getName());

        IBusinessDataSet businessDS = new BusinessDataSetImpl();
        businessDS.setDicomDataSet(dds);
        
        return businessDS;
    }

}
