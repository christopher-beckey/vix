/*
 * Created on Nov 18, 2005
 *
 */
package gov.va.med.imaging.dicom.dcftoolkit.test;

import junit.framework.TestCase;

import java.nio.charset.Charset;

import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;
import org.apache.logging.log4j.core.Appender;
import org.apache.logging.log4j.core.LoggerContext;
import org.apache.logging.log4j.core.appender.ConsoleAppender;
import org.apache.logging.log4j.core.config.AppenderRef;
import org.apache.logging.log4j.core.config.Configuration;
import org.apache.logging.log4j.core.config.Configurator;
import org.apache.logging.log4j.core.config.LoggerConfig;
import org.apache.logging.log4j.core.layout.PatternLayout;

/**
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 *
 *
 * @author William Peterson
 *
 */
public class DicomDCFCommonBase extends TestCase {
  
    public static Logger TESTLOGGER = null; //Logger.getLogger("JUNIT_TEST");
    //public static Logger logger = LogManager.getRootLogger();
    public static ConsoleAppender appender;


    /*
     * @see TestCase#setUp()
     */
    @SuppressWarnings("deprecation")
	protected void setUp() throws Exception {
        super.setUp();
        // Removed; unused
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
    public DicomDCFCommonBase(String arg0) {
        super(arg0);
    }

}
