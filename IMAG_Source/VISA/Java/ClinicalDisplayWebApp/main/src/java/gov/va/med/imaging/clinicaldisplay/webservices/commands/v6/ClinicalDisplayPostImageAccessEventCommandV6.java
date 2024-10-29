/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 18, 2010
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands.v6;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayPostImageAccessEventCommand;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator6;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayPostImageAccessEventCommandV6
extends AbstractClinicalDisplayPostImageAccessEventCommand
{
	private ImageAccessLogEvent imageAccessLogEvent = null;
	private boolean logEventTranslated = false;
	private final gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ImageAccessLogEventType logEvent;

	public ClinicalDisplayPostImageAccessEventCommandV6(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ImageAccessLogEventType logEvent)
	{
		super();
		ClinicalDisplayCommandCommonV6.setTransactionContext(logEvent.getCredentials(), transactionId);
		this.logEvent = logEvent;
	}

	@Override
	protected ImageAccessLogEvent getImageAccessLogEvent()
	throws URNFormatException
	{
		// the translator might not be able to translate the event, if it can't then the result
		// is still null but we don't want to bother trying over and over again
		// so use logEventTranslated boolean to keep track of that and only try it once
		if((imageAccessLogEvent == null) && (!logEventTranslated))
		{
			imageAccessLogEvent = ClinicalDisplayTranslator6.translate(logEvent);
			logEventTranslated = true;
		}
		return imageAccessLogEvent;
	}

	@Override
	public String getInterfaceVersion()
	{
		return ClinicalDisplayCommandCommonV6.clinicalDisplayV6InterfaceVersion;
	}

}
