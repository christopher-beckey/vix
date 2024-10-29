/**
 * 
 */
package gov.va.med.imaging.terminology;

import java.net.URI;
import java.net.URISyntaxException;
import gov.va.med.logging.Logger;

/**
 * An implementation of SchemeTranslationSPI that simply returns the given
 * source codes.  This translator may be invoked when there is no translation to do.
 * 
 * @author vhaiswbeckec
 *
 */
public class IdentitySchemeTranslation
implements SchemeTranslationSPI
{
	private final CodingScheme scheme;
	
	/**
	 * 
	 * @param scheme
	 * @return
	 */
	public static IdentitySchemeTranslation create(CodingScheme scheme) 
	{
		return new IdentitySchemeTranslation(scheme);
	}
	
	/**
	 * @param sourceScheme
	 * @param sourceScheme2
	 */
	private IdentitySchemeTranslation(CodingScheme scheme)
	{
		this.scheme = scheme;
	}

	@Override
	public CodingScheme getDestinationCodingScheme()
	{
		return scheme;
	}

	@Override
	public CodingScheme getSourceCodingScheme()
	{
		return scheme;
	}

	/**
	 * @throws URISyntaxException 
	 * @see gov.va.med.imaging.terminology.SchemeTranslationSPI#translate(java.lang.String)
	 */
	@Override
	public ClassifiedValue[] translate(String sourceCode) 
	{
		return new ClassifiedValue[]{ new ClassifiedValue(scheme, sourceCode) };
	}

}
