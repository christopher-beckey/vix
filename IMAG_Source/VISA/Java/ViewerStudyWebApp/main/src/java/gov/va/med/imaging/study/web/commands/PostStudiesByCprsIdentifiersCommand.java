
package gov.va.med.imaging.study.web.commands;


import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.study.web.rest.translator.ViewerStudyWebTranslator;
import gov.va.med.imaging.study.web.rest.types.CprsIdentifiersType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyStudiesType;

import java.util.List;

/**
 * @author Budy Tjahjo
 *
 */
public class PostStudiesByCprsIdentifiersCommand
extends AbtractPostStudiesByCprsIdentifiersCommand<ViewerStudyStudiesType>
{
	/**
	 * @param siteId
	 * @param patientId
	 * @param cprsIdentifiers
	 */
	public PostStudiesByCprsIdentifiersCommand(
			String siteId, 
			String patientIcn,
			CprsIdentifiersType cprsIdentifiers)
	{
		super(siteId, patientIcn, cprsIdentifiers);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected ViewerStudyStudiesType translateRouterResult(List<Study> routerResult)
	throws TranslationException, MethodException
	{
		return ViewerStudyWebTranslator.translateStudies(routerResult);
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
