/**
 * 
 */
package gov.va.med.imaging.vistaimagingdatasource;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.protocol.vista.VistaImagingTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;
import gov.va.med.imaging.vistaobjects.CprsIdentifierImages;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author William Peterson
 *
 */
public class VistaImagingExternalPackageDataSourceServiceV3 extends
		VistaImagingExternalPackageDataSourceServiceV2 {
	
	public final static String MAG_REQUIRED_VERSION = "3.0P170";


	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public VistaImagingExternalPackageDataSourceServiceV3(
			ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
	}
	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistadatasource.AbstractBaseVistaExternalPackageDataSourceService#getRequiredVistaImagingVersion()
	 */
	@Override
	protected String getRequiredVistaImagingVersion() 
	{
		return VistaImagingCommonUtilities.getVistaDataSourceImagingVersion(
				VistaImagingDataSourceProvider.getVistaConfiguration(), this.getClass(), 
				MAG_REQUIRED_VERSION);
	}


	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistaimagingdatasource.AbstractBaseVistaImagingExternalPackageDataSourceService#postStudiesFromCprsIdentifiers(gov.va.med.RoutingToken, gov.va.med.PatientIdentifier, java.util.List)
	 */
	@Override
	public List<Study> postStudiesFromCprsIdentifiers(
			RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier,
			List<CprsIdentifier> cprsIdentifiers) throws MethodException,
			ConnectionException {
		getLogger().debug("...executing postStudiesFromCprsIdentifiers method in V3.");

		VistaCommonUtilities.setDataSourceMethodAndVersion("postStudiesFromCprsIdentifiers", getDataSourceVersion());
		VistaSession vistaSession = null;

        getLogger().debug("postStudiesFromCprsIdentifiers({}, ) TransactionContext ({}).", patientIdentifier, TransactionContextFactory.get().getTransactionId());

		List<Study> result = new ArrayList<Study>();

		try
		{
			vistaSession = getVistaSession();
			
			CprsIdentifierImages cprsIdentifierImages = 
					getVistaImageListFromCprsIdentifiers(vistaSession, getSite(), patientIdentifier, cprsIdentifiers);
			
			for(CprsIdentifier item: cprsIdentifiers)
			{
				String cprsIdentifier = item.getCprsIdentifier();
				List<Study> studies = cprsIdentifierImages.getVistaStudies().get(cprsIdentifier);
				result.addAll(studies);
			}
			
		}
		catch(IOException ioX)
		{
			throw new ConnectionException(ioX);
		}
		finally
		{
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
				}
			}
		}
		
		return result;
	}

	
	@Override
	protected String getDataSourceVersion()
	{
		return "3";
	}
	
	
	/**
	 * Retrieve the list of images from list of cprs identifier
	 * 
	 * @param vistaSession
	 * @param patientIcn
	 * @param cprsIdentifiers
	 * @return
	 * @throws MethodException
	 * @throws IOException
	 * @throws ConnectionException
	 */
	private CprsIdentifierImages getVistaImageListFromCprsIdentifiers(
		VistaSession vistaSession,
		Site site,
		PatientIdentifier patientIdentifier,
		List<CprsIdentifier> cprsIdentifiers)
	throws MethodException, IOException, ConnectionException
	{
		try
		{
			getLogger().debug("...executing getVistaImageListFromCprsIdentifiers method in V3.");
			
			VistaQuery query = VistaImagingQueryFactory.createGetImagesForCprsIdentifiers(cprsIdentifiers);
			String vistaResponse = vistaSession.call(query);
			return VistaImagingTranslator.extractCprsImageListFromVistaResult(site, patientIdentifier, vistaResponse, null);
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
		catch(TranslationException trX)
		{
			throw new IOException(trX);
		} 
		catch (URNFormatException urnX)
		{
			throw new IOException(urnX);
		}
	}

}
