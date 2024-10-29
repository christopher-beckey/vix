/**
 * 
 * 
 * Date Created: Feb 13, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement
public enum TIUNoteRequestStatusType
{
	signedAll,
	unsigned,
	uncosigned,
	byAuthor,
	signedDateRange

}
