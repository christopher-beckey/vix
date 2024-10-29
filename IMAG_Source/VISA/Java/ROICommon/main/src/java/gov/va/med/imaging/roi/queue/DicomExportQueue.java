/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 17, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.roi.queue;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DicomExportQueue
extends AbstractExportQueue
{
	private final String ipAddress;
	private final int port;

	/**
	 * @param queueUrn
	 * @param name
	 * @param location
	 */
	public DicomExportQueue(DicomExportQueueURN queueUrn, String serviceName,
			String ipAddress, int port, String location)
	{
		super(queueUrn, serviceName, location);
		this.ipAddress = ipAddress;
		this.port = port;
	}

	public String getIpAddress()
	{
		return ipAddress;
	}

	public int getPort()
	{
		return port;
	}

}
