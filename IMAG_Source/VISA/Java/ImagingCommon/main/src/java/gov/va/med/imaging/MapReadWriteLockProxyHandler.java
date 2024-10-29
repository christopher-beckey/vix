/**
 * 
 */
package gov.va.med.imaging;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import gov.va.med.logging.Logger;

/**
 * This class provides the locking for a ReadWriteLock Map instance.
 * Calls to the underlying Map are intercepted by a dynamic proxy, which
 * delegates to this class.  This class obtains the correct (read or write)
 * lock, invokes the underlying Map instance, releases the lock and then
 * returns.
 * The required locking is determined by the MapMethodLocks enum found
 * later in this file.
 * The method(s) defined in the ReadWriteLockMap is(are)
 * implemented in this class through reflection.
 * 
 * @author vhaiswbeckec
 *
 * @param <K>
 * @param <V>
 */
class MapReadWriteLockProxyHandler<K, V>
implements InvocationHandler
{
	private ReadWriteLock readWriteLock = new ReentrantReadWriteLock();
	private static Logger logger = Logger.getLogger(MapReadWriteLockProxyHandler.class);
	private Map<K, V> target;
	
	/**
	 * Create an instance, the target is the Map instance to which
	 * we delegate the "real" functionality.  This class just provides
	 * locking around the Map instance.
	 * 
	 * @param target
	 */
	MapReadWriteLockProxyHandler(Map<K, V> target)
	{
		this.target = target;
	}
	
	/**
	 * A Map (or ReadWriteLockMap) method has been called, intercepted by the proxy,
	 * and now passed to this method.  This methods acquires the necessary lock
	 * and then invokes the method on the underlying Map.
	 * 
	 * @param proxy - The proxy instance which has invoked this code
	 * @param method - The method being called on the proxy
	 * @param args - The arguments to the method being called
	 */
	public Object invoke(Object proxy, Method method, Object[] args) 
	throws Throwable
	{
		// get the name of the method being called, the method name
		// is used to determine the locking needed.
		String methodName = method.getName();
		Object result = null;
		
		// using the method name, get the enum that corresponds to the method name
		MapMethodLocks mapMethodLock = MapMethodLocks.valueOf(methodName);
		
		// depending on the enum (selected by the method name), lock either
		// the read or the write lock.  
		// Note that we never lock both but lock the write lock preferentially if both are specified.
		// Note that if the method is not in the enum then we'll assume a write lock because it
		// is safest.
		
		// Fortify change: created and stored a Lock object in local variable b/c Fortify
		// can't tell if the two calls to get the lock at different times result in the same object.
		Lock localLock = null;
		
		if(mapMethodLock == null || mapMethodLock.requiresWriteLock)
			localLock = readWriteLock.writeLock();
		else if(mapMethodLock.requiresReadLock)
			localLock = readWriteLock.readLock();
		
		// Potentially contains null.
		if(localLock != null) 
		{
			localLock.lock();
		}
		
		try
		{
			// Special handling because no one actually implements the methods in ReadWriteLockMap
			// other than this class, and only through reflection.
			// This method provides a way to clear and replace the entire Map in one write-locked
			// operation.
			if("clearAndPutAll".equals(methodName) )
			{
				target.clear();
				target.putAll((Map<? extends K, ? extends V>) args[0]);
			}
			// Else this is a normal Map method, invoke it.
			// Note that if the Map interface changes (additional methods) this code
			// will continue to pass through the calls.
			else
				result = method.invoke(target, args);
		}
		finally
		{
			// Fortify change: shouldn't happen but check anyway
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
		
		return result;
	}
	
	/**
	 * This class defines the reuired read or write lock for each method
	 * in the Map and ReadWriteLockMap interfaces.
	 * 
	 * @author vhaiswbeckec
	 *
	 */
	public enum MapMethodLocks
	{
		clear(false, true),
		clearAndPutAll(false, true),
		containsKey(true, false),
		containsValue(true, false),
		entrySet(true, false),
		equals(true, false),
		get(true, false),
		isEmpty(true, false),
		keySet(true, false),
		put(false, true),
		putAll(false, true),
		remove(false, true),
		size(true, false),
		values(true, false);
		
		boolean requiresReadLock = false;
		boolean requiresWriteLock = false;
		
		private MapMethodLocks(boolean requiresReadLock, boolean requiresWriteLock)
		{
			this.requiresReadLock = requiresReadLock;
			this.requiresWriteLock = requiresWriteLock;
		}
	}
}