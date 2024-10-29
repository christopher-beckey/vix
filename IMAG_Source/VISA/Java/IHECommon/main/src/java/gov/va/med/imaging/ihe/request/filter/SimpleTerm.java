/**
 * 
 */
package gov.va.med.imaging.ihe.request.filter;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.regex.Pattern;
import gov.va.med.logging.Logger;

/**
 * '_' underscore matches any single character
 * '%' matches any string
 * 
 * @author vhaiswbeckec
 *
 */
public class SimpleTerm
extends UnaryTerm
{
	private static DateFormat[] getDateFormats()
	{
		return new DateFormat[]{
			new SimpleDateFormat("yyyyMMddhhmm"),
			new SimpleDateFormat("yyyyMMdd"),
			new SimpleDateFormat("yyyyMM"),
			new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ssZZZZ")
		};
	}
	private static DateFormat getCanonicalDateFormat()
	{
		return getDateFormats()[0];
	}
	
	private String value;

	public SimpleTerm(String value)
	{
		this(value, null);
	}
	
	/**
	 * @param value
	 */
	public SimpleTerm(String value, String codingScheme)
	{
		super(codingScheme);
		if(value == null)
			throw new IllegalArgumentException("The value parameter must not be null.");
		this.value = value;
	}

	/**
	 * Will never return null.
	 * The returned value will not have the single quotes that are required
	 * by the XCA specification.
	 * 
	 * @return
	 * @throws InvalidTermValueFormatException - if the single quotes were not in the value
	 */
	public String getValueAsString()
	throws InvalidTermValueFormatException
	{
		if(value == null)
			throw new InvalidTermValueFormatException();
		
		String v = value.trim();
		if(v.startsWith("'") && v.endsWith("'") && v.length() > 2)
		{
			return v.substring(1, v.length()-1);
		}
		throw new InvalidTermValueFormatException();
	}

	public Date getValueAsDate()
	throws InvalidTermValueFormatException
	{
		if(value == null)
			throw new InvalidTermValueFormatException();
		
		for(DateFormat dateFormat : getDateFormats())
			try
			{
				return dateFormat.parse(value);
			}
			catch (ParseException x)
			{}

        Logger.getLogger(this.getClass()).warn("Unable to parse parameter value '{}' as a date parameter.", value);
		throw new InvalidTermValueFormatException();
	}
	
	public Long getValueAsLong()
	throws InvalidTermValueFormatException
	{
		if(value == null)
			throw new InvalidTermValueFormatException();

		try
		{
			return Long.parseLong(value);
		}
		catch(NumberFormatException nfx)
		{
			throw new InvalidTermValueFormatException();
		}
	}
	
	public Double getValueAsDouble()
	throws InvalidTermValueFormatException
	{
		if(value == null)
			throw new InvalidTermValueFormatException();

		try
		{
			return Double.parseDouble(value);
		}
		catch(NumberFormatException nfx)
		{
			throw new InvalidTermValueFormatException();
		}
	}
	
	public void setValue(String value)
	{
		this.value = value;
	}

	/**
	 * Do thing match if they are in a different coding scheme?
	 * @throws InvalidTermValueFormatException 
	 */
	@Override
	public boolean matches(String value) 
	throws InvalidTermValueFormatException
	{
		// is there any wild card matching?
		if(isUsingWildcardMatching())
			return getRegexPattern().matcher(value).matches();
		else
			return this.getValueAsString().equals(value);
	}

	/**
	 * 
	 * @return
	 */
	public boolean isUsingWildcardMatching()
	{
		return this.value.indexOf('_') >= 0 || this.value.indexOf('%') >= 0;
	}
	
	/**
	 * Creates a regular expression from the value property.
	 * @return
	 */
	private Pattern regexPattern = null;
	private synchronized Pattern getRegexPattern() 
	throws InvalidTermValueFormatException
	{
		if(regexPattern == null)
		{
			String regex = this.getValueAsString();
			
			// make sure that the string does not contain any regular expression
			// special characters, this is something of a security issue but is mostly just
			// to assure that the results are as expected
			regex = regex.replace(".", "\\x2e");
			regex = regex.replace("^", "\\x5e");
			regex = regex.replace("$", "\\x24");
			regex = regex.replace("\\", "\\x5c");
			regex = regex.replace("(", "\\x28" );
			regex = regex.replace(")", "\\x29");

			// replace the IHE defined wild card characters with the equivalent regular expressions
			regex = regex.replace("_", "[\\w\\W]");
			regex = regex.replace("%", "([\\w\\W]*)??");
			
			regexPattern = Pattern.compile(regex);
		}
		
		return regexPattern;
	}

	@Override
	public Iterator<SimpleTerm> getSimpleTermIterator()
	{
		final SimpleTerm parent = this;
		return new Iterator<SimpleTerm>()
		{
			boolean nextCalled = false;
			@Override
			public boolean hasNext()
			{
				return !nextCalled;
			}

			@Override
			public SimpleTerm next()
			{
				if(! nextCalled)
				{
					nextCalled = true;
					return parent;
				}
				throw new NoSuchElementException();
			}

			@Override
			public void remove(){}
		};
	}

	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(getCodingScheme());
		sb.append('.');
		sb.append(value);
		
		return sb.toString();
	}
}
