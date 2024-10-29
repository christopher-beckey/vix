/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 27, 2012
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
package gov.va.med.imaging.imagegear.datasource;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.disclosure.pdf.PdfStatusReturnCode;
import gov.va.med.imaging.disclosure.pdf.ROIMakePDFDebugMode;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedImageInputStream;
import gov.va.med.imaging.exchange.storage.DataSourceImageInputStream;
import gov.va.med.imaging.roi.datasource.ImageMergeWriterDataSourceSpi;
import gov.va.med.imaging.utils.FileUtilities;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ImageGearImageMergeWriterDataSourceService
extends AbstractImageGearDataSourceService
implements ImageMergeWriterDataSourceSpi
{
	public final static String SUPPORTED_PROTOCOL = "imagegear";
	public final static float protocolVersion = 1.0F;
	
	public ImageGearImageMergeWriterDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	{
		super(resolvedArtifactSource, protocol);
	}
	
	// to support local data source
	public ImageGearImageMergeWriterDataSourceService(ResolvedArtifactSource resolvedArtifactSource)
	{
		super(resolvedArtifactSource, SUPPORTED_PROTOCOL);
	}

	@Override
	public OutputStream getOutputStream(String groupIdentifier, String objectIdentifier, ImageFormat imageFormat, String objectDescription) 
	throws ConnectionException, MethodException
	{
		try {
			setDataSourceMethodVersionAndProtocol("getOutputStream", getDataSourceVersion());

			File outputDirectory = getGroupDirectory(groupIdentifier);
			outputDirectory.mkdirs();
			String filename = outputDirectory.getAbsolutePath() + File.separator + objectIdentifier + "." + imageFormat.getDefaultFileExtension();

			// after the file is written the manifest file should be added with the entry
			// not really able to do after file is written
			appendObjectToInputManifest(groupIdentifier, filename, objectDescription);
			try {
				return new FileOutputStream(filename);
			} catch (FileNotFoundException e) {
				throw new MethodException("ImageGearImageMergeWriterDataSourceService.getOutputStream() --> FileNotFoundException creating output file stream: " + e.getMessage());
			}
		} catch (IOException e) {
			throw new MethodException("ImageGearImageMergeWriterDataSourceService.getOutputStream() --> IOException creating output file stream: " + e.getMessage());
		}
	}
	
	private void appendObjectToInputManifest(String groupIdentifier, String filename, String objectDescription) 
	throws MethodException
	{
		try
		{
			File manifestFile = getGroupFileList(groupIdentifier);
			BufferedWriter writer = new BufferedWriter(new FileWriter(manifestFile, true));
			writer.write(filename + "^" + objectDescription + "\n");
			writer.close();
		} 
		catch (IOException ioX)
		{
			throw new MethodException("ImageGearImageMergeWriterDataSourceService.appendObjectToInputManifest() --> Error writing to input manifest file: " + ioX.getMessage());
		}	
	}
	
	private File getGroupFileList(String groupIdentifier) throws IOException
	{
		File outputDirectory = getGroupDirectory(groupIdentifier);
		return FileUtilities.getFile( outputDirectory.getAbsolutePath() + File.separatorChar + groupIdentifier + ".txt");
	}
	
	private File getGroupDirectory(String groupIdentifier) throws IOException
	{
		String groupOutputDirectory = getImageGearConfiguration().getGroupOutputDirectory();
		groupOutputDirectory = groupOutputDirectory + File.separatorChar + groupIdentifier;
		return FileUtilities.getFile(groupOutputDirectory);
	}

	@Override
	public DataSourceImageInputStream mergeObjects(String groupIdentifier, Patient patient)
	throws ConnectionException, MethodException
	{
		try 
		{
			getStatistics().incrementDisclosureWriteRequests();
			setDataSourceMethodVersionAndProtocol("mergeObjects", getDataSourceVersion());

			File groupDirectory = getGroupDirectory(groupIdentifier);
			File groupFile = getGroupFileList(groupIdentifier); // list of input files
			File manifestDirectory = new File(groupDirectory.getAbsolutePath() + File.separatorChar + "output");
			String debugOutputFilename = groupDirectory.getAbsolutePath() + File.separatorChar + "pdf_disclosure.log";
			int retVal = -1;
			
			Process process = createExecutingProcess(groupIdentifier, groupFile, groupDirectory, manifestDirectory, patient);
			
			try(InputStream is = process.getInputStream();
				InputStreamReader isr = new InputStreamReader(is);	
				BufferedReader br = new BufferedReader(isr);
				FileWriter fw = new FileWriter(debugOutputFilename, false);
				BufferedWriter debugWriter = new BufferedWriter(fw);)
			{				
				String line = null;

				while ((line = br.readLine()) != null) 
				{
					debugWriter.write(line + "\n");
				}

				CountDownLatch countdownLatch = new CountDownLatch(1);
				long timeout = getImageGearConfiguration().getThreadTimeoutMs();
				ImageGearWorkerThread thread = new ImageGearWorkerThread(process, countdownLatch, "PDF Merge [" + groupIdentifier + "]");
				thread.start();
				
				try 
				{
                    getLogger().debug("ImageGearImageMergeWriterDataSourceService.mergeObjects() --> Waiting [{} ms] for PDF thread to complete.", timeout);
					countdownLatch.await(timeout, TimeUnit.MILLISECONDS);
				} catch (InterruptedException x) {
					String msg = "ImageGearImageMergeWriterDataSourceService.mergeObjects() --> InterruptedException waiting for thread to generate PDF: " + x.getMessage();
					getLogger().error(msg);
					throw new MethodException(msg, x);
				}

				if (countdownLatch.getCount() > 0)
					throw new MethodException("ImageGearImageMergeWriterDataSourceService.mergeObjects() --> Unable to create PDF in allowed time [" + timeout + " ms]");
				
				retVal = thread.getExitCode();
                getLogger().debug("ImageGearImageMergeWriterDataSourceService.mergeObjects() --> PDF process completed with exit code [{}]", retVal);
				
				debugWriter.flush();	
			} 
			catch (Exception ex) 
			{
				getStatistics().incrementDisclosureWriteFailures();
				String msg = "ImageGearImageMergeWriterDataSourceService.mergeObjects() --> Encountered exception [" + ex.getClass().getSimpleName() + "] while generating PDF disclosure: " + ex.getMessage();
				getLogger().error(msg);
				throw new MethodException(msg);
			}

			PdfStatusReturnCode returnCode = PdfStatusReturnCode.getFromCode(retVal);
			
			if (returnCode == PdfStatusReturnCode.success) 
			{
				getLogger().info("ImageGearImageMergeWriterDataSourceService.mergeObjects() --> Completed generating PDF result, status is success. Rolling up results into zip file");
				ByteStreamPump pump = ByteStreamPump.getByteStreamPump();
				// output should be in the manifestDirectory
				File zipFile = new File(groupDirectory.getAbsolutePath() + File.separatorChar + "result.zip");
				
				try (FileOutputStream fos = new FileOutputStream(zipFile);
					 ZipOutputStream zipStream = new ZipOutputStream(fos);)
				{
					File [] files = manifestDirectory.listFiles();
					for (File file : files) {
						ZipEntry entry = new ZipEntry(file.getName());
						entry.setSize(file.length());
						zipStream.putNextEntry(entry);

						FileInputStream input = new FileInputStream(file);
						pump.xfer(input, zipStream);
						input.close();
					}
					
					getLogger().info("ImageGearImageMergeWriterDataSourceService.mergeObjects() --> Zip file created, returning input stream to zip file");
					getStatistics().incrementDisclosureWriteSuccess();
					
					return new ByteBufferBackedImageInputStream(new FileInputStream(zipFile), (int) zipFile.length());
				} 
				catch (Exception ex) 
				{
					getStatistics().incrementDisclosureWriteFailures();
					String msg = "ImageGearImageMergeWriterDataSourceService.mergeObjects() --> Encountered exception [" + ex.getClass().getSimpleName() + "] while creating zip output stream: " + ex.getMessage();
					getLogger().error(msg);
					throw new MethodException(msg);
				}
			} 
			else 
			{
				getStatistics().incrementDisclosureWriteFailures();
				throw new MethodException("ImageGearImageMergeWriterDataSourceService.mergeObjects() --> Error merging artifacts into PDF, returned status [" + (returnCode == null ? retVal : returnCode.getDescription()) + "]");
			}
		} 
		catch (IOException e) 
		{
			throw new MethodException("ImageGearImageMergeWriterDataSourceService.mergeObjects() --> IOException: " + e.getMessage());
		}
	}
	
	private Process createExecutingProcess(String groupIdentifier, 
			File groupFile, File groupDirectory, File manifestDirectory, Patient patient)
	throws IOException
	{ 
		ROIMakePDFDebugMode debugMode = getDebugMode();
			
		DateFormat dateFormat = new SimpleDateFormat("MMMM_dd_yyyy");
		DateFormat timeFormat = new SimpleDateFormat("kk_mm_ss");
		DateFormat dobFormat = new SimpleDateFormat("MM/dd/yyyy");
			
		Calendar now = Calendar.getInstance();	
		String roiOfficeName = getImageGearConfiguration().getRoiOfficeName();
		String ssn = patient.getFilteredSsn();
		
		StringBuilder sb = new StringBuilder();
		String pdfExecutable = getImageGearConfiguration().getPdfGeneratorExePath();
		sb.append(pdfExecutable);
		sb.append(" \"" + groupIdentifier + "\"");
		sb.append(" \"" + debugMode.getValue() + "\"");
		sb.append(" \"" + roiOfficeName + "\"");		
		//sb.append(" \"" + groupFile.getAbsolutePath()  + "\"");
		sb.append(" \"" + groupDirectory.getAbsolutePath() + "\""); // this is where it looks for the input file, it appends the groupIdentifier and .txt
		sb.append(" \"" + groupDirectory.getAbsolutePath() + "\"");
		sb.append(" \"" + manifestDirectory.getName() + "\"");
		sb.append(" \"" + patient.getPatientName() + "\"");
		if(patient.isPatientIcnIncluded())
			sb.append(" \"" + patient.getPatientIcn() + "\"");
		else
			sb.append(" \"" + patient.getDfn() + "\"");
		sb.append(" \"" + ssn + "\"");
		sb.append(" \"" + dobFormat.format(patient.getDob()) + "\"");
		sb.append(" \"" + dateFormat.format(now.getTime()) + "\"");
		sb.append(" \"" + timeFormat.format(now.getTime()) + "\"");
        getLogger().debug("ImageGearImageMergeWriterDataSourceService.createExecutingProcess() --> Creating executing PDF merge process [{}]", sb.toString());
		
		// not outputting to the transaction log because it contains patient identification information we don't want in the transaction log
		
		return Runtime.getRuntime().exec(sb.toString());
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityException
	{
		return true;
	}
	
	protected String getDataSourceVersion()
	{
		return "1";
	}
}
