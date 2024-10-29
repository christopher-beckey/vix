/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Oct 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.commands;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.hydra.rest.types.HydraRestTranslator;
import gov.va.med.imaging.hydra.rest.types.HydraStudiesType;

import java.util.List;

/**
 * @author Julian
 *
 */
public class GetHydraStudiesByCrpsIdentifierCommand
extends AbtractGetStudiesByCprsIdentifierCommand<HydraStudiesType>
{

	/**
	 * @param siteId
	 * @param patientIdentifier
	 * @param cprsIdentifierString
	 */
	public GetHydraStudiesByCrpsIdentifierCommand(String siteId,
		String patientIcn, String cprsIdentifierString)
	{
		super(siteId, patientIcn, cprsIdentifierString);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected HydraStudiesType translateRouterResult(List<Study> routerResult)
	throws TranslationException, MethodException
	{
		return HydraRestTranslator.translateStudyList(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<HydraStudiesType> getResultClass()
	{
		return HydraStudiesType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(HydraStudiesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getStudy().length;
	}

}
