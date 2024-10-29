/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 27, 2010
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
package gov.va.med.imaging.mix.webservices.commands.v1;

import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class MixCommandCommonV1
{
private final static Logger logger = Logger.getLogger(MixCommandCommonV1.class);
	
	public final static String mixV1InterfaceVersion = "V1";
	
	public static Logger getLogger()
	{
		return logger;
	}
	
	public static void setTransactionContext(
			gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType requestor,
			java.lang.String transactionId)
		{
			logger.info(
					"setTransactionContext, id='" + transactionId + 
					"', username='" + requestor == null || requestor.getUsername() == null ? "null" : "" + requestor.getUsername() + 
					"'.");
			TransactionContext transactionContext = TransactionContextFactory.get();
			
			if(transactionId != null)
				transactionContext.setTransactionId(transactionId);
			
			if(requestor != null)
			{
				if( requestor.getUsername() != null )
					transactionContext.setFullName(requestor.getUsername());
				if( requestor.getFacilityId() != null )
					transactionContext.setSiteNumber(requestor.getFacilityId());
				if( requestor.getFacilityName() != null )
					transactionContext.setSiteName(requestor.getFacilityName());
				if( requestor.getPurposeOfUse() != null )
					transactionContext.setPurposeOfUse(requestor.getPurposeOfUse().toString());
				if( requestor.getSsn() != null )
					transactionContext.setSsn(requestor.getSsn());
			}
		}
}