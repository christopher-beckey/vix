/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.indexterm;

import java.io.IOException;
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
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.indexterm.enums.IndexTerm;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.AbstractVistaImagingDataSourceService;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;

/**
 * @author Administrator
 *
 */
public class VistaImagingIndexTermDataSourceService
extends AbstractVistaImagingDataSourceService
implements IndexTermDataSourceSpi
{
	public final static String SUPPORTED_PROTOCOL = "vistaimaging";

	private final static Logger logger = Logger.getLogger(VistaImagingIndexTermDataSourceService.class);
	// The required version of VistA Imaging needed to execute the RPC calls for this operation
	public final static String MAG_REQUIRED_VERSION ="3.0P59"; 		
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public VistaImagingIndexTermDataSourceService(ResolvedArtifactSource resolvedArtifactSource, 
			String protocol)
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	public static VistaImagingIndexTermDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new VistaImagingIndexTermDataSourceService(resolvedArtifactSource, protocol);
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
	    return VistaSession.getOrCreate(getMetadataUrl(), getSite());
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

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi#getOrigins(gov.va.med.RoutingToken)
	 */
	public List<IndexTermValue> getOrigins(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getOrigins", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getOrigins TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
				VistaImagingIndexTermQueryFactory.createGetOriginIndexQuery();
			String rtn = vistaSession.call(query);
			return VistaImagingIndexTermTranslator.translateIndexFields(rtn, getSite(), IndexTerm.origin_index);
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

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi#getSpecialties(gov.va.med.RoutingToken, java.util.List, java.util.List)
	 */
	public List<IndexTermValue> getSpecialties(RoutingToken globalRoutingToken,
		List<IndexClass> indexClasses, List<IndexTermURN> eventUrns)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getSpecialties", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getSpecialties TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
				VistaImagingIndexTermQueryFactory.createGetSpecialtyIndexQuery(indexClasses, eventUrns);
			String rtn = vistaSession.call(query);
			return VistaImagingIndexTermTranslator.translateIndexFields(rtn, getSite(), IndexTerm.specialty_index);
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

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi#getProcedureEvents(gov.va.med.RoutingToken, java.util.List, java.util.List)
	 */
	public List<IndexTermValue> getProcedureEvents(
		RoutingToken globalRoutingToken, List<IndexClass> indexClasses,
		List<IndexTermURN> specialtyUrns)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getProcedureEvents", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getProcedureEvents TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
				VistaImagingIndexTermQueryFactory.createProcedureEventsIndexQuery(indexClasses, specialtyUrns);
			String rtn = vistaSession.call(query);
			return VistaImagingIndexTermTranslator.translateIndexFields(rtn, getSite(), IndexTerm.event_index);
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

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi#getTypes(gov.va.med.RoutingToken, java.util.List)
	 */
	@Override
	public List<IndexTermValue> getTypes(RoutingToken globalRoutingToken,
		List<IndexClass> indexClasses)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getTypes", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getTypes TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();			
			VistaQuery query = 
				VistaImagingIndexTermQueryFactory.createTypesIndexQuery(indexClasses);
			String rtn = vistaSession.call(query);
			return VistaImagingIndexTermTranslator.translateIndexFields(rtn, getSite(), IndexTerm.type_index);
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


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi#getIndexTermValues(gov.va.med.RoutingToken, java.util.List)
	 */
	//public List<IndexTermValue> getIndexTermValues(RoutingToken globalRoutingToken,
	//	List<IndexTerm> terms) 
	//throws MethodException, ConnectionException
	//{
	//	// TODO Auto-generated method stub
	//	return null;
	//}
	
}
