/**
 * 
 */
package gov.va.med.imaging.ihe.request;

import gov.va.med.imaging.ihe.FindDocumentStoredQueryParameterNames;
import gov.va.med.imaging.ihe.exceptions.ParameterFormatException;
import gov.va.med.imaging.ihe.request.filter.FilterTerm;
import java.util.Date;
import java.util.ArrayList;
import java.util.Collection;

/**
 * A type specific ArrayList that permits easy finding of StoredQueryParameter 
 * elements.
 * 
 * @author vhaiswbeckec
 *
 */
public class StoredQueryParameterList
extends ArrayList<StoredQueryParameter>
{
	/**
	 * 
	 */
	public static final String SCHEME_SUFFIX = "Scheme";
	private static final long serialVersionUID = 1L;

	public StoredQueryParameterList()
	{
		super();
	}
	
	public StoredQueryParameter getByName(FindDocumentStoredQueryParameterNames parameterName)
	{
		return getByName(parameterName.toString());
	}
	
	public StoredQueryParameter getByName(String parameterName)
	{
		if(parameterName == null)
			return null;
		
		for(StoredQueryParameter p : this)
			if(parameterName.equals(p.getName()))
				return p;
		
		return null;
	}

	@Override
	public synchronized void add(int index, StoredQueryParameter element)
	{
		// if the element name ends with Scheme then the value(s)
		// are merged into the element with the same name and without the
		// "Scheme" suffix if it exists, otherwise this element
		// (with the "Scheme" suffix is stored and later replaced when
		// the value element is added
		String elementName = element.getName();
		StoredQueryParameter existing = getByName(element.getName());
		boolean schemeElement = elementName.endsWith(SCHEME_SUFFIX);
		StoredQueryParameter existingSchemeElement = getByName(elementName + SCHEME_SUFFIX);
		
		if( schemeElement && existing == null)
		{
			String valueElementName = elementName.substring(0, elementName.length()-SCHEME_SUFFIX.length());
			StoredQueryParameter existingValueElement = getByName(valueElementName);
			if(existingValueElement != null)
				existingValueElement.mergeAsCodingScheme(element);
		}
		else if(existing != null)
		{
			existing.merge(element);
		}
		else if(! schemeElement && existingSchemeElement != null)
		{
			super.remove(existingSchemeElement);
			element.mergeAsCodingScheme(existingSchemeElement);
			super.add(index, element);
		}
		else
		{
			super.add(index, element);
		}
	}

	@Override
	public boolean add(StoredQueryParameter e)
	{
		int initialSize = this.size();
		add(initialSize, e);
		
		return !(size() == initialSize);
	}

	@Override
	public boolean addAll(Collection<? extends StoredQueryParameter> c)
	{
		return this.addAll(this.size(), c);
	}

	@Override
	public boolean addAll(int index, Collection<? extends StoredQueryParameter> c)
	{
		for(StoredQueryParameter storedQueryParameter : c)
			this.add(index++, storedQueryParameter);
		
		return true;
	}
	
	/**
	 * For multi-valued parameters, this method encapsulates
	 * the boolean math and the wildcard matching in the resulting
	 * FilterTerm instance.
	 * 
	 * @param name
	 * @return
	 */
	public FilterTerm getParameterFilterTerm(String name)
	{
		if(name == null)
			return null;
		
		for(StoredQueryParameter parameter : this)
			if( name.equals(parameter.getName()) )
				return parameter.getFilterTerm();
		
		return null;
	}
	
	/**
	 * 
	 * @param name
	 * @return
	 */
	public String[][] getParameterRawValue(String name)
	{
		if(name == null)
			return null;
		
		for(StoredQueryParameter parameter : this)
			if( name.equals(parameter.getName()) )
				return parameter.getRawValues();
		
		return null;
	}

	/**
	 * 
	 * @param name
	 * @return
	 */
	public String getParameterAsString(String name)
	throws ParameterFormatException 
	{
		if(name == null)
			return null;
		
		for(StoredQueryParameter parameter : this)
			if( name.equals(parameter.getName()) )
				return parameter.getValueAsString();
		
		return null;
	}
	
	/**
	 * 
	 * @param name
	 * @return
	 */
	public Integer getParameterAsInt(String name)
	throws ParameterFormatException 
	{
		if(name == null)
			return null;
		
		for(StoredQueryParameter parameter : this)
			if( name.equals(parameter.getName()) )
				return parameter.getValueAsInt();
		
		return null;
	}
	
	/**
	 * 
	 * @param name
	 * @return
	 */
	public Date getParameterAsDate(String name)
	throws ParameterFormatException 
	{
		if(name == null)
			return null;
		
		for(StoredQueryParameter parameter : this)
			if( name.equals(parameter.getName()) )
				return parameter.getValueAsDate();
		
		return null;
	}
	
	/**
	 * 
	 * @param name
	 * @return
	 * @throws ParameterFormatException
	 */
	public Float getParameterAsFloat(String name)
	throws ParameterFormatException 
	{
		if(name == null)
			return null;
		
		for(StoredQueryParameter parameter : this)
			if( name.equals(parameter.getName()) )
				return parameter.getValueAsFloat();
		
		return null;
	}	
}
