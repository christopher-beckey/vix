/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * @date Aug 4, 2010
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author vhaiswbeckec
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */

package gov.va.med.configuration;

import java.io.*;
import java.net.URL;
import java.net.URLDecoder;
import javax.naming.CommunicationException;
import javax.naming.NamingException;

import org.apache.commons.io.IOUtils;

import gov.va.med.imaging.StringUtil;
import gov.va.med.lookahead.LookAheadObjectInputStream;

/**
 * @author vhaiswbeckec
 *
 */
public class LocalFileSerializationStorage
implements ConfigurationStorage
{

	/**
	 * 
	 * @see gov.va.med.configuration.ConfigurationStorage#load(java.net.URL)
	 */
	@SuppressWarnings("null")
	@Override
	public ConfigurationContext load(URL location) 
	throws NamingException
	{
		if(location == null)
			throw new CommunicationException("Unable to load from a null location.");
		
		Object readObject = null;
		//InputStream inStream = null;
		//ObjectInputStream objectInStream = null;
		//String filename = filenameFromURL(location);
		try (InputStream inStream = location.openStream();
				ObjectInputStream objectInStream = new ObjectInputStream( inStream ) )
		{
			//inStream = location.openStream();
			//objectInStream = new ObjectInputStream( inStream );
			
			readObject = LookAheadObjectInputStream.deserialize(IOUtils.toByteArray(inStream), ConfigurationContext.class.getName());
			
			return (ConfigurationContext)readObject;
		}
		catch (IOException x)
		{
			throw new CommunicationException("Unable to read configuration from '" + location.toString() + "'.");
		}
		catch (ClassNotFoundException x)
		{
			throw new CommunicationException(
				"Read from '" + location.toString() + 
				"' but unable to load class '" + (readObject == null ? "<unknown>" : "" + readObject.getClass().getName()) +
				"'found there, was expecting '" + ConfigurationContext.class.getName() + "'.");
		}
		catch (ClassCastException x)
		{
			throw new CommunicationException(
				"Read from '" + location.toString() + 
				"' but class '" + (readObject == null ? "<unknown>" : "" + readObject.getClass().getName()) +
				"'found there, was expecting '" + ConfigurationContext.class.getName() + "'.");
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.configuration.ConfigurationStorage#store(java.net.URL, gov.va.med.configuration.ConfigurationContext)
	 */
	@SuppressWarnings("null")
	@Override
	public void store(URL location, ConfigurationContext context)
	throws NamingException
	{
		if(context == null)
			throw new CommunicationException("Unable to store a null ConfigurationContext.");
		if(location == null)
			throw new CommunicationException("Unable to store a null location.");

		// Fortify change: clean string for good measure
		File configFile = new File(StringUtil.cleanString(filenameFromURL(location)));
		
		try 
		{
			if(!configFile.exists()) {			
				configFile.createNewFile();		// create the file if it does not exist
			}
		}
		catch (IOException x)
		{
			throw new CommunicationException("Unable to create configuration file [" + configFile.getAbsolutePath() + "].");
		}

		// Fortify change: moved streams into try-with-resources
		try ( OutputStream outStream = new FileOutputStream(configFile);
			  ObjectOutputStream objectOutStream = new ObjectOutputStream( outStream) )
		{
			objectOutStream.writeObject(context);
		}
		catch (IOException x)
		{
			throw new CommunicationException("Unable to write configuration to [" + configFile.getAbsolutePath() + "].");
		}
	}

	private static final String FILE_PROTOCOL = "file:";
	private String filenameFromURL(URL location)
	{
		String filename = URLDecoder.decode( location.toExternalForm() );
		if(filename.startsWith(FILE_PROTOCOL))
			filename = filename.substring(FILE_PROTOCOL.length());
		
		return filename;
	}
}
