/**
 * 
 * 
 * Date Created: Feb 11, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult;

import gov.va.med.URN;
import gov.va.med.URNProvider;

/**
 * @author Julian Werfel
 *
 */
public class ConsultURNProvider
extends URNProvider
{
	@SuppressWarnings("unchecked")
	@Override
	protected Class<? extends URN>[] getUrnClasses()
	{
		return new Class [] 
              {
				ConsultURN.class
              };
	}
}