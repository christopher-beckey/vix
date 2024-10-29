/**
 * 
 */
package gov.va.med.imaging.terminology;

import java.net.URISyntaxException;

/**
 * @author vhaiswbeckec
 *
 */
public interface SchemeTranslationSPI
{
	/**
	 * 
	 * @return
	 */
	public CodingScheme getSourceCodingScheme();
	
	/**
	 * 
	 * @return
	 */
	public CodingScheme getDestinationCodingScheme();
	
	/**
	 * Translate the source code from the source coding scheme into the destination
	 * coding scheme.  If the code cannot be translated then return a null, indicating
	 * no translation is possible.
	 * 
	 * @param sourceCode
	 * @return
	 * @throws URISyntaxException 
	 */
	public ClassifiedValue[] translate(String sourceCode);
	
}
