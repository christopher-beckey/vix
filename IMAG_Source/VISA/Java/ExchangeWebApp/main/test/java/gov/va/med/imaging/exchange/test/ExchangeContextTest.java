/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 17, 2008
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
package gov.va.med.imaging.exchange.test;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import junit.framework.Assert;
import gov.va.med.imaging.exchange.ImagingExchangeContext;
import gov.va.med.imaging.exchange.webservices.translator.v1.test.ExchangeWebAppTestBase;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeContextTest 
extends ExchangeWebAppTestBase 
{
	
	protected static ClassPathXmlApplicationContext springFactory;
	
	static 
	{
		springFactory = new ClassPathXmlApplicationContext(new String[] {"applicationContext.xml"});
	}
	
	public ExchangeContextTest()
	{
		super(ExchangeContextTest.class.toString());
	}
	
	private final static int threadTestCount = 1000;
	
	/**
	 * Test getting the context several times with different threads - be sure the synchronization is working
	 */
	public void testGetContext()
	{
		Thread threads [] = new Thread[threadTestCount];
		ThreadGroup workerThreadGroup = new ThreadGroup("ContextTestGroup");
		workerThreadGroup.setDaemon(true);
		for(int i = 0; i < threadTestCount; i++)
		{
		
			threads[i] = new Thread(workerThreadGroup, i + "")
			{
				/* (non-Javadoc)
				 * @see java.lang.Thread#run()
				 */
				@Override
				public void run() 
				{
					int termCount = ImagingExchangeContext.getExchangeInterfaceProcedureFilterTerms().getFilterTerms().size();
					System.out.println("Got [" + termCount + "] procedure filter terms from thread [" + Thread.currentThread().getId() + "]");
					
					assertNotSame("0 procedure filter terms", 0, termCount);
				}
				
			};
		}
		
		for(int i = 0; i < threadTestCount; i++)
		{
			threads[i].start();
		}
		
		for (int n = 0; n < threadTestCount; ++n)
		{
			synchronized (threads[n])
			{
				try
				{
					if(threads[n].isAlive())
						threads[n].wait();
				} 
				catch (InterruptedException x)
				{
					Assert.fail(x.getMessage());
				}
			}
		}
	}

}
