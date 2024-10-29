package gov.va.med.imaging.cache;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public interface Mergable<T>
{
	public void merge(T other) throws MergeException;
}
