package gov.va.med.imaging.dicom.dcftoolkit.test;

import java.util.Arrays;

import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.dcftoolkit.common.impl.DicomDataSetImpl;
import gov.va.med.imaging.exchange.business.dicom.exceptions.DicomException;

import org.junit.Assert;
import org.junit.Test;

import com.lbs.DCS.UID;

public class Part10BufferTest extends DicomDCFCommonBase {

	public Part10BufferTest(String arg0) {
		super(arg0);
	}

	@Test
	public void testPart10BufferOne() {
		
		IDicomDataSet dds = this.fillDicomDataSet(1);
		byte[] expectedHdr = {(byte)0x44, (byte)0x49, (byte)0x43, (byte)0x4d};
		byte[] expectedTS = {(byte)0x31, (byte)0x2e, (byte)0x32, (byte)0x2e, (byte)0x38, 
				(byte)0x34, (byte)0x30, (byte)0x2e, (byte)0x31, (byte)0x30, (byte)0x30, 
				(byte)0x30, (byte)0x38, (byte)0x2e, (byte)0x31, (byte)0x2e, (byte)0x32};
		String ts = UID.TRANSFERLITTLEENDIAN;
		dds.setReceivedTransferSyntax(ts);
		byte [] data = dds.part10Buffer(false);
		assertNotNull(data);
		byte[] actualHdr = {0,0,0,0};
		for (int i=0, k=128; i<4; i++, k++){
			actualHdr[i] = data[k];
		}
		Assert.assertArrayEquals(expectedHdr, actualHdr);
		byte[] actualTS = new byte[17];
		Arrays.fill(actualTS, (byte) 0x0);
		for (int i=0, k=262; i<17; i++, k++){
			actualTS[i] = data[k];
		}
		Assert.assertArrayEquals(expectedTS, actualTS);		
	}


	@Test
	public void testPart10BufferTwo() {
		
		IDicomDataSet dds = this.fillDicomDataSet(1);
		byte[] expectedHdr = {(byte)0x44, (byte)0x49, (byte)0x43, (byte)0x4d};
		byte[] expectedTS = {(byte)0x31, (byte)0x2e, (byte)0x32, (byte)0x2e, (byte)0x38, 
				(byte)0x34, (byte)0x30, (byte)0x2e, (byte)0x31, (byte)0x30, (byte)0x30, 
				(byte)0x30, (byte)0x38, (byte)0x2e, (byte)0x31, (byte)0x2e, (byte)0x32};
		String ts = UID.TRANSFERLITTLEENDIAN;
		dds.setReceivedTransferSyntax(ts);
		byte [] data = dds.part10Buffer(true);
		assertNotNull(data);
		byte[] actualHdr = {0,0,0,0};
		for (int i=0, k=128; i<4; i++, k++){
			actualHdr[i] = data[k];
		}
		Assert.assertArrayEquals(expectedHdr, actualHdr);		
		byte[] actualTS = new byte[17];
		Arrays.fill(actualTS, (byte) 0x0);
		for (int i=0, k=262; i<17; i++, k++){
			actualTS[i] = data[k];
		}
		Assert.assertArrayEquals(expectedTS, actualTS);		
	}

	
	@Test
	public void testPart10BufferThree() {
		
		IDicomDataSet dds = this.fillDicomDataSet(1);
		byte[] expectedHdr = {(byte)0x44, (byte)0x49, (byte)0x43, (byte)0x4d};
		byte[] expectedTS = {(byte)0x31, (byte)0x2e, (byte)0x32, (byte)0x2e, (byte)0x38, 
				(byte)0x34, (byte)0x30, (byte)0x2e, (byte)0x31, (byte)0x30, (byte)0x30, 
				(byte)0x30, (byte)0x38, (byte)0x2e, (byte)0x31, (byte)0x2e, (byte)0x32};
		String ts = UID.TRANSFERLITTLEENDIANEXPLICIT;
		dds.setReceivedTransferSyntax(ts);
		byte [] data = dds.part10Buffer(false);
		assertNotNull(data);
		byte[] actualHdr = {0,0,0,0};
		for (int i=0, k=128; i<4; i++, k++){
			actualHdr[i] = data[k];
		}
		Assert.assertArrayEquals(expectedHdr, actualHdr);
		byte[] actualTS = new byte[17];
		Arrays.fill(actualTS, (byte) 0x0);
		for (int i=0, k=262; i<17; i++, k++){
			actualTS[i] = data[k];
		}
		Assert.assertArrayEquals(expectedTS, actualTS);		
	}


	@Test
	public void testPart10BufferFour() {
		
		IDicomDataSet dds = this.fillDicomDataSet(1);
		byte[] expectedHdr = {(byte)0x44, (byte)0x49, (byte)0x43, (byte)0x4d};
		byte[] expectedTS = {(byte)0x31, (byte)0x2e, (byte)0x32, (byte)0x2e, (byte)0x38, 
				(byte)0x34, (byte)0x30, (byte)0x2e, (byte)0x31, (byte)0x30, (byte)0x30, 
				(byte)0x30, (byte)0x38, (byte)0x2e, (byte)0x31, (byte)0x2e, (byte)0x32};
		String ts = UID.TRANSFERLITTLEENDIANEXPLICIT;
		dds.setReceivedTransferSyntax(ts);
		byte [] data = dds.part10Buffer(true);
		assertNotNull(data);
		byte[] actualHdr = {0,0,0,0};
		for (int i=0, k=128; i<4; i++, k++){
			actualHdr[i] = data[k];
		}
		Assert.assertArrayEquals(expectedHdr, actualHdr);		
		byte[] actualTS = new byte[17];
		Arrays.fill(actualTS, (byte) 0x0);
		for (int i=0, k=262; i<17; i++, k++){
			actualTS[i] = data[k];
		}
		Assert.assertArrayEquals(expectedTS, actualTS);		
	}

	
	@Test
	public void testPart10BufferFive() {
		
		IDicomDataSet dds = this.fillDicomDataSet(1);
		byte[] expectedHdr = {(byte)0x44, (byte)0x49, (byte)0x43, (byte)0x4d};
		byte[] expectedTS = {(byte)0x31, (byte)0x2e, (byte)0x32, (byte)0x2e, (byte)0x38, 
				(byte)0x34, (byte)0x30, (byte)0x2e, (byte)0x31, (byte)0x30, (byte)0x30, 
				(byte)0x30, (byte)0x38, (byte)0x2e, (byte)0x31, (byte)0x2e, (byte)0x32};
		String ts = UID.TRANSFERJPEGBASELINEPROCESS1;
		dds.setReceivedTransferSyntax(ts);
		byte [] data = dds.part10Buffer(false);
		assertNotNull(data);
		byte[] actualHdr = {0,0,0,0};
		for (int i=0, k=128; i<4; i++, k++){
			actualHdr[i] = data[k];
		}
		Assert.assertArrayEquals(expectedHdr, actualHdr);
		byte[] actualTS = new byte[17];
		Arrays.fill(actualTS, (byte) 0x0);
		for (int i=0, k=262; i<17; i++, k++){
			actualTS[i] = data[k];
		}
		Assert.assertArrayEquals(expectedTS, actualTS);		
	}


	@Test
	public void testPart10BufferSix() {
		
		IDicomDataSet dds = this.fillDicomDataSet(1);
		byte[] expectedHdr = {(byte)0x44, (byte)0x49, (byte)0x43, (byte)0x4d};
		//1.2.840.10008.1.2.4.50
		byte[] expectedTS = {(byte)0x31, (byte)0x2e, (byte)0x32, (byte)0x2e, (byte)0x38, 
				(byte)0x34, (byte)0x30, (byte)0x2e, (byte)0x31, (byte)0x30, (byte)0x30, 
				(byte)0x30, (byte)0x38, (byte)0x2e, (byte)0x31, (byte)0x2e, (byte)0x32,
				(byte)0x2e, (byte)0x34, (byte)0x2e, (byte)0x35, (byte)0x30};
		String ts = UID.TRANSFERJPEGBASELINEPROCESS1;
		dds.setReceivedTransferSyntax(ts);
		byte [] data = dds.part10Buffer(true);
		assertNotNull(data);
		byte[] actualHdr = {0,0,0,0};
		for (int i=0, k=128; i<4; i++, k++){
			actualHdr[i] = data[k];
		}
		Assert.assertArrayEquals(expectedHdr, actualHdr);		
		byte[] actualTS = new byte[22];
		Arrays.fill(actualTS, (byte) 0x0);
		for (int i=0, k=262; i<22; i++, k++){
			actualTS[i] = data[k];
		}
		Assert.assertArrayEquals(expectedTS, actualTS);		
	}

	
	@Test
	public void testPart10BufferSeven() {
		
		IDicomDataSet dds = this.fillDicomDataSet(1);
		byte[] expectedHdr = {(byte)0x44, (byte)0x49, (byte)0x43, (byte)0x4d};
		byte[] expectedTS = {(byte)0x31, (byte)0x2e, (byte)0x32, (byte)0x2e, (byte)0x38, 
				(byte)0x34, (byte)0x30, (byte)0x2e, (byte)0x31, (byte)0x30, (byte)0x30, 
				(byte)0x30, (byte)0x38, (byte)0x2e, (byte)0x31, (byte)0x2e, (byte)0x32};
		byte [] data = dds.part10Buffer(true);
		assertNotNull(data);
		byte[] actualHdr = {0,0,0,0};
		for (int i=0, k=128; i<4; i++, k++){
			actualHdr[i] = data[k];
		}
		Assert.assertArrayEquals(expectedHdr, actualHdr);		
		byte[] actualTS = new byte[17];
		Arrays.fill(actualTS, (byte) 0x0);
		for (int i=0, k=262; i<17; i++, k++){
			actualTS[i] = data[k];
		}
		Assert.assertArrayEquals(expectedTS, actualTS);		
	}

	
	public IDicomDataSet fillDicomDataSet(int dsNum) {
		IDicomDataSet dds = new DicomDataSetImpl();
		if (dsNum==1) {
			try{
				dds.insertDicomElement("0008,0016", null, "1.2.840.10008.5.1.4.1.1.1"); // SOP Class UID
				dds.insertDicomElement("0008,0018", null, "1.2.840.113619.2.1.1.2703176852.560.948465036.612.123"); // SOPInstanceUID
				// Patient
				dds.insertDicomElement("0010,0010", null, "familiy^given^middle^prefix^suffix"); // Nmae
				dds.insertDicomElement("0010,0020", null, "666-34-1256"); // PatientId
				dds.insertDicomElement("0010,0030", null, "19561224"); // DateOfBirth
				dds.insertDicomElement("0010,0040", null, "M"); // Sex
				dds.insertDicomElement("0010,1030", null, "78.5"); // Weight (kg)
				dds.insertDicomElement("0010,1020", null, "159"); // Size (cm)
				dds.insertDicomElement("0010,2160", null, "caucasian"); // EthnicGroup
				dds.insertDicomElement("0010,21c0", null, "1"); // PregnancyStatus
				dds.insertDicomElement("0040,3001", null, "top secret"); // ConfidentialityConstraint
				dds.insertDicomElement("0010,2000", null, "pacemaker"); // MedicalAlerts
				dds.insertDicomElement("0010,2110", null, "Plutonium\\led\\anthrax"); // ContrastAllergies
				// visit
				dds.insertDicomElement("0038,0010", null, "A321456"); // AdmissionId
				dds.insertDicomElement("0038,0020", null, "2005.04.29"); // AdmittingDate - date
				dds.insertDicomElement("0038,0021", null, "22:49:57.012345"); // AdmittingDate - time
				dds.insertDicomElement("0008,0080", null, "Saint No Mercy VA Hospital"); // InstituteName
				dds.insertDicomElement("0008,0090", null, "Smith^John^^Dr.^M.D."); // ReferringPhysicianName
				// ISR
				dds.insertDicomElement("0008,0050", null, "20050428-12345"); // AccessionNumber
				dds.insertDicomElement("0032,1032", null, "Dorkian^Mo^^Dr.^M.D."); // RequestingPhysician
				dds.insertDicomElement("0032,1033", null, "Orthopedix"); // RequestingService
				// RP
				dds.insertDicomElement("0040,1001", null, "RP12345-1"); // RpId
				dds.insertDicomElement("0040,1002", null, "limping to left leg"); // Reason
				dds.insertDicomElement("0040,1008", null, "very confidential"); // ConfidentialityCode
				dds.insertDicomElement("0032,1060", null, "Knee with Contrast"); // Description
				dds.insertDicomElement("0040,1400", null, "dds is the long text for requested procedure comments"); // Comments
				// SPS
				dds.insertDicomElement("0040,0009", null, "SPS12345-1-1"); // ScheduledProcedureStepId
				dds.insertDicomElement("0040,0020", null, "SCHEDULED"); // State (of SPS)
				dds.insertDicomElement("0040,0001", null, "ddstheAETitle00"); // StationAeTitle
				dds.insertDicomElement("0040,0002", null, "20050430"); // StartDate - date
				dds.insertDicomElement("0040,0003", null, "074957.0"); // StartDate - time
				dds.insertDicomElement("0008,0060", null, "CR"); // Modality
				// Study
				dds.insertDicomElement("0020,000d", null, "1.2.840.113619.2.1.1.2703176852.560.948465036.612"); // InstanceUID (Study)
				dds.insertDicomElement("0020,0010", null, "theStudyID"); // StudyId
				dds.insertDicomElement("0008,0020", null, "20050429"); // StudyDate - date
				dds.insertDicomElement("0008,0030", null, "152947.001"); // StudyDate - time
				dds.insertDicomElement("0032,000a", null, "COMPLETED"); // StatusId
				dds.insertDicomElement("0032,000c", null, "MEDIUM"); // StudyPriorityId
				dds.insertDicomElement("0032,1030", null, "Double check single chance"); // Reason
				dds.insertDicomElement("0008,1030", null, "Long description of study: who, when, what, why, how"); // Description
				dds.insertDicomElement("0032,0034", null, "20050429"); // ReadDate - date
				dds.insertDicomElement("0032,0035", null, "161359"); // ReadDate - time
				dds.insertDicomElement("0008,1060", null, "Bread^Crumby^^^M.D."); // ReadingPhysician
				dds.insertDicomElement("0008,1050", null, "Ground^Beefy^^^M.D."); // PerformingPhysician
				// Series
				dds.insertDicomElement("0018,0015", null, "KNEE"); // BodyPart
				dds.insertDicomElement("0020,000e", null, "1.2.840.113619.2.1.1.2703176852.560.948465036.613.1"); // InstanceUID (Series)
				dds.insertDicomElement("0020,0052", null, "1.2.840.113619.2.1.1.2703176852.560.948465036.614"); // FrameOfReferenceUID
				dds.insertDicomElement("0008,0021", null, "20050429"); // SeriesDate - date
				dds.insertDicomElement("0008,0031", null, "161359"); // SeriesDate - time
				dds.insertDicomElement("0020,0011", null, "3"); // SeriesNumber
				dds.insertDicomElement("0020,0060", null, "L"); // Laterality
				dds.insertDicomElement("0018,5100", null, "FFS"); // SpacialPosition
				// Instance
				dds.insertDicomElement("0008,0008", null, "PRIMARY\\ORIGINAL"); // ImageType
				dds.insertDicomElement("0008,0023", null, "20050429"); // ContentDate - date
				dds.insertDicomElement("0008,0033", null, "161411"); // ContentDate - time
				dds.insertDicomElement("0020,0012", null, "3"); // AcqusitionNumber
				dds.insertDicomElement("0020,1002", null, "6"); // NumberOfImagesAcquired
				dds.insertDicomElement("0008,0018", null, "1.2.840.113619.2.1.1.2703176852.560.948465036.613.1.3"); // SOP InstanceUID
				dds.insertDicomElement("0018,0010", null, "cherry pitt"); // BolusAgent
				dds.insertDicomElement("0018,0060", null, "5.67"); // KiloVoltPeak
				dds.insertDicomElement("0018,1151", null, "320"); // XrayTubeCurrent
				dds.insertDicomElement("0028,0004", null, "MONOCHROME1"); // PhotometricInterpretation
				dds.insertDicomElement("0028,0010", null, "512"); // Rows
				dds.insertDicomElement("0028,0011", null, "512"); // Columns
				dds.insertDicomElement("0028,0002", null, "1"); // SamplesPerPixel
				dds.insertDicomElement("0028,0100", null, "10"); // BitsAllocated
				dds.insertDicomElement("0028,0101", null, "10"); // BitsStored
				dds.insertDicomElement("0028,0101", null, "9"); // HighBit
				dds.insertDicomElement("0028,0103", null, "0"); // PixelRepresentation (0 or 1)
				dds.insertDicomElement("0018,1004", null, "20050430-078"); // PlateId
				dds.insertDicomElement("0018,1403", null, "18CMX24CM"); // CasetteSize
				dds.insertDicomElement("0018,1120", null, "70.45"); // GantryDetectorTilt (degree)
				dds.insertDicomElement("0018,1130", null, "8.54"); // TableHeight (mm)
				dds.insertDicomElement("0028,1052", null, "19.3"); // RescaleIntercept (mm)
				dds.insertDicomElement("0028,1053", null, "1.1"); // RescaleSlope (mm)
				dds.insertDicomElement("0018,0050", null, "3.4"); // SliceThickness (mm)
				dds.insertDicomElement("0018,1100", null, "350"); // ReconstructionDiameter (mm)
				dds.insertDicomElement("0018,0020", null, "SE/GR"); // ScanningSequence
				dds.insertDicomElement("0018,0021", null, "NONE"); // ScanningVariant
				dds.insertDicomElement("0018,0022", null, "PFF"); // ScanningOptions
				dds.insertDicomElement("0018,0023", null, "2D"); // MrAcqType
				dds.insertDicomElement("0018,0080", null, "37.24"); // RepetitionTime (ms)
				dds.insertDicomElement("0018,0081", null, "6.47"); // EchoTime (ms)
			}
			catch(DicomException dX){
				fail("Failed to build DicomDataSet.");
			}
		}
		return (IDicomDataSet)dds;
	}
	
}
