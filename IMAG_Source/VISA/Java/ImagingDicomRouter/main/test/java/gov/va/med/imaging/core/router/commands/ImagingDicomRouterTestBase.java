/*
 * Created on Nov 18, 2005
 *
 */
package gov.va.med.imaging.core.router.commands;

import java.nio.charset.Charset;

import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;
import org.apache.logging.log4j.core.appender.ConsoleAppender;
import org.apache.logging.log4j.core.config.AppenderRef;
import org.apache.logging.log4j.core.config.Configurator;
import org.apache.logging.log4j.core.config.LoggerConfig;
import org.apache.logging.log4j.core.layout.PatternLayout;
import org.apache.logging.log4j.spi.LoggerContext;

import gov.va.med.configuration.Configuration;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.notifications.email.NotificationEmailConfiguration;
import junit.framework.TestCase;

/**
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 *
 *
 * @author William Peterson
 *
 */
public class ImagingDicomRouterTestBase extends TestCase {
  
    //public static Logger logger =null; //LogManager.getRootLogger();
    //public static ConsoleAppender appender;


    /*
     * @see TestCase#setUp()
     */
    @SuppressWarnings("deprecation")
	protected void setUp() throws Exception {
        super.setUp();
		// Removed logging stuff; unused

        Configurator.setLevel("ImagingDicomRouterTestBase", Level.DEBUG);

		DicomServerConfiguration.getConfiguration().setSiteId("660");
		DicomServerConfiguration.getConfiguration().setHostName("test");
		NotificationEmailConfiguration.getConfiguration().setMaximumMessageCountPerEmail(20);
    }

    /*
     * @see TestCase#tearDown()
     */
    protected void tearDown() throws Exception {
        super.tearDown();
    }

    /**
     * Constructor for DicomDCFSCUTestBase.
     * @param arg0
     */
    public ImagingDicomRouterTestBase(String arg0) {
        super(arg0);
    }
}
