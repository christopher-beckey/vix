/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 24, 2011
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
package gov.va.med.imaging.router.commands.dd;

import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.router.commands.dd.provider.DataDictionaryCommandContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractDataDictionaryCommandImpl<R>
extends AbstractCommandImpl<R>
{
	private static final long serialVersionUID = 8859348133982849800L;

	protected DataDictionaryCommandContext getDataDictionaryCommandContext()
	{
		return (DataDictionaryCommandContext)getCommandContext();
	}

	/**
	 * Set the source of the data (from the data source)
	 */
	protected void setInitialTransactionContextFields()
	{
		DataDictionaryCommandContext dataDictionaryCommandContext = getDataDictionaryCommandContext();
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setServicedSource(dataDictionaryCommandContext.getLocalSite().getArtifactSource().createRoutingToken().toRoutingTokenString());
	}
	
	/**
	 * Convenience method to set the entries returned
	 * @param entriesReturned
	 */
	protected void setDataSourceEntriesReturned(int entriesReturned)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setDataSourceEntriesReturned(entriesReturned);
	}
}
