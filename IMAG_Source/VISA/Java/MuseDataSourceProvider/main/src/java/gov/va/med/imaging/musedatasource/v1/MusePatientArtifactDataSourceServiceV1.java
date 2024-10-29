/**
 * 
 */
package gov.va.med.imaging.musedatasource.v1;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.muse.proxy.rest.v1.MusePatientArtifactRestProxyV1;
import gov.va.med.imaging.musedatasource.AbstractMusePatientArtifactDataSourceService;
import gov.va.med.imaging.musedatasource.MuseDataSourceProvider;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.musedatasource.translator.MuseDatasourceTranslator;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.muse.MuseConnection;
import gov.va.med.imaging.url.muse.exceptions.MuseConnectionException;

import java.io.IOException;
import java.util.List;

/**
 * @author William Peterson
 *
 */
public class MusePatientArtifactDataSourceServiceV1 
extends AbstractMusePatientArtifactDataSourceService{

	private final static String DATASOURCE_VERSION = "1";
	private MusePatientArtifactRestProxyV1 proxy = null;

	private final MuseConnection museConnection;
	
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public MusePatientArtifactDataSourceServiceV1(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		
		museConnection = new MuseConnection(getMetadataUrl());
	}

	@Override
	protected String getDataSourceVersion() {
		return DATASOURCE_VERSION;
	}
	
	
	@Override
	protected MusePatientArtifactRestProxyV1 getProxy(MuseServerConfiguration museServer)
	throws ConnectionException
	{		
		if(proxy == null)
		{
			ProxyServices proxyServices = getProxyServices(museServer);
			if(proxyServices == null)
				throw new ConnectionException("Did not receive any applicable services for site [" + getSite().getSiteNumber() + "]");
			proxy = new MusePatientArtifactRestProxyV1(proxyServices,
					MuseDataSourceProvider.getMuseConfiguration(), museServer, false);
		}
		return proxy;
		
	}
	
	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.musedatasource.AbstractMusePatientArtifactDataSourceService#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() {
		return true;
	}

	@Override
	public ArtifactResults getPatientArtifacts(RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier, StudyFilter studyFilter,
			StudyLoadLevel studyLoadLevel, boolean includeImages,
			boolean includeDocuments) throws MethodException,
			ConnectionException 
	{
        getLogger().info("getPatientArtifacts for patient ({}), StudyLoadLevel ({}), TransactionContext ({}).", patientIdentifier, studyLoadLevel, TransactionContextFactory.get().getDisplayIdentity());
		
		if(studyFilter.getMusePatientId() == null || studyFilter.getMusePatientId().equals(""))
			throw new MethodException("Cannot use local patient identifier to retrieve remote patient information");

		// Filter this out based on the patient ID pattern matching
		if (getMuseConfiguration() != null && studyFilter != null) {
			String patientIdFilterPattern = getMuseConfiguration().getMusePatientFilterRegularExpression();
			String musePatientId = studyFilter.getMusePatientId();
			if ((patientIdFilterPattern != null) && (musePatientId != null) && musePatientId.matches(patientIdFilterPattern)) {
				getLogger().info("getPatientArtifacts filtered out patient for MUSE service because muse identifier matched pattern");
				return null;
			}
		}

		try 
		{
			museConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting patient artifacts", ioX);
			throw new MuseConnectionException(ioX);
		}					
		if(studyFilter != null)
		{
			if(studyFilter.isStudyIenSpecified())
			{
                getLogger().info("Filtering study by study Id [{}]", studyFilter.getStudyId());
			}
		}
		
		List<MuseServerConfiguration> servers = getMuseConfiguration().getServers();
		ArtifactResults result = null;
		ArtifactResults collectedResults = null;
		for(MuseServerConfiguration server : servers){
			
			if(!server.isMuseDisabled()){
				result = getProxy(server).getPatientArtifacts(getSite(), patientIdentifier, studyFilter, globalRoutingToken, 
						studyLoadLevel, includeImages, includeDocuments);
                getLogger().info("getPatientArtifacts got [{}] artifacts from site [{}]", result == null ? "0" : "" + result.getArtifactSize(), getSite().getSiteNumber());
				collectedResults = MuseDatasourceTranslator.mergeMuseResults(collectedResults, result);
			}
			else{
				getLogger().info("Muse Services are disabled.");
			}
		}
		return collectedResults;
	}
}
