/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult.rest.translator;

import java.util.List;

import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.consult.rest.types.ConsultType;
import gov.va.med.imaging.consult.rest.types.ConsultsType;

/**
 * @author Julian Werfel
 *
 */
public class ConsultRestTranslator
{

	public static ConsultsType translateConsults(List<Consult> consults)
	{
		if(consults == null)
			return null;
		
		ConsultType [] result = new ConsultType[consults.size()];
		
		for(int i = 0; i < consults.size(); i++)
		{
			result[i] = translate(consults.get(i));
		}
		
		return new ConsultsType(result);
	}
	
	private static ConsultType translate(Consult consult)
	{
		ConsultType type = new ConsultType(consult.getConsultUrn().toString(), consult.getDate(), 
			consult.getService(), consult.getProcedure(), consult.getStatus(), 
			consult.getNumberNotes());
		
		type.setSiteVixUrl(consult.getSiteVixUrl());
		
		return type;
	}
}
