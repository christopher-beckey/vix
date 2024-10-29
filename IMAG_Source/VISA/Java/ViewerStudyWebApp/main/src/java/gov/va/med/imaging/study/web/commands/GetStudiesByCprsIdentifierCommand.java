/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.commands;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.study.web.rest.translator.ViewerStudyWebTranslator;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyStudiesType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyStudyType;

import java.util.List;

/**
 * @author Julian
 *
 */
public class GetStudiesByCprsIdentifierCommand
extends AbtractGetStudiesByCprsIdentifierCommand<ViewerStudyStudiesType>
{
	/**
	 * @param siteId
	 * @param patientId
	 * @param cprsIdentifierString
	 */
	public GetStudiesByCprsIdentifierCommand(String siteId, String patientIcn,
		String cprsIdentifierString)
	{
		super(siteId, patientIcn, cprsIdentifierString);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected ViewerStudyStudiesType translateRouterResult(List<Study> routerResult)
	throws TranslationException, MethodException
	{
		getLogger().debug("Translate RouterResult");
		DocumentSetResult documentSetResult = getDocumentSetResult();
		String cprsIdentifier = getCprsIdentifierString();
		if (documentSetResult != null)
		{
			getLogger().debug("Translate documentSetResult to List<ViewerStudyStudyType>");
			List<ViewerStudyStudyType> documentList = ViewerStudyWebTranslator.translateDocumentSetResultWithImages(documentSetResult, cprsIdentifier);
			
			if ((documentList != null) && (documentList.size() > 0))
			{
				return new ViewerStudyStudiesType(documentList.toArray(new ViewerStudyStudyType[documentList.size()]));
//				ViewerStudyStudyType[] result = new ViewerStudyStudyType[documentList.size()];
//				int i = 0;
//				for(ViewerStudyStudyType studyType: documentList)
//				{
//					result[i] = studyType;
//					i++;
//				}
//				return new ViewerStudyStudiesType(result);
			}
			else
			{
				return null;
			}
		}
		else
		{
			return ViewerStudyWebTranslator.translateStudies(routerResult);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<ViewerStudyStudiesType> getResultClass()
	{
		return ViewerStudyStudiesType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(ViewerStudyStudiesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getStudy().length;
	}
}
