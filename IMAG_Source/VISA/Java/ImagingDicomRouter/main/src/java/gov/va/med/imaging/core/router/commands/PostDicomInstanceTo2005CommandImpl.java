/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.nio.channels.ReadableByteChannel;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * This command is the driver for storing a DICOM instance. It performs
 * validation of the patient and imaging service request, check UIDs and coerces
 * them if necessary, determines whether the instance is an "old" or "new" SOP
 * class, and stores the instance appropriately.
 * 
 * @author vhaiswlouthj
 * 
 */
public class PostDicomInstanceTo2005CommandImpl extends AbstractDicomCommandImpl<Boolean>
{
	private static final long serialVersionUID = -4963797794965394068L;
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
	private static Logger logger = Logger.getLogger(PostDicomInstanceTo2005CommandImpl.class);

	private final IDicomDataSet dds;
	private final InstrumentConfig instrument;
	private final ReadableByteChannel instanceChannel;
	private final InputStream inputStream;
    private final DicomAE dicomAE;
    
	// DICOM import variables
	private final String originIndex;
	

	/**
	 * @param router
	 * @param asynchronousMethodProcessor
	 */
	public PostDicomInstanceTo2005CommandImpl(IDicomDataSet dds, DicomAE dicomAE, 
			InstrumentConfig instrument, ReadableByteChannel instanceChannel, 
			InputStream inputStream, String originIndex)
	{
		super();
		this.dds = dds;
		this.dicomAE = dicomAE;
		this.instrument = instrument;
		this.instanceChannel = instanceChannel;
		this.inputStream = inputStream;
		
		
		// DICOM import fields
		this.originIndex = originIndex;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see gov.va.med.imaging.core.router.AsynchronousCommandProcessor#callInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext() throws MethodException, ConnectionException
	{
		String sAEPortAndThreadID = "";
		try
		{
			TransactionContext transactionContext = TransactionContextFactory.get();
			transactionContext.setServicedSource(DicomServerConfiguration.getConfiguration().getSiteId());

			// Ask the M gateway to create a queue entry and return us a temporary filename 
			// so we can write out our new file.
			String[] data = GatewayTcpConnection.getTemporaryFilenameAndIEN(
					instrument.getNickName(), 
					originIndex);
			
			String tempFilename = data[0];
			String ien = data[1];
			sAEPortAndThreadID = "[" + dicomAE.getRemoteAETitle() + "->" + 
			   instrument.getPort() + "/" + Long.toString(Thread.currentThread().getId()) + "]";

			// Write out the file using the filename received from the M gateway.
            logger.info("Received filename from gateway: {}. Starting to write file {}.", tempFilename, sAEPortAndThreadID);
			Long t0 = System.currentTimeMillis();
			FileOutputStream outputStream = new FileOutputStream(new File(StringUtil.toSystemFileSeparator(StringUtil.cleanString(tempFilename))));
				
			// Fortify change: added try/catch/finally blocks to close resources
			try 
			{
				writeFileToDisk(outputStream);
			}
			catch(FileNotFoundException fnf)
			{
				logger.error("callSynchronouslyInTransactionContext() --> encountered FileNotFoundException", fnf);
				throw new MethodException(fnf.getMessage(), fnf);
			}
			catch(IOException iox)
			{
				logger.error("callSynchronouslyInTransactionContext() --> encountered IOException", iox);
				throw new MethodException(iox.getMessage(), iox);
			}
			finally
			{
	        	try{ if(outputStream != null) { outputStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
	        	try{ if(inputStream != null) { inputStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}

			// Close the streams
			//	outputStream.close();
			//	inputStream.close(); // Hummm.....don't create it but still close it???
			}
			
		    // Get the time delta
			Long deltaT = System.currentTimeMillis()-t0;

            logger.info("Disk Dump Time = {} ms {}.", deltaT.toString(), sAEPortAndThreadID);

		    // Tell the M gateway that the file has been written out, so that it
			// can add update the queue entry to complete, allowing image processing to 
		   	// process the file
            logger.info("Requesting queue entry for ien {}. File has been written to {} {}.", ien, tempFilename, sAEPortAndThreadID);
			GatewayTcpConnection.requestQueueEntry(ien);
			
		}
		catch (FileNotFoundException e)
		{
            logger.error("Could not create file to write out DICOM object {}.", sAEPortAndThreadID);
			throw new MethodException(e);
		}
		catch (IOException e)
		{
            logger.error("Could not write to temporary DICOM file {}.", sAEPortAndThreadID);
			throw new MethodException(e);
		}
		catch (Exception e)
		{
			logger.error(e.getMessage(), e);
			throw new MethodException(e);
		}

		return true;
	}

	private void writeFileToDisk(FileOutputStream outputStream) throws FileNotFoundException, IOException
	{
		
		byte buf[]=new byte[1024];
		int len;
		while((len=inputStream.read(buf))>0)
		{
			outputStream.write(buf,0,len);
		}
	}


	private static class GatewayTcpConnection
	{
		private static String GET_TEMPORARY_FILENAME = "FileNameRequest^";
		private static String REQUEST_QUEUE_ENTRY = "FileCreated^";
		
		public static String[] getTemporaryFilenameAndIEN(String instrumentName, String originIndex) throws IOException
		{
			// Initialize the request with pieces 1 and 2, the requested action, 
			// and the instrument name
			String request = GET_TEMPORARY_FILENAME + instrumentName;

			//
			// If this is a DICOM import request, which requires additional information such
			// as the origin index, media type, and original path, fill in pieces 3, 4, and 5
			// in the request string
			//
			if (!originIndex.trim().equals(""))
			{
				request += "^" + originIndex;
			}
			
			// Send the request and get the return value
			String returnValue = sendRequest(request);

			return StringUtil.split(returnValue, StringUtil.CARET);
		}
		
		public static String requestQueueEntry(String fileName) throws IOException
		{
			return sendRequest(REQUEST_QUEUE_ENTRY + fileName);
		}
		
		private static String sendRequest(String request) throws IOException
		{
			
			String response = "";
			String address = config.getLegacyGatewayAddress();
			int port = config.getLegacyGatewayPort();
			Socket socket = null;
			try {
				socket = new Socket(address, port);
				socket.setSoTimeout(10000);
				PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
				BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

				// Write out the message to the server
				String reqMsg = StringUtil.cleanString(request);
				out.println(reqMsg);
				out.flush();

				// Read the response lines from the server, and assemble them into a response
				String responseLine = "";

				// Fortify change: added try/catch/finally blocks to close resources
				try {
					while ((responseLine = in.readLine()) != null) {
						response += responseLine + "\n";
					}
				} catch (IOException iox) {
					logger.error("sendRequest() --> encountered IOException", iox);
					throw iox;
				} finally {
					try {
						if (in != null) {
							in.close();
						}
					} catch (Exception exc) {/*unrecoverable so do nothing*/}
					try {
						if (out != null) {
							out.close();
						}
					} catch (Exception exc) {/*unrecoverable so do nothing*/}

				}
			} finally {
				try {
					if (socket != null) {
						socket.close();
					}
				} catch (Exception exc) {/*unrecoverable so do nothing*/}
			}
			
			if (response.endsWith(StringUtil.NEW_LINE))
			{
				response = response.substring(0, response.length() - StringUtil.NEW_LINE.length());
			}
			//socket.close();	
			if(logger.isDebugEnabled()){
                logger.debug("Request to port [{}]:{} --> Response: {}", port, request, response);}
			return response;
			
		}

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#hashCode()
	 */
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.dds == null) ? 0 : this.dds.hashCode());
		result = prime * result + ((this.instanceChannel == null) ? 0 : this.instanceChannel.hashCode());
		result = prime * result + ((this.instrument == null) ? 0 : this.instrument.hashCode());

		return result;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj)
	{
		// Perform cast for subsequent tests
		final PostDicomInstanceTo2005CommandImpl other = (PostDicomInstanceTo2005CommandImpl) obj;

		// Check the studyUrn
		boolean areFieldsEqual = areFieldsEqual(this.dds, other.dds);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.instanceChannel, other.instanceChannel);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.instrument, other.instrument);
		return areFieldsEqual;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see gov.va.med.imaging.core.router.AsynchronousCommandProcessor#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		StringBuffer sb = new StringBuffer();

		sb.append(this.dds.toString());
		sb.append(this.instanceChannel.toString());

		return sb.toString();
	}

}
