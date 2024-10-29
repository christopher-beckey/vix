package gov.va.med.cache.gui.shared;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public interface Mergable<T>
{
	public void merge(T other) throws MergeException;
}
