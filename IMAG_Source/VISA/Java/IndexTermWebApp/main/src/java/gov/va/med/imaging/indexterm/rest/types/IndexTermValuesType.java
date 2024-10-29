/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="indexTerms")
public class IndexTermValuesType
{
	private IndexTermValueType [] indexTerm;
	
	public IndexTermValuesType()
	{
		super();
		this.indexTerm = new IndexTermValueType[0];
	}

	/**
	 * @param indexTermValue
	 */
	public IndexTermValuesType(IndexTermValueType[] indexTermValue)
	{
		super();
		this.indexTerm = indexTermValue;
	}

	public IndexTermValueType[] getIndexTerm()
	{
		return indexTerm;
	}

	public void setIndexTerm(IndexTermValueType[] indexTermValue)
	{
		this.indexTerm = indexTermValue;
	}

}
