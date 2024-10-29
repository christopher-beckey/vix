/**
 * 
 * 
 * Date Created: Feb 11, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.consult;

import gov.va.med.imaging.url.vista.VistaQuery;

/**
 * @author Julian Werfel
 *
 */
public class VistaImagingConsultQueryFactory
{

	public static VistaQuery createGetConsultsQuery(String patientDfn)
	{
		VistaQuery query = new VistaQuery("GMRC LIST CONSULT REQUESTS");
		query.addParameter(VistaQuery.LITERAL, patientDfn);
		return query;
		
	}
}
