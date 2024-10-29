/*
 * Created on Nov 18, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package gov.va.med.imaging.pixeledit;

import gov.va.med.imaging.dicom.dcftoolkit.utilities.reconstitution.DicomFileExtractor;
import junit.framework.TestCase;

import java.nio.charset.Charset;

import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;
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
public class PixelEditTestBase extends TestCase {
  
    protected static Logger testLogger = null; //Logger.getLogger("JUNIT_TEST");
    private static Logger logger = null; //Logger.getLogger (PixelEditTestBase.class);
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
     * Constructor for PixelEditTestBase.
     * @param arg0
     */
    public PixelEditTestBase(String arg0) {
        super(arg0);
    }

}
