/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 23, 2023
  Developer:  VHAISLTJAHJB
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
package gov.va.med.imaging.vistaimagingdatasource.roi;

import java.io.IOException;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
//import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
//import gov.va.med.imaging.roi.datasource.ExportQueueDataSourceSpi;
//import gov.va.med.imaging.roi.queue.DicomExportQueue;
//import gov.va.med.imaging.roi.queue.AbstractExportQueueURN;
//import gov.va.med.imaging.roi.queue.NonDicomExportQueue;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.AbstractVistaImagingDataSourceService;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;
import gov.va.med.imaging.vistaimagingdatasource.roi.query.VistaImagingROICCPQueryFactory;
import gov.va.med.imaging.vistaimagingdatasource.roi.translator.VistaImagingROITranslator;
import gov.va.med.imaging.roi.datasource.CommunityCareROIDataSourceSpi;
//import gov.va.med.imaging.vistaimagingdatasource.roi.query.VistaImagingROIQueryFactory;

/**
 * @author VHAISLTJAHJB
 *
 */
public class CommunityCareROIDataSourceService
extends AbstractVistaImagingDataSourceService
implements CommunityCareROIDataSourceSpi
{

	private Logger logger = Logger.getLogger(this.getClass());
	
	public final static String SUPPORTED_PROTOCOL = "vistaimaging";
	
	// The required version of VistA Imaging needed to execute the RPC calls for this operation
	public final static String MAG_REQUIRED_VERSION ="3.0P130"; // "3.0P130";
	//TODO: fix the version to P130 when the KIDS properly reports P130
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public CommunityCareROIDataSourceService(ResolvedArtifactSource resolvedArtifactSource, 
			String protocol)
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	public static CommunityCareROIDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new CommunityCareROIDataSourceService(resolvedArtifactSource, protocol);
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
		
		logger.info("isVersionCompatible searching for version [" + version + "], TransactionContext (" + TransactionContextFactory.get().getDisplayIdentity() + ").");
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
	public List<String> getCommunityCareProviders(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getCommunityCareProviders", getDataSourceVersion());
		logger.info("getCommunityCareProviders (" + globalRoutingToken.toRoutingTokenString() + ") TransactionContext (" + TransactionContextFactory.get().getDisplayIdentity() + ").");
		VistaSession localVistaSession = null;
		try 
		{
			localVistaSession = getVistaSession();
			VistaQuery query = VistaImagingROICCPQueryFactory.getCommunityCareProvidersQuery();
			String rtn = localVistaSession.call(query);
			return VistaImagingROITranslator.translateCommunityCareProviders(rtn);
		}
		catch(IOException ioX)
		{
			logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
		}
		catch (InvalidVistaCredentialsException e)
		{
			throw new InvalidCredentialsException(e.getMessage());
		}
		catch (VistaMethodException e)
		{
			throw new MethodException(e.getMessage());
		}
		finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();} catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

}
