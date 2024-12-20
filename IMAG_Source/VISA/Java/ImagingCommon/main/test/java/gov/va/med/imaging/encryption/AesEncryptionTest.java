/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 25, 2012
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
package gov.va.med.imaging.encryption;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;
import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;

import org.junit.Test;

/**
 * @author VHAISWWERFEJ
 *
 */
public class AesEncryptionTest
{
	@Test
	public void testEncryption()
	{
		try
		{
			testEncryption("&A{CLZWKHAA , ALUUN A}&B{101364841}&C{1002016321V080363}&D{RPT^CPRS;TEST.ST-LOUIS.MED.VA.GOV^2705^TIU^1822447^^^^^^^^0}&E{992}&F{MONSON , STEVE }&G{136672}&H{223334667}&I{CLE13}&J{982}&K{VISTA IMAGING VIX^90e2cca6-8de1-479e-ba7c-a52ea5b9028d}&L{http://vhaiswimmixvi1/VistaWebSvcs/ImagingExchangeSiteService.asmx}&M{2001}&O{VW}");
			testEncryption("asdfasdfasdfasfdasfsadfasdfasdfasdfasdlfuhasolfhasuifhao8vhfwe398p4htp23084n9e8nw8p9evn8fsdv");
			testEncryption("asdfasdfasdfasf\ndasfsadfasdfasd dfasdlfuhasolfhasuifhao 8vhfwe398p4htp23084n9\ne8nw8p9evn8fsdv\n");
			testEncryption("ALUUN A}&B{101364841}&C{1002016321V080363}&D{RPT^CPRS;TEST.ST-LOUIS.MED.VA.GOV^2705^TIU^1822447^^^^^^^^0}&E{992}&F{MONSON , STEVE }&G{136672}&H{223334667}&I{CLE13}&J{982}&K{VISTA IMAGING VIX^90e2cca6-8de1-479e-ba7c-a52ea5b9028d}&L{http://vhaiswimmixvi1/VistaWebSvcs/ImagingExchangeSiteService.asmx}&M{2001}&O{VW}&P{df-22495334-t}");
			testEncryption("RIPPLE,FUDGE||234||000-00-0001||Salt Lake City||660||~1XWBAS139-574184_1||boating1||boating99!");
			testEncryption("PROVIDER,ONE||1024||000-00-0034||Ann Arbor||530||~1XWBAS34-574814_2||fudge||1fudge.");
			testEncryption("TECHNOLOGIST,TWOEIGHTTHREE||53||000-00-0283||Salt Lake City||660||~1XWBAS139-744184_1||abc123||abc123!!");
		}
		catch(Exception ex)
		{
			fail(ex.getMessage());
		}
	}
	
	
	private void testEncryption(String clearText)
	throws Exception
	{
		String encrypted = AesEncryption.encrypt(clearText);
		System.out.println(encrypted);
		if(encrypted.contains("/") || encrypted.contains("+")){
			fail("Wrong Base64 alphabet.");
		}
		String decrypted = AesEncryption.decodeByteArray(encrypted);
		assertEquals(clearText, decrypted);
	}

}
