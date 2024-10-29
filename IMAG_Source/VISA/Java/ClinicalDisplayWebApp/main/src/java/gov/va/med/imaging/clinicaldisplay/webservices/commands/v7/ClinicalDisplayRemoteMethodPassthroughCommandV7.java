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
package gov.va.med.imaging.clinicaldisplay.webservices.commands.v7;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayRemoteMethodPassthroughCommand;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator7;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayRemoteMethodPassthroughCommandV7
extends AbstractClinicalDisplayRemoteMethodPassthroughCommand
{
	private final PassthroughInputMethod passthroughInputMethod;

	public ClinicalDisplayRemoteMethodPassthroughCommandV7(String transactionId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, 
			String siteId,
			String methodName, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodInputParameterType inputParameters)
	{
		super(siteId, methodName);
		passthroughInputMethod = ClinicalDisplayTranslator7.translate(getMethodName(), inputParameters);
		ClinicalDisplayCommandCommonV7.setTransactionContext(credentials, transactionId);
	}

	@Override
	protected PassthroughInputMethod getPassthroughInputMethod()
	{
		return passthroughInputMethod;
	}

	@Override
	public String getInterfaceVersion()
	{
		return ClinicalDisplayCommandCommonV7.clinicalDisplayV7InterfaceVersion;
	}
}
