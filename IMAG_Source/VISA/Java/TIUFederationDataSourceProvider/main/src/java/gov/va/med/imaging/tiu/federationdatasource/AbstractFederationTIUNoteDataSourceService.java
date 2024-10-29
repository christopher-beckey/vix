package gov.va.med.imaging.tiu.federationdatasource;

import java.util.Date;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federationdatasource.AbstractFederationDataSourceService;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author William Peterson
 *
 */

public abstract class AbstractFederationTIUNoteDataSourceService 
extends AbstractFederationDataSourceService
implements TIUNoteDataSourceSpi 
{
	
	private ProxyServices federationProxyServices = null;
	private final static String FEDERATION_PROXY_SERVICE_NAME = "Federation";
	private final static Logger logger = Logger.getLogger(AbstractFederationTIUNoteDataSourceService.class);
	
	public abstract String getDataSourceVersion();
	protected final VftpConnection federationConnection;


	public AbstractFederationTIUNoteDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
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
	
	protected Logger getLogger()
	{
		return logger;
	}
	
	/**
	 * Returns the proxy services available, if none are available then null is returned
	 */
	protected ProxyServices getFederationProxyServices()
	{
		if(federationProxyServices == null)
		{
			federationProxyServices = 
				FederationProxyUtilities.getFederationProxyServices(getSite(), 
						getFederationProxyName(), getDataSourceVersion());
		}
		return federationProxyServices;
	}
	
	protected String getFederationProxyName()
	{
		return FEDERATION_PROXY_SERVICE_NAME;
	}


	public List<TIUNote> getMatchingTIUNotes(RoutingToken globalRoutingToken, String searchText, String titleList)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "getMatchingTIUNotes");
	}

	public List<TIUAuthor> getAuthors(RoutingToken globalRoutingToken, String searchText)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "getAuthors");
	}

	public List<TIULocation> getLocations(RoutingToken globalRoutingToken, String searchText)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "getLocations");
	}

	public Boolean associateImageWithTIUNote(AbstractImagingURN imagingUrn, PatientTIUNoteURN tiuItemIdentifier)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "associateImageWithTIUNote");
	}

	public Boolean electronicallySignTIUNote(PatientTIUNoteURN tiuNoteUrn, String electronicSignature)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "electronicallySignTIUNote");
	}

	public Boolean electronicallyFileTIUNote(PatientTIUNoteURN tiuNoteUrn) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "electronicallyFileTIUNote");
	}

	public Boolean isTIUNoteAConsult(TIUItemURN tiuNoteUrn) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "isTIUNoteAConsult");
	}

	public Boolean isNoteValidAdvanceDirective(TIUItemURN noteUrn) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "isNoteValidAdvanceDirective");
	}

	public Boolean isPatientNoteValidAdvanceDirective(PatientTIUNoteURN noteUrn)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "isPatientNoteValidAdvanceDirective");
	}

	public List<PatientTIUNote> getPatientTIUNotes(RoutingToken globalRoutingToken, TIUNoteRequestStatus noteStatus,
			PatientIdentifier patientIdentifier, Date fromDate, Date toDate, String authorDuz, int count,
			boolean ascending) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "getPatientTIUNotes");
	}

	public String getTIUNoteText(PatientTIUNoteURN noteUrn) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "getTIUNoteText");
	}
	
	public PatientTIUNoteURN createTIUNote(TIUItemURN noteUrn, PatientIdentifier patientIdentifier,
			TIUItemURN locationUrn, Date noteDate, ConsultURN consultUrn, String noteText, TIUItemURN authorUrn)
		throws MethodException, ConnectionException{
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "createTIUNote");		
	}


	public PatientTIUNoteURN createTIUNoteAddendum(PatientTIUNoteURN noteUrn, Date date, String addendumText)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "createTIUNoteAddendum");
	}

	public Boolean isTIUNoteValid(RoutingToken globalRoutingToken, TIUItemURN noteUrn, PatientTIUNoteURN tiuNoteUrn, String typeIndex) 
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(TIUNoteDataSourceSpi.class, "isTIUNoteValid");
	}

}
