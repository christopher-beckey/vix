/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: March 12, 2013 
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswlouthj 
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
package gov.va.med.imaging.user.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ApplicationTimeoutParameters;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.OrderingLocation;
import gov.va.med.imaging.exchange.business.dicom.importer.Report;
import gov.va.med.imaging.exchange.business.dicom.importer.ReportParameters;
import gov.va.med.imaging.exchange.business.dicom.importer.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.user.UserContext;
import gov.va.med.imaging.user.UserRouter;

import java.util.List;

import com.thoughtworks.xstream.XStream;

/**
 * @author vhaiswlouthj
 *
 */
public class GetApplicationTimeoutParametersCommand 
extends AbstractUserCommand<ApplicationTimeoutParameters, String>
{
	private final String interfaceVersion;
	private final String siteId;
	private final String applicationName;
	
	public GetApplicationTimeoutParametersCommand(String siteId, String applicationName, String interfaceVersion)
	{
		super("GetApplicationTimeoutParametersCommand");
		
		this.siteId = siteId;
		this.applicationName = applicationName;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected ApplicationTimeoutParameters executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		UserRouter router = UserContext.getRouter();		
		ApplicationTimeoutParameters result = router.getApplicationTimeoutParameters(siteId, applicationName);
		setEntriesReturned(1);
		return result;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return siteId + applicationName;
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(ApplicationTimeoutParameters routerResult) 
	throws TranslationException 
	{
		XStream xstream = ImporterUtils.getXStream();
    	return xstream.toXML(routerResult);
	}

}
