/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 9, 2008
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
package gov.va.med.imaging.url.mix.test;

import java.net.MalformedURLException;
import gov.va.med.ProtocolHandlerUtility;
import gov.va.med.imaging.exchange.business.SiteImpl;
import gov.va.med.imaging.exchange.business.Site;
import junit.framework.TestCase;

/**
 * @author VHAISWWERFEJ
 *
 */
public class AbstractMixTest extends TestCase {
	
	public AbstractMixTest() 
	{
		super(AbstractMixTest.class.toString());
	}
	
	protected Site site;
	
	public AbstractMixTest(String name)
	{
		super(name);
		ProtocolHandlerUtility.initialize(true);
		
		try
		{
			site = new SiteImpl("200", "Dept. of Defense", "DOD", "", 0, "", 0, "");
		}
		catch (MalformedURLException x)
		{
			x.printStackTrace();
		}
		/*
		TransactionContext context = TransactionContextFactory.get();
		context.setTransactionId(System.currentTimeMillis() + "");
		context.setFullName("IMAGPROVIDERONETWOSIX,ONETWOSIX");
		context.setSsn("843924956");
		context.setSiteNumber("660");
		context.setSiteName("SALT LAKE CITY");
		*/
	}

	@Override
	protected void setUp() throws Exception 
	{		
		super.setUp();		
		/*
		TransactionContext context = TransactionContextFactory.get();
		context.setTransactionId(System.currentTimeMillis() + "");
		*/	
	}

}
