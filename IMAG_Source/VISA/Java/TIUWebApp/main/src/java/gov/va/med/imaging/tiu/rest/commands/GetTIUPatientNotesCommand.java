/**
 * 
 * 
 * Date Created: Feb 13, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.commands;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;
import gov.va.med.imaging.tiu.rest.translator.TIURestTranslator;
import gov.va.med.imaging.tiu.rest.types.TIUPatientNotesType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUPatientNotesCommand
extends AbstractTIUCommand<List<PatientTIUNote>, TIUPatientNotesType>
{
	private final String requestStatus;
	private final String patientId;
	private final String fromDate;
	private final String toDate;
	private final String authorDuz;
	private final int count;
	private final boolean ascending;
	private final String interfaceVersion;
	private final String siteId;
	
	public GetTIUPatientNotesCommand(String siteId, String requestStatus,
		String patientId, String fromDate, String toDate, String authorDuz,
		int count, boolean ascending, String interfaceVersion)
	{
		super("getPatientNotes");
		this.requestStatus = requestStatus;
		this.patientId = patientId;
		this.fromDate = fromDate;
		this.toDate = toDate;
		this.authorDuz = authorDuz;
		this.count = count;
		this.ascending = ascending;
		this.interfaceVersion = interfaceVersion;
		this.siteId = siteId;
		getLogger().debug("...calling GetTIUPatientNotesCommand method.");
}

	/**
	 * @return the requestStatus
	 */
	public String getRequestStatus()
	{
		return requestStatus;
	}

	/**
	 * @return the patientId
	 */
	public String getPatientId()
	{
		return patientId;
	}

	/**
	 * @return the fromDate
	 */
	public Date getFromDate()
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:sszzz");
	    Date startDate = null;

		if(this.fromDate != null && !this.fromDate.equals("")){
			try {
				startDate = sdf.parse(this.fromDate);
			} catch (ParseException pX) {
				getLogger().warn("Failed to parse fromDate. Will continue query without this query field.  ", pX);
			}
		}
		return startDate;
	}

	/**
	 * @return the toDate
	 */
	public Date getToDate()
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:sszzz");
	    Date stopDate = null;

		if(this.toDate != null && !this.toDate.equals("")){
			try {
				stopDate = sdf.parse(this.toDate);
			} catch (ParseException pX) {
				getLogger().warn("Failed to parse toDate. Will continue query without this query field.  ", pX);
			}
		}
		return stopDate;
	}

	/**
	 * @return the authorDuz
	 */
	public String getAuthorDuz()
	{
		return authorDuz;
	}

	/**
	 * @return the count
	 */
	public int getCount()
	{
		return count;
	}

	/**
	 * @return the ascending
	 */
	public boolean isAscending()
	{
		return ascending;
	}

	public String getSiteId() {
		return siteId;
	}
	
	protected SiteServiceFacadeRouter getSiteServiceRouter(){
		return SiteServiceContext.getSiteServiceFacadeRouter();
	}

	protected SiteConnection getLocalSiteConnection(String protocol) throws MethodException, ConnectionException{
		SiteServiceFacadeRouter siteServiceRouter = getSiteServiceRouter();
		if (siteServiceRouter == null) {
			return null;
		}

		Site site = siteServiceRouter.getSite(getSiteId());
		if (site == null) {
			return null;
		}

		return site.getSiteConnections().get(protocol);
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<PatientTIUNote> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		getLogger().debug("...executing Router command.");

		List<PatientTIUNote> patientTIUNoteList = null;
		try {
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			PatientIdentifier patientIdentifier = TIURestTranslator.parsePatientIdentifier(getPatientId());
			TIUNoteRequestStatus noteRequestStatus = TIURestTranslator.translate(getRequestStatus());

			patientTIUNoteList = getRouter().getPatientTIUNotes(routingToken, noteRequestStatus, patientIdentifier, getFromDate(), getToDate(), getAuthorDuz(), getCount(), isAscending());

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
				throw new ConnectionException("No VIXS or VIX site available");
			}

			StringBuffer buf = new StringBuffer();
			buf.append(protocol);
			buf.append("://");
			buf.append(siteConnection.getServer());
			buf.append(":");
			buf.append(siteConnection.getPort());
			buf.append("/IngestWebApp");
			buf.append("/token/ingest");

			for (PatientTIUNote note : patientTIUNoteList) {
				note.setSiteVixUrl(buf.toString());
			}

			return patientTIUNoteList;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting tiu patient notes via router", e);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient (" + getPatientId() + ") with note status (" + getRequestStatus() + ")";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected TIUPatientNotesType translateRouterResult(
		List<PatientTIUNote> routerResult)
	throws TranslationException, MethodException
	{
		return TIURestTranslator.translatePatientNotes(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<TIUPatientNotesType> getResultClass()
	{
		return TIUPatientNotesType.class;
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
	public Integer getEntriesReturned(TIUPatientNotesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getNote().length;
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, getRequestStatus());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientId());
	
		return transactionContextFields;
	}
	
}
