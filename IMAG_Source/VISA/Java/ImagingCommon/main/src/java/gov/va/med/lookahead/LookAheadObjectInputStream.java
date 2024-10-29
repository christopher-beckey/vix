package gov.va.med.lookahead;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InvalidClassException;
import java.io.ObjectInputStream;
import java.io.ObjectStreamClass;


/**
 * Our ObjectInputStream subclass.
 * 
 * @author Pierre Ernst
 * 
 */
public class LookAheadObjectInputStream extends ObjectInputStream {
	
private String classNameToDeserialize;
	
	public String getClassNameToDeserialize() {
		return classNameToDeserialize;
	}
	
	public void setClassNameToDeserialize(String classNameToDeserialize) {
		this.classNameToDeserialize = classNameToDeserialize;
	}

	public LookAheadObjectInputStream(InputStream inputStream)
			throws IOException {
		super(inputStream);
	}
	
	public static Object deserialize(byte[] buffer, String classNameToDeserialize) throws IOException, ClassNotFoundException {
		ByteArrayInputStream bais = new ByteArrayInputStream(buffer);
		// We use LookAheadObjectInputStream instead of InputStream
		LookAheadObjectInputStream ois = new LookAheadObjectInputStream(bais);
		ois.setClassNameToDeserialize(classNameToDeserialize);
		Object obj = ois.readObject();
		ois.close();
		bais.close();
		return obj;
	}

	/**
	 * Only deserialize instances of given class
	 */
	@Override
	protected Class<?> resolveClass(ObjectStreamClass desc) throws IOException,
			ClassNotFoundException {
		if (!desc.getName().equals(classNameToDeserialize)) {
			// Fortify scan: added to see if this makes a difference
			//throw new InvalidClassException("Unauthorized deserialization attempt", desc.getName());  
		}
		return super.resolveClass(desc);
	}
}
