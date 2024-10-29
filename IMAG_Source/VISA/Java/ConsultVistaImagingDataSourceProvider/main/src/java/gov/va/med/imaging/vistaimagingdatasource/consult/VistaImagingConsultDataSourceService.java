/**
 * 
 * 
 * Date Created: Feb 11, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.consult;

import java.io.IOException;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.consult.datasource.ConsultDataSourceSpi;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.AbstractVistaImagingDataSourceService;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;

/**
 * @author Julian Werfel
 *
 */
public class VistaImagingConsultDataSourceService
extends AbstractVistaImagingDataSourceService
implements ConsultDataSourceSpi
{

	public final static String SUPPORTED_PROTOCOL = "vistaimaging";

	private final static Logger LOGGER = Logger.getLogger(VistaImagingConsultDataSourceService.class);
	// The required version of VistA Imaging needed to execute the RPC calls for this operation
	public final static String MAG_REQUIRED_VERSION ="3.0P59"; 
			
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public VistaImagingConsultDataSourceService(ResolvedArtifactSource resolvedArtifactSource, 
			String protocol)
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	public static VistaImagingConsultDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new VistaImagingConsultDataSourceService(resolvedArtifactSource, protocol);
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

        LOGGER.debug("VistaImagingConsultDataSourceService.isVersionCompatible() --> searching for version [{}], TransactionContext [{}]", version, TransactionContextFactory.get().getDisplayIdentity());
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
		catch(Exception ex)
		{
            LOGGER.error("VistaImagingConsultDataSourceService.isVersionCompatible() --> There was an error finding the installed Imaging version from VistA: {}", ex.getMessage());
			TransactionContextFactory.get().addDebugInformation("VistaImagingConsultDataSourceService.isVersionCompatible() --> failed, " + (ex == null ? "<null error>" : ex.getMessage()));
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
	 * @see gov.va.med.imaging.consult.datasource.ConsultDataSourceSpi#getPatientConsults(gov.va.med.RoutingToken, gov.va.med.PatientIdentifier)
	 */
	@Override
	public List<Consult> getPatientConsults(RoutingToken globalRoutingToken,
		PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getPatientConsults", getDataSourceVersion());
		VistaSession vistaSession = null;
        LOGGER.debug("VistaImagingConsultDataSourceService.getPatientConsults --> Patient Id [{}], transaction id [{}]", patientIdentifier, TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();
			String patientDfn = getPatientDfn(vistaSession, patientIdentifier);			
			VistaQuery query = VistaImagingConsultQueryFactory.createGetConsultsQuery(patientDfn);			
			String rtn = vistaSession.call(query);			
			return VistaImagingConsultTranslator.translateConsults(rtn, patientIdentifier, getSite());
		}
		catch(VistaMethodException vmX)
		{
			String msg = "VistaImagingConsultDataSourceService.getPatientConsults() --> Encountered VistaMethodException: " + vmX.getMessage();
			throw new MethodException(msg, vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			String msg = "VistaImagingConsultDataSourceService.getPatientConsults() --> Encountered InvalidVistaCredentialsException: " + icX.getMessage();
			throw new InvalidCredentialsException(msg, icX);
		}
		catch(IOException ioX)
		{
			String msg = "VistaImagingConsultDataSourceService.getPatientConsults() --> Encountered IOException: " + ioX.getMessage();
			throw new ConnectionException(msg, ioX);
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}	
		}
	}
}
