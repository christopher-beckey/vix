/**
**/

package gov.va.med.imaging.dx.datasource.configuration;

import java.util.Comparator;

/**
 * A comparator that implements sorting:
 * 1.) by home community ID
 * 2.) by repository ID, where a repository ID='*' is sorted last
 * 
 * @author vhaisltjahjb
 */
public class DxSiteConfigurationComparator
implements Comparator<DxSiteConfiguration>
{
	/**
	 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
	 */
	@Override
	public int compare(DxSiteConfiguration subject, DxSiteConfiguration object)
	{
		return subject.getRoutingToken().compareTo(object.getRoutingToken());
	}
	
}