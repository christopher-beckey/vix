/**
 * 
 */
package gov.va.med.imaging.vistarealm;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import gov.va.med.lookahead.LookAheadObjectInputStream;
import junit.framework.TestCase;

/**
 * @author VHAISWBECKEC
 *
 */
public abstract class AbstractSerializationTest<T extends Serializable>
extends TestCase
{
	/**
	 * Serialize the prototype object to a byte buffer stream
	 * deserialize the byte buffer stream to a copy 
	 * assert that the copy and the original (prototype) are equals().
	 * return the copy
	 * 
	 * @param prototype
	 * @throws IOException
	 * @throws ClassNotFoundException
	 */
	protected T serializeDeserializeAndAssertEquality(T prototype) 
	throws IOException, ClassNotFoundException
	{
		ByteArrayOutputStream dataStoreOut = new ByteArrayOutputStream();
		ObjectOutputStream ooStream = new ObjectOutputStream(dataStoreOut);
		ooStream.writeObject(prototype);
		
		ByteArrayInputStream dataStoreIn = new ByteArrayInputStream(dataStoreOut.toByteArray());
		ObjectInputStream oiStream = new ObjectInputStream(dataStoreIn);
		@SuppressWarnings("unchecked")
		T copy = (T)LookAheadObjectInputStream.deserialize(dataStoreOut.toByteArray(), AbstractSerializationTest.class.getName());
		
		assertEquals(prototype, copy);
		
		return copy;
	}
}
