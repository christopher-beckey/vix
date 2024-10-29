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
public abstract class AbstractExportQueue
{
	private final AbstractExportQueueURN queueUrn;
	private final String name;
	private final String location;
	
	public AbstractExportQueue(AbstractExportQueueURN queueUrn, String name,
			String location)
	{
		super();
		this.queueUrn = queueUrn;
		this.name = name;
		this.location = location;
	}
	
	public AbstractExportQueueURN getQueueUrn()
	{
		return queueUrn;
	}
	
	public String getName()
	{
		return name;
	}
	
	public String getLocation()
	{
		return location;
	}
}
