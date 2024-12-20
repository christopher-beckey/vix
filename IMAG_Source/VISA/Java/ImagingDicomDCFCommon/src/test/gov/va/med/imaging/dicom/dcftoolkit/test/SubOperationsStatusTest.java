/**
 * Created on Jul 22, 2008
 */
package gov.va.med.imaging.dicom.dcftoolkit.test;

import gov.va.med.imaging.dicom.dcftoolkit.common.observer.SubOperationsStatus;

/**
 *
 *
 *
 * @author William Peterson
 *
 */
public class SubOperationsStatusTest extends DicomDCFCommonBase {

	public SubOperationsStatusTest(String arg0){
		super(arg0);
	}
	
	public void testSuccessOne(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(0);
		for(int i=0; i<10; i++){
			status.setSuccessfulSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.SUCCESS);
	}

	public void testSuccessTwo(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(0);
		for(int i=0; i<10; i++){
			status.setSuccessfulSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.SUCCESS);
	}
	
	
	public void testSuccessThree(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(0);
		for(int i=0; i<10; i++){
			status.setWarningSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.SUCCESS);
	}
	
	public void testSuccessFour(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(0);
		for(int i=0; i<7; i++){
			status.setSuccessfulSubOperations();
		}
		for(int j=0; j<3; j++){
			status.setWarningSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.SUCCESS);
	}

	
	public void testFailureOne(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(10);
		for(int i=0; i<7; i++){
			status.setSuccessfulSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.FAILURE);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.FAILURE);
	}
	

	public void testFailureTwo(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(10);
		for(int i=0; i<6; i++){
			status.setFailedSubOperations();
		}
		for(int j=0; j<4; j++){
			status.setWarningSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.FAILURE);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.FAILURE);
	}

	public void testFailureThree(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(10);
		for(int i=0; i<10; i++){
			status.setFailedSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.FAILURE);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.FAILURE);
	}

	public void testFailureFour(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(10);
		status.setCompleteStatus(SubOperationsStatus.FAILURE);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.FAILURE);
	}
	
	public void testFailureFive(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setCompleteStatus(SubOperationsStatus.FAILURE);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.FAILURE);
	}

	public void testWarningOne(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(0);
		for(int i=0; i<10; i++){
			status.setFailedSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.WARNING);
	}
	
	
	public void testWarningTwo(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(10);
		for(int i=0; i<6; i++){
			status.setSuccessfulSubOperations();
		}
		for(int j=0; j<4; j++){
			status.setFailedSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.WARNING);
	}
	

	public void testWarningThree(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(10);
		for(int i=0; i<3; i++){
			status.setWarningSubOperations();
		}
		for(int j=0; j<2; j++){
			status.setFailedSubOperations();
		}
		for(int k=0; k<5; k++){
			status.setSuccessfulSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.WARNING);
	}
	
	public void testWarningFour(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(10);
		for(int i=0; i<3; i++){
			status.setSuccessfulSubOperations();
		}
		for(int j=0; j<3; j++){
			status.setFailedSubOperations();
		}
		for(int k=0; k<3; k++){
			status.setWarningSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.WARNING);
	}
	
	public void testWarningFive(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(10);
		for(int i=0; i<7; i++){
			status.setFailedSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.WARNING);
	}
	
	public void testWarningSix(){
		SubOperationsStatus status = new SubOperationsStatus();
		status.setRemainingSubOperations(10);
		for(int i=0; i<7; i++){
			status.setSuccessfulSubOperations();
		}
		status.setCompleteStatus(SubOperationsStatus.SUCCESS);
		int correctStatus = status.getCompleteStatus();
		assertTrue(correctStatus == SubOperationsStatus.SUCCESS);
	}

	
}
