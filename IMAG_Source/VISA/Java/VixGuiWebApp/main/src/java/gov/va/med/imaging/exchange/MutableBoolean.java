package gov.va.med.imaging.exchange;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class MutableBoolean
{
	private boolean value;
	
	public MutableBoolean()
	{
		value = false;
	}

	public boolean isValue()
    {
    	return value;
    }

	public void setValue(boolean value)
    {
    	this.value = value;
    }
}
