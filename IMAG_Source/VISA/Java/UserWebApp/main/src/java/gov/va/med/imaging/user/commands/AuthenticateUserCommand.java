/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 26, 2010
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
package gov.va.med.imaging.user.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.facade.InternalContext;
import gov.va.med.imaging.exchange.business.AuditEvent;
import gov.va.med.imaging.exchange.business.UserCredentials;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.user.UserContext;

import java.util.HashMap;
import java.util.List;

import com.thoughtworks.xstream.XStream;

/**
 * @author vhaiswlouthj
 *
 */
public class AuthenticateUserCommand 
extends AbstractUserCommand<UserCredentials, String>
{
	private final String interfaceVersion;
	private final String applicationName;
	
	public AuthenticateUserCommand(String interfaceVersion, String applicationName)
	{
		super("authenticateUser");
		this.interfaceVersion = interfaceVersion;
		this.applicationName = applicationName;
	}

	@Override
	protected UserCredentials executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		UserCredentials cred = new UserCredentials();
		cred.setDuz(transactionContext.getDuz());
		cred.setFullname(transactionContext.getFullName());
		cred.setSiteName(transactionContext.getSiteName());
		cred.setSiteNumber(transactionContext.getSiteNumber());
		cred.setSsn(transactionContext.getSsn());

		// Add the user keys to the credentials
		List<String> userKeys = UserContext.getRouter().getUserKeys(getLocalRoutingToken());
		cred.setUserKeys(userKeys);
		
		// Create an audit event
    	HashMap<String, String> eventElements = new HashMap<String, String>();
    	eventElements.put("User DUZ", transactionContext.getDuz());
    	String message = "User with DUZ: " + transactionContext.getDuz()+" logged in to the Importer 2 GUI.";
		InternalContext.getRouter().postAuditEvent(
					null,
					new AuditEvent(AuditEvent.CLIENT_LOGIN,
							DicomServerConfiguration.getConfiguration().getHostName(),
							applicationName,
							message,
							eventElements));

		return cred;
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(UserCredentials routerResult) 
	throws TranslationException 
	{

    	// Get and configure XStream
		XStream xstream = getXStream();
    	xstream.alias("UserCredentials", UserCredentials.class);
    	
    	return xstream.toXML(routerResult);
	}

	@Override
	protected String getMethodParameterValuesString() {
		// TODO Auto-generated method stub
		return null;
	}
	
}
