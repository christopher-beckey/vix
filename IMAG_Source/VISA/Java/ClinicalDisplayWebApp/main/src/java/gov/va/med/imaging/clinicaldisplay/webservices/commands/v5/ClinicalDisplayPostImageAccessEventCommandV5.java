/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 19, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands.v5;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayPostImageAccessEventCommand;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayPostImageAccessEventCommandV5
extends AbstractClinicalDisplayPostImageAccessEventCommand
{
	private ImageAccessLogEvent imageAccessLogEvent = null;
	private final gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventType logEvent;

	public ClinicalDisplayPostImageAccessEventCommandV5(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventType logEvent)
	{
		super();
		ClinicalDisplayCommandCommonV5.setTransactionContext(logEvent.getCredentials(), transactionId);
		this.logEvent = logEvent;
	}

	@Override
	protected ImageAccessLogEvent getImageAccessLogEvent()
	throws URNFormatException
	{
		if(imageAccessLogEvent == null)
		{
			imageAccessLogEvent = ClinicalDisplayCommandCommonV5.getTranslator().transformLogEvent(logEvent);
		}
		return imageAccessLogEvent;
	}

	@Override
	public String getInterfaceVersion()
	{
		return ClinicalDisplayCommandCommonV5.clinicalDisplayV5InterfaceVersion;
	}
}
