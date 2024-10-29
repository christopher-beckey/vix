/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.study.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.study.StudyFacadeRouter;
import gov.va.med.imaging.study.rest.translator.RestStudyTranslator;
import gov.va.med.imaging.study.rest.types.StudiesResultType;
import gov.va.med.imaging.study.rest.types.StudyFilterType;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public class StudyGetStudiesCommand
extends AbstractStudyCommand<ArtifactResults, StudiesResultType>
{
	private final String siteId;
	private final PatientIdentifier patientIdentifier;
	private final StudyFilter studyFilter;
	
	public StudyGetStudiesCommand(String siteId, PatientIdentifier patientIdentifier, StudyFilterType studyFilterType) {
		
		super("StudyGetStudiesCommand");
		this.siteId = siteId;
		this.patientIdentifier = patientIdentifier;	
		this.studyFilter = RestStudyTranslator.tranlsate(studyFilterType);
	}
	
	public StudyGetStudiesCommand(PatientIdentifier patientIdentifier, StudyFilterType studyFilterType) {
		
		this(null, patientIdentifier, studyFilterType);
	}

	@Override
	protected ArtifactResults executeRouterCommand() 
	throws MethodException, ConnectionException {
		
		checkCommandEnabled();
		RoutingToken routingToken = null;
		
		if(getSiteId() == null || getSiteId().length() <= 0) {
			routingToken = getLocalRoutingToken();
		} else {
			try {
				routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			} catch (RoutingTokenFormatException rtfX) {
				throw new MethodException(rtfX);
			}
		}
		
		StudyFacadeRouter router = getRouter();
		if(router == null) {
			String errMsg = "StudyGetStudiesCommand --> Could not get an instance of StudyFacadeRouter. Can't proceed.";
			getLogger().error(errMsg);
			throw new MethodException(errMsg);
		}

		return router.getShallowArtifactResultsForPatientFromSite(routingToken, getPatientIdentifier(), 
				getStudyFilter(), true, true);
	}

	@Override
	protected String getMethodParameterValuesString() {
		
		return "for patient [" + getPatientIdentifier() + "] from site [" + getSiteId() + "]";
	}

	@Override
	protected StudiesResultType translateRouterResult(ArtifactResults routerResult)
	throws TranslationException, MethodException {
		
		return RestStudyTranslator.translate(routerResult);
	}

	@Override
	protected Class<StudiesResultType> getResultClass() {
		
		return StudiesResultType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		
		Map<WebserviceInputParameterTransactionContextField, String> txContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		txContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		txContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		txContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), 
				studyFilter.getToDate()));
		txContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIdentifier().toString());

		return txContextFields;
	}

	@Override
	public Integer getEntriesReturned(StudiesResultType translatedResult) {
		
		return translatedResult == null ? 0 : translatedResult.getSize();
	}

	public String getSiteId() {
		
		return siteId;
	}

	public PatientIdentifier getPatientIdentifier()	{
		
		return patientIdentifier;
	}

	public StudyFilter getStudyFilter() {
		
		return studyFilter;
	}

	@Override
	protected boolean isRequiresEnterprise() {
		
		// no matter the input, this command will not require the CVIX
		return false;
	}

	@Override
	protected boolean isRequiresLocal()	{
		/*
		// if the patient identifier is a DFN then this requires a VIX, not a CVIX
		if(getPatientIdentifier().getPatientIdentifierType() == PatientIdentifierType.dfn)
			return true;
		return false;
		*/
		
		return getPatientIdentifier().getPatientIdentifierType() == PatientIdentifierType.dfn;
	}
}
