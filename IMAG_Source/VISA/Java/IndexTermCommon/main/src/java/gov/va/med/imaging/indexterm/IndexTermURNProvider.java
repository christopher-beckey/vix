/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm;

import gov.va.med.URN;
import gov.va.med.URNProvider;

/**
 * @author Administrator
 *
 */
public class IndexTermURNProvider
extends URNProvider
{
	@SuppressWarnings("unchecked")
	@Override
	protected Class<? extends URN>[] getUrnClasses()
	{
		return new Class [] 
              {
				IndexTermURN.class
              };
	}
}