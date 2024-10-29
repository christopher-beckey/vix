/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 18, 2008
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
package gov.va.med.imaging.exchange.webservices.translator.v1.test;

import gov.va.med.ProtocolHandlerUtility;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteImpl;
import junit.framework.TestCase;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class ExchangeWebAppTestBase 
extends TestCase 
{
	static
	{
		ProtocolHandlerUtility.initialize(true);
	}
	
	protected Site site = null;
	
	public ExchangeWebAppTestBase(String className)
	{
		super(className);
	}
	
	public ExchangeWebAppTestBase()
	{
		super(ExchangeWebAppTestBase.class.toString());
	}

	@Override
	protected void setUp() throws Exception {	
		super.setUp();
		site = new SiteImpl("200", "DOD", "DOD", "", 0, "", 0, "");
	}

}
