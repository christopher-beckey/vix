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

import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;
import gov.va.med.imaging.exchange.business.storage.exceptions.RetrievalException;


public class NetworkLocationInfoDAOTests
{
	NetworkLocationInfoDAO dao = new NetworkLocationInfoDAO();
	
	@Test
	public void testTranslateGetCurrentWriteLocation() throws RetrievalException
	{
		StringBuilder builder = new StringBuilder();
		builder.append("0^^1\r\n");
		builder.append("NETWORK LOCATION IEN^PHYSICAL REFERENCE\r\n");
		builder.append("2^\\\\vhaiswimgvms501\\image1$\\");
		NetworkLocationInfo info = dao.translateGetWriteLocation(builder.toString());
		
		Assert.assertTrue(info.getNetworkLocationIEN().equals("2"));
		Assert.assertTrue(info.getPhysicalPath().equals("\\\\vhaiswimgvms501\\image1$\\"));
		
	}

	
	@Test(expected = RetrievalException.class)
	public void testTranslateGetCurrentWriteLocationFailure() throws RetrievalException
	{
		StringBuilder builder = new StringBuilder();
		builder.append("1^No Write Location Found for this Place IEN^0");
		NetworkLocationInfo info = dao.translateGetWriteLocation(builder.toString());
	}

	
	@Test
	public void testTranslateGetNetworkLocationDetails() throws RetrievalException
	{
		StringBuilder builder = new StringBuilder();
		builder.append("0^^1\r\n");
		builder.append("PHYSICAL REFERENCE\r\n");
		builder.append("\\\\vhaiswimgvms501\\image1$\\");
		NetworkLocationInfo info = dao.translateGetNetworkLocationDetails("17", builder.toString());
		
		Assert.assertTrue(info.getNetworkLocationIEN().equals("17"));
		Assert.assertTrue(info.getPhysicalPath().equals("\\\\vhaiswimgvms501\\image1$\\"));
		
	}

	
	@Test(expected = RetrievalException.class)
	public void testTranslateGetNetworkLocationDetailsFailure() throws RetrievalException
	{
		StringBuilder builder = new StringBuilder();
		builder.append("1^No Network Location Found with this IEN^0");
		NetworkLocationInfo info = dao.translateGetNetworkLocationDetails("17", builder.toString());
	}
	
	@Test
	public void testTranslateGetAllNetworkLocations() throws RetrievalException
	{
		StringBuilder builder = new StringBuilder();
		builder.append("0^^34\r\n");
		builder.append("IEN^NETWORK LOCATION^PLACE^PHYSICAL REFERENCE^TOTAL SPACE^SPACE USED^FREE SPACE^Reachability Status^READ ONLY^STORAGE TYPE^HASH SUBDIRECTORY^Site supports \'ABSTRACT\' files^Site supports \'FULL\' files^Site supports \'BIG\' files^TEXT^Site supports \'DICOM\' files^Type of data compression^User name^Password^MAINTAINCONNECTION^MAX # RETRY ON CONNECT^MAX # RETRY ON TRANSMIT^Syntax for physical name^SUBDIRECTORY^RETENTION PERIOD^LAST PURGE DATE^SITE^ROUTER^TIME OFFLINE^MUSE SITE #^MUSE VERSION #^GROUP MEMBER\r\n");
		builder.append("2^DAN-MAG2-01^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE1$\\^4574002^^2978426^1^0^MAG^Y^^^^^^^^^^^^^^^^DAN^0^^^^\r\n");
		builder.append("3^DAN-MAG2-02^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE2$\\^4574002^^3032553^1^0^MAG^Y^^^^^^^^^^^^^^^^DAN^0^^^^\r\n");
		builder.append("3^DAN-MAG2-02^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE2$\\^4574002^^3032553^1^0^MAG^Y^^^^^^^^^^^^^^^^DAN^0^^^^\r\n");
		builder.append("18^DAN-MAG2-04^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE4$\\^4574002^^2844325^1^0^MAG^Y^^^^^^^^^^^^^^^^^0^^^^\r\n");
		builder.append("19^DAN-MAG2-05^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE5$\\^4574002^^4238932^1^^MAG^Y^^^^^^^^^^^^^^^^^0^^^^\r\n");
		builder.append("20^DAN-MAG2-06^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE6$\\^4574002^^4238280^1^^MAG^Y^^^^^^^^^^^^^^^^^0^^^^\r\n");
		builder.append("21^DAN-MAG2-07^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE7$\\^4574002^^2399153^1^^MAG^Y^^^^^^^^^^^^^^^^^0^^^^\r\n");
		builder.append("22^DAN-MAG2-08^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE8$\\^4574002^^2401398^1^^MAG^Y^^^^^^^^^^^^^^^^^0^^^^\r\n");
		builder.append("23^DAN-MAG2-09^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE9$\\^4574002^^3333161^1^^MAG^Y^^^^^^^^^^^^^^^^^0^^^^\r\n");
		builder.append("24^DAN-MAG2-10^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE10$\\^4574002^^2495893^1^^MAG^Y^^^^^^^^^^^^^^^^^0^^^^30\r\n");
		builder.append("25^DAN-MAG2-11^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE11$\\^4574002^^2495886^1^^MAG^Y^^^^^^^^^^^^^^^^^0^^^^30\r\n");
		builder.append("42^DAN-MAG2-12^1^\\\\VHADANIMMCLU2A.V11.MED.VA.GOV\\IMAGE12$\\^4574002^^2496074^1^0^MAG^Y^^^^^^^^^^^^^^^^^^^^^30\r\n");
		builder.append("39^DAN-STGD01^1^\\\\VHADANIMMGWV01.V11.MED.VA.GOV\\SG01\\^579537^^520110^1^0^WORM-OTG^Y^^^^^^^^^^^^^^^^^^^^^\r\n");
		builder.append("40^DAN-STGD02^1^\\\\VHADANIMMGWV01.V11.MED.VA.GOV\\SG02\\^579537^^520110^1^0^WORM-OTG^Y^^^^^^^^^^^^^^^^^^^^^\r\n");
		builder.append("6^GCC1^^\\\\VHAHECFTP1.V11.MED.VA.GOV\\550$\\^^^^0^^GCC^^^^^^^^vhadania^&[paz88!R0^^^^^^^^DAN^1^^^^\r\n");
		builder.append("7^GCC1^^\\\\VHAHECFTP1\\550$\\^^^^1^^GCC^^^^^^^^vhadania^3>eN*P*%x9>x?9 h1^^^^^^^^DAN^1^^^^\r\n");
		builder.append("41^MAGGTU4^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\r\n");
		builder.append("30^RG-DAN1^1^^13722006^^7487853^0^^GRP^^^^^^^^^^^^^^^^^^^^^^\r\n");
		builder.append("34^RG-DAN1^2^^^^^0^^GRP^^^^^^^^^^^^^^^^^^^^^^\r\n");
		builder.append("31^RG-DAN2^1^^0^^0^0^^GRP^^^^^^^^^^^^^^^^^^^^^^\r\n");
		builder.append("32^RG-DAN3^1^^0^^0^0^^GRP^^^^^^^^^^^^^^^^^^^^^^\r\n");
		builder.append("33^RG-DAN4^1^^0^^0^0^^GRP^^^^^^^^^^^^^^^^^^^^^^\r\n");
		builder.append("15^VHAANNMUSE1^1^\\\\VHAANNMUSEDB.V11.MED.VA.GOV\\VOL000\\^^^^1^^EKG^^^^^^^^vha11\\vhadaniutwo^3AmlTZb\"`U&nA1m!^^^^^^^^AA/BC/DETROIT/SAG^1^^1^5^\r\n");
		builder.append("13^VHABACMUSE^1^\\\\VHABACMUSE001.V11.MED.VA.GOV\\VOL000\\^^^^0^^EKG^^^^^^^^vhadaniutwo^*/TF1M3vuSZnJ2%^^^^^^^^^1^^1^4^\r\n");
		builder.append("14^VHADETIMM3^1^\\\\VHADETIMM3.V11.MED.VA.GOV\\VOL000\\^^^^0^^EKG^^^^^^^^vhadaniutwo^ 2.jh;\\w~3Ipl8/^^^^^^^^^1^^1^4^\r\n");
		builder.append("1^VHAINDIU^1^\\\\VHAINDMUSE3.V11.MED.VA.GOV\\VOL000\\^^^^1^^EKG^^^^^^^^VHA11\\VHAINDIUtwo^/(HUu-7.:o{vc\"%^^^^^^^^Indy-Danville^0^^1^5^\r\n");
		builder.append("10^VHANINFMUSE1^1^\\\\VHANINFMUSE1.V11.MED.VA.GOV\\VOL000\\^^^^0^^EKG^^^^^^^^VHADANIUTWO^!o-z/+!ewlAyQ 0^^^^^^^^DAN^1^^1^4^\r\n");
		builder.append("16^VISTASITESERVICE^1^http://siteserver.vista.med.va.gov/vistawebsvcs/siteservice.asmx^^^^1^^URL^^^^^^^^^^^^^^^^^^^^^^\r\n");
		builder.append("5^WORMOTG^1^\\\\VHADETIMMJB1.V11.MED.VA.GOV\\DAN_TEMPJB1-1$\\^73394^^37366^1^1^WORM-OTG^Y^^^^^^^^^^^^^^^^DAN^0^^^^\r\n");
		builder.append("9^WORMOTG1^1^\\\\VHADETIMMJB1.V11.MED.VA.GOV\\DAN_TEMPJB1-2$\\^73394^^37366^1^1^WORM-OTG^Y^^^^^^^^^^^^^^^^DAN^0^^^^\r\n");
		builder.append("8^WORMOTG2^1^\\\\VHADETIMMJB1.V11.MED.VA.GOV\\DAN_IMAGEJB1$\\^73394^^37366^1^1^WORM-OTG^^^^^^^^^^^^^^^^^DAN^0^^^^\r\n");
		builder.append("28^WORMOTG2H^1^\\\\VHADETIMMJB1.V11.MED.VA.GOV\\DAN_IMAGEJB1_2H$\\^73394^^37366^1^1^WORM-OTG^Y^^^^^^^^^^^^^^^^^0^^^^\r\n");
		builder.append("17^WORMOTG3^1^\\\\VHADETIMMJB1.V11.MED.VA.GOV\\DAN_IMAGEJB3H$\\^73393^^42281^1^1^WORM-OTG^Y^^^^^^^^^^^^^^^^DAN^0^^^^\r\n");
		builder.append("35^WORMOTG3H^1^\\\\VHADETIMMJB1.V11.MED.VA.GOV\\DAN_IMAGEJB3$\\^73393^^57889^1^0^WORM-OTG^Y^^^^^^^^^^^^^^^^^^^^^");
		List<NetworkLocationInfo> info = dao.translateFindAll(builder.toString());
		
		//Assert.assertTrue(info.size() == 35);
		//Assert.assertTrue(info.getPhysicalPath().equals("\\\\vhaiswimgvms501\\image1$\\"));
		
	}
}