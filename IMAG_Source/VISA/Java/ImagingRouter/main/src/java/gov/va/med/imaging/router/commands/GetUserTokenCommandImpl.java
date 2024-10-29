/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Sep 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.router.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.tomcat.vistarealm.encryption.EncryptionToken;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Julian
 *
 */
public class GetUserTokenCommandImpl
extends AbstractCommandImpl<String>
{
	private static final long serialVersionUID = 2560310959100383456L;
	private String appName = null;

	
	public GetUserTokenCommandImpl(
			String appName)
	{
		super();
		this.appName = appName;
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public String callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		try
		{
			TransactionContext transactionContext = TransactionContextFactory.get(); 
			transactionContext.setServicedSource(getCommandContext().getLocalSite().getArtifactSource().createRoutingToken().toRoutingTokenString());
			transactionContext.setSecurityTokenApplicationName(getSecurityTokenApplicationName());
			return EncryptionToken.encryptUserCredentials();
		} 
		catch (AesEncryptionException aeseX)
		{
			throw new MethodException(aeseX);
		}
	}

	private String getSecurityTokenApplicationName() {
		return this.appName;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return null;
	}

}
