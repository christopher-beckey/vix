package gov.va.med.imaging.exchange;

import gov.va.med.imaging.DateUtil;
import gov.va.med.imaging.access.TransactionLogEntry;
import gov.va.med.imaging.access.TransactionLogWriter;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.enums.DatasourceProtocol;
import gov.va.med.imaging.exchange.enums.ImageQuality;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import gov.va.med.logging.Logger;


/**
 * Class/servlet to stream the log entries into file of requested mime type
 * (either CSV or TSV). XLS code is also here but not used.
 * 
 * @author VHAISWBECKEC
 * @author VHAISPNGUYEQ (reworked)
 *
 */
public class ExcelTransactionLog extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(ExcelTransactionLog.class);
	
	/**
	 * Default constructor
	 */
	public ExcelTransactionLog() {
		super();
	}

	/**
	 * Initialization of the servlet
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Do nothing
	}

	/**
	 * Returns information about the servlet such as 
	 * author, version, and copyright. 
	 *
	 * @return String information about this servlet
	 * 
	 */
	public String getServletInfo() {
		return "Transaction Log CSV and TSV (XLS is available but not used) Generation Servlet";
	}

	/**
	 * The doGet method of the servlet
	 *
	 * @param HttpServletRequest		standard 'request' object sent by the client to the server
	 * @param HttpServletResponse		standard 'response' object sent by the server to the client
	 * 
	 * @throws ServletException | IOException
	 * 
	 */
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		String fromFormat = "yyyy-MM-dd HH:mm";
		String toFormat = "MM/dd/yyyy HH:mm:ss";
		
		String fromDateParam = req.getParameter("fromDate");
		String toDateParam = req.getParameter("toDate");

        LOGGER.info("ExcelTransactionLog.doGet() --> fromDateParam [{}], toDateParam [{}]", fromDateParam, toDateParam);
		
		// Apply formatting corrections to the "from" format if we have the older one available, or default to the current date
		if (fromDateParam == null) {
			fromDateParam = new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + " 00:00";
			LOGGER.info("ExcelTransactionLog.doGet() --> fromDateParam defaulted to current date as [{}]", fromDateParam);
		} else if (fromDateParam.matches("\\d\\d/\\d\\d/\\d\\d\\d\\d \\d\\d:\\d\\d.*")) {
			fromDateParam = fromDateParam.replaceFirst("(\\d\\d)/(\\d\\d)/(\\d\\d\\d\\d) (\\d\\d):(\\d\\d).*", "$3-$1-$2 $4:$5");
			LOGGER.info("ExcelTransactionLog.doGet() --> fromDateParam reformatted as [{}]", fromDateParam);
		}
		if (toDateParam == null) {
			toDateParam = new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + " 23:59";
			LOGGER.info("ExcelTransactionLog.doGet() --> toDateParam defaulted to current date as [{}]", toDateParam);
		} else if (toDateParam.matches("\\d\\d/\\d\\d/\\d\\d\\d\\d \\d\\d:\\d\\d.*")) {
			toDateParam = toDateParam.replaceFirst("(\\d\\d)/(\\d\\d)/(\\d\\d\\d\\d) (\\d\\d):(\\d\\d).*", "$3-$1-$2 $4:$5");
			LOGGER.info("ExcelTransactionLog.doGet() --> toDateParam reformatted as [{}]", toDateParam);
		}
		
		ContentType contentType = req.getParameter("format") == null 
								  ? ContentType.getByAcceptHeader(req.getHeader("accept")) 
								  : ContentType.getByAcceptHeader(req.getParameter("format"));	
		
		resp.setContentType(contentType.getMimeType());

		try {
					
			Date fromDate = formatter.parse(DateUtil.changeDateFormat(fromDateParam, fromFormat, toFormat));
			Date toDate = formatter.parse(DateUtil.changeDateFormat(toDateParam, fromFormat, toFormat));
					
			// No button for XLS on the GUI. Leave for future
			if(contentType == ContentType.XLS) {
				
				resp.setHeader("Content-Disposition", "attachment; filename=\"TransactionLogs.xls\"");
				
				/*
					streamContentAsXLS(response.getOutputStream(), fromDate, toDate, imageQuality, user, modality, 
								   datasourceProtocol, errorMessage, imageUrn, transactionId);
				*/
				
				streamContentAsXLS(resp.getOutputStream(), fromDate, toDate, null, null, null, null, null, null, null);
						
				resp.getOutputStream().flush();
				
			} else {
				
				resp.setHeader("Content-Disposition", 
									"attachment; filename=\"TransactionLogs." + (contentType == ContentType.CSV ? "csv" : "tsv") + "\"");
				streamContent(resp.getWriter(), fromDate, toDate, contentType == ContentType.CSV ? "," : "\t");
						
				resp.getWriter().flush();
			}
		} catch (Exception e) {
			String msg = "ExcelTransactionLog.doGet() --> Exception [" + e.getClass().getSimpleName() + "]: " + e.getMessage();
			LOGGER.error(msg);
			throw new ServletException(msg, e);
		} 
	}

	/**
	 * Helper method to stream log entries (content) as either "CSV" or "TSV" type of file
	 * 
	 * @param PrintWriter					object to stream with
	 * @param Date							from date
	 * @param Date							to date
	 * @param String						field delimiter
	 * 
	 * @throws IOException | RowsExceededException | WriteException
	 * 
	 */
	private void streamContent(PrintWriter writer, Date fromDate, Date toDate, String fieldDelimiter) 
	throws IOException, RowsExceededException, WriteException {

        LOGGER.info("ExcelTransactionLog.streamContent() --> Streaming as [{}] type of file", fieldDelimiter.equals(",") ? "CSV" : "TSV");
		
		String recordDelimiter = System.getProperty("line.separator");
		writeDelimitedHeaders(writer, fieldDelimiter, recordDelimiter);
 
		try {
			VixGuiWebAppRouter router = FacadeRouterUtility.getFacadeRouter (VixGuiWebAppRouter.class);
			TransactionLogWriter txLogWriter = new DelimitedTransactionLogWriter(writer, fieldDelimiter, recordDelimiter);		
			router.getTransactionLogEntries(txLogWriter, fromDate, toDate, null, null, null, 
											null, null, null, null, new Boolean (true), null, null);
		} catch (Exception x) {
            LOGGER.error("ExcelTransactionLog.streamContent() --> Stream error: {}", x.getMessage());
			throw new IOException (x);
		}
	}
	
	/**
	 * There's no button on the GUI for XLS. This one is never used.
	 * Leave here for future use.
	 * 
	 * @param out
	 * @param contentType
	 * @param startDate
	 * @param endDate
	 * @param imageQuality
	 * @param user
	 * @param modality
	 * @param datasourceProtocol
	 * @throws IOException 
	 * @throws WriteException 
	 * @throws RowsExceededException 
	 */
	private void streamContentAsXLS(
			OutputStream out, 
			Date startDate, 
			Date endDate, 
			ImageQuality imageQuality, 
			String user,
			String modality, 
			DatasourceProtocol datasourceProtocol,
			String errorMessage,
			String imageUrn,
			String transactionId) 
	throws IOException, RowsExceededException, WriteException {
		
		WritableWorkbook workbook = Workbook.createWorkbook(out);
		WritableSheet sheet = workbook.createSheet("Transaction Log", 0); 
		writeTitleCells(sheet);

		try {			
			
			XlsTransactionLogWriter xlsWriter = new XlsTransactionLogWriter(sheet);
			VixGuiWebAppRouter router = FacadeRouterUtility.getFacadeRouter (VixGuiWebAppRouter.class);
			
			if(startDate == null && 
					endDate == null && 
					imageQuality == null && 
					user == null && 
					modality == null && 
					datasourceProtocol == null && 
					errorMessage == null && 
					imageUrn == null && 
					transactionId != null) {
		
				router.getTransactionLogEntriesByTransactionId(xlsWriter, transactionId);
			} else {
				
				router.getTransactionLogEntries(xlsWriter, startDate, endDate, imageQuality, user, modality, 
						datasourceProtocol, errorMessage, imageUrn, transactionId, new Boolean (true), null, null);
			}
		} catch (Exception x){
			throw new IOException (x);
		}

		workbook.write();
		workbook.close(); 
	}

	/**
	 * Helper method to create cell(s)
	 * 
	 * @param WritableSheet						XLS writable sheet
	 * 
	 * @throws RowsExceededException | WriteException
	 * 
	 */
	private void writeTitleCells(WritableSheet sheet) throws RowsExceededException, WriteException {
		for(Columns column : Columns.values())
			sheet.addCell( new Label(column.ordinal(), 0, column.getColumnHeader()) );
	}

	/**
	 * Helper method to stream log entries (content)
	 * 
	 * @param PrintWriter				writer object to work with
	 * @param String					field delimiter
	 * @param String 					record delimiter
	 * 
	 */
	private void writeDelimitedHeaders(PrintWriter writer, String fieldDelimiter, String recordDelimiter) {
		
		int columnCount = Columns.values().length;
		int currentColumn = 0;
		
		for(Columns column : Columns.values()) {

			currentColumn++;
			writer.write( column.getColumnHeader() );
			
			if(currentColumn < columnCount)	{
				writer.write(fieldDelimiter);
			}
		}
		
		writer.write(recordDelimiter);
	}

	/**
	 * Destruction of the servlet
	 */
	public void destroy() {
		super.destroy();
	}

	/**
	 * Enum to declare what mime type to work with
	 * 
	 * @author VHAISPNGUYEQ
	 *
	 */
	public enum ContentType {
		
		XLS("application/vnd-ms-excel"),
		CSV("text/csv"),
		TSV("text/tab-separated-values");

		private String mimeType;

		/**
		 * Convenient Constructor
		 * 
		 * @param String			given mime type
		 * 
		 */
		ContentType(String mimeType) {
			this.mimeType = mimeType;
		}

		public String getMimeType() {
			return mimeType;
		}

		static ContentType getByAcceptHeader(String acceptHeader) {
			
			if(acceptHeader == null)
				return ContentType.XLS;

			acceptHeader = acceptHeader.toLowerCase();
			String [] acceptHeaderValues = acceptHeader.split(",");

			for(String acceptHeaderValue : acceptHeaderValues)
				for( ContentType contentType : ContentType.values() )
					if( acceptHeaderValue.indexOf(contentType.getMimeType()) >= 0 )
						return contentType;

			return ContentType.XLS;
		}
	}

	/**
	 * An interface for classes that format individual columns of the
	 * spreadsheet.  These may be generic to type or specific to a column.
	 * The formatting is called when doing text (CSV, TSV) output.
	 * 
	 * @param <T>			generic type
	 */
	static interface ColumnFormatter<T> {
		String formatColumnValue(T columnValue);
	}

	/**
	 * A definition for generic type conversion.  An instance of this may be 
	 * assigned to each column.  The conversion for each column will be called
	 * when building an XLS output.
	 *  
	 * @param <S> - source type
	 * @param <D> - destination
	 * 
	 */
	static interface ColumnTypeConverter<S, D> {
		D convert(S value);
	}

	/**
	 * A column formatter for date columns stored as Long values
	 * 
	 */
	static class DateAsLongColumnFormatter implements ColumnFormatter<Long>	{
		// the first date format in the array 
		private DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

		@Override
		public String formatColumnValue(Long columnValue) {
			
			if(columnValue == null)
				return "";
			
			return dateFormat.format(new Date(columnValue.longValue()));
		}
	}

	static class RemoveTabAndNewlineFormatter implements ColumnFormatter<String> {
		@Override
		public String formatColumnValue(String value) {
			
			String formattedValue = (value == null ? "" : "" + value);
			
			if (value != null) {
				formattedValue = formattedValue.replace('\n',' ');
				formattedValue = formattedValue.replace('\t',' ');
			}
			
			return formattedValue;
		}
	}

	static class LongToDateConverter implements ColumnTypeConverter<Long, Date> {
		@Override
		public Date convert(Long value)	{
			return value == null ? null : new Date(value.longValue());
		}
	}

	public enum Columns {
		TransactionTime("Date and Time", "getStartTime", new DateAsLongColumnFormatter(), new LongToDateConverter()),
		Duration("Time on ViX (msec)", "getElapsedTime", null, null),
		PatientICN("Patient ICN", "getPatientIcn", null, null),
		QueryType("Query Type", "getQueryType", null, null),
		QueryFilter("Query Filter", "getQueryFilter", null, null),
		AsynchronousCommand("Asynchronous?", "isAsynchronousCommand", null, null),
		ItemsReturned("Items (Size) Returned", "getItemCount", null, null),
		DataSourceItemsReceived("Data Source Items Received", "getDataSourceItemsReceived", null, null),
		FacadeBytesReturned("Facade Bytes Returned", "getFacadeBytesSent", null, null),
		DataSourceBytesReceived("DataSource Bytes Received", "getDataSourceBytesReceived", null, null),
		ImageQuality("Quality", "getQuality", null, null),		
		CommandClassName("Command Class Name", "getCommandClassName", null, null),
		OriginatingHost("Originating IP Address", "getOriginatingHost", null, null),
		User("User", "getUser", null, null),
		CacheHit("Item in cache?", "isCacheHit", null, null),
		ErrorMessage("Error Message", "getErrorMessage", new RemoveTabAndNewlineFormatter(), null),
		Modality("Modality", "getModality", null, null),
		PurposeOfUse("Purpose of Use", "getPurposeOfUse", null, null),
		DatasourceProtocol("Datasource Protocol", "getDatasourceProtocol", null, null),		
		ResponseCode("Response Code", "getResponseCode", null, null),
		RealmSiteNumber("Realm Site Number", "getRealmSiteNumber", null, null),
		URN("URN", "getUrn", null, null),
		TransactionNumber("Transaction Number", "getTransactionId", null, null),
		VixSoftwareVersion("Vix Software Version", "getVixSoftwareVersion", null, null),
		RemoteLoginMethod("VistA Login Method", "getRemoteLoginMethod", null, null),
		FacadeBytesReceived("Facade Bytes Received", "getFacadeBytesReceived", null, null),
		DataSourceBytesReturned("DataSource Bytes Returned", "getDataSourceBytesSent", null, null),			
		MachineName("Machine Name", "getMachineName", null, null),
		RequestingSite("Requesting Site", "getRequestingSite", null, null),
		ExceptionClassName("Exception Class Name", "getExceptionClassName", null, null),		
		TimeToFirstByte("Time To First Byte", "getTimeToFirstByte", null, null),		
		RespondingSite("Responding Site", "getRespondingSite", null, null),
		CommandId("Command ID", "getCommandId", null, null),
		ParentCommandId("Parent Command ID", "getParentCommandId", null, null),		
		FacadeImageFormatSent("Facade Image Format Sent", "getFacadeImageFormatSent", null, null),
		FacadeImageQualitySent("Facade Image Quality Sent", "getFacadeImageQualitySent", null, null),
		DataSourceImageFormatReceived("Data Source Image Format Received", "getDataSourceImageFormatReceived", null, null),
		DataSourceImageQualityReceived("Data Source Image Quality Received", "getDataSourceImageQualityReceived", null, null),
		ClientVersion("Client Version", "getClientVersion", null, null),
		DataSourceMethod("Data Source Method", "getDataSourceMethod", null, null),
		DataSourceVersion("Data Source Version", "getDataSourceVersion", null, null),
		DebugInformation("Debug Information", "getDebugInformation", new RemoveTabAndNewlineFormatter(), null),
		DataSourceResponseServer("Data Source Response Server", "getDataSourceResponseServer", null, null),
		ThreadId("Thread ID", "getThreadId", null, null),
		VixSiteNumber("VIX Site Number", "getVixSiteNumber", null, null),
		RequestingVixSiteNumber("Requesting VIX Site Number", "getRequestingVixSiteNumber", null, null);
		

		private final String columnHeader;
		private Method accessorMethod;
		private final ColumnFormatter<?> columnFormatter;
		private final ColumnTypeConverter<?, ?> typeConverter;

		Columns(String columnHeader, String accessorMethodName, 
				ColumnFormatter<?> columnFormatter, ColumnTypeConverter<?, ?> typeConverter) {
			
			this.columnHeader = columnHeader;
			
			try	{
				this.accessorMethod = TransactionLogEntry.class.getMethod(accessorMethodName, (Class<?>[])null);
			} catch (SecurityException e) {
				this.accessorMethod = null;
				e.printStackTrace();
			} catch (NoSuchMethodException e) {
				this.accessorMethod = null;
				e.printStackTrace();
			}
			
			this.columnFormatter = columnFormatter;
			this.typeConverter = typeConverter;
		}

		public String getColumnHeader()	{
			return columnHeader;
		}

		public Method getAccessorMethod() {
			return accessorMethod;
		}

		public ColumnFormatter<?> getColumnFormatter() {
			return columnFormatter;
		}

		public ColumnTypeConverter<?, ?> getTypeConverter() {
			return typeConverter;
		}
	}
	
	class XlsTransactionLogWriter implements TransactionLogWriter {
		
		final WritableSheet sheet;
		int row = 1;
		
		XlsTransactionLogWriter(WritableSheet sheet) {
			this.sheet = sheet;
		}

		@SuppressWarnings({ "rawtypes", "unchecked" })
		@Override
		public void writeTransactionLogEntry(TransactionLogEntry logEntry) throws MethodException {
			
			for(Columns column : Columns.values()) {
				try {
					Method accessor = column.getAccessorMethod();
					if( accessor != null) {
						// the return type of the getXXX method
						//Class<?> propertyType = accessor.getReturnType();
						// the value of the column (the log entry property)
						Object value = null;

						value = accessor.invoke(logEntry, (Object[])null);
						ColumnTypeConverter typeConverter = column.getTypeConverter();
						if(typeConverter != null)
							value = typeConverter.convert(value);
						if(value == null)
							sheet.addCell(new Label(column.ordinal(), row, ""));

						else if( value instanceof Boolean )
							sheet.addCell( new jxl.write.Boolean(column.ordinal(), row, ((java.lang.Boolean)value).booleanValue()) );

						else if( value instanceof Character )
							sheet.addCell( new jxl.write.Label(column.ordinal(), row, ((java.lang.Character)value).toString()) );

						else if( value instanceof Long )
							sheet.addCell( new jxl.write.Number(column.ordinal(), row, ((java.lang.Long)value).longValue()) );

						else if( value instanceof Integer )
							sheet.addCell( new jxl.write.Number(column.ordinal(), row, ((java.lang.Integer)value).intValue()) );

						else if( value instanceof Float )
							sheet.addCell( new jxl.write.Number(column.ordinal(), row, ((java.lang.Float)value).floatValue()) );

						else if( value instanceof Double )
							sheet.addCell( new jxl.write.Number(column.ordinal(), row, ((java.lang.Double)value).doubleValue()) );

						else if( value instanceof Date )
							sheet.addCell( new jxl.write.DateTime(column.ordinal(), row, (java.util.Date)value) );

						else
							sheet.addCell( new Label(column.ordinal(), row, value.toString()) );
					}
					else
						sheet.addCell(new Label(column.ordinal(), row, ""));

				} catch(Exception e) {
					try	{
						sheet.addCell(new Label(column.ordinal(), row, e.getMessage()));
					} catch(WriteException wX) {
						throw new MethodException(wX);
					}
				}
			}
			
			++row;
		}
	}
	
	class DelimitedTransactionLogWriter implements TransactionLogWriter	{
		
		private final PrintWriter writer;
		private final String fieldDelimiter;
		private final String recordDelimiter;
		
		public DelimitedTransactionLogWriter(PrintWriter writer, String fieldDelimiter, String recordDelimiter) {
			this.writer = writer;
			this.fieldDelimiter = fieldDelimiter;
			this.recordDelimiter = recordDelimiter;
		}

		/* (non-Javadoc)
		 * @see gov.va.med.imaging.access.TransactionLogWriter#writeTransactionLogEntry(gov.va.med.imaging.access.TransactionLogEntry)
		 */
		@SuppressWarnings({ "rawtypes", "unchecked" })
		@Override
		public void writeTransactionLogEntry(TransactionLogEntry logEntry) throws MethodException {
			
			int columnIndex = 0;
			for(Columns column : Columns.values()) {
				
				if(columnIndex != 0)
					writer.write(fieldDelimiter);
				
				try	{
					Method accessor = column.getAccessorMethod();
					
					if( accessor != null) {
						Object value = accessor.invoke(logEntry, (Object[]) null);
						ColumnFormatter formatter = column.getColumnFormatter();
						// wrap formatted and unformatted values in double quotes
						if(formatter != null)
							writer.write( "\"" + formatter.formatColumnValue(value) + "\"" );
						else
							writer.write( value == null ? "" : "\"" + value.toString() + "\"" );
					} else
						writer.write("");
				} catch(Exception e) {
					LOGGER.warn(e);
					e.printStackTrace();
					writer.write( e == null ?  
							"<ERROR>" : "" + e.getMessage() == null ?
									e.getClass().getSimpleName() : e.getMessage() );
				}
				
				++columnIndex;
			}
			
			writer.write(recordDelimiter);
		}
	}
}