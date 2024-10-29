package gov.va.med.imaging.viewer.commands;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.viewer.ViewerImagingContext;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.UserInfoType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class GetUserInformationByUserIdCommand 
extends AbstractViewerImagingCommands<List<String>, UserInfoType>
{
	private Logger logger = Logger.getLogger(this.getClass());

	private final String interfaceVersion;
	private final String siteId;
	private final String userId;
	
	public GetUserInformationByUserIdCommand(String siteId, String userId, String interfaceVersion)
	{
		super("GetUserInformationByUserIdCommand");
		
		this.siteId = siteId;
		this.userId = userId;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<String> executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		try
		{
			TransactionContext transactionContext = TransactionContextFactory.get();

			if((transactionContext != null) && transactionContext.getSiteNumber().startsWith("200"))
			{
				logger.debug("CVIX - returns null");
				return null;
			}
			
			RoutingToken routingToken = null;
			
			if (getSiteId() == null)
			{
				routingToken = createLocalRoutingToken();
			}
			else
			{
				routingToken =
						RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			}
			
			List<String> userKeys = null;
			String userInfo = ViewerImagingContext.getRouter().getUserInformationByUserId(routingToken, getUserId());

            logger.debug("userInfo: {}", userInfo);
			
			if (userInfo != null && !userInfo.isEmpty()) 
			{
				userKeys = ViewerImagingContext.getRouter().getUserKeys(routingToken);
                logger.debug("userKeys: {}", userKeys);
				if (userKeys == null) 
				{
					userKeys = new ArrayList<String>();
				}
				userKeys.add(userInfo);
			}
			
			return userKeys;

		}
		catch(RoutingTokenFormatException rtfX)
		{
            logger.debug("RoutingToken Exception: {}", rtfX.getMessage());
			return null;
		}
		catch (Exception e)
		{
            logger.debug("General Exception: {}", e.getMessage());
			return null;
		}
		
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return siteId + "," + userId;
	}

	@Override
	protected Class<UserInfoType> getResultClass() 
	{
		return UserInfoType.class;
	}

	@Override
	protected UserInfoType translateRouterResult(List<String> routerResult)
	{
        logger.debug("userInfo & UserKeys to translate: {}", routerResult);
    	return ViewerImagingRestTranslator.translateUserInfo(routerResult);
	}

	public String getSiteId()
	{
		if ((siteId == null) || (siteId.isEmpty()))
		{
			TransactionContext transactionContext = TransactionContextFactory.get();
			return transactionContext.getSiteNumber();
		}
		else
		{
			return siteId;
		}
	}
	
	public String getUserId()
	{
		if ((userId == null) || (userId.isEmpty()))
		{
			TransactionContext transactionContext = TransactionContextFactory.get();
			if (transactionContext.getDuz() == null)
			{
				return "DUZ";
			}
			else
			{
				return transactionContext.getDuz();
			}
		}
		else
		{
			return userId;
		}
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		return null;
	}

	@Override
	public String getInterfaceVersion() {
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(UserInfoType translatedResult) {
		return 1;
	}

}
