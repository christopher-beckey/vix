package gov.va.med.imaging.tiu.federation.proxy.v10;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import org.apache.commons.httpclient.methods.GetMethod;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.consult.federation.translator.ConsultFederationRestTranslator;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.federation.rest.proxy.AbstractFederationRestProxy;
import gov.va.med.imaging.federation.rest.proxy.FederationRestGetClient;
import gov.va.med.imaging.federation.rest.proxy.FederationRestPostClient;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.TIUFederationProxyServiceType;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.datasource.ITIUNoteRestProxy;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;
import gov.va.med.imaging.tiu.federation.endpoints.FederationTIUNoteRestUri;
import gov.va.med.imaging.tiu.federation.translator.TIUFederationRestTranslator;
import gov.va.med.imaging.tiu.federation.types.FederationPatientTIUNoteArrayType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUAuthorArrayType;
import gov.va.med.imaging.tiu.federation.types.FederationTIULocationArrayType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteAddendumInputType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteArrayType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteInputParametersType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteInputType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class FederationRestTIUNoteProxyV10
extends AbstractFederationRestProxy
implements ITIUNoteRestProxy
{

	public FederationRestTIUNoteProxyV10(ProxyServices proxyServices, FederationConfiguration federationConfiguration) {
		super(proxyServices, federationConfiguration);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.ImagingProxy#addOptionalGetInstanceHeaders(org.apache.commons.httpclient.methods.GetMethod)
	 */
	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) 
	{
		// not needed here
	}	

	@Override
	protected String getRestServicePath() {
		return FederationTIUNoteRestUri.tiuNoteServicePath;
	}

	@Override
	protected ProxyServiceType getProxyServiceType() {
		return new TIUFederationProxyServiceType();
	}

	@Override
	protected String getDataSourceVersion() {
		return "10";
	}

	public List<TIUNote> getMatchingTIUNotes(RoutingToken globalRoutingToken, String searchText, String titleList)
			throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("getMatchingTIUNotes, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), globalRoutingToken.toRoutingTokenString());
			setDataSourceMethodAndVersion("getMatchingTIUNotes");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.getTIUNotesPath, urlParameterKeyValues);

			searchText = (searchText == null) ? ("null") : URLEncoder.encode(searchText, "UTF-8");
			titleList = (titleList == null) ? ("null") : URLEncoder.encode(titleList, "UTF-8");
			url = url + "?searchText=" + searchText + "&titleList=" + titleList;
			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			FederationTIUNoteArrayType federationTIUNoteArrayType = null;
			try {
				federationTIUNoteArrayType = getClient.executeRequest(FederationTIUNoteArrayType.class);
			} catch (ConnectionException ex) {
				String msg = ex.getMessage();
				if (msg != null && msg.contains("XMLStreamException: ParseError")) {
					getLogger().info("Got ConnectionException indicating parse error. This means no TIU Notes were returned, returning empty tiuNotesResult");

					List<TIUNote> tiuNotesResult = new ArrayList<TIUNote>(0);
					return tiuNotesResult;
				}
				throw ex;
			}

            getLogger().info("getMatchingTIUNotes, Transaction [{}] returned [{}] TIUNote webservice objects.", transactionContext.getTransactionId(), federationTIUNoteArrayType == null ? "null" : "" + federationTIUNoteArrayType.getValues().length);
			List<TIUNote> tiuNotesResult = null;
			if (federationTIUNoteArrayType != null && federationTIUNoteArrayType.getValues() != null) {

				List<TIUNote> result = TIUFederationRestTranslator.translate(federationTIUNoteArrayType);
				tiuNotesResult = new ArrayList<TIUNote>(result.size());
				tiuNotesResult.addAll(result);
			} else {
				tiuNotesResult = new ArrayList<TIUNote>(0);
			}
            getLogger().info("getMatchingTIUNotes, Transaction [{}] returned [{}] TIUNote business objects.", transactionContext.getTransactionId(), tiuNotesResult == null ? "null" : "" + tiuNotesResult.size());
			return tiuNotesResult;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting matching TIU notes", e);
			throw new MethodException("General error getting matching TIU notes", e);
		}
	}

	public List<TIUAuthor> getAuthors(RoutingToken globalRoutingToken, String searchText)
			throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("getAuthors, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), globalRoutingToken.toRoutingTokenString());
			setDataSourceMethodAndVersion("getAuthors");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.getTIUAuthorsPath, urlParameterKeyValues);
			searchText = (searchText == null) ? ("null") : URLEncoder.encode(searchText, "UTF-8");
			url = url + "?searchText=" + searchText;
			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			FederationTIUAuthorArrayType federationTIUAuthorArrayType = null;
			try {
				federationTIUAuthorArrayType = getClient.executeRequest(FederationTIUAuthorArrayType.class);
			} catch (ConnectionException ex) {
				String msg = ex.getMessage();
				if (msg != null && msg.contains("XMLStreamException: ParseError")) {
					getLogger().info("Got ConnectionException indicating parse error. This means no TIU Notes were returned, returning empty tiuAuthorResult");

					List<TIUAuthor> tiuAuthorResult = new ArrayList<TIUAuthor>(0);
					return tiuAuthorResult;
				}
				throw ex;
			}

            getLogger().info("getAuthors, Transaction [{}] returned [{}] TIUAuthors webservice objects.", transactionContext.getTransactionId(), federationTIUAuthorArrayType == null ? "null" : "" + federationTIUAuthorArrayType.getValues().length);
			List<TIUAuthor> tiuAuthorResult = null;
			if (federationTIUAuthorArrayType != null && federationTIUAuthorArrayType.getValues() != null) {

				List<TIUAuthor> result = TIUFederationRestTranslator.translate(federationTIUAuthorArrayType);
				tiuAuthorResult = new ArrayList<TIUAuthor>(result.size());
				tiuAuthorResult.addAll(result);
			} else {
				tiuAuthorResult = new ArrayList<TIUAuthor>(0);
			}
            getLogger().info("getAuthors, Transaction [{}] returned [{}] TIUAuthors business objects.", transactionContext.getTransactionId(), tiuAuthorResult == null ? "null" : "" + tiuAuthorResult.size());
			return tiuAuthorResult;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting authors", e);
			throw new MethodException("General error getting authors", e);
		}
	}

	public List<TIULocation> getLocations(RoutingToken globalRoutingToken, String searchText)
			throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("getLocations, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), globalRoutingToken.toRoutingTokenString());
			setDataSourceMethodAndVersion("getLocations");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.getTIULocationsPath, urlParameterKeyValues);
			searchText = (searchText == null) ? ("null") : URLEncoder.encode(searchText, "UTF-8");
			url = url + "?searchText=" + searchText;

			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			FederationTIULocationArrayType federationTIULocationArrayType = null;
			try {
				federationTIULocationArrayType = getClient.executeRequest(FederationTIULocationArrayType.class);
			} catch (ConnectionException ex) {
				String msg = ex.getMessage();
				if (msg != null && msg.contains("XMLStreamException: ParseError")) {
					getLogger().info("Got ConnectionException indicating parse error. This means no studies were returned, returning empty studyResult");

					List<TIULocation> indexTermValueResult = new ArrayList<TIULocation>(0);
					return indexTermValueResult;
				}
				throw ex;
			}

            getLogger().info("getLocations, Transaction [{}] returned [{}] TIULocation webservice objects.", transactionContext.getTransactionId(), federationTIULocationArrayType == null ? "null" : "" + federationTIULocationArrayType.getValues().length);
			List<TIULocation> tiuLocationsResult = null;
			if (federationTIULocationArrayType != null && federationTIULocationArrayType.getValues() != null) {
				List<TIULocation> result = TIUFederationRestTranslator.translate(federationTIULocationArrayType);
				tiuLocationsResult = new ArrayList<TIULocation>(result.size());
				tiuLocationsResult.addAll(result);
			} else {
				tiuLocationsResult = new ArrayList<TIULocation>(0);
			}
            getLogger().info("getLocations, Transaction [{}] returned [{}] TIULocation business objects.", transactionContext.getTransactionId(), tiuLocationsResult == null ? "null" : tiuLocationsResult.size());
			return tiuLocationsResult;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting locations", e);
			throw new MethodException("General error getting locations", e);
		}
	}

	public Boolean associateImageWithTIUNote(AbstractImagingURN imagingUrn, PatientTIUNoteURN patientTIUNoteUrn)
			throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("associateImageWithTIUNote, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), patientTIUNoteUrn.toRoutingTokenString());
			setDataSourceMethodAndVersion("associateImageWithTIUNote");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", patientTIUNoteUrn.toRoutingTokenString());
			urlParameterKeyValues.put("{imageUrn}", imagingUrn.toString());
			urlParameterKeyValues.put("{tiuNoteUrn}", patientTIUNoteUrn.toString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.associateImageWithNotePath, urlParameterKeyValues);
			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			RestBooleanReturnType result = getClient.executeRequest(RestBooleanReturnType.class);
            getLogger().info("associateImageWithTIUNote, Transaction [{}] returned [{}]  result.", transactionContext.getTransactionId(), result == null ? "null" : result.isResult());
			if (result == null) {
				return new Boolean(false);
			} else {
				return new Boolean(result.isResult());
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error associating image with TIU note", e);
			throw new MethodException("General error associating image with TIU note", e);
		}
	}

	public PatientTIUNoteURN createTIUNote(TIUItemURN tiuNoteUrn, PatientIdentifier patientIdentifier,
			TIUItemURN locationUrn, Date noteDate, ConsultURN consultUrn, String noteText, TIUItemURN authorUrn)
			throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("createTIUNote, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), tiuNoteUrn.toRoutingTokenString());
			setDataSourceMethodAndVersion("createTIUNote");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", tiuNoteUrn.toRoutingTokenString());

			// Create note type
			FederationTIUNoteInputType federationTIUNoteType = new FederationTIUNoteInputType();

			// Set note urn
			if (tiuNoteUrn != null) {
				federationTIUNoteType.setNoteUrn(TIUFederationRestTranslator.translateUrn(tiuNoteUrn));
			}

			// Set patient identifier
			if (patientIdentifier != null) {
				federationTIUNoteType.setPatientIdentifier(new RestStringType(patientIdentifier.toString()));
			}

			// Set location urn
			if (locationUrn != null) {
				federationTIUNoteType.setLocationUrn(TIUFederationRestTranslator.translateUrn(locationUrn));
			}

			// Set consult urn
			if (consultUrn != null) {
				federationTIUNoteType.setConsultUrn(ConsultFederationRestTranslator.translateUrn(consultUrn));
			}

			// Set note text
			if (noteText != null) {
				federationTIUNoteType.setNoteText(TIUFederationRestTranslator.translate(noteText));
			}

			// Set author urn
			if (authorUrn != null) {
				federationTIUNoteType.setAuthorUrn(TIUFederationRestTranslator.translateUrn(authorUrn));
			}

			// Set note date (not really necessary)
			if (noteDate != null) {
				federationTIUNoteType.setNoteDate(noteDate);
			}

			// Initialize URL and client
			String url = getWebResourceUrl(FederationTIUNoteRestUri.createTIUNotePath, urlParameterKeyValues);
			FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);

			// Get result from client
			RestStringType federationPatientTIUNoteUrnType = null;
			try {
				federationPatientTIUNoteUrnType = postClient.executeRequest(RestStringType.class, federationTIUNoteType);
			} catch (ConnectionException ex) {
				String msg = ex.getMessage();
				if ((msg != null) && (msg.contains("XMLStreamException: ParseError"))) {
					getLogger().info("Got ConnectionException indicating parse error. This means no TIU Notes were returned, returning empty patientTIUNoteURNResult");
					return null;
				}
				throw ex;
			} catch (Exception e) {
				throw new MethodException("General exception calling federation REST endpoint to create note", e);
			}

			// Log the result
            getLogger().info("createTIUNote, Transaction [{}] returned [{}] PatientTIUNoteURN webservice object.", transactionContext.getTransactionId(), federationPatientTIUNoteUrnType.getValue() == null ? "null" : "only 1");

			// Check the result
			try {
				PatientTIUNoteURN patientTIUNoteUrnResult = null;
				if (federationPatientTIUNoteUrnType != null && federationPatientTIUNoteUrnType != null) {
					patientTIUNoteUrnResult = TIUFederationRestTranslator.translatePatientTIUNoteURN(federationPatientTIUNoteUrnType);
				}
                getLogger().info("createTIUNote, Transaction [{}] returned [{}] PatientTIUNoteURN business object.", transactionContext.getTransactionId(), patientTIUNoteUrnResult == null ? "null" : "only 1");
				return patientTIUNoteUrnResult;
			} catch (Exception e) {
				throw new MethodException("Error creating tiu note while translating TIU note urn", e);
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error creating TIU note", e);
			throw new MethodException("General error creating TIU note", e);
		}
	}

	public Boolean electronicallySignTIUNote(PatientTIUNoteURN tiuNoteUrn, String electronicSignature)
			throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("electronicallySignTIUNote, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), tiuNoteUrn.toRoutingTokenString());
			setDataSourceMethodAndVersion("electronicallySignTIUNote");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", tiuNoteUrn.toRoutingTokenString());
			urlParameterKeyValues.put("{tiuNoteUrn}", tiuNoteUrn.toString());

			RestStringType eSignatureType = new RestStringType(electronicSignature);

			String url = getWebResourceUrl(FederationTIUNoteRestUri.electronicallySignNotePath, urlParameterKeyValues);
			FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			RestBooleanReturnType result = postClient.executeRequest(RestBooleanReturnType.class, eSignatureType);
            getLogger().info("electronicallySignTIUNote, Transaction [{}] returned [{}]  result.", transactionContext.getTransactionId(), result == null ? "null" : result.isResult());
			if (result == null) {
				return new Boolean(false);
			} else {
				return new Boolean(result.isResult());
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error electronically signing TIU note", e);
			throw new MethodException("General error electronically signing TIU note", e);
		}
	}

	public Boolean electronicallyFileTIUNote(PatientTIUNoteURN tiuNoteUrn) throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("electronicallyFileTIUNote, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), tiuNoteUrn.toRoutingTokenString());
			setDataSourceMethodAndVersion("electronicallyFileTIUNote");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", tiuNoteUrn.toRoutingTokenString());
			urlParameterKeyValues.put("{tiuNoteUrn}", tiuNoteUrn.toString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.electronicallyFileNotePath, urlParameterKeyValues);
			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			RestBooleanReturnType result = getClient.executeRequest(RestBooleanReturnType.class);
            getLogger().info("electronicallyFileTIUNote, Transaction [{}] returned [{}]  result.", transactionContext.getTransactionId(), result == null ? "null" : result.isResult());
			if (result == null) {
				return new Boolean(false);
			} else {
				return new Boolean(result.isResult());
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error electronically filing TIU note", e);
			throw new MethodException("General error electronically filing TIU note", e);
		}
	}

	public Boolean isTIUNoteAConsult(TIUItemURN tiuItemUrn) throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("isTIUNoteAConsult, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), tiuItemUrn.toRoutingTokenString());
			setDataSourceMethodAndVersion("isTIUNoteAConsult");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", tiuItemUrn.toRoutingTokenString());
			urlParameterKeyValues.put("{tiuItemUrn}", tiuItemUrn.toString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.isTiuNoteAConsultPath, urlParameterKeyValues);
			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			RestBooleanReturnType result = getClient.executeRequest(RestBooleanReturnType.class);
            getLogger().info("isTIUNoteAConsult, Transaction [{}] returned [{}]  result.", transactionContext.getTransactionId(), result == null ? "null" : result.isResult());
			if (result == null) {
				return new Boolean(false);
			} else {
				return new Boolean(result.isResult());
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error checking if TIU note is a consult", e);
			throw new MethodException("General error checking if TIU note is a consult", e);
		}
	}

	public Boolean isNoteValidAdvanceDirective(TIUItemURN tiuItemUrn) throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("isNoteValidAdvanceDirective, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), tiuItemUrn.toRoutingTokenString());
			setDataSourceMethodAndVersion("isNoteValidAdvanceDirective");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", tiuItemUrn.toRoutingTokenString());
			urlParameterKeyValues.put("{tiuItemUrn}", tiuItemUrn.toString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.isNoteValidAdvanceDirectivePath, urlParameterKeyValues);
			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			RestBooleanReturnType result = getClient.executeRequest(RestBooleanReturnType.class);
            getLogger().info("isNoteValidAdvanceDirective, Transaction [{}] returned [{}]  result.", transactionContext.getTransactionId(), result == null ? "null" : result.isResult());
			if (result == null) {
				return new Boolean(false);
			} else {
				return new Boolean(result.isResult());
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error checking note advance directive validity", e);
			throw new MethodException("General error checking note advance directive validity", e);
		}
	}

	public Boolean isPatientNoteValidAdvanceDirective(PatientTIUNoteURN noteUrn)
			throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("isPatientNoteValidAdvanceDirective, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), noteUrn.toRoutingTokenString());
			setDataSourceMethodAndVersion("isPatientNoteValidAdvanceDirective");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", noteUrn.toRoutingTokenString());
			urlParameterKeyValues.put("{noteUrn}", noteUrn.toString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.isPatientNoteValidAdvanceDirectivePath, urlParameterKeyValues);
			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			RestBooleanReturnType result = getClient.executeRequest(RestBooleanReturnType.class);
            getLogger().info("isPatientNoteValidAdvanceDirective, Transaction [{}] returned [{}]  result.", transactionContext.getTransactionId(), result == null ? "null" : result.isResult());
			if (result == null) {
				return new Boolean(false);
			} else {
				return new Boolean(result.isResult());
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error checking patient note advance directive validity", e);
			throw new MethodException("General error checking patient note advance directive validity", e);
		}
	}

	
	public List<PatientTIUNote> getPatientTIUNotes(RoutingToken globalRoutingToken, TIUNoteRequestStatus noteStatus,
			PatientIdentifier patientIdentifier, Date fromDate, Date toDate, String authorDuz, int count,
			boolean ascending) throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("getPatientTIUNotes, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), globalRoutingToken.toRoutingTokenString());
			setDataSourceMethodAndVersion("getPatientTIUNotes");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());

			FederationTIUNoteInputParametersType federationTIUNoteInputType = new FederationTIUNoteInputParametersType();
			federationTIUNoteInputType.setNoteStatus(TIUFederationRestTranslator.translate(noteStatus));
			federationTIUNoteInputType.setPatientIdentifier(new RestStringType(patientIdentifier.getValue()));
			federationTIUNoteInputType.setCount(count);
			federationTIUNoteInputType.setAscending(ascending);
			federationTIUNoteInputType.setAuthorDuz(authorDuz);
			federationTIUNoteInputType.setFromDate(convertDate(fromDate));
			federationTIUNoteInputType.setToDate(convertDate(toDate));

			String url = getWebResourceUrl(FederationTIUNoteRestUri.getPatientTIUNotesPath, urlParameterKeyValues);
			FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			FederationPatientTIUNoteArrayType federationPatientTIUNoteArrayType = null;
			try {
				federationPatientTIUNoteArrayType = postClient.executeRequest(FederationPatientTIUNoteArrayType.class, federationTIUNoteInputType);
			} catch (ConnectionException ex) {
				String msg = ex.getMessage();
				if (msg != null && msg.contains("XMLStreamException: ParseError")) {
					getLogger().info("Got ConnectionException indicating parse error. This means no studies were returned, returning empty studyResult");

					List<PatientTIUNote> patientTIUNoteResult = new ArrayList<PatientTIUNote>(0);
					return patientTIUNoteResult;
				}
				throw ex;
			}

            getLogger().info("getPatientTIUNotes, Transaction [{}] returned [{}] IndexTermValue webservice objects.", transactionContext.getTransactionId(), federationPatientTIUNoteArrayType == null ? "null" : federationPatientTIUNoteArrayType.getValues().length);
			List<PatientTIUNote> patientTIUNoteResult = null;
			if (federationPatientTIUNoteArrayType != null && federationPatientTIUNoteArrayType.getValues() != null) {
				List<PatientTIUNote> result = TIUFederationRestTranslator.translate(federationPatientTIUNoteArrayType);
				patientTIUNoteResult = new ArrayList<PatientTIUNote>(result.size());
				patientTIUNoteResult.addAll(result);
			} else {
				patientTIUNoteResult = new ArrayList<PatientTIUNote>(0);
			}
            getLogger().info("getPatientTIUNotes, Transaction [{}] returned [{}] IndexTermValue business objects.", transactionContext.getTransactionId(), patientTIUNoteResult == null ? "null" : patientTIUNoteResult.size());
			return patientTIUNoteResult;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting patient TIU notes", e);
			throw new MethodException("General error getting patient TIU notes", e);
		}
	}

	public String getTIUNoteText(PatientTIUNoteURN noteUrn) throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("getTIUNoteText, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), noteUrn.toRoutingTokenString());
			setDataSourceMethodAndVersion("getTIUNoteText");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", noteUrn.toRoutingTokenString());
			urlParameterKeyValues.put("{noteUrn}", noteUrn.toString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.getTIUNoteTextPath, urlParameterKeyValues);
			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			String result = getClient.executeRequest(String.class);
            getLogger().info("getImageSystemGlobalNode, Transaction [{}] returned response of length [{}] bytes.", transactionContext.getTransactionId(), result == null ? "null" : result.length());
			return result;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error getting TIU note text", e);
			throw new MethodException("General error getting TIU note text", e);
		}
	}

	public PatientTIUNoteURN createTIUNoteAddendum(PatientTIUNoteURN noteUrn, Date date, String addendumText)
			throws MethodException, ConnectionException {
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("createTIUNoteAddendum, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), noteUrn.toRoutingTokenString());
			setDataSourceMethodAndVersion("createTIUNoteAddendum");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", noteUrn.toRoutingTokenString());
			urlParameterKeyValues.put("{noteUrn}", noteUrn.toString());

			FederationTIUNoteAddendumInputType addendumType = new FederationTIUNoteAddendumInputType(date.toString(), addendumText);

			String url = getWebResourceUrl(FederationTIUNoteRestUri.createTIUNoteAddendumPath, urlParameterKeyValues);
			FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			RestStringType federationPatientTIUNoteUrnType = null;
			try {
				federationPatientTIUNoteUrnType = postClient.executeRequest(RestStringType.class, addendumType);
			} catch (ConnectionException ex) {
				String msg = ex.getMessage();
				if (msg != null && msg.contains("XMLStreamException: ParseError")) {
					getLogger().info("Got ConnectionException indicating parse error. This means no studies were returned, returning empty studyResult");

					PatientTIUNoteURN patientTIUNoteUrnResult = null;
					return patientTIUNoteUrnResult;
				}
				throw ex;
			}

            getLogger().info("createTIUNoteAddendum, Transaction [{}] returned [{}] TIU webservice objects.", transactionContext.getTransactionId(), federationPatientTIUNoteUrnType == null ? "null" : federationPatientTIUNoteUrnType);
			try {
				PatientTIUNoteURN patientTIUNoteUrnResult = null;
				if (federationPatientTIUNoteUrnType != null) {
					patientTIUNoteUrnResult = TIUFederationRestTranslator.translatePatientTIUNoteURN(federationPatientTIUNoteUrnType);
				} else {
					patientTIUNoteUrnResult = null;
				}
                getLogger().info("createTIUNoteAddendum, Transaction [{}] returned [{}] IndexTermValue business objects.", transactionContext.getTransactionId(), patientTIUNoteUrnResult == null ? "null" : patientTIUNoteUrnResult);
				return patientTIUNoteUrnResult;
			} catch (URNFormatException urnfX) {
				getLogger().error("Error in createTIUNoteAddendum", urnfX);
				throw new MethodException(urnfX);
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error creating note addendum", e);
			throw new MethodException("General error creating note addendum", e);
		}
	}

	public Boolean isTIUNoteValid(RoutingToken globalRoutingToken, TIUItemURN tiuNoteUrn, PatientTIUNoteURN patientTiuNoteUrn,
			String typeIndex) 
	throws MethodException, ConnectionException 
	{
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();

            getLogger().info("isTIUNoteValid, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), globalRoutingToken.toRoutingTokenString());
			setDataSourceMethodAndVersion("isTIUNoteValid");
			Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
			urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());

			String url = getWebResourceUrl(FederationTIUNoteRestUri.isTiuNoteValidPath, urlParameterKeyValues);
			Boolean firstQueryParam = false;
			String queryDelim = "?";

			if (tiuNoteUrn != null) {
				firstQueryParam = true;
				url = url + queryDelim + "tiuNoteUrn=" + URLEncoder.encode(tiuNoteUrn.toString(), "UTF-8");
			}

			if (patientTiuNoteUrn != null) {
				queryDelim = (firstQueryParam ? "&" : "?");
				firstQueryParam = true;
				url = url + queryDelim + "patientTiuNoteUrn=" + URLEncoder.encode(patientTiuNoteUrn.toString(), "UTF-8");
			}

			if (typeIndex != null) {
				queryDelim = (firstQueryParam ? "&" : "?");
				url = url + queryDelim + "typeIndex=" + URLEncoder.encode(typeIndex, "UTF-8");
			}

			FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
			RestBooleanReturnType result = getClient.executeRequest(RestBooleanReturnType.class);
            getLogger().info("isTIUNoteValid, Transaction [{}] returned [{}]  result.", transactionContext.getTransactionId(), result == null ? "null" : "" + result.isResult());
			if (result == null) {
				return new Boolean(false);
			} else {
				return new Boolean(result.isResult());
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			getLogger().debug("General error checking note validity", e);
			throw new MethodException("General error checking note validity", e);
		}
	}
	
	private String convertDate(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:sszzz");
	    String strDate = null;

		if(date != null){
			strDate = sdf.format(date);
		}
		return strDate;

	}
	
}
