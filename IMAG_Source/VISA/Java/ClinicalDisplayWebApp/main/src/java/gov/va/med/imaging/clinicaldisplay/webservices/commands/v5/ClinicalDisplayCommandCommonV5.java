/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 4, 2010
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

import gov.va.med.logging.Logger;

import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator5;
import gov.va.med.imaging.exchange.business.Requestor.PurposeOfUse;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayCommandCommonV5
{

	private final static ClinicalDisplayTranslator5 interpreter = new ClinicalDisplayTranslator5();
	private final static Logger logger = Logger.getLogger(ClinicalDisplayCommandCommonV5.class);
	
	public final static String clinicalDisplayV5InterfaceVersion = "V5";
	
	public static Logger getLogger()
	{
		return logger;
	}
	
	public static ClinicalDisplayTranslator5 getTranslator()
	{
		return interpreter;
	}
	
	public static void setTransactionContext(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials,
			String transactionId)
	{
		getLogger().info(
				"setTransactionContext, id='" + transactionId + 
				"', username='" + credentials == null || credentials.getFullname() == null ? "null" : "" + credentials.getFullname() +
				"'.");
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		if(transactionId != null)
			transactionContext.setTransactionId(transactionId);
		
		if(credentials != null)
		{
			if( credentials.getFullname() != null )
				transactionContext.setFullName(credentials.getFullname());
			if( credentials.getSiteNumber() != null )
				transactionContext.setSiteNumber(credentials.getSiteNumber());
			if( credentials.getSiteName() != null )
				transactionContext.setSiteName(credentials.getSiteName());
			if( credentials.getDuz() != null )
				transactionContext.setPurposeOfUse(credentials.getDuz());
			if( credentials.getSsn() != null )
				transactionContext.setSsn(credentials.getSsn());
			if(credentials.getDuz() != null)
				transactionContext.setDuz(credentials.getDuz());
			if(credentials.getSecurityToken() != null)
				transactionContext.setBrokerSecurityToken(credentials.getSecurityToken());
			transactionContext.setPurposeOfUse(PurposeOfUse.routineMedicalCare.getDescription());
		}		
	}
}
