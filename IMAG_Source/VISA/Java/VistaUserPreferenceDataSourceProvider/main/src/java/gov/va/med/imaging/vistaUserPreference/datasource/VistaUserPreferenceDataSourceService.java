/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.datasource;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.AbstractVistaImagingDataSourceService;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;

/**
 * @author Budy Tjahjo
 *s
 */
public class VistaUserPreferenceDataSourceService
extends AbstractVistaImagingDataSourceService
implements VistaUserPreferenceDataSourceSpi
{
	
	public final static String SUPPORTED_PROTOCOL = "vistaimaging";

	private final static Logger logger = Logger.getLogger(VistaUserPreferenceDataSourceService.class);
	// The required version of VistA Imaging needed to execute the RPC calls for this operation
	public final static String MAG_REQUIRED_VERSION ="3.0P59"; 

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public VistaUserPreferenceDataSourceService(ResolvedArtifactSource resolvedArtifactSource, 
			String protocol)
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	public static VistaUserPreferenceDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new VistaUserPreferenceDataSourceService(resolvedArtifactSource, protocol);
	}
	
	/**
	 * The artifact source must be checked in the constructor to assure that it is an instance
	 * of ResolvedSite.
	 * 
	 * @return
	 */
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
		return VistaSession.getOrCreate(getMetadataUrl(), getSite(), 
			ImagingSecurityContextType.MAG_WINDOWS);
	    //		new ImagingSecurityContextType("Security context used for all MAG* RPCs", "MAG WINDOWS", true));
    }
	
	private Logger getLogger()
	{
		return logger;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImagingPatientDataSource#isVersionCompatible()
	 */
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
	public List<String> getUserPreference(
			RoutingToken globalRoutingToken,
			String userID,
			String key)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getUserPreference", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getUserPreference userID({}) key({}) TransactionContext ({}).", userID, key, TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();
			
			VistaQuery query = VistaUserPreferenceQueryFactory.createGetUserPreferenceQuery(userID, key);
			String rtn = vistaSession.call(query);
			String[] result = StringUtils.Split(rtn, StringUtils.NEW_LINE);
			return new ArrayList<String>(Arrays.asList(result)); 				}
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
	public List<String> getUserPreferenceKeys(RoutingToken globalRoutingToken,
			String entity) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getUserPreferenceKeys", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getUserPreferenceKeys userID({}) TransactionContext ({}).", entity, TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();
			
			VistaQuery query = VistaUserPreferenceQueryFactory.createGetUserPreferenceKeysQuery(entity);
			String rtn = vistaSession.call(query);
			
			List<String> userPreferenceKeys = VistaUserPreferenceTranslator.getUserPreferenceKeys(rtn);
			
			return userPreferenceKeys;
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
	public String postUserPreference(RoutingToken globalRoutingToken,
			String userID, String key, String value) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("postUserPreference", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("postUserPreference user({}) key ({}) value length ({}) TransactionContext ({}).", userID, key, value.length(), TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();
			
			VistaQuery query = VistaUserPreferenceQueryFactory.createPostUserPreferenceQuery(userID, key, value);

			return vistaSession.call(query);
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
	public String deleteUserPreference(RoutingToken globalRoutingToken,
			String userID, String key) throws MethodException,
			ConnectionException {
		VistaCommonUtilities.setDataSourceMethodAndVersion("deleteUserPreference", getDataSourceVersion());
		
		VistaSession vistaSession = null;
        getLogger().info("deleteUserPreference userID({}) key({}) TransactionContext ({}).", userID, key, TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();
			
			VistaQuery query = VistaUserPreferenceQueryFactory.createDeleteUserPeferenceQuery(userID, key);
			return vistaSession.call(query);
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



}
