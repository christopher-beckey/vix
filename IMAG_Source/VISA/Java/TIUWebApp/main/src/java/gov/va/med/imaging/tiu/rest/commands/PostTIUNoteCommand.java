/**
 * 
 * 
 * Date Created: Feb 7, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.commands;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import gov.va.med.PatientIdentifier;
import gov.va.med.URNFactory;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.rest.translator.TIURestTranslator;
import gov.va.med.imaging.tiu.rest.types.TIUNoteInputType;
import gov.va.med.imaging.tiu.rest.types.TIUPatientNoteType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import javax.net.ssl.*;

/**
 * @author Julian Werfel
 *
 */
public class PostTIUNoteCommand
extends AbstractTIUCommand<PatientTIUNote, TIUPatientNoteType> {
	
	private final TIUNoteInputType noteInput;
	private final String interfaceVersion;
	private String siteId;

	/**
	 * @param noteInput
	 */
	public PostTIUNoteCommand(TIUNoteInputType noteInput,
		String interfaceVersion) {
		
		super("PostTIUNoteCommand(createTIUNote)");
		this.noteInput = noteInput;
		this.interfaceVersion = interfaceVersion;
	}

	/**
	 * @return the noteInput
	 */
	public TIUNoteInputType getNoteInput() {
		return noteInput;
	}
	
	public String getSiteId() {
		return siteId;
	}

	protected SiteConnection getLocalSiteConnection(String protocol) throws MethodException, ConnectionException {
		
		SiteServiceFacadeRouter siteServiceRouter = getSiteServiceRouter();
		
		if (siteServiceRouter == null) {
			getLogger().warn("Couldn't get a SiteServiceRouter instance. Return null.");
			return null;
		}

		Site site = siteServiceRouter.getSite(getSiteId());
		if (site == null) {
			getLogger().warn("Couldn't get a Site from given site Id [{}]. Return null.", getSiteId());
			return null;
		}

		return site.getSiteConnections().get(protocol);
	}
	
	protected SiteServiceFacadeRouter getSiteServiceRouter() {
		return SiteServiceContext.getSiteServiceFacadeRouter();
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected PatientTIUNote executeRouterCommand()
	throws MethodException, ConnectionException {
		
		try {
			
			TIUNoteInputType noteInput = getNoteInput();

			// Get note title urn
			TIUItemURN tiuNoteTitleUrn = null;
			if (noteInput.getTiuNoteTitleUrn() != null) {
				tiuNoteTitleUrn = URNFactory.create(noteInput.getTiuNoteTitleUrn(), TIUItemURN.class);
				this.siteId = tiuNoteTitleUrn.getOriginatingSiteId();
			}

			// Get patient identifier
			PatientIdentifier patientIdentifier = null;
			if (noteInput.getPatientId() != null) {
				patientIdentifier = PatientIdentifier.fromString(noteInput.getPatientId());
			}

			// Get location URN
			TIUItemURN locationUrn = null;
			if ((noteInput.getTiuNoteLocationUrn() != null) && (noteInput.getTiuNoteLocationUrn().length() > 0)) {
				locationUrn = URNFactory.create(noteInput.getTiuNoteLocationUrn(), TIUItemURN.class);
			}

			// Get date
			Date date = null;
			if (noteInput.getDate() != null) {
				date = TIURestTranslator.parseDate(noteInput.getDate());
			}

			// Get consult urn
			ConsultURN consultUrn = null;
			if ((noteInput.getConsultUrn() != null) && (noteInput.getConsultUrn().length() > 0)) {
				consultUrn = URNFactory.create(noteInput.getConsultUrn(), ConsultURN.class);
			}

			// Get note text
			String noteText = null;
			if (noteInput.getNoteText() != null) {
				noteText = noteInput.getNoteText();
			}

			// Get author urn
			TIUItemURN authorUrn = null;
			if ((noteInput.getTiuNoteAuthorUrn() != null) && (noteInput.getTiuNoteAuthorUrn().length() > 0)) {
				if (noteInput.getTiuNoteAuthorUrn().contains(StringUtil.DASH)) {
					authorUrn = URNFactory.create(noteInput.getTiuNoteAuthorUrn(), TIUItemURN.class);
				} else {
					authorUrn = TIUItemURN.create(getSiteId(), noteInput.getTiuNoteAuthorUrn());
				}
			}

			// Get the protocol and site
			String protocol = "https";
			SiteConnection siteConnection = getLocalSiteConnection(SiteConnection.siteConnectionVixs);

			// Fallback if VIXS is not available
			if (siteConnection == null) {
				protocol = "http";
				siteConnection = getLocalSiteConnection(SiteConnection.siteConnectionVix);
			}

			// Ensure we have a site
			if (siteConnection == null) {
				String msg = "No VIXS or VIX available for given site Id [" + getSiteId() + "]";
				getLogger().error(msg);
				throw new ConnectionException(msg);
			}

			// Construct the url
			StringBuffer buf = new StringBuffer();
			buf.append(protocol);
			buf.append("://");
			buf.append(siteConnection.getServer());
			buf.append(":");
			buf.append(siteConnection.getPort());
			buf.append("/IngestWebApp");
			buf.append("/token/ingest");

			// Reject if the VIX is down
			if (! (checkVixAvailability(protocol, siteConnection))) {
                getLogger().error("Target VIX [{}] is unavailable; rejecting message", siteConnection.getServer());
				throw new MethodException("Target VIX [" + siteConnection.getServer() + "] is unavailable; rejecting note creation");
			}

			// Create the TIU note to get a new PatientTIUNoteURN object
			PatientTIUNoteURN patientTiuNoteUrn = getRouter().createTIUNote(tiuNoteTitleUrn, patientIdentifier, locationUrn, date, consultUrn, noteText, authorUrn);

			// Create the new note object
			PatientTIUNote patientTiuNote = new PatientTIUNote(patientTiuNoteUrn, null, date, null, null, null, null, null, null, 0,  null );
			patientTiuNote.setSiteVixUrl(buf.toString());

			return patientTiuNote;
			
		} catch (MethodException | ConnectionException | URNFormatException e) {
			Throwable exCause = e.getCause();  // Fortify coding			
			String errMsg = exCause != null ? exCause.getMessage() : e.getMessage(); 
			getLogger().error(errMsg);
			throw new MethodException(errMsg, e);
		} catch (Exception e) {
			getLogger().error(e.getMessage(), e);
			throw new MethodException("General error creating TIU note via router", e);
		}
	}

	private boolean checkVixAvailability(String protocol, SiteConnection siteConnection) {

		URL targetURL = null;
		HttpURLConnection urlConnection = null;
		HttpsURLConnection httpsURLConnection = null;
		
		try {
			
			// Connect to the site to get the VISA Version page
			
			targetURL = new URL(protocol + "://" + siteConnection.getServer() + ":" + siteConnection.getPort());
			urlConnection = (HttpURLConnection) targetURL.openConnection();
			
			// Set a connection and read timeout of 10 seconds (should be more than sufficient for the version page)
			urlConnection.setConnectTimeout(10000);
			urlConnection.setReadTimeout(10000);
			
			// If this is HTTPs, we need to ensure we trust any host and don't care about the certificate
			if (urlConnection instanceof HttpsURLConnection) {
				
				httpsURLConnection = (HttpsURLConnection) urlConnection;

				// Trust any host
				httpsURLConnection.setHostnameVerifier(new HostnameVerifier() {
					public boolean verify(String hostname, SSLSession session) {
						return !Objects.isNull(hostname);
					}
				});
				
				// Trust any certificate presented
				SSLContext context = SSLContext.getInstance("TLSv1.2");
				context.init(null, new TrustManager [] {new X509TrustManager() {
					public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {}

					public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {}

					public X509Certificate[] getAcceptedIssuers() {
						//Fortify change: return null;
						return new X509Certificate[0];
					}
				}}, null);
				
				// Set the SSL factory
				httpsURLConnection.setSSLSocketFactory(context.getSocketFactory());	
			}
			
			try(InputStream inStream = urlConnection.getInputStream();
				InputStreamReader streamReader = new InputStreamReader(inStream);
				BufferedReader bufferReader = new BufferedReader(streamReader)) {

				// Read through the input looking for "VISA Version"
				String input = null;
				while ((input = bufferReader.readLine()) != null) {
					if (input.contains("VISA Version")) {
						return true;
					}
				}
			}
		} catch (Exception e) {
            getLogger().warn("PostTIUNoteCommand.checkVixAvailability() --> [{}]: Can't connect to [{}]", e.getClass().getSimpleName(), targetURL);
		} finally {
			try { if (urlConnection != null) { urlConnection.disconnect(); } } catch (Exception e) { /* Ignore */ }
			try { if (httpsURLConnection != null) { httpsURLConnection.disconnect(); } } catch (Exception e) { /* Ignore */ }
		}

		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "creating note [" + getNoteInput().getTiuNoteTitleUrn() + "] for patient [" + getNoteInput().getPatientId() + "]";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected TIUPatientNoteType translateRouterResult(PatientTIUNote routerResult)
	throws TranslationException, MethodException
	{
		return TIURestTranslator.translate(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<TIUPatientNoteType> getResultClass()
	{
		return TIUPatientNoteType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getInterfaceVersion()
	 */
	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(TIUPatientNoteType translatedResult)
	{
		return null;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getNoteInput().getPatientId());
	
		return transactionContextFields;
	}

}
