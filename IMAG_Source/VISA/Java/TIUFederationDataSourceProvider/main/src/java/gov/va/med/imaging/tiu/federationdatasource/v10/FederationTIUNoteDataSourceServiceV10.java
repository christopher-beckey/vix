

package gov.va.med.imaging.tiu.federationdatasource.v10;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.TIUFederationProxyServiceType;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;
import gov.va.med.imaging.tiu.federation.proxy.v10.FederationRestTIUNoteProxyV10;
import gov.va.med.imaging.tiu.federationdatasource.AbstractFederationTIUNoteDataSourceService;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author William Peterson
 *
 */

public class FederationTIUNoteDataSourceServiceV10 
extends AbstractFederationTIUNoteDataSourceService 
{

	private final VftpConnection federationConnection;		
	private final static String DATASOURCE_VERSION = "10";
	public final static String SUPPORTED_PROTOCOL = "vftp";
	private ProxyServices federationProxyServices = null;			
	private FederationRestTIUNoteProxyV10 proxy = null;

	public FederationTIUNoteDataSourceServiceV10(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getArtifactUrl());
	}

	@Override
	public String getDataSourceVersion() {
		return DATASOURCE_VERSION;
	}
	
	private FederationRestTIUNoteProxyV10 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getCurrentFederationProxyServices();			
			if(proxyServices == null)
				throw new ConnectionException("Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestTIUNoteProxyV10(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}
	
	/**
	 * Returns the current version of proxy services, if none are available then null is returned
	 */
	private ProxyServices getCurrentFederationProxyServices()
	{
		if(federationProxyServices == null)
		{
			federationProxyServices = 
				FederationProxyUtilities.getCurrentFederationProxyServices(getSite(), 
						getFederationProxyName(), getDataSourceVersion());
		}
		return federationProxyServices;
	}
	
	private ProxyServiceType getProxyServiceType()
	{
		return new TIUFederationProxyServiceType();
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityException
	{
		if(getFederationProxyServices() == null)			
			return false;
		
		try
		{

            getLogger().debug("Found FederationProxyServices, looking for '{}' service type at site [{}].", getProxyServiceType(), getSite().getSiteNumber());
			getFederationProxyServices().getProxyService(getProxyServiceType());
            getLogger().debug("Found service type '{}' at site [{}], returning true for version compatible.", getProxyServiceType(), getSite().getSiteNumber());
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("Cannot find proxy service type '{}' at site [{}]", getProxyServiceType(), getSite().getSiteNumber());
			return false;
		}
	}


	@Override
	public List<TIUNote> getMatchingTIUNotes(RoutingToken globalRoutingToken, String searchText, String titleList)
			throws MethodException, ConnectionException {
        getLogger().info("getMatchingTIUNotes TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().getMatchingTIUNotes(globalRoutingToken, searchText, titleList);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting matching TIU notes via proxy", e);
			throw new MethodException("General error getting matching TIU notes via proxy", e);
		}
	}

	@Override
	public List<TIUAuthor> getAuthors(RoutingToken globalRoutingToken, String searchText)
			throws MethodException, ConnectionException {
        getLogger().info("getAuthors TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().getAuthors(globalRoutingToken, searchText);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting authors via proxy", e);
			throw new MethodException("General error getting authors via proxy", e);
		}
	}

	@Override
	public List<TIULocation> getLocations(RoutingToken globalRoutingToken, String searchText)
			throws MethodException, ConnectionException {
        getLogger().info("getLocations TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().getLocations(globalRoutingToken, searchText);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting locations via proxy", e);
			throw new MethodException("General error getting locations via proxy", e);
		}
	}

	@Override
	public Boolean associateImageWithTIUNote(AbstractImagingURN imagingUrn, PatientTIUNoteURN tiuItemIdentifier)
			throws MethodException, ConnectionException {
        getLogger().info("associateImageWithTIUNote TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().associateImageWithTIUNote(imagingUrn, tiuItemIdentifier);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error associating image with TIU note via proxy", e);
			throw new MethodException("General error associating image with TIU note via proxy", e);
		}
	}

	@Override
	public Boolean electronicallySignTIUNote(PatientTIUNoteURN tiuNoteUrn, String electronicSignature)
			throws MethodException, ConnectionException {
        getLogger().info("electronicallySignTIUNote TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().electronicallySignTIUNote(tiuNoteUrn, electronicSignature);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error electronically signing TIU note via proxy", e);
			throw new MethodException("General error electronically signing TIU note via proxy", e);
		}
	}

	@Override
	public Boolean electronicallyFileTIUNote(PatientTIUNoteURN tiuNoteUrn) throws MethodException, ConnectionException {
        getLogger().info("electronicallyFileTIUNote TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().electronicallyFileTIUNote(tiuNoteUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error electronically filing TIU note via proxy", e);
			throw new MethodException("General error electronically filing TIU note via proxy", e);
		}
	}

	@Override
	public Boolean isTIUNoteAConsult(TIUItemURN tiuNoteUrn) throws MethodException, ConnectionException {
        getLogger().info("isTIUNoteAConsult TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().isTIUNoteAConsult(tiuNoteUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error checking if TIU note is a consult via proxy", e);
			throw new MethodException("General error checking if TIU note is a consult via proxy", e);
		}
	}

	@Override
	public Boolean isNoteValidAdvanceDirective(TIUItemURN noteUrn) throws MethodException, ConnectionException {
        getLogger().info("isNoteValidAdvanceDirective TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().isNoteValidAdvanceDirective(noteUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error if note is a valid advance directive via proxy", e);
			throw new MethodException("General error if note is a valid advance directive via proxy", e);
		}
	}

	@Override
	public Boolean isPatientNoteValidAdvanceDirective(PatientTIUNoteURN noteUrn)
			throws MethodException, ConnectionException {
        getLogger().info("isPatientNoteValidAdvanceDirective TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().isPatientNoteValidAdvanceDirective(noteUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error checking if patient note is a valid advance directive via proxy", e);
			throw new MethodException("General error checking if patient note is a valid advance directive via proxy", e);
		}
	}

	@Override
	public List<PatientTIUNote> getPatientTIUNotes(RoutingToken globalRoutingToken, TIUNoteRequestStatus noteStatus,
			PatientIdentifier patientIdentifier, Date fromDate, Date toDate, String authorDuz, int count,
			boolean ascending) throws MethodException, ConnectionException {
        getLogger().info("getPatientTIUNotes TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().getPatientTIUNotes(globalRoutingToken, noteStatus, patientIdentifier, fromDate, toDate, authorDuz, count, ascending);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting patient TIU notes via proxy", e);
			throw new MethodException("General error getting patient TIU notes via proxy", e);
		}
	}

	@Override
	public String getTIUNoteText(PatientTIUNoteURN noteUrn) throws MethodException, ConnectionException {
        getLogger().info("getTIUNoteText TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().getTIUNoteText(noteUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting TIU note text via proxy", e);
			throw new MethodException("General error getting TIU note text via proxy", e);
		}
	}

	@Override
	public PatientTIUNoteURN createTIUNoteAddendum(PatientTIUNoteURN noteUrn, Date date, String addendumText)
			throws MethodException, ConnectionException {
        getLogger().info("createTIUNoteAddendum TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().createTIUNoteAddendum(noteUrn, date, addendumText);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error creating TIU note addendum via proxy", e);
			throw new MethodException("General error creating TIU note addendum via proxy", e);
		}
	}

	@Override
	public PatientTIUNoteURN createTIUNote(TIUItemURN noteUrn, PatientIdentifier patientIdentifier,
			TIUItemURN locationUrn, Date noteDate, ConsultURN consultUrn, String noteText, TIUItemURN authorUrn)
			throws MethodException, ConnectionException {
        getLogger().info("createTIUNote TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().createTIUNote(noteUrn, patientIdentifier, locationUrn, noteDate, consultUrn, noteText, authorUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error creating TIU note via proxy", e);
			throw new MethodException("General error creating TIU note via proxy", e);
		}
	}

	@Override
	public Boolean isTIUNoteValid(RoutingToken globalRoutingToken, TIUItemURN noteUrn, PatientTIUNoteURN tiuNoteUrn,
			String typeIndex) 
			throws MethodException, ConnectionException {
        getLogger().info("isTIUNoteValid TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}

		try {
			return getProxy().isTIUNoteValid(globalRoutingToken, noteUrn, tiuNoteUrn, typeIndex);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error checking if TIU note is valid via proxy", e);
			throw new MethodException("General error checking if TIU note is valid via proxy", e);
		}
	}

	

}
