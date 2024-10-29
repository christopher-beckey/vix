/*
 * Created on Dec 8, 2005
 *
 */
package gov.va.med.imaging.dicom.test;

import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationAbortException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationGeneralException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationRejectException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.storagescu.impl.DicomStoreSCUImpl;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;

import com.lbs.DCS.DCSException;


/**
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 *
 *
 * @author William Peterson
 *
 */
public class OpenAssociationTest extends DicomDCFSCUTestBase {

    /*
     * @see TestCase#setUp()
     */
    protected void setUp() throws Exception {
        super.setUp();
    }

    /*
     * @see TestCase#tearDown()
     */
    protected void tearDown() throws Exception {
        super.tearDown();
    }

    /**
     * Constructor for OpenAssociationTest.
     * @param arg0
     */
    public OpenAssociationTest(String arg) {
        super(arg);
    }
/*
    public void testVerifyAssociation(){
        boolean result = false;
        String localAETitle = "VISTA_Send_Image";
        String remoteAETitle = "EFILM";
        String ipAddr = "10.2.16.232:4006";
        DicomStoreSCUImpl scuConnect;
        
        String[] args = null;
        try{
        	scuConnect = new DicomStoreSCUImpl(args);
            result = scuConnect.VerifyAssociation(localAETitle, remoteAETitle, ipAddr);
            if(result){
                junitLogger.info("Verification is successful.");
                junitLogger.info("Verification Test is complete.");
            }
            else{
                junitLogger.info("Verification is not successful.");
                fail("Test failed.");
            }
        }
        catch(DCSException dcsX){
            junitLogger.info("Association was rejected.");
            dcsX.printStackTrace();
            fail("Test failed.");
        }
        catch(DicomAssociationRejectException reject){
            junitLogger.info("Association was rejected.");
            reject.printStackTrace();
            fail("Test failed.");
        }
    }

    public void testOpenAssociation(){
        String localAETitle = "VISTA_Send_Image";
        DicomAE scpInfo = new DicomAE();
        DicomStoreSCUImpl scuConnect;
        String[] args = null;

        try{
        	scuConnect = new DicomStoreSCUImpl(args);
            scpInfo.setRemoteAETitle("EFILM");
            scpInfo.setHostName("10.2.16.232");
            scpInfo.setPort("4006");
            scpInfo.setStudyTimeoutSeconds(180);
            
            junitLogger.info("Setup complete.");
            
            scuConnect.openStoreAssociation(localAETitle, scpInfo);
            
            junitLogger.info("Association is successfully established.");
            
            scuConnect.closeStoreAssociation();
            
            junitLogger.info("Association is successfully released.");
            junitLogger.info("Open Association Test complete.");
        }
        catch(DCSException dcsX){
            junitLogger.info("Association was rejected.");
            dcsX.printStackTrace();
            fail("Test failed.");
        }
        catch(DicomAssociationRejectException reject){
            junitLogger.info("Association was rejected.");
            reject.printStackTrace();
            fail("Test failed.");
        }
        catch(DicomAssociationGeneralException generalError){
            junitLogger.info("Association General Exception.");
            generalError.printStackTrace();
            fail("Test failed.");
        }
        catch(DicomAssociationAbortException abort){
            junitLogger.info("Aborting Association.");
            abort.printStackTrace();
            fail("Test failed.");
        }   
    }
*/
}
