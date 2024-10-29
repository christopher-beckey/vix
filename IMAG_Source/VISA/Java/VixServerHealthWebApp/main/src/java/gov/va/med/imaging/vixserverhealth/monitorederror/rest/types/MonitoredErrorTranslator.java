/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 30, 2013
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
package gov.va.med.imaging.vixserverhealth.monitorederror.rest.types;

import gov.va.med.imaging.monitorederrors.MonitoredError;

import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
public class MonitoredErrorTranslator
{

	public static MonitoredErrorsType translate(List<MonitoredError> monitoredErrors)
	{
		if(monitoredErrors == null)
			return null;
		MonitoredErrorType [] result = new MonitoredErrorType[monitoredErrors.size()];
		for(int i = 0; i < monitoredErrors.size(); i++)
		{
			result[i] = translate(monitoredErrors.get(i));
		}
		
		return new MonitoredErrorsType(result);
	}
	
	private static MonitoredErrorType translate(MonitoredError monitoredError)
	{
		return new MonitoredErrorType(monitoredError.getErrorMessageContains(),
				monitoredError.getCount(), monitoredError.getLastOccurrence(), 
				monitoredError.isActive());
	}
}
