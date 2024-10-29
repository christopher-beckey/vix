/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.enums;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Administrator
 *
 */
public enum IndexClass
{
	admin("ADMIN"),
	clin("CLIN"), 
	clinAdmin("CLIN/ADMIN"), 
	adminClin("ADMIN/CLIN");
	
	final String value;
	
	IndexClass(String value)
	{
		this.value = value;
	}

	/**
	 * @return the value
	 */
	public String getValue()
	{
		return value;
	}
	
	public final static List<IndexClass> clinClassGroup = new ArrayList<IndexClass>();
	public final static List<IndexClass> adminClassGroup = new ArrayList<IndexClass>();
	
	static
	{
		clinClassGroup.add(clin);
		clinClassGroup.add(clinAdmin);
		clinClassGroup.add(adminClin);
		
		adminClassGroup.add(admin);
		adminClassGroup.add(adminClin);
		adminClassGroup.add(clinAdmin);
	}
	
	public static IndexClass fromValue(String value)
	{
		for(IndexClass indexClass : IndexClass.values())
		{
			if(indexClass.getValue().equals(value))
				return indexClass;
		}
		return null;
	}

}
