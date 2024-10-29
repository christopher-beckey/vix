/**
 * 
 */
package gov.va.med;

import java.io.IOException;
import java.nio.charset.Charset;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.core.Appender;
import org.apache.logging.log4j.core.LoggerContext;
import org.apache.logging.log4j.core.appender.FileAppender;
import org.apache.logging.log4j.core.config.AppenderRef;
import org.apache.logging.log4j.core.config.Configuration;
import org.apache.logging.log4j.core.config.LoggerConfig;
import org.apache.logging.log4j.core.layout.PatternLayout;

/**
 * A cheap little appender that is convenient for debugging.
 * Each time it is started it will create a new file based on the 
 * time.  Other than that, it is just a derivation of FileAppender.
 * This appender makes no attempt to clean up old files so its use in
 * a production system is strongly discouraged.
 * 
 * @author vhaiswbeckec
 *
 */
public class DebugFileAppender
//extends FileAppender
//implements org. apache.log4j.Appender
{
	private static String fileExtension = ".log";
	private static String dateFormatSpecification = "ddMMyyyy-hhmm"; 
	private static DateFormat df = new SimpleDateFormat(dateFormatSpecification);
	private static String filenameRoot = null;
	
	private static String generateFilename(String filenameRoot)
	{
		return filenameRoot == null ? "appender" : "" + filenameRoot + df.format(new Date()) + fileExtension;
	}

	
	/**
	 * @throws IOException 
	 * 
	 */
	@SuppressWarnings("deprecation")
	public DebugFileAppender() throws IOException
	{
		this(PatternLayout.createLayout(
				"%d{DATE} %5p [%t] (%F:%L) - %m%n", 
				null, 
				null, 
				null, 
				Charset.defaultCharset(), 
				false,
				false,
				null,
				null), 
			generateFilename(filenameRoot));
	}

	/**
	 * @param layout
	 * @param filename
	 * @throws IOException
	 */
	public DebugFileAppender(PatternLayout layout, String filenameRoot) 
	throws IOException
	{
		//super(layout, generateFilename(filenameRoot));
		this(layout, generateFilename(filenameRoot), false);
	}

	/**
	 * @param layout
	 * @param filename
	 * @param append
	 * @throws IOException
	 */
	public DebugFileAppender(PatternLayout layout, String filenameRoot, boolean append)
			throws IOException
	{
		//super(layout, generateFilename(filenameRoot), append);
		this(layout, generateFilename(filenameRoot), append, true, 4000);
	}

	/**
	 * @param layout
	 * @param filename
	 * @param append
	 * @param bufferedIO
	 * @param bufferSize
	 * @throws IOException
	 */
	@SuppressWarnings({ "deprecation"})
	public DebugFileAppender(PatternLayout layout, String filenameRoot, boolean append,
			boolean bufferedIO, int bufferSize) throws IOException
	{
		// Removed; should remove entire class.
	}

	public void setFilenameRoot(String pfilenameRoot)
	{
		filenameRoot = pfilenameRoot;
		//setFile(generateFilename(filenameRoot));
	}
}
