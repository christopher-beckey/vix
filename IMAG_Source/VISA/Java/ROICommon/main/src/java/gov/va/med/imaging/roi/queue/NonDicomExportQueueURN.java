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

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.NamespaceIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNComponents;
import gov.va.med.URNType;
import gov.va.med.imaging.exceptions.URNFormatException;

/**
 * @author VHAISWWERFEJ
 *
 */
@URNType(namespace="nondicomexportqueue")
public class NonDicomExportQueueURN
extends AbstractExportQueueURN
{

	private static final long serialVersionUID = 984757095520692579L;
	
	private static final String namespace = "nondicomexportqueue";
	private static NamespaceIdentifier namespaceIdentifier = new NamespaceIdentifier(namespace);
	
	public static synchronized NamespaceIdentifier getManagedNamespace()
	{
		return namespaceIdentifier;
	}

	public static NonDicomExportQueueURN create(String originatingSiteId, 
			String queueId)
	throws URNFormatException
	{	
		return new NonDicomExportQueueURN(NonDicomExportQueueURN.getManagedNamespace(),
				originatingSiteId, queueId);
	}
	
	public static NonDicomExportQueueURN create(URNComponents urnComponents, 
			SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		return new NonDicomExportQueueURN(urnComponents, serializationFormat);
	}
	
	protected NonDicomExportQueueURN(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		super(urnComponents, serializationFormat);
	}
	
	protected NonDicomExportQueueURN(NamespaceIdentifier namespaceIdentifier,
			String originatingSiteId, 
			String queueId)
	throws URNFormatException
	{
		super(namespaceIdentifier, originatingSiteId, queueId);
	}
	
	@Override
	public GlobalArtifactIdentifier clone() 
	throws CloneNotSupportedException
	{
		try
		{
			return create(getOriginatingSiteId(), getQueueId());
		} 
		catch (URNFormatException e)
		{
			throw new CloneNotSupportedException(e.getMessage());
		}
	}
}
