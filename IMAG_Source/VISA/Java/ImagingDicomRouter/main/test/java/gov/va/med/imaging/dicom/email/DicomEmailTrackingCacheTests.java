package gov.va.med.imaging.dicom.email;

import junit.framework.Assert;
import junit.framework.TestCase;

public class DicomEmailTrackingCacheTests extends TestCase {

	public void testDicomEmailTrackingCache()
	{
		//
		// Part 1 - Basic functionality
		//

		// Create an email info object and ask if it has been sent. Should say no...
		DicomEmailInfo info = new DicomEmailInfo(DicomEmailType.UID, DicomLevel.SERIES, "ABCDE");
		boolean hasEmailBeenSent = DicomEmailTrackingCache.hasEmailBeenSent(info);
		Assert.assertFalse(hasEmailBeenSent);
		
		// As again. Should say yes...
		hasEmailBeenSent = DicomEmailTrackingCache.hasEmailBeenSent(info);
		Assert.assertTrue(hasEmailBeenSent);
		
		//
		// Part 2 - Create another email info object with a different message type
		//
		info = new DicomEmailInfo(DicomEmailType.ARCHIVER, DicomLevel.SERIES, "ABCDE");
		
		// Ask if it has been sent. Should say no...
		hasEmailBeenSent = DicomEmailTrackingCache.hasEmailBeenSent(info);
		Assert.assertFalse(hasEmailBeenSent);
		
		// As again. Should say yes...
		hasEmailBeenSent = DicomEmailTrackingCache.hasEmailBeenSent(info);
		Assert.assertTrue(hasEmailBeenSent);

		
		//
		// Part 3 - Create another email info object with a different level
		//
		info = new DicomEmailInfo(DicomEmailType.ARCHIVER, DicomLevel.STUDY, "ABCDE");
		
		// Ask if it has been sent. Should say no...
		hasEmailBeenSent = DicomEmailTrackingCache.hasEmailBeenSent(info);
		Assert.assertFalse(hasEmailBeenSent);
		
		// As again. Should say yes...
		hasEmailBeenSent = DicomEmailTrackingCache.hasEmailBeenSent(info);
		Assert.assertTrue(hasEmailBeenSent);

		
		//
		// Part 4 - Create another email info object with a different messageId
		//
		info = new DicomEmailInfo(DicomEmailType.ARCHIVER, DicomLevel.STUDY, "EFGHI");
		
		// Ask if it has been sent. Should say no...
		hasEmailBeenSent = DicomEmailTrackingCache.hasEmailBeenSent(info);
		Assert.assertFalse(hasEmailBeenSent);
		
		// As again. Should say yes...
		hasEmailBeenSent = DicomEmailTrackingCache.hasEmailBeenSent(info);
		Assert.assertTrue(hasEmailBeenSent);

	}
}
