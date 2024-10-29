/*
 * Created on Apr 5, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package gov.va.med.imaging.dicom.test;

import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.dcftoolkit.utilities.exceptions.DicomFileException;
import gov.va.med.imaging.dicom.dcftoolkit.utilities.reconstitution.DicomFileExtractor;
import gov.va.med.imaging.exchange.business.dicom.exceptions.DicomException;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 *
 *
 * @author William Peterson
 *
 */
public class DCMFileParserTest extends DicomDCFUtilitiesBase {

    /*
     * @see DicomDCFUtilitiesTestBase#setUp()
     */
    protected void setUp() throws Exception {
        super.setUp();
    }

    /*
     * @see DicomDCFUtilitiesTestBase#tearDown()
     */
    protected void tearDown() throws Exception {
        super.tearDown();
    }

    /**
     * Constructor for DCMFileParserTest.
     * @param arg0
     */
    public DCMFileParserTest(String arg0) {
        super(arg0);
    }
    public void testDicomFileParserOne(){
        
    	String dcmFilename = ".\\testdata\\test1.dcm";
    	IDicomDataSet dds= this.parseFileToDDS(dcmFilename);
        String transferSyntax = dds.getReceivedTransferSyntax();
    	//testLogger.info("DataSet: " + dds.getDicomDataSet().toString());
        assertNotNull(transferSyntax);
        assertEquals("1.2.840.10008.1.2.4.50", transferSyntax);
        assertEquals("1.2.840.10008.5.1.4.1.1.77.1.4", dds.getSOPClass());
        try {
			assertEquals("20050817", dds.getDicomElement("0008,0020").getStringValue());
		} catch (DicomException e) {
			fail("Failed to retrieve DICOM element.");
		}
        assertEquals("DVNET ", dds.getManufacturer());
    }
    
    
    public void testDicomFileParserTwo(){
        
        String dcmFilename = ".\\testdata\\test3.dcm";
        IDicomDataSet dds= this.parseFileToDDS(dcmFilename);
        String transferSyntax = dds.getReceivedTransferSyntax();
    	//testLogger.info("DataSet: " + dds.getDicomDataSet().toString());
        assertNotNull(transferSyntax);
        assertEquals("1.2.840.10008.1.2.4.50", transferSyntax);
        assertEquals("1.2.840.10008.5.1.4.1.1.77.1.4", dds.getSOPClass());
        try {
			assertEquals("RGB", dds.getDicomElement("0028,0004").getStringValue());
		} catch (DicomException e) {
			fail("Failed to retrieve DICOM element.");
		}
        assertEquals("DVNET ", dds.getManufacturer());
    }

    
    public void testDicomFileParserThree(){
        
        String dcmFilename = ".\\testdata\\test4.dcm";
        IDicomDataSet dds= this.parseStreamToDDS(dcmFilename);
        String transferSyntax = dds.getReceivedTransferSyntax();
    	//testLogger.info("DataSet: " + dds.getDicomDataSet().toString());
        assertNotNull(transferSyntax);
        assertEquals("1.2.840.10008.1.2.1", transferSyntax);
        assertEquals("1.2.840.10008.5.1.4.1.1.1.1", dds.getSOPClass());
        try {
			assertEquals("MONOCHROME2", dds.getDicomElement("0028,0004").getStringValue());
		} catch (DicomException e) {
			fail("Failed to retrieve DICOM element.");
		}
        assertEquals("GE MEDICAL SYSTEMS", dds.getManufacturer());
    }

    
    private IDicomDataSet parseFileToDDS(String dcmFilename){
        
        IDicomDataSet dds = null;
        try{
            DicomFileExtractor parser = new DicomFileExtractor();
            dds = (IDicomDataSet)parser.getDDSFromDicomFile(dcmFilename);
        }
        catch(DicomFileException noFile){
            testLogger.info("Did not find DICOM File {}", dcmFilename);
            noFile.printStackTrace();
            fail("Test failed.");
        }
        return dds;
    }

    private IDicomDataSet parseStreamToDDS(String dcmFilename){
        
        IDicomDataSet dds = null;
        try{
            DicomFileExtractor parser = new DicomFileExtractor();
            
            File file = new File(dcmFilename);
            FileInputStream inStream = new FileInputStream(file);
            int count = inStream.available();
            SizedInputStream sizedDicomStream = new SizedInputStream(inStream, count);
            
            dds = (IDicomDataSet)parser.getDDSFromDicomStream(sizedDicomStream);
        }
        catch(DicomFileException noFile){
            testLogger.info("Did not find DICOM File {}", dcmFilename);
            noFile.printStackTrace();
            fail("Test failed.");
        } 
        catch (FileNotFoundException fnfX) {
			fnfX.printStackTrace();
            fail("Test failed.");
		} 
        catch (IOException ioX) {
			ioX.printStackTrace();
            fail("Test failed.");
		}
        return dds;
    }

/*    
	private void removeSelectedBadVRElements(DicomDataSet dds){
		ArrayList<String> removeList = DicomServerConfiguration.getConfiguration().getRemovedElements();
		if(removeList != null){
			Iterator<String> iter = removeList.iterator();
			while(iter.hasNext()){
				String tagNumber  = iter.next();
				try{
					AttributeTag tag = new AttributeTag(tagNumber);
					if(dds.containsElement(tag)){
						DicomElement element = dds.findElement(tag);
						short vr = element.vr();
	
						try{
							switch (vr){
								case DCM.VR_AE: 
									VRValidator.instance().validateAE((DicomAEElement)element);
									break;
								case DCM.VR_AS: 
									VRValidator.instance().validateAS((DicomASElement)element);
									break;
								case DCM.VR_AT: 
									VRValidator.instance().validateAT((DicomATElement)element);
									break;
								case DCM.VR_CS: 
									VRValidator.instance().validateCS((DicomCSElement)element);
									break;
								case DCM.VR_DA: 
									VRValidator.instance().validateDA((DicomDAElement)element);
									break;
								case DCM.VR_DS: 
									VRValidator.instance().validateDS((DicomDSElement)element);
									break;
								case DCM.VR_DT: 
									VRValidator.instance().validateDT((DicomDTElement)element);
									break;
								case DCM.VR_FD: 
									VRValidator.instance().validateFD((DicomFDElement)element);
									break;
								case DCM.VR_FL: 
									VRValidator.instance().validateFL((DicomFLElement)element);
									break;
								case DCM.VR_IS: 
									VRValidator.instance().validateIS((DicomISElement)element);
									break;
								case DCM.VR_LO: 
									VRValidator.instance().validateLO((DicomLOElement)element);
									break;
								case DCM.VR_LT: 
									VRValidator.instance().validateLT((DicomLTElement)element);
									break;
								case DCM.VR_PN: 
									VRValidator.instance().validatePN((DicomPNElement)element);
									break;
								case DCM.VR_SH: 
									VRValidator.instance().validateSH((DicomSHElement)element);
									break;
								case DCM.VR_SL: 
									VRValidator.instance().validateSL((DicomSLElement)element);
									break;
								case DCM.VR_SQ: 
									ValidationErrorList list = VRValidator.instance().validateSQ((DicomSQElement)element,"0");
									if(list.hasErrors()){
										throw new DCSException();
									}
									break;
								case DCM.VR_SS: 
									VRValidator.instance().validateSS((DicomSSElement)element);
									break;
								case DCM.VR_ST: 
									VRValidator.instance().validateST((DicomSTElement)element);
									break;
								case DCM.VR_TM: 
									VRValidator.instance().validateTM((DicomTMElement)element);
									break;
								case DCM.VR_UI: 
									VRValidator.instance().validateUI((DicomUIElement)element);
									break;
								case DCM.VR_UL: 
									VRValidator.instance().validateUL((DicomULElement)element);
									break;
								case DCM.VR_UN: 
									VRValidator.instance().validateUN((DicomUNElement)element);
									break;
								case DCM.VR_US: 
									VRValidator.instance().validateUS((DicomUSElement)element);
									break;
								case DCM.VR_UT: 
									VRValidator.instance().validateUT((DicomUTElement)element);
									break;
								case DCM.VR_OB: 
									VRValidator.instance().validateOB((DicomOBElement)element);
									break;
								case DCM.VR_OW: 
									VRValidator.instance().validateOW((DicomOWElement)element);
									break;
								case DCM.VR_OF: 
									VRValidator.instance().validateOF((DicomOFElement)element);
									break;
							}
						}
						catch(DCSException dcsX){
							dds.insert(tag, "");
						}
					}
				}
				catch(DCSException dcsX){
					//Do nothing with exception.
				}
			}
		}
	}
*/    
    
}
