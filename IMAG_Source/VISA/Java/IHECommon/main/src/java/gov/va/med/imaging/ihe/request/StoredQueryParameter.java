package gov.va.med.imaging.ihe.request;

import gov.va.med.imaging.ihe.exceptions.*;
import gov.va.med.imaging.ihe.request.filter.ConjunctionTerm;
import gov.va.med.imaging.ihe.request.filter.DisjunctionTerm;
import gov.va.med.imaging.ihe.request.filter.FilterTerm;
import gov.va.med.imaging.ihe.request.filter.SimpleTerm;
import gov.va.med.imaging.ihe.xca.XcaTimeZone;
import gov.va.med.imaging.terminology.ClassifiedValue;
import gov.va.med.imaging.terminology.CodingScheme;
import gov.va.med.imaging.terminology.SchemeTranslationSPI;
import gov.va.med.imaging.terminology.SchemeTranslationServiceFactory;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * 
 * @author vhaiswbeckec
 *
 */
public class StoredQueryParameter
{
	private final static Logger LOGGER = Logger.getLogger(StoredQueryParameter.class);
	
	private final String name;
	private FilterTerm filterTerm;
	private String[][] rawValues;
	private String[][] codingSchemeValues;

	
	/**
	 * @param name
	 * @param rawValues
	 */
	public StoredQueryParameter(String name, String[] rawValues)
	{
		this(name, rawValues, (String)null);
	}

	/**
	 * 
	 * @param name
	 * @param rawValues
	 * @param identificationScheme
	 */
	public StoredQueryParameter(String name, String[] rawValues, String[] codingSchemes)
	{
		this(name, new String[][]{rawValues}, new String[][]{codingSchemes});
	}
	
	/**
	 * 
	 * @param name
	 * @param rawValues
	 * @param identificationScheme
	 */
	public StoredQueryParameter(String name, String[] rawValues, String codingScheme)
	{
		this(name, new String[][]{rawValues}, new String[][]{{codingScheme}});
	}
	
	/**
	 * @param name
	 * @param rawValues
	 * @param identificationScheme
	 */
	public StoredQueryParameter(String name, String[][] rawValues, String codingScheme)
	{
		this(name, rawValues, new String[][]{{codingScheme}});
	}
	
	/**
	 * This constructor should never be needed outside of the class because
	 * the representation of the raw values as an array of arrays is not expressed
	 * in the source of the data used to build an instance.
	 * 
	 * @param name
	 * @param rawValues
	 * @param identificationScheme
	 */
	public StoredQueryParameter(String name, String[][] rawValues, String[][] codingSchemes)
	{
		super();
		this.name = name;
		this.rawValues = rawValues;
		this.codingSchemeValues = codingSchemes;
	}
	
	/**
	 * @return
	 */
	protected Logger getLogger()
	{
		return LOGGER;
	}

	public String getName()
	{
		return this.name;
	}
	
	public String[][] getRawValues()
	{
		return this.rawValues;
	}
	
	public String[][] getCodingSchemeValues()
	{
		return this.codingSchemeValues;
	}

	/**
	 * @param rawValues the rawValues to set
	 */
	private void setRawValues(String[][] rawValues)
	{
		this.rawValues = rawValues;
		this.filterTerm = null;
	}

	/**
	 * @param codingSchemeValues the codingSchemeValues to set
	 */
	private void setCodingSchemeValues(String[][] codingSchemeValues)
	{
		this.codingSchemeValues = codingSchemeValues;
		this.filterTerm = null;
	}

	/**
	 * When there is only one classification scheme, makes the
	 * coding scheme array length of 1 and sets the first value
	 * @param codingSchemeValues
	 */
	private void setCodingSchemeValue(String codingSchemeValues)
	{
		this.codingSchemeValues = new String[][]{{codingSchemeValues}};
		this.filterTerm = null;
	}
	
	/**
	 * Return a FilterTerm, which may be a SimpleTerm for a single
	 * value slot or may be a complex hierarchy of FilterTerm
	 * instances implementing a boolean expression.
	 * The FilterTerm.matches() method may be used to determine
	 * whether a FilterTerm (simple or complex) matches a value. 
	 * 
	 * A parameter specified as a Slot with multiple Value elements must be
	 * interpreted as if it were a single Value element.
	 * A parameter specified as a Slot with multiple values must be interpreted
	 * with OR semantics (disjunction).
	 * A parameter specified as multiple Slot element must be interpreted with
	 * AND semantics (conjunction).
	 * 
	 * NOTE synchronized because filterTerm is calculated only as needed.
	 * 
	 * @see IHE Transactons V5 Section 3.18.4.1.2.3.5
	 * @return
	 */
	public synchronized FilterTerm getFilterTerm()
	{
		if(filterTerm == null && rawValues != null && rawValues.length > 0)
		{
			CodingSchemeMatchMode codingSchemeMatchMode = getCodingSchemesMatchMode(); 
			if(codingSchemeMatchMode == CodingSchemeMatchMode.FAILURE)
			{
				LOGGER.warn("StoredQueryParameter.getFilterTerm() --> Coding schemes and raw values do not match.");
				return null;
			}
			
			// walk through them backwards so that the leftmost elements are at the top of the hierarchy
			FilterTerm currentDisjunctionTerm = null;
			for(int disjunctionIndex = rawValues.length-1; disjunctionIndex >= 0; disjunctionIndex--)
			{
				// though this really does not logically matter for conjunctions unless we optimize
				String [] rawValueConjunctionArray = rawValues[disjunctionIndex];
				FilterTerm currentConjunctionTerm = null;
				for(int conjunctionIndex = rawValueConjunctionArray.length-1; conjunctionIndex >= 0; conjunctionIndex--)
				{
					SimpleTerm currentSimpleTerm = 
						new SimpleTerm(rawValueConjunctionArray[conjunctionIndex],
							codingSchemeMatchMode == CodingSchemeMatchMode.NULL ? null :
							codingSchemeMatchMode == CodingSchemeMatchMode.ONE ? codingSchemeValues[0][0] : 
							codingSchemeValues[disjunctionIndex][conjunctionIndex]);
					
					currentConjunctionTerm = currentConjunctionTerm == null ? currentSimpleTerm : new ConjunctionTerm(currentConjunctionTerm, currentSimpleTerm);
				}
				
				currentDisjunctionTerm =  currentDisjunctionTerm == null ? currentConjunctionTerm : new DisjunctionTerm(currentDisjunctionTerm, currentConjunctionTerm);
			}
			
			this.filterTerm = currentDisjunctionTerm;
		}
		
		return this.filterTerm;
	}
	
	// ==================================================================
	public enum CodingSchemeMatchMode{NULL, ONE, ONE_TO_ONE, FAILURE;}
	/**
	 * @return
	 */
	public CodingSchemeMatchMode getCodingSchemesMatchMode()
	{
		// if there are NO coding schemes specified then terms cannot be translated
		if( getCodingSchemeValues() == null || 
			getCodingSchemeValues().length == 0 || 
			(getCodingSchemeValues().length == 1 && getCodingSchemeValues()[0] == null))
			return CodingSchemeMatchMode.NULL;
		
		// if there is 1 coding schemes specified then all terms use that scheme
		if( getCodingSchemeValues().length == 1 && 
			getCodingSchemeValues()[0] != null && 
			getCodingSchemeValues()[0].length == 1 )
			return CodingSchemeMatchMode.ONE;

		// else all coding schemes must have a corresponding element
		if( getCodingSchemeValues().length != getRawValues().length )
			return CodingSchemeMatchMode.FAILURE;
		
		for(int outerIndex = 0; outerIndex < getRawValues().length; ++outerIndex)
			if( getCodingSchemeValues()[outerIndex] == null && getRawValues()[outerIndex] != null ||
				getCodingSchemeValues()[outerIndex] != null && getRawValues()[outerIndex] == null ||
				(getCodingSchemeValues()[outerIndex] != null && getRawValues()[outerIndex] != null &&
				 getCodingSchemeValues()[outerIndex].length != getRawValues()[outerIndex].length) )
				return CodingSchemeMatchMode.FAILURE;
		
		return CodingSchemeMatchMode.ONE_TO_ONE;
	}
	// ==================================================================

	/**
	 * Translates the raw values into the destination coding scheme.
	 * 
	 * @param schemeTranslationFactory
	 * @param destinationCodeScheme
	 */
	public synchronized void translateToClassificationScheme(
		SchemeTranslationServiceFactory schemeTranslationFactory,
		CodingScheme destinationCodeScheme)
	{
		CodingSchemeMatchMode matchMode = getCodingSchemesMatchMode();
		switch(matchMode)
		{
		case ONE:			// means that all parameter values correlate to one classification scheme
			translateOneSourceClassificationSchemeToClassificationScheme(schemeTranslationFactory, destinationCodeScheme);
			break;
		case ONE_TO_ONE:	// means that each parameter value has a correlated classification scheme
			translateMultipleSourceClassificationSchemeToClassificationScheme(schemeTranslationFactory, destinationCodeScheme);
			break;
		case NULL:			// means that no classification scheme was specified
			// don't translate
			break;
		case FAILURE:		// means that the request didn't meet the specification
			break;
		}
		
	}
	
	/**
	 * Translate all of the raw values from the one (source) classification scheme into the
	 * destination classification scheme.
	 * 
	 * @param schemeTranslationFactory
	 * @param destinationCodeScheme
	 */
	private void translateOneSourceClassificationSchemeToClassificationScheme(
		SchemeTranslationServiceFactory schemeTranslationFactory, 
		CodingScheme destinationCodeScheme)
	{
		String sourceClassificationSchemeName = getCodingSchemeValues()[0][0];
		CodingScheme sourceClassificationScheme = CodingScheme.valueOf(sourceClassificationSchemeName);
		SchemeTranslationSPI schemeTranslator = 
			schemeTranslationFactory.getSchemeTranslator(sourceClassificationScheme, destinationCodeScheme);
		
		if(schemeTranslator == null)
		{
            LOGGER.warn("StoredQueryParameter.translateOneSourceClassificationSchemeToClassificationScheme() --> No translator available to translate from [{}] to [{}]", sourceClassificationSchemeName, destinationCodeScheme.getName());
			return;
		}
		
		// its not really a matrix, just a list of lists of String
		List<List<String>> translatedMatrix = new ArrayList<List<String>>();
		
		// the raw values are an array of arrays of strings
		// during translation, we may add a String element to an inner array but
		// we will never add a new array of String to the outer array
		for( String[] rawValueRow : getRawValues() )
		{
			List<String> translatedRow = new ArrayList<String>();
			translatedMatrix.add(translatedRow);
			
			for(String rawValue : rawValueRow)
			{
				ClassifiedValue[] translatedValues = schemeTranslator.translate(rawValue);
				if(translatedValues == null)
				{
                    LOGGER.warn("StoredQueryParameter.translateOneSourceClassificationSchemeToClassificationScheme() --> Failed to translate from [{}] to [{}] raw value [{}]", sourceClassificationSchemeName, destinationCodeScheme.getName(), rawValue);
				}
				else		// if the translation produced values, add them to a row List
				{
					for(ClassifiedValue translatedValue : translatedValues)
						translatedRow.add(translatedValue.getCodeValue());
				}
			}
		}
		// replace the (one) classification scheme with the destination classification scheme
		setCodingSchemeValue( destinationCodeScheme.getCanonicalIdentifier().toString() );
		
		// replace the raw values with the translated values
		String[][] newRawValues = new String[translatedMatrix.size()][];
		int index = 0;
		for( List<String> row : translatedMatrix )
			newRawValues[index++] = row.toArray(new String[row.size()]);
		
		setRawValues(newRawValues);
	}

	/**
	 * Translate all of the raw values from the correlated (source) classification schemes into the
	 * destination classification scheme.
	 * 
	 * @param schemeTranslationFactory
	 * @param destinationCodeScheme
	 */
	private void translateMultipleSourceClassificationSchemeToClassificationScheme(
		SchemeTranslationServiceFactory schemeTranslationFactory, CodingScheme destinationCodeScheme)
	{
		// its not really a matrix, just a list of lists of String
		List<List<String>> translatedMatrix = new ArrayList<List<String>>();
		
		// the raw values are an array of arrays of strings
		// during translation, we may add a String element to an inner array but
		// we will never add a new array of String to the outer array
		int rowIndex = 0;
		for( String[] rawValueRow : getRawValues() )
		{
			List<String> translatedRow = new ArrayList<String>();
			translatedMatrix.add(translatedRow);
			
			int columnIndex = 0;
			for(String rawValue : rawValueRow)
			{
				String sourceClassificationSchemeName = getCodingSchemeValues()[rowIndex][columnIndex];
				CodingScheme sourceClassificationScheme = CodingScheme.valueOf(sourceClassificationSchemeName);
				
				SchemeTranslationSPI schemeTranslator = 
					schemeTranslationFactory.getSchemeTranslator(sourceClassificationScheme, destinationCodeScheme);
				
				if(schemeTranslator == null)
                    LOGGER.warn("StoredQueryParameter.translateMultipleSourceClassificationSchemeToClassificationScheme() --> No translator available to translate from [{}] to [{}]", sourceClassificationSchemeName, destinationCodeScheme.getName());
				
				ClassifiedValue[] translatedValues = schemeTranslator == null ? null : schemeTranslator.translate(rawValue);
				
				if(translatedValues == null)
				{
                    LOGGER.warn("StoredQueryParameter.translateMultipleSourceClassificationSchemeToClassificationScheme() --> Failed to translate from [{}] to [{}] raw value [{}]", sourceClassificationSchemeName, destinationCodeScheme.getName(), rawValue);
				}
				else		// if the translation produced values, add them to a row List
				{
					for(ClassifiedValue translatedValue : translatedValues)
						translatedRow.add(translatedValue.getCodeValue());
				}
				columnIndex++;
			}
			rowIndex++;
		}
		// replace the (one) classification scheme with the destination classification scheme
		setCodingSchemeValue( destinationCodeScheme.getCanonicalIdentifier().toString() );
		
		// replace the raw values with the translated values
		String[][] newRawValues = new String[translatedMatrix.size()][];
		int index = 0;
		for( List<String> row : translatedMatrix )
			newRawValues[index++] = row.toArray(new String[row.size()]);
		
		setRawValues(newRawValues);	}

	/**
	 * Merging a StoredQueryParameter means merging the values.  
	 * The raw values become a union of the raw values
	 * from both instances.
	 * 
	 * NOTE: synchronized because filterTerm is calculated only as needed.
	 * 
	 * @param e
	 */
	public synchronized void merge(StoredQueryParameter that)
	{
		String[][] mergedValues = new String[this.getRawValues().length + that.getRawValues().length][];
		
		int index = 0;
		for(; index < this.getRawValues().length; ++index)
			mergedValues[index] = this.getRawValues()[index];
		
		int offset = index;
		for(; index<offset + that.getRawValues().length; ++index)
			mergedValues[index] = that.getRawValues()[index-offset];
		this.setRawValues( mergedValues );
	}
	
	/**
	 * Merge the values of the given StoredQueryParameter into this StoredQueryParameter
	 * as the coding scheme value.
	 * 
	 * NOTE: synchronized because filterTerm is calculated only as needed.
	 * 
	 * @param element
	 */
	public synchronized void mergeAsCodingScheme(StoredQueryParameter element)
	{
		String[][] mergedValues = new String[this.getCodingSchemeValues().length + element.getRawValues().length][];
		
		int index = 0;
		for(; index<this.getCodingSchemeValues().length; ++index)
			mergedValues[index] = this.getCodingSchemeValues()[index];
		
		int offset = index;
		for(; index<offset + element.getRawValues().length; ++index)
			mergedValues[index] = element.getRawValues()[index-offset];
		this.setCodingSchemeValues( mergedValues );
	}
	
	/**
	 * 
	 * @return
	 * @throws ParameterMultiplicityFormatException
	 */
	private String getUnaryStringValue() 
	throws ParameterMultiplicityFormatException
	{
		if( getRawValues().length == 0 || (getRawValues().length == 1 && getRawValues()[0].length == 0) )
			return null;
		else if(getRawValues().length == 1 && getRawValues()[0].length == 1)
			return getRawValues()[0][0];
		else
			throw new ParameterMultiplicityFormatException(name);
	}
	
	/**
	 * 
	 * @param name
	 * @return
	 */
	public String getValueAsString()
	throws ParameterFormatException 
	{
		String unaryValue = getUnaryStringValue();
		
		if(unaryValue == null)
			return null;
		
		if(unaryValue.startsWith("'") && unaryValue.endsWith("'"))
			return unaryValue.substring(1, unaryValue.length()-1);
		else
		{
            LOGGER.warn("StoredQueryParameter.getValueAsString() --> String parameters must be delimited by single quotes, value [{}] is not. This is only a warning, but the request is not XCA compliant.", getName());
			return unaryValue;
		}
	}
	
	/**
	 * 
	 * @param name
	 * @return
	 */
	public Integer getValueAsInt()
	throws ParameterFormatException 
	{
		String valueAsString = getUnaryStringValue();
		
		if(valueAsString == null)
			return null;
		
		try
		{
			return Integer.decode( valueAsString );
		}
		catch (NumberFormatException x)
		{
			throw new ParameterNumberFormatException(name);
		}
	}
	
	/**
	 * 
	 * @param name
	 * @return
	 */
	public Date getValueAsDate()
	throws ParameterFormatException 
	{
		String dateAsString = getUnaryStringValue();
		
		if(dateAsString == null)
			return null;
		
		for(DateFormat dateFormat : getDateFormats())
			try
			{
				return dateFormat.parse(dateAsString);
			}
			catch (ParseException x)
			{}

        LOGGER.warn("StoredQueryParameter.getValueAsDate() --> Unable to parse parameter [{}], value [{}] as a date parameter.", name, dateAsString);
		throw new ParameterDateFormatException(name);
	}
	
	/**
	 * 
	 * @param name
	 * @return
	 * @throws ParameterFormatException
	 */
	public Float getValueAsFloat()
	throws ParameterFormatException 
	{
		String valueAsString = getUnaryStringValue();
		
		if(valueAsString == null)
			return null;
		
		try
		{
			return Float.valueOf( valueAsString );
		}
		catch (NumberFormatException x)
		{
			throw new ParameterNumberFormatException(name);
		}
	}
	
	private List<DateFormat> getDateFormats()
	{
		List<DateFormat> formats = new ArrayList<DateFormat>();
		formats.add(new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ssZZZZ"));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmm");
		sdf.setTimeZone(XcaTimeZone.getTimeZone());
		formats.add(sdf);
		formats.add(new SimpleDateFormat("yyyyMMdd"));
		formats.add(new SimpleDateFormat("yyyyMM"));
		return formats;
	}

	// ==============================================================
	// Setters should only be used by the scheme translation components
	// the parameter values should otherwise be considered final.
	// ==============================================================
	
	public void setValue(String[][] rawValue)
	{
		this.setRawValues(rawValue);
	}
	
	public void setValue(String[] rawValue)
	{
		this.setRawValues( new String[][]{rawValue} );
	}
	
	public void setValue(Integer value)
	{
		this.setRawValues( new String[][]{{value.toString()}} );
	}
	
	public void setValue(Float value)
	{
		this.setRawValues( new String[][]{{value.toString()}} );
	}
	
	public void setValue(String value)
	{
		this.setRawValues( new String[][]{{value}} );
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(this.getName());
		sb.append('=');
		try
		{
			sb.append(this.getUnaryStringValue());
		}
		catch (ParameterMultiplicityFormatException x)
		{
			for(String[] lineValues : this.getRawValues())
				for(String unaryValue : lineValues)
					sb.append(unaryValue + ",");
		}
		
		return sb.toString();
	}
}