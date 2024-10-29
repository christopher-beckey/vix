/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 12, 2011
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
package gov.va.med.imaging.vistaimagingdatasource.dd;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.datasource.DataDictionaryDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryEntryQuery;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryFile;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryFileField;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryQuery;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryResult;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryResultEntry;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;

/**
 * @author VHAISWWERFEJ
 *
 */
public class VistaImagingDataDictionaryDataSourceService
extends AbstractVersionableDataSource 
implements DataDictionaryDataSourceSpi
{
	public final static String SUPPORTED_PROTOCOL = "vistaimaging";
	
	private final static Logger logger = Logger.getLogger(VistaImagingDataDictionaryDataSourceService.class);
	
	public VistaImagingDataDictionaryDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	{
		super(resolvedArtifactSource, protocol);
	}
	
	// to support local data source
	public VistaImagingDataDictionaryDataSourceService(ResolvedArtifactSource resolvedArtifactSource)
	{
		super(resolvedArtifactSource, SUPPORTED_PROTOCOL);
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityException
	{
		return true;
	}

	@Override
	public DataDictionaryResult queryDataDictionary(
			DataDictionaryQuery dataDictionaryQuery) 
	throws MethodException, ConnectionException
	{
        logger.info("VistaImagingDataDictionaryDataSourceService.queryDataDictionary() -->  Given query string [{}], TransactionContext [{}]", dataDictionaryQuery.toString(), TransactionContextFactory.get().getDisplayIdentity());
		
		VistaCommonUtilities.setDataSourceMethodVersionAndProtocol("queryDataDictionary", getDataSourceVersion(), SUPPORTED_PROTOCOL);
		
		if ((dataDictionaryQuery.getFields().length==1) && (dataDictionaryQuery.getFields()[0].equals("*"))) {
			// substitute "*" with all field names
			DataDictionaryFileField[] fileFields = getDataDictionaryFileFields(dataDictionaryQuery.getFileNumber());
			DataDictionaryQuery dataDictionaryQuery2= new DataDictionaryQuery(
					dataDictionaryQuery.getFileNumber(),
					getFieldNumbers(fileFields),
					dataDictionaryQuery.getMaximumResults(),
					dataDictionaryQuery.getMoreParameter());
			dataDictionaryQuery = dataDictionaryQuery2;
		}
		
		VistaSession localVistaSession = null;
		
		try 
		{
			localVistaSession = getVistaSession();
			VistaQuery query = VistaImagingDataDictionaryQueryFactory.createDDRListerQuery(dataDictionaryQuery);
			
			String result = localVistaSession.call(query);

			return VistaImagingDataDictionaryTranslator.translateDataDictionaryQuery(dataDictionaryQuery, result);
		}
		catch(IOException ioX)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.queryDataDictionary() --> IOException: " + ioX.getMessage();
			logger.error(msg);
        	throw new ConnectionException(msg, ioX);
		}
		catch (InvalidVistaCredentialsException ine)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.queryDataDictionary() --> InvalidVistaCredentialsException: " + ine.getMessage();
			logger.error(msg);
			throw new InvalidCredentialsException(msg, ine);
		}
		catch (VistaMethodException ve)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.queryDataDictionary() --> VistaMethodException: " + ve.getMessage();
			logger.error(msg);
			throw new MethodException(msg, ve);
		}
		finally
        {
        	// Fortify change: check for null first
        	// OLD:try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}
	
	public DataDictionaryFile getDataDictionaryFile(String fileNumber)
	throws MethodException, ConnectionException
	{
        logger.info("VistaImagingDataDictionaryDataSourceService.getDataDictionaryFile() --> TransactionContext [{}]", TransactionContextFactory.get().getDisplayIdentity());
		
		VistaCommonUtilities.setDataSourceMethodVersionAndProtocol("getDataDictionaryFile", getDataSourceVersion(), SUPPORTED_PROTOCOL);
		
		VistaSession localVistaSession = null;
		
		try 
		{
			localVistaSession = getVistaSession();
			List<DataDictionaryFile> allFiles = getDataDictionaryFilesInternal(localVistaSession);
			for (DataDictionaryFile file:allFiles)
			{
				if (file.getNumber().equals(fileNumber)){
					file.getFields().addAll(Arrays.asList(getDataDictionaryFileFieldsInternal(localVistaSession, fileNumber)));
					for (DataDictionaryFileField field:file.getFields())
					{
						addDataDictionaryFileFieldAttributes(localVistaSession, field);
					}
					return file;
				}
			}
			return null;
		}
		catch(IOException ioX)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryFile() --> IOException: " + ioX.getMessage();
			logger.error(msg);
        	throw new ConnectionException(msg, ioX);
		}
		catch (InvalidVistaCredentialsException ine)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryFile() --> InvalidVistaCredentialsException: " + ine.getMessage();
			logger.error(msg);
			throw new InvalidCredentialsException(msg, ine);
		}
		catch (VistaMethodException ve)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryFile() --> VistaMethodException: " + ve.getMessage();
			logger.error(msg);
			throw new MethodException(msg, ve);
		}
		finally
        {
        	// Fortify change: check for null first
        	// OLD:try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}
	
	private DataDictionaryFileField addDataDictionaryFileFieldAttributes(VistaSession localVistaSession, DataDictionaryFileField field) 
	throws IOException, InvalidVistaCredentialsException, VistaMethodException	
	{
		VistaQuery query = VistaImagingFileManQueryFactory.createFileManAttributesQuery(field.getFileNumber(), field.getFieldNumber());
		
		String result = localVistaSession.call(query);
		
		VistaImagingFileManTranslator.translateDataDictionaryFileFieldAttributes(field, result);
		
		return field;
	}
	
	@Override
	public List<DataDictionaryFile> getDataDictionaryFiles()
	throws MethodException, ConnectionException
	{
        logger.info("VistaImagingDataDictionaryDataSourceService.getDataDictionaryFiles() --> TransactionContext [{}]", TransactionContextFactory.get().getDisplayIdentity());
		
		VistaCommonUtilities.setDataSourceMethodVersionAndProtocol("getDataDictionaryFiles", getDataSourceVersion(), SUPPORTED_PROTOCOL);
		
		VistaSession localVistaSession = null;
		
		try 
		{
			localVistaSession = getVistaSession();
			return getDataDictionaryFilesInternal(localVistaSession);
		}
		catch(IOException ioX)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryFiles() --> IOException: " + ioX.getMessage();
			logger.error(msg);
        	throw new ConnectionException(msg, ioX);
		}
		catch (InvalidVistaCredentialsException ine)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryFiles() --> InvalidVistaCredentialsException: " + ine.getMessage();
			logger.error(msg);
			throw new InvalidCredentialsException(msg, ine);
		}
		catch (VistaMethodException ve)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryFiles() --> VistaMethodException: " + ve.getMessage();
			logger.error(msg);
			throw new MethodException(msg, ve);
		}
		finally
        {
        	// Fortify change: check for null first
        	// OLD:try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}
	
	private List<DataDictionaryFile> getDataDictionaryFilesInternal(VistaSession localVistaSession) 
	throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		VistaQuery query = VistaImagingDataDictionaryQueryFactory.createGetFilesQuery();
		
		String rtn = localVistaSession.call(query);
		
		List<DataDictionaryFile> result = VistaImagingDataDictionaryTranslator.translateDataDictionaryFileList(rtn);

        logger.info("VistaImagingDataDictionaryDataSourceService.getDataDictionaryFilesInternal() --> Translated VistaResult into [{}] file entries", result.size());
		
		return result;
	}

	@Override
	public DataDictionaryResultEntry getDataDictionaryValue(
			DataDictionaryEntryQuery dataDictionaryEntryQuery)
	throws MethodException, ConnectionException
	{
        logger.info("VistaImagingDataDictionaryDataSourceService.getDataDictionaryValue() --> Get value for [{}], TransactionContext [{}]", dataDictionaryEntryQuery.toString(), TransactionContextFactory.get().getDisplayIdentity());
		
		VistaCommonUtilities.setDataSourceMethodVersionAndProtocol("getDataDictionaryValue", getDataSourceVersion(), SUPPORTED_PROTOCOL);
		
		if ((dataDictionaryEntryQuery.getFields().length==1) && (dataDictionaryEntryQuery.getFields()[0].equals("*"))) {
			// substitute "*" with all field names
			DataDictionaryFileField[] fileFields = getDataDictionaryFileFields(dataDictionaryEntryQuery.getFileNumber()); 
			
			DataDictionaryEntryQuery dataDictionaryEntryQuery2= new DataDictionaryEntryQuery(
					dataDictionaryEntryQuery.getFileNumber(),
					getFieldNumbers(fileFields),
					dataDictionaryEntryQuery.getIen());
			dataDictionaryEntryQuery = dataDictionaryEntryQuery2;
		}
		VistaSession localVistaSession = null;
		try 
		{
			localVistaSession = getVistaSession();
			VistaQuery query = VistaImagingDataDictionaryQueryFactory.createGetEntryValue(dataDictionaryEntryQuery);
			String rtn = localVistaSession.call(query);
			DataDictionaryResultEntry result = VistaImagingDataDictionaryTranslator.translateDataDictionaryResultEntry(dataDictionaryEntryQuery, rtn);
			
			return result;
		}
		catch(IOException ioX)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryValue() --> IOException: " + ioX.getMessage();
			logger.error(msg);
        	throw new ConnectionException(msg, ioX);
		}
		catch (InvalidVistaCredentialsException ine)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryValue() --> InvalidVistaCredentialsException: " + ine.getMessage();
			logger.error(msg);
			throw new InvalidCredentialsException(msg, ine);
		}
		catch (VistaMethodException ve)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryValue() --> VistaMethodException: " + ve.getMessage();
			logger.error(msg);
			throw new MethodException(msg, ve);
		}
		finally
        {
        	// Fortify change: check for null first
        	// OLD:try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	@Override
	public DataDictionaryFileField[] getDataDictionaryFileFields(String fileNumber)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodVersionAndProtocol("getFileManFileFields", getDataSourceVersion(), SUPPORTED_PROTOCOL);
		
		VistaSession localVistaSession = null;
		
		try 
		{
			localVistaSession = getVistaSession();
			return getDataDictionaryFileFieldsInternal(localVistaSession, fileNumber);
		}
		catch(IOException ioX)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryFileFields() --> IOException: " + ioX.getMessage();
			logger.error(msg);
        	throw new ConnectionException(msg, ioX);
		}
		catch (InvalidVistaCredentialsException ine)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryFileFields() --> InvalidVistaCredentialsException: " + ine.getMessage();
			logger.error(msg);
			throw new InvalidCredentialsException(msg, ine);
		}
		catch (VistaMethodException ve)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getDataDictionaryFileFields() --> VistaMethodException: " + ve.getMessage();
			logger.error(msg);
			throw new MethodException(msg, ve);
		}
		finally
        {
        	// Fortify change: check for null first
        	// OLD:try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}
	
	private DataDictionaryFileField[] getDataDictionaryFileFieldsInternal(VistaSession localVistaSession, String fileNumber) 
	throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		VistaQuery query = VistaImagingFileManQueryFactory.createGetFileManFieldsQuery(fileNumber);
		String rtn = localVistaSession.call(query);
		DataDictionaryFileField[] result = VistaImagingDataDictionaryTranslator.translateFileFields(fileNumber, rtn);
		
		return result;
	}

	@Override
	public String[] getFileManEntryByValue(String fileNumber, String keyName, String keyValue)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodVersionAndProtocol("getFileManEntryByValue", getDataSourceVersion(), SUPPORTED_PROTOCOL);
		
		VistaSession localVistaSession = null;
		
		try 
		{
			localVistaSession = getVistaSession();
			VistaQuery query = VistaImagingFileManQueryFactory.createGetFileManEntryByValue(fileNumber, keyName, keyValue);
			String rtn = localVistaSession.call(query);
			String [] iens = VistaImagingFileManTranslator.translateFileSearchResult(rtn);

			return iens;
		}
		catch(IOException ioX)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getFileManEntryByValue() --> IOException: " + ioX.getMessage();
			logger.error(msg);
        	throw new ConnectionException(msg, ioX);
		}
		catch (InvalidVistaCredentialsException ine)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getFileManEntryByValue() --> InvalidVistaCredentialsException: " + ine.getMessage();
			logger.error(msg);
			throw new InvalidCredentialsException(msg, ine);
		}
		catch (VistaMethodException ve)
		{
			String msg = "VistaImagingDataDictionaryDataSourceService.getFileManEntryByValue() --> VistaMethodException: " + ve.getMessage();
			logger.error(msg);
			throw new MethodException(msg, ve);
		}
		finally
        {
        	// Fortify change: check for null first
        	// OLD:try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}
	
	protected String[] getFieldNumbers(DataDictionaryFileField[] fields){
		String[] result = new String[fields.length];
		for (int i = 0; i < fields.length; i++){
			result[i] = fields[i].getFieldNumber();
		}
		return result;
	}
	
	protected String getDataSourceVersion()
	{
		return "1";
	}
	
	private VistaSession getVistaSession() 
    throws IOException, ConnectionException, MethodException
    {
	    return VistaSession.getOrCreate(getMetadataUrl(), getSite());
    }
	
	protected ResolvedSite getResolvedSite()
	{
		return (ResolvedSite)getResolvedArtifactSource();
	}
	
	protected Site getSite()
	{
		return getResolvedSite().getSite();
	}
}
