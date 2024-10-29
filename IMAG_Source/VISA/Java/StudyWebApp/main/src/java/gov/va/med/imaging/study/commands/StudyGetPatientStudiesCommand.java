/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 10, 2013
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

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.study.StudyFacadeFilter;
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
public class StudyGetPatientStudiesCommand
extends AbstractStudyCommand<ArtifactResults, StudiesResultType>
{
	private final String patientLookupSiteId;
	private final PatientIdentifier patientIdentifier;
	private final StudyFacadeFilter studyFilter;
	
	public StudyGetPatientStudiesCommand(String patientLookupSiteId, 
			PatientIdentifier patientIdentifier, StudyFilterType studyFilterType)
	{
		super("getVAPatientStudies");
		this.patientLookupSiteId = patientLookupSiteId;
		this.patientIdentifier = patientIdentifier;	
		this.studyFilter = RestStudyTranslator.tranlsate(studyFilterType);
	}
	
	@Override
	protected ArtifactResults executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		checkCommandEnabled();
		try
		{			
			try
			{
				studyFilter.setExcludeSiteNumbers(getExcludedSiteNumbers());
			}
			catch(RoutingTokenFormatException rtfX)
			{
                getLogger().warn("RoutingTokenFormatException while setting excluded sites, {}", rtfX.getMessage(), rtfX);
			}
			
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getPatientLookupSiteId());			
			StudyFacadeRouter router = getRouter();			
			return router.getStudyOnlyArtifactResultsForPatient(routingToken, getPatientIdentifier(), 
					getStudyFilter(), getStudyFilter().isIncludeRadiology(), getStudyFilter().isIncludeArtifacts());
			
		}
		catch (RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}
	
	private Collection<String> getExcludedSiteNumbers()
	{
		Collection<String> excludedSiteNumbers = new ArrayList<String>();
		excludedSiteNumbers.add("200");
		return excludedSiteNumbers;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient '" + getPatientIdentifier() + "'";
	}

	@Override
	protected StudiesResultType translateRouterResult(ArtifactResults routerResult)
	throws TranslationException, MethodException
	{
		return RestStudyTranslator.translate(routerResult);
	}

	@Override
	protected Class<StudiesResultType> getResultClass()
	{
		return StudiesResultType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), 
				studyFilter.getToDate()));
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIdentifier().toString());

		return transactionContextFields;
	}

	@Override
	public Integer getEntriesReturned(StudiesResultType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getSize();
	}

	public String getPatientLookupSiteId()
	{
		return patientLookupSiteId;
	}

	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	public StudyFacadeFilter getStudyFilter()
	{
		return studyFilter;
	}

	@Override
	protected boolean isRequiresEnterprise()
	{
		// this method only works on the CVIX
		return true;
	}

	@Override
	protected boolean isRequiresLocal()
	{
		// this method does not require a VIX enabled (it doesn't actually run on the VIX but the above handles that).
		return false;
	}
}
