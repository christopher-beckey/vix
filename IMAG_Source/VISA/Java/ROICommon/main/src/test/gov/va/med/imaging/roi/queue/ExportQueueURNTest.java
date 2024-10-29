/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 17, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.roi.queue;

import gov.va.med.URNFactory;
import gov.va.med.imaging.exceptions.URNFormatException;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ExportQueueURNTest
{
	@Test
	public void testDicomExportQueueURNs()
	{
		try
		{
			DicomExportQueueURN urn = DicomExportQueueURN.create("660", "1");
			assertEquals("urn:dicomexportqueue:660-1", urn.toString());
			assertEquals("urn:dicomexportqueue:660-1", urn.toStringCDTP());
			
			DicomExportQueueURN createdUrn = URNFactory.create(urn.toString());
			assertEquals(urn.toString(), createdUrn.toString());
			
		}
		catch(URNFormatException urnfX)
		{
			fail(urnfX.getMessage());
		}
	}
	
	@Test
	public void testNonDicomExportQueueURNs()
	{
		try
		{
			NonDicomExportQueueURN urn = NonDicomExportQueueURN.create("660", "1");
			assertEquals("urn:nondicomexportqueue:660-1", urn.toString());
			assertEquals("urn:nondicomexportqueue:660-1", urn.toStringCDTP());
			
			NonDicomExportQueueURN createdUrn = URNFactory.create(urn.toString());
			assertEquals(urn.toString(), createdUrn.toString());
			
		}
		catch(URNFormatException urnfX)
		{
			fail(urnfX.getMessage());
		}
	}

}
