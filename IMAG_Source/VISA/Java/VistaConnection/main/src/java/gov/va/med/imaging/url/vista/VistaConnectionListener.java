/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Feb 8, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
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
package gov.va.med.imaging.url.vista;

/**
 * @author VHAISWBECKEC
 *
 */
public interface VistaConnectionListener
{
	/**
	 * @param openedConnection
	 * @return true to allow the open to continue, else false to abort the open
	 */
	public abstract boolean connectionOpening(VistaConnection openedConnection);
	
	/**
	 * A notification that the connection has been opened
	 * @param openedConnection
	 */
	public abstract void connectionOpened(VistaConnection openedConnection);
	
	/**
	 * 
	 * @param closedConnection
	 * @return true to allow the close to continue, else false to preserve the open connection
	 */
	public abstract boolean connectionClosing(VistaConnection closedConnection);
	
	/**
	 * A notification that the connection has been closed
	 * @param closedConnection
	 */
	public abstract void connectionClosed(VistaConnection closedConnection);
}
