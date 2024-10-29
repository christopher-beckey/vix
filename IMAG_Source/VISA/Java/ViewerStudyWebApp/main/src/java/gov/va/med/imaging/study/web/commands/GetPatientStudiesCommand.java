/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jun 4, 2015
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.study.web.rest.translator.ViewerStudyWebTranslator;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyFilterType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyStudiesType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyStudyType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Julian
 *
 */
public class GetPatientStudiesCommand
extends AbstractViewerStudyWebCommand<List<Study>, ViewerStudyStudiesType>
{
	private final String siteId;
	private final String patientIcn;
	private final ViewerStudyFilterType filterType;
	private String imageFilter;
	
	private DocumentSetResult documentSetResult;

	/**
	 * Constructor
	 * 
	 * @param String					site Id
	 * @param String					patient ICN
	 * @param ViewerStudyFilterType		filter type
	 * 
	 */
	
	public GetPatientStudiesCommand(String siteId,
		String patientIcn, ViewerStudyFilterType filterType)
	{
		super("GetPatientStudiesCommand.getPatientStudies()");
		this.siteId = siteId;
		this.patientIcn = patientIcn;
		this.filterType = filterType;
		this.imageFilter = null;
	}	
	
	/**
	 * Constructor
	 * 
	 * @param String					site Id
	 * @param String					patient ICN
	 * @param String					image filter
	 * @param ViewerStudyFilterType		filter type
	 * 
	 */
	public GetPatientStudiesCommand(String siteId,
		String patientIcn, String imageFilter, ViewerStudyFilterType filterType)
	{
		super("GetPatientStudiesCommand.getPatientStudies()");
		this.siteId = siteId;
		this.patientIcn = patientIcn;
		this.filterType = filterType;
		this.imageFilter = imageFilter;
	}	

	/**
	 * @return ViewerStudyFilterType saved filter type
	 * 
	 */
	public ViewerStudyFilterType getFilterType()
	{
		return filterType;
	}

	/**
	 * @return String		saved site Id
	 * 
	 */
	public String getSiteId()
	{
		return siteId;
	}

	/**
	 * @return String		saved patient ICN
	 * 
	 */
	public String getPatientIcn()
	{
		return patientIcn;
	}

	/**
	 * @return String		saved image filter
	 * 
	 */
	public String getImageFilter() 
	{
		return imageFilter;
	}

	/**
	 * Implementation of abstract method
	 * 
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 * 
	 * @throws MethodException			required
	 * @throws ConnectionException		required
	 * @return List<Study>				result
	 * 
	 */
	@Override
	protected List<Study> executeRouterCommand()
		throws MethodException, ConnectionException
	{
		getLogger().info("GetPatientStudiesCommand.executeRouterCommand() --> ** START **");
		
		try
		{		
			boolean includeDocs = false;
			
			// QN: "filterType" object is always null, thus default to StudyFilter instance, which is never null
			StudyFilter studyFilter = ViewerStudyWebTranslator.translate(filterType);
			studyFilter.setIncludeAllObjects(true);  // set to opposite of default
			
			if(imageFilter == null || imageFilter.equals(""))  // This is for the POST
			{
				studyFilter.setIncludeMuseOrders(false); // set to opposite of default
			}
			else
			{
				// QN: added to prevent JLV from retrieving DAS/DES/HAIMS docs along with radiology
				includeDocs = imageFilter.contains("*DASH*");
				// QN: return to its original/found state in ViewerStudyService for further processing
				imageFilter = imageFilter.replace("*DASH*", "");
				
				// QN: reworked = same effects
				studyFilter.setIncludePatientOrders(imageFilter.contains("PAT"));
				studyFilter.setIncludeEncounterOrders(imageFilter.contains("ENC"));
				studyFilter.setIncludeMuseOrders(imageFilter.contains("MUSE"));
			}
					
			getLogger().debug("attempting to call ViewerStudyFacadeRouter.GetStudyOnlyArtifactResultsBySiteNumberCommand.getStudyOnlyByStudyURN() command");
		
			ArtifactResults artifactResults = getRouter().getStudyOnlyByStudyURN(RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId()),
																				 PatientIdentifier.icnPatientIdentifier(patientIcn), 
																				 studyFilter, 
																				 true,  // always include Radiology
																				 includeDocs); // include HAIMS docs for Dash (true) but not JLV (false)
			
			getLogger().debug("ViewerStudyFacadeRouter.GetStudyOnlyArtifactResultsBySiteNumberCommand.getStudyOnlyByStudyURN() command --> done");
			
			List<Study> result = null;
			
			// QN: Reworked for Fortify.
			if(artifactResults != null) 
			{
				StudySetResult studySetResult = artifactResults.getStudySetResult();
				if(studySetResult != null)
				{
					result = new ArrayList<Study>(studySetResult.getArtifacts());
				}

                getLogger().debug("GetPatientStudiesCommand.executeRouterCommand() --> returned 'result' contains StudySetResult --> {}", artifactResults.containsStudySetResult());

				//Original comment. QN has no clues.
				//When ViewerStudyWebApp was originally written, documentSetResult (which is used by DoD) was not included
				//The best way to handle this is to use StudyWebApp way to translate 
				//artifactResults (both studySetResult and documentSetResult to ViewerStudyStudiesType
				//Next patch should consider to rewrite this
				documentSetResult = artifactResults.getDocumentSetResult() != null ? artifactResults.getDocumentSetResult() : null;
                getLogger().debug("GetPatientStudiesCommand.executeRouterCommand() --> 'documentSetResult' exists --> {}", documentSetResult != null);
			}
			
			return result;
		}
		catch(RoutingTokenFormatException rtfX)
		{
            getLogger().error("GetPatientStudiesCommand.executeRouterCommand() --> {}", rtfX.getMessage());
			throw new MethodException(rtfX.getMessage(), rtfX);
		}
	}
	
	/** 
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 * 
	 * @return String		result
	 * 
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient [" + getPatientIcn() + "] to site [" + getSiteId() + "]";
	}
	
	/** 
	 * Translate the retrieved result into required type
	 * 
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 * 
	 * @param List<Study>					object to translate
	 * @return ViewerStudyStudiesType		result of translation
	 * @throws TranslationException			required
	 * @throws MethodException				required
	 * 
	 */
	@Override
	protected ViewerStudyStudiesType translateRouterResult(List<Study> routerResult)
		throws TranslationException, MethodException
	{
		getLogger().info("GetPatientStudiesCommand.translateRouterResult() --> ** START **");
		
		ViewerStudyStudiesType translatedResult = null;
		
		// 'studiesType' can be null. 'documentList' can NOT be null (empty ArrayList at worst) but check anyway 
		ViewerStudyStudiesType studiesType =  ViewerStudyWebTranslator.translateStudies(routerResult);
		List<ViewerStudyStudyType> documentList = ViewerStudyWebTranslator.translateDocumentSetResult(documentSetResult);

		if ((documentSetResult == null) || (documentList == null || documentList.size() == 0))
		{
            getLogger().debug("GetPatientStudiesCommand.translateRouterResult() --> no documents to return. Will return {}] study(ies)", studiesType != null && studiesType.getStudy() != null ? studiesType.getStudy().length : 0);
			translatedResult =  studiesType;  // Gotta return something even if studiesType can be null
		}
		else
		{
			// result so far. Do this way to avoid the 'else' below.
			translatedResult = 	new ViewerStudyStudiesType(documentList.toArray(new ViewerStudyStudyType[0]));
			
			if (studiesType != null && studiesType.getStudy() != null && studiesType.getStudy().length > 0)
			{
                getLogger().debug("GetPatientStudiesCommand.translateRouterResult() --> will return [{}] study(ies) and [{}] document(s)", studiesType.getStudy().length, documentList.size());
				translatedResult = new ViewerStudyStudiesType((ViewerStudyStudyType[]) combineTwoArrays(studiesType.getStudy(), translatedResult.getStudy()));
			}
		}
		
		return translatedResult;		
	}
	
	/**
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 * 
	 * @return Class<ViewerStudyStudiesType>	save object type
	 * 
	 */
	@Override
	protected Class<ViewerStudyStudiesType> getResultClass()
	{
		return ViewerStudyStudiesType.class;
	}
	
	/** 
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 * 
	 * @return Map<WebserviceInputParameterTransactionContextField, String>		result
	 * 
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIcn() == null ? "" : getPatientIcn());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
	
		return transactionContextFields;
	}
	
	/** 
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 * 
	 * @param ViewerStudyStudiesType	object to get data from
	 * @return Integer					number of entries of the object
	 * 
	 */
	@Override
	public Integer getEntriesReturned(ViewerStudyStudiesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getStudy().length;
	}
	
	/**
	 * Helper method to combine two arrays of generic type
	 * 
	 * Java 1.8 Stream = too slow; Collection and arraycopy = about the same speed
	 * Choose arraycopy to have less import statements
	 * 
	 * @param T []			first array of generic type
	 * @param T [] 			second array of generic type		
	 * @return T []			result of two arrays combined
	 * 
	 */
	private <T> T[] combineTwoArrays(T[] array1, T[] array2) 
	{
		// Both arrays will never be null here.  No need to check unless Fortify complains.
		T[] result = Arrays.copyOf(array1, array1.length + array2.length);
		System.arraycopy(array2, 0, result, array1.length, array2.length);
		return result;
	}
}
