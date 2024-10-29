/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 23, 2012
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

import gov.va.med.imaging.GUID;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.disclosure.pdf.PdfStatusReturnCode;
import gov.va.med.imaging.disclosure.pdf.ROIMakePDFDebugMode;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedInputStream;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.roi.datasource.ImageAnnotationWriterDataSourceSpi;
import gov.va.med.imaging.utils.FileUtilities;

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
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ImageGearImageAnnotationWriterDataSourceService
extends AbstractImageGearDataSourceService
implements ImageAnnotationWriterDataSourceSpi
{
	public final static String SUPPORTED_PROTOCOL = "imagegear";
	public final static float protocolVersion = 1.0F;
	
	public ImageGearImageAnnotationWriterDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	{
		super(resolvedArtifactSource, protocol);
	}
	
	// to support local data source
	public ImageGearImageAnnotationWriterDataSourceService(ResolvedArtifactSource resolvedArtifactSource)
	{
		super(resolvedArtifactSource, SUPPORTED_PROTOCOL);
	}
	
	private final static ByteStreamPump pump = ByteStreamPump.getByteStreamPump();

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.roi.datasource.ImageAnnotationWriterDataSourceSpi#burnImageAnnotations(java.io.InputStream, gov.va.med.imaging.roi.datasource.ImageAnnotationDetails)
	 */
	@Override
	public DataSourceInputStream burnImageAnnotations(InputStream inputStream, ImageFormat imageFormat, ImageAnnotationDetails imageAnnotationDetails)
	throws MethodException, ConnectionException
	{
		GUID guid = new GUID();

		setDataSourceMethodVersionAndProtocol("burnImageAnnotations", getDataSourceVersion());
		getStatistics().incrementBurnAnnotationRequests();
        getLogger().info("ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> Writing annotations to directory [{}]", guid.toLongString());
		String groupOutputDirectory = getImageGearConfiguration().getGroupOutputDirectory() + File.separator + guid.toLongString();

		try 
		{
			File outputDirectory = FileUtilities.getFile(groupOutputDirectory);
			outputDirectory.mkdirs();

			File imageFile = new File(outputDirectory.getAbsolutePath() + File.separator + "image" + "." + imageFormat.getDefaultFileExtension());
			
			try(FileOutputStream imageOutputStream = new FileOutputStream(imageFile, false);)
			{
				pump.xfer(inputStream, imageOutputStream);
			} 
			catch (Exception ex) 
			{
				getStatistics().incrementBurnAnnotationFailures();
				String msg = "ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> While creating output file [" + imageFile.getAbsolutePath() + "], encountered exception [" + ex.getClass().getSimpleName() + "]: " + ex.getMessage(); 
				getLogger().error(msg);
				throw new MethodException(msg);
			} 

			File annotationFile = new File(outputDirectory.getAbsolutePath() + File.separator + "annotations.xml");
			
			try(FileWriter innerFileWriter = new FileWriter(annotationFile, false);
				BufferedWriter annotationWriter = new BufferedWriter(innerFileWriter);) 
			{
				annotationWriter.write(imageAnnotationDetails.getAnnotationXml());
				annotationWriter.flush();
			} 
			catch(IOException iox) 
			{
				getStatistics().incrementBurnAnnotationFailures();
				String msg = "ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> While writing to annotation file [" + annotationFile.getAbsolutePath() + "], encountered [IOException]: " + iox.getMessage();
				getLogger().error(msg);
				throw new MethodException(msg);
			}

			String debugOutputFilename = outputDirectory.getAbsolutePath() + File.separator + "burn_annotation.log";
			Process process = null;
			
			try
			{
				process = createExecutingProcess(guid.toLongString(), imageFile, annotationFile, outputDirectory.getAbsoluteFile());
			}
			catch(IOException iox) 
			{
				getStatistics().incrementBurnAnnotationFailures();
				String msg = "ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> While creating process to write to: " + iox.getMessage();
				getLogger().error(msg);
				throw new MethodException(msg);
			}
			
			int retVal = -1;
			
			try(FileWriter innerDebugWriter = new FileWriter(debugOutputFilename, false);
				BufferedWriter debugWriter = new BufferedWriter(innerDebugWriter);
				InputStream is = process.getInputStream();
				InputStreamReader isr = new InputStreamReader(is);
				BufferedReader br = new BufferedReader(isr);) 
			{
				String line = null;

				while ((line = br.readLine()) != null) 
				{
					debugWriter.write(line + "\n");
				}

				CountDownLatch countdownLatch = new CountDownLatch(1);
				long timeout = getImageGearConfiguration().getThreadTimeoutMs();
				ImageGearWorkerThread thread = new ImageGearWorkerThread(process, countdownLatch, "Burn Annotation [" + guid.toLongString() + "]");
				thread.start();
				
				try 
				{
                    getLogger().debug("ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> Waiting [{} ms] for Annotation Burn thread to complete.", timeout);
					countdownLatch.await(timeout, TimeUnit.MILLISECONDS);
				} 
				catch (InterruptedException x) 
				{
					String msg = "ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> InterruptedException while waiting for thread to burn annotations: " + x.getMessage();
					getLogger().error(msg);
					throw new MethodException(msg, x);
				}

				if (countdownLatch.getCount() > 0)
					throw new MethodException("ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> Unable to burn annotations in allowed time [" + timeout + " ms]");
				
				retVal = thread.getExitCode();

                getLogger().debug("ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> Annotation Burn completed with exit code [{}]", retVal);

				debugWriter.flush();

				PdfStatusReturnCode returnCode = PdfStatusReturnCode.getFromCode(retVal);
				if (returnCode == PdfStatusReturnCode.success) 
				{
					File annotatedFile = new File(outputDirectory.getAbsolutePath() + File.separator + "image_Annotated." + imageFormat.getDefaultFileExtension());
					getLogger().info("ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> Successfully burned in image annotations, status is success. Returning input stream to annotated image");
					if (annotatedFile.exists()) 
					{
						try(FileInputStream fis = new FileInputStream(annotatedFile);) 
						{
							ByteBufferBackedInputStream result = new ByteBufferBackedInputStream(fis, (int) annotatedFile.length());
							getStatistics().incrementBurnAnnotationSuccess();
							return result;
						} 
						catch (FileNotFoundException fnfX) 
						{
							getStatistics().incrementBurnAnnotationFailures();
							throw new MethodException("ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> FileNotFoundException opening annotated image: " + fnfX.getMessage(), fnfX);
						}
					} else {
						getStatistics().incrementBurnAnnotationFailures();
						throw new MethodException("ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> Annotated File does not exist despite successful response from created annotated image");
					}
				} else {
					getStatistics().incrementBurnAnnotationFailures();
					throw new MethodException("ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> Error burning annotations into image, returned status [" + retVal + "]");
				}
			} // Too much rework for all these try blocks !!!
			catch (Exception ex) 
			{
				String msg = "ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> Encountered exception [" + ex.getClass().getSimpleName() + "] while burning image annotations: " + ex.getMessage();
				getLogger().error(msg);
				getStatistics().incrementBurnAnnotationFailures();
				throw new MethodException(msg, ex);
			}
		} catch(Exception ex) {
			String msg = "ImageGearImageAnnotationWriterDataSourceService.burnImageAnnotations() --> Encountered exception [" + ex.getClass().getSimpleName() + "] while burning image annotations: " + ex.getMessage();
			getLogger().error(msg);
			getStatistics().incrementBurnAnnotationFailures();
			throw new MethodException(msg, ex);
		}
	}
	
	private Process createExecutingProcess(String jobId, File imageFile, File annotationsXml, File outputFile)
	throws IOException
	{
		ROIMakePDFDebugMode debugMode = getDebugMode();
		
		StringBuilder sb = new StringBuilder();
		String annotationExecutable = getImageGearConfiguration().getBurnAnnotationsExePath();
		sb.append(annotationExecutable);
		sb.append(" \"" + jobId + "\"");
		sb.append(" \"" + debugMode.getValue() + "\"");
		sb.append(" \"" + imageFile.getAbsolutePath() + "\"");		
		sb.append(" \"" + annotationsXml.getAbsolutePath() + "\"");
		sb.append(" \"" + outputFile.getAbsolutePath() + "\"");
        getLogger().debug("ImageGearImageAnnotationWriterDataSourceService.createExecutingProcess() --> Getting burn process [{}]", sb.toString());
		
		// not outputting to the transaction log because it contains patient identification information we don't want in the transaction log
		
		return  Runtime.getRuntime().exec(sb.toString());
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
