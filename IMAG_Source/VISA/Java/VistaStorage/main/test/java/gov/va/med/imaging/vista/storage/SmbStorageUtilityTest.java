package gov.va.med.imaging.vista.storage;

import static org.junit.Assert.*;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import org.junit.Test;

import gov.va.med.imaging.core.interfaces.StorageCredentials;

public class SmbStorageUtilityTest extends SmbStorageUtility {

	private final String unitTestFilename = "\\\\localhost\\c$\\temp\\unittest.txt";
	private final String unitTestFilename2 = "\\\\localhost\\c$\\temp\\unittest2.txt";
	private final String unitTestFilename3 = "\\\\localhost\\c$\\temp\\unittest3.txt";

//	private final String unitTestFilename = "\\\\I873VSTWIN-T1\\c$\\temp\\unittest.txt";
//	private final String unitTestFilename2 = "\\\\I873VSTWIN-T1\\c$\\temp\\unittest2.txt";
//	private final String unitTestFilename3 = "\\\\I873VSTWIN-T1\\c$\\temp\\unittest3.txt";

	private final String unitTestLocalFilename4 = "C:\\temp\\unittest4.txt";
	private final String username = "administrator"; //"vaaaccvxcluster";
    private final String a_key = "Vista2014"; //"Password1";
    private final String sitenumber = "500"; //"Password1";

	@Test
	public void testDeleteFile() {
		createTestFile();
		
		SmbStorageUtility util = new SmbStorageUtility();
		
		TestStorageCredentials storageCredentials = new TestStorageCredentials(sitenumber,username,a_key);
		try {
			util.deleteFile(unitTestFilename, (StorageCredentials) storageCredentials);
		} catch (IOException e) {
			fail(e.getMessage());
		}
	}

	
	@Test
	public void testCopyFile() {
		createTestFile();

		SmbStorageUtility util = new SmbStorageUtility();
		
		TestStorageCredentials storageCredentials = new TestStorageCredentials(sitenumber,username,a_key);
		try {
			if (fileExists(unitTestFilename2, storageCredentials))
			{
				util.deleteFile(unitTestFilename2, (StorageCredentials) storageCredentials);
			}
			util.copyFile(unitTestFilename, unitTestFilename2, storageCredentials);  
		} catch (Exception e) {
			fail(e.getMessage());
		}
	}
	
	
	@Test
	public void testRenameFile() {
		createTestFile();

		SmbStorageUtility util = new SmbStorageUtility();
		
		TestStorageCredentials storageCredentials = new TestStorageCredentials(sitenumber,username,a_key);
		try {
			if (fileExists(unitTestFilename3, storageCredentials))
			{
				util.deleteFile(unitTestFilename3, (StorageCredentials) storageCredentials);
			}
			util.renameFile(unitTestFilename, unitTestFilename3, storageCredentials);  
		} catch (Exception e) {
			fail(e.getMessage());
		}
	}

	@Test
	public void testCopyRemoteFileToLocalFile() {
		createTestFile();

		SmbStorageUtility util = new SmbStorageUtility();
		
		TestStorageCredentials storageCredentials = new TestStorageCredentials(sitenumber,username,a_key);
		try {
			util.copyRemoteFileToLocalFile(unitTestFilename, unitTestLocalFilename4, storageCredentials);
		} catch (IOException e) {
			fail(e.getMessage());
		}
	}

	@Test
	public void testReadFileAsString() {
		createTestFile();

		SmbStorageUtility util = new SmbStorageUtility();
		
		TestStorageCredentials storageCredentials = new TestStorageCredentials(sitenumber,username,a_key);
		try {
			System.out.print("Read: "  + util.readFileAsString(unitTestFilename, storageCredentials));
		} catch (IOException e) {
			fail(e.getMessage());
		}
	}

	private void createTestFile()
	{
		String str = "Hello";
	    BufferedWriter writer;
		try {
			writer = new BufferedWriter(new FileWriter(unitTestFilename));
			writer.write(str);
		    writer.close();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}

}
