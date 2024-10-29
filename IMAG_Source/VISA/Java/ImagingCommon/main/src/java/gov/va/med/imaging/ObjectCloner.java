package gov.va.med.imaging;

import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import gov.va.med.lookahead.LookAheadObjectInputStream;

public class ObjectCloner {
	// so that nobody can accidentally create an ObjectCloner object
	private ObjectCloner() {
	}

	// returns a deep copy of an object
	static public Object deepCopy(Object originalObject) throws Exception {
		ObjectOutputStream oos = null;
		try 
		{
			ByteArrayOutputStream bos = new ByteArrayOutputStream(); // A
			oos = new ObjectOutputStream(bos); // B
			// serialize and pass the object
			oos.writeObject(originalObject); // C
			oos.flush(); // D
			return LookAheadObjectInputStream.deserialize(bos.toByteArray(), ObjectCloner.class.getName());			
		} 
		catch (Exception e) 
		{
			System.out.println("Exception in ObjectCloner = " + e);
			throw (e);
		} 
		finally 
		{
        	// Fortify change: check for null first
        	// OLD: oos.close() 
        	try{ if(oos != null) { oos.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
		}
	}
}