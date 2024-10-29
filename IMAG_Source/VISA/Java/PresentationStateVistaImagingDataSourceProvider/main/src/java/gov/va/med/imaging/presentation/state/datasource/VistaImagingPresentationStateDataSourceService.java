/**
 * 
 */
package gov.va.med.imaging.presentation.state.datasource;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.AbstractVistaImagingDataSourceService;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author William Peterson
 *
 */
public class VistaImagingPresentationStateDataSourceService 
extends AbstractVistaImagingDataSourceService 
implements PresentationStateDataSourceSpi {

	public final static String SUPPORTED_PROTOCOL = "vistaimaging";

	private final static Logger logger = Logger.getLogger(VistaImagingPresentationStateDataSourceService.class);
	// The required version of VistA Imaging needed to execute the RPC calls for this operation
	public final static String MAG_REQUIRED_VERSION ="3.0P59"; 		

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public VistaImagingPresentationStateDataSourceService(
			ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	public static VistaImagingPresentationStateDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new VistaImagingPresentationStateDataSourceService(resolvedArtifactSource, protocol);
	}
	
	protected ResolvedSite getResolvedSite()
	{
		return (ResolvedSite)getResolvedArtifactSource();
	}
	
	protected Site getSite()
	{
		return getResolvedSite().getSite();
	}
	
	private VistaSession getVistaSession() 
    throws IOException, ConnectionException, MethodException
    {
	    return VistaSession.getOrCreate(getMetadataUrl(), getSite());
    }
	
	private Logger getLogger()
	{
		return logger;
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityCredentialsExpiredException
	{
		String version = VistaImagingCommonUtilities.getVistaDataSourceImagingVersion(
				getVistaImagingConfiguration(), this.getClass(), 
				MAG_REQUIRED_VERSION);

        logger.info("isVersionCompatible searching for version [{}], TransactionContext ({}).", version, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
		try
		{
			localVistaSession = getVistaSession();	
			return VistaImagingCommonUtilities.isVersionCompatible(version, localVistaSession);	
		}
		catch(SecurityCredentialsExpiredException sceX)
		{
			// caught here to be sure it gets thrown as SecurityCredentialsExpiredException, not ConnectionException
			throw sceX;
		}
		catch(MethodException mX)
		{
			logger.error("There was an error finding the installed Imaging version from VistA", mX);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (mX == null ? "<null error>" : "" + mX.getMessage()));
		}
		catch(ConnectionException cX)
		{
			logger.error("There was an error finding the installed Imaging version from VistA", cX);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (cX == null ? "<null error>" : "" + cX.getMessage()));
		}		
		catch(IOException ioX)
		{
			logger.error("There was an error finding the installed Imaging version from VistA", ioX);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (ioX == null ? "<null error>" : "" + ioX.getMessage()));
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();} catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}		
		}		
		return false;
	}
	
	protected String getDataSourceVersion()
	{
		return "1";
	}

	@Override
	public Boolean deletePSRecord(RoutingToken globalRoutingToken,
			PresentationStateRecord pStateRecord) throws MethodException, ConnectionException {
		VistaCommonUtilities.setDataSourceMethodAndVersion("deletePSRecord", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("deletePSRecord TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		if(pStateRecord == null){
			throw new MethodException("PresentationStateRecord is null.  No data to work with.");
		}
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
				VistaImagingPresentationStateQueryFactory.deletePSRecordQuery(pStateRecord);
			String rtn = vistaSession.call(query);
			if(rtn.startsWith("0"))
			{
                getLogger().info("Deleted Presentation State Record [{}] {}", pStateRecord.getpStateUID(), rtn);
				return true;
			}
			throw new MethodException("Error associated Presentation State Record deletion, " + rtn);
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
		catch(IOException ioX)
		{
			throw new ConnectionException(ioX);
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}		
		}
	}

	@Override
	public List<PresentationStateRecord> getPSDetails(
			RoutingToken globalRoutingToken, List<PresentationStateRecord> pStateRecords)
			throws MethodException, ConnectionException {
		VistaCommonUtilities.setDataSourceMethodAndVersion("getPSDetails", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getPSDetails TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
					VistaImagingPresentationStateQueryFactory.getPSDetailsQuery(pStateRecords);
			String rtn = vistaSession.call(query);
			return VistaImagingPresentationStateTranslator.translatePSDetails(rtn);
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
		catch(IOException ioX)
		{
			throw new ConnectionException(ioX);
		}
		finally
		{        	
			// Fortify change: check for null first
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}		
		}
	}

	@Override
	public List<PresentationStateRecord> getPSRecords(
			RoutingToken globalRoutingToken, PresentationStateRecord pStateRecord)
			throws MethodException, ConnectionException {
		VistaCommonUtilities.setDataSourceMethodAndVersion("getPSRecords", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getPSRecords TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		if(pStateRecord == null){
			throw new MethodException("PresentationStateRecord is null.  No data to work with.");
		}
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
					VistaImagingPresentationStateQueryFactory.getPSRecordsQuery(pStateRecord);
			String rtn = vistaSession.call(query);
			return VistaImagingPresentationStateTranslator.translatePSRecords(rtn);
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
		catch(IOException ioX)
		{
			throw new ConnectionException(ioX);
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}		
		}
	}

	@Override
	public Boolean postPSDetail(RoutingToken globalRoutingToken,
			PresentationStateRecord pStateRecord) throws MethodException,
			ConnectionException {
		VistaCommonUtilities.setDataSourceMethodAndVersion("postPSDetail", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("postPSDetail TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		if(pStateRecord == null){
			throw new MethodException("PresentationStateRecord is null.  No data to work with.");
		}
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
					VistaImagingPresentationStateQueryFactory.createPSDetailQuery(pStateRecord);
			String rtn = vistaSession.call(query);
			if(rtn.startsWith("0"))
			{
                getLogger().info("Created new Presentation State Detail [{}] {}", pStateRecord.getpStateUID(), rtn);
				return true;
			}
			throw new MethodException("Error associated Presentation State Detail creation, " + rtn);
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
		catch(IOException ioX)
		{
			throw new ConnectionException(ioX);
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}		
		}
	}

	@Override
	public Boolean postPSRecord(RoutingToken globalRoutingToken,
			PresentationStateRecord pStateRecord) throws MethodException,
			ConnectionException {
		VistaCommonUtilities.setDataSourceMethodAndVersion("postPSRecord", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("postPSRecord TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		if(pStateRecord == null){
			throw new MethodException("PresentationStateRecord is null.  No data to work with.");
		}
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
					VistaImagingPresentationStateQueryFactory.createPSRecordQuery(pStateRecord);
			String rtn = vistaSession.call(query);
			if(rtn.startsWith("0"))
			{
                getLogger().info("Created Presentation State Record for [{}] {}", pStateRecord.getStudyUID(), rtn);
				return true;
			}
			throw new MethodException("Error associated Presentation State Record creation, " + rtn);
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
		catch(IOException ioX)
		{
			throw new ConnectionException(ioX);
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}		
		}
	}

	@Override
	public List<String> getStudyPSDetails(RoutingToken globalRoutingToken, String studyContext) 
	throws ConnectionException, MethodException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getStudyPSDetails", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getStudyPSDetails TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
					VistaImagingPresentationStateQueryFactory.getStudyPSDetailsQuery(studyContext);
			String rtn = vistaSession.call(query);
			String[] lines = StringUtils.Split(rtn, StringUtils.CRLF);
			return new ArrayList<String>(Arrays.asList(lines));
		} catch (MethodException e) {
			throw new MethodException(e);
		} catch (InvalidVistaCredentialsException e) {
			throw new InvalidCredentialsException(e);
		} catch (VistaMethodException e) {
			throw new MethodException(e);
		} catch (IOException e) {
			throw new MethodException(e);
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{vistaSession.close();}  catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}	
		}
	}
}

