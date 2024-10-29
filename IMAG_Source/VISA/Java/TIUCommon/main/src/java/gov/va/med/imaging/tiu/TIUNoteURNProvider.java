/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu;

import gov.va.med.URN;
import gov.va.med.URNProvider;

/**
 * @author Julian Werfel
 *
 */
public class TIUNoteURNProvider
extends URNProvider
{
	@SuppressWarnings("unchecked")
	@Override
	protected Class<? extends URN>[] getUrnClasses()
	{
		return new Class [] 
              {
				TIUItemURN.class,
				PatientTIUNoteURN.class
              };
	}
}