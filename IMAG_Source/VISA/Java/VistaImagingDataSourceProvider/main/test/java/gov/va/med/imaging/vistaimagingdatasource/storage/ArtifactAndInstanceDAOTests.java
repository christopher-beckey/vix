/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Nov, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswlouthj
  Description: DICOM Study cache manager. Maintains the cache of study instances
  			   and expires old studies after 15 minutes. 

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

package gov.va.med.imaging.vistaimagingdatasource.storage;

import gov.va.med.imaging.exchange.business.storage.Artifact;
import gov.va.med.imaging.exchange.business.storage.ArtifactInstance;
import gov.va.med.imaging.exchange.business.storage.exceptions.RetrievalException;

import java.util.List;

import org.junit.Test;

public class ArtifactAndInstanceDAOTests extends BaseArtifactDAOTests
{
	private ArtifactAndInstanceDAO dao = new ArtifactAndInstanceDAO();

	@Test
	public void translateGetEntityByIdTest() 
	{
		StringBuffer buffer = new StringBuffer();
		buffer.append("0^^35\r\n");
		buffer.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n");
		buffer.append("<ARTIFACTS>\r\n");
		buffer.append("<ARTIFACT\r\n");
		buffer.append("PK=\"29\"\r\n");
		buffer.append("ARTIFACTTOKEN=\"Zr2$MagM0003Mymhi1h!roBU1003hzX1s\"\r\n");
		buffer.append("ARTIFACTDESCRIPTOR=\"2\"\r\n");
		buffer.append("KEYLIST=\"15\"\r\n");
		buffer.append("SIZEINBYTES=\"5220\"\r\n");
		buffer.append("CRC=\"2854413326\"\r\n");
		buffer.append("CREATINGAPPLICATION=\"4\"\r\n");
		buffer.append("CREATEDDATETIME=\"20170908.134802\"\r\n");
		buffer.append("LASTACCESSDATETIME=\"\"\r\n");
		buffer.append("DELETINGAPPLICATION=\"\"\r\n");
		buffer.append("DELETEDDATETIME=\"\" >\r\n");
		buffer.append("<KEYS>\r\n");
		buffer.append("<KEY KVALUE=\"SiteDFN=500-100910\" KLEVEL=\"1\" />\r\n");
		buffer.append("<KEY KVALUE=\"SiteAcc=500-500-GMR-933\" KLEVEL=\"2\" />\r\n");
		buffer.append("<KEY KVALUE=\"StudyId=1.2.840.113754.1.4.500.1.933\" KLEVEL=\"3\" />\r\n");
		buffer.append("<KEY KVALUE=\"SeriesId=1.3.6.1.4.1.5962.99.1.158.1981.1504826731148.10.3.1.1\" KLEVEL=\"4\" />\r\n");
		buffer.append("<KEY KVALUE=\"SOPId=1.3.6.1.4.1.5962.99.1.1588144780.1981967931.1504826731148.12.0\" KLEVEL=\"5\" />\r\n");
		buffer.append("</KEYS>\r\n");
		buffer.append("<ARTIFACTINSTANCES>\r\n");
		buffer.append("<ARTIFACTINSTANCE\r\n");
		buffer.append("PK=\"27\"\r\n");
		buffer.append("ARTIFACT=\"29\"\r\n");
		buffer.append("STORAGEPROVIDER=\"1\"\r\n");
		buffer.append("CREATEDDATETIME=\"20170908.134802\"\r\n");
		buffer.append("LASTACCESSDATETIME=\"\"\r\n");
		buffer.append("FILEREF=\"500_00000000000029.jpg\"\r\n");
		buffer.append("DISKVOLUME=\"2\"\r\n");
		buffer.append("FILEPATH=\"500\00\00\00\00\00\00\" >\r\n");
		buffer.append("</ARTIFACTINSTANCE >\r\n");
		buffer.append("</ARTIFACTINSTANCES>\r\n");
		buffer.append("</ARTIFACT>\r\n");
		buffer.append("</ARTIFACTS>\r\n");

		try {
			Artifact artifact = dao.translateGetEntityById("1", buffer.toString());
			System.out.println("Artifact: " +artifact.toString());
			
			List<ArtifactInstance> instances = artifact.getArtifactInstances();
			System.out.println("Instances: " + instances.get(0).toString());
			//assertEquals(instances.size(), 2);
			
		} catch (RetrievalException e) {
			
		}
	}

	@Test
	public void translateGetEntityByExampleTest() throws RetrievalException
	{
		Artifact artifact = dao.translateGetEntityByExample(new Artifact(), getArtifactAndInstancesXmlString());
		validateArtifactAndKeysAndInstances(artifact);
	}


}