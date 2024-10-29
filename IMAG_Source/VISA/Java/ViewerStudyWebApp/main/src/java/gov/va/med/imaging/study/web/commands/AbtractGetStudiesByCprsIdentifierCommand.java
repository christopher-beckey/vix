/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Oct 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.MuseStudyURN;
import gov.va.med.imaging.P34StudyURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.study.web.ViewerStudyFacadeRouter;
import gov.va.med.imaging.study.web.rest.translator.ViewerStudyWebTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Julian
 *
 */
public abstract class AbtractGetStudiesByCprsIdentifierCommand<E extends Object>
extends AbstractViewerStudyWebCommand<List<Study>, E>
{

	private final String siteId;
	private final String patientIcn;
	private final String cprsIdentifierString;
	private DocumentSetResult documentSetResult;
	
	public AbtractGetStudiesByCprsIdentifierCommand(String siteId, String patientIcn,
		String cprsIdentifierString)
	{
		super("getStudiesByCprsIdentifier");
		this.siteId = siteId;
		this.patientIcn = patientIcn;
		this.cprsIdentifierString = cprsIdentifierString;
		this.documentSetResult = null;
	}

	/**
	 * @return the siteId
	 */
	public String getSiteId()
	{
		return siteId;
	}

	/**
	 * @return the patientIdentifier
	 */
	public String getPatientIcn()
	{
		return patientIcn;
	}

	/**
	 * @return the cprsIdentifierString
	 */
	public String getCprsIdentifierString()
	{
		return cprsIdentifierString;
	}
	
	public DocumentSetResult getDocumentSetResult()
	{
		return documentSetResult;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<Study> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		getLogger().debug("Called via GetStudiesByCprsIdentifierCommand.");
		ViewerStudyFacadeRouter router = getRouter();
		documentSetResult = null;
		
		try
		{
			PatientIdentifier patientIdentifier = new PatientIdentifier(patientIcn, PatientIdentifierType.icn);
			String cprsIdentifier = getCprsIdentifierString();
            getLogger().debug("cprsIdentifier = {}", cprsIdentifier);
			if(cprsIdentifier.startsWith("urn:vastudy") 
					|| cprsIdentifier.startsWith("urn:bhiestudy")
					|| cprsIdentifier.startsWith("urn:paid")
					|| cprsIdentifier.startsWith("urn:vap34study") 
					|| cprsIdentifier.startsWith("urn:musestudy"))
			{
				boolean includeDocument = false;
				boolean includeRadiology = true;
				StudyURN studyUrn;
				if(cprsIdentifier.startsWith("urn:vap34study")){
					studyUrn = URNFactory.create(cprsIdentifier, P34StudyURN.class);
				}
				else if(cprsIdentifier.startsWith("urn:musestudy")){
					studyUrn = URNFactory.create(cprsIdentifier, MuseStudyURN.class);
				}
				else if(cprsIdentifier.startsWith("urn:paid")){
					studyUrn = null;
					includeDocument = true;
					includeRadiology = false;
				}
				else{
					studyUrn = URNFactory.create(cprsIdentifier, StudyURN.class);					
				}
				
				// Fortify change: why is this an offending statement?
				//logger.debug("creating StudyFilter(" + studyUrn + ")");
				
				TransactionContext transactionContext = TransactionContextFactory.get();
				transactionContext.setUrn(cprsIdentifier);

				StudyFilter filter;
				if (studyUrn != null)
				{
					transactionContext.setPatientID(studyUrn.getPatientId());
					filter = new StudyFilter(studyUrn);
				}
				else
				{
					transactionContext.setPatientID(patientIcn);
					filter = new StudyFilter();
				}
				
				if(cprsIdentifier.startsWith("urn:vap34study")){
					filter.setIncludeAllObjects(true);
				}
				else if(cprsIdentifier.startsWith("urn:musestudy")){
					filter.setIncludeMuseOrders(true);
				}
				else{
					filter.setIncludeAllObjects(false);					
				}
				
				filter.setIncludeImages(true);

                getLogger().debug("getStudyWithImagesByStudyURN - include document = {}", includeDocument);
				ArtifactResults artifactResults = router.getStudyWithImagesByStudyURN(
						RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId()), 
						patientIdentifier, filter, includeRadiology, includeDocument);

                getLogger().debug("artifactResults = {}", artifactResults);
				if(cprsIdentifier.startsWith("urn:paid"))
				{
                    getLogger().debug("DocumentSetResult = {}", artifactResults.getDocumentSetResult());
					if (artifactResults.getDocumentSetResult() != null)
					{
						documentSetResult = artifactResults.getDocumentSetResult();
					}
					//This will force calling TranslateRouterResult
					List<Study> result = new ArrayList<Study>();
					result.add(null);
					return result;
				}
				else
				{
					List<Study> result = new ArrayList<Study>(artifactResults.getStudySetResult().getArtifacts());
					return result;
				}
			}
			else 
			{
				StudyFilter filter = new StudyFilter();
				filter.setIncludeAllObjects(true);
				filter.setIncludeImages(true);
				return router.getStudiesByCprsIdentifier(
						getPatientIcn(), 
						RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId()), 
						new CprsIdentifier(getCprsIdentifierString()),
						filter);
			}
		}
		catch (RoutingTokenFormatException rtfX)
		{
			throw new MethodException("RoutingTokenFormatException, unable to get studies by CPRS identifier", rtfX);
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException("URNFormatException, unable to get studies by CPRS study URN", urnfX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient [" + getPatientIcn() + "] to site [" + getSiteId() + "], CPRS identifier [" + getCprsIdentifierString() + "]";
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIcn());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
	
		return transactionContextFields;
	}
}
