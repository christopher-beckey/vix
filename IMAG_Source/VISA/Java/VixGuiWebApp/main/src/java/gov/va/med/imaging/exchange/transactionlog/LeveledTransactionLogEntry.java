/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 23, 2011
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
package gov.va.med.imaging.exchange.transactionlog;

import gov.va.med.imaging.access.TransactionLogEntry;

/**
 * This object contains a transaction log entry and the level in the command order that this transction was called in
 * @author VHAISWWERFEJ
 *
 */
public class LeveledTransactionLogEntry
{
	private final TransactionLogEntry transactionLogEntry;
	private final int level;
	
	public LeveledTransactionLogEntry(TransactionLogEntry transactionLogEntry, int level)
	{
		this.transactionLogEntry = transactionLogEntry;
		this.level = level;
	}

	public TransactionLogEntry getTransactionLogEntry()
	{
		return transactionLogEntry;
	}

	public int getLevel()
	{
		return level;
	}

}
