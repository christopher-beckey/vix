package gov.va.med.cache.rest;

import gov.va.med.cache.gui.shared.CacheVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;
import gov.va.med.cache.gui.shared.RegionVO;

public interface CacheWriter 
{
	/**
	 * @param out
	 * @param depth
	 * @param cache
	 */
	public abstract void writeStartTag(CacheVO cache);
	public abstract void writeEndTag(CacheVO cache);

	/**
	 * @param out
	 * @param region
	 * @param depth
	 */
	public abstract void writeStartTag(CacheVO cache, RegionVO region);
	public abstract void writeEndTag(CacheVO cache, RegionVO region);

	/**
	 * 
	 * @param out
	 * @param cache
	 * @param region
	 * @param groupAncestry - the last GroupVO is the group that this method is writing
	 * @param level
	 * @param depth
	 */
	public abstract void writeStartTag(CacheVO cache, RegionVO region, GroupVO[] groupAncestry);
	public abstract void writeEndTag(CacheVO cache, RegionVO region, GroupVO[] groupAncestry);

	/**
	 * @param out
	 * @param cache
	 * @param region
	 * @param groupAncestry
	 * @param instance
	 */
	public abstract void writeStartTag(CacheVO cache, RegionVO region, GroupVO[] groupAncestry, InstanceVO instance);
	public abstract void writeEndTag(CacheVO cache, RegionVO region, GroupVO[] groupAncestry, InstanceVO instance);
	public abstract void writeEndTag();
	public abstract void writeStartTag();
	public abstract String getMediaType();

}