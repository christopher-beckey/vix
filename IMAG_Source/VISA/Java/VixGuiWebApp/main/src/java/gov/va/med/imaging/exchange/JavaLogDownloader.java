/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 16, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.exchange;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.FacadeRouterUtility;

/**
 * Servlet to provide the ability to download a java log from the VIX
 * 
 * @author vhaiswwerfej
 *
 */
public class JavaLogDownloader extends HttpServlet {
	public final int MAX_REQUEST_SIZE = 8192; // 8KB

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private transient Logger logger = Logger.getLogger(this.getClass());

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String filename = request.getParameter("filename");
		if (filename == null)
			throw new ServletException("Missing filename input parameter");
		if (filename.indexOf("..") >= 0) // an attempt to keep someone from downloading from anywhere on the machine
			throw new ServletException("Invalid filename input parameter, cannot include '..' in path");

		// Turn logger off to avoid recursive logging
        logger.debug("Filename to download: {}", filename);

		try {
			if (filename.toLowerCase().endsWith(".zip")) {
				processZip(filename, response);
			} else {
				processText(filename, response);
			}
		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}

	private void processText(String filepath, HttpServletResponse response) throws Exception {

		LogLineDecryptor logLineDecryptor = new LogLineDecryptor();
		logLineDecryptor.setDisableLogging(filepath.toLowerCase().contains("imagingexchangewebapp"));

		// clear the cache-control and pragma to fix IE issue where it can't download
		// the logs.
		// http://support.microsoft.com/default.aspx?scid=kb;en-us;316431
		// IE tries to obey the no-caching rule and cannot download the file, clearing
		// these headers fixes the issue
		response.setHeader("Pragma", "");
		response.setHeader("Cache-Control", "");
		VixGuiWebAppRouter router = FacadeRouterUtility.getFacadeRouter(VixGuiWebAppRouter.class);

		response.setContentType("text/plain");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + getFileName(filepath) + "\"");

		InputStream inputStream = router.getJavaLogFile(filepath);
		LineReader reader = new LineReader(new InputStreamReader(inputStream), new char[] { 0x0D, 0x0A });
		OutputStreamWriter writer = new OutputStreamWriter(response.getOutputStream());

		for (String logLine = reader.readLine(); logLine != null; logLine = reader.readLine()) {
			logLine = logLine.replaceAll("\\x0a", "");
			writer.write(logLineDecryptor.decryptLine(logLine) + "\r\n");
		}

		reader.close();
		writer.flush();
		writer.close();
	}

	private void processZip(String filepath, HttpServletResponse response) throws Exception {
		// clear the cache-control and pragma to fix IE issue where it can't download
		// the logs.
		// http://support.microsoft.com/default.aspx?scid=kb;en-us;316431
		// IE tries to obey the no-caching rule and cannot download the file, clearing
		// these headers fixes the issue
		response.setHeader("Pragma", "");
		response.setHeader("Cache-Control", "");
		VixGuiWebAppRouter router = FacadeRouterUtility.getFacadeRouter(VixGuiWebAppRouter.class);

		response.setContentType("application/zip");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + getFileName(filepath) + "\"");

		InputStream inputStream = router.getJavaLogFile(filepath);
		PrintStream writer = new PrintStream(response.getOutputStream());

		pipeContent(inputStream, writer);
		writer.flush();
		writer.close();
	}

	private void pipeContent(final InputStream content, final PrintStream output) throws IOException {
		final byte[] buffer = new byte[MAX_REQUEST_SIZE];
		int read;
		while ((read = content.read(buffer)) >= 1) {
			output.write(buffer, 0, read);
		}
	}
	
	private String getFileName(String path) throws IOException {
		if(path==null) {
			throw new IOException("File path was not defined");
		}
		return StringUtil.cleanString(FilenameUtils.getName(path));
	}

}
