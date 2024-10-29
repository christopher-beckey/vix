/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 21, 2011
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

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.access.TransactionLogEntry;
import gov.va.med.imaging.access.TransactionLogEntryObjectBuilder;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * @author VHAISWWERFEJ
 *
 */
public class TransactionLogGrouperTest
{

	@Test
	public void testSorting()
	{
		List<TransactionLogEntry> entries = new ArrayList<TransactionLogEntry>();
		TransactionLogEntry parentTransaction = 
			TransactionLogEntryObjectBuilder.createTransactionLogEntry("parent1", "");
		TransactionLogEntry childTransaction =
			TransactionLogEntryObjectBuilder.createTransactionLogEntry("child1", 
					parentTransaction.getCommandId());
		TransactionLogEntry childTransaction2 =
			TransactionLogEntryObjectBuilder.createTransactionLogEntry("child2", 
					parentTransaction.getCommandId());
		
		TransactionLogEntry childTransaction3 =
			TransactionLogEntryObjectBuilder.createTransactionLogEntry("child3", 
					childTransaction.getCommandId());
		
		entries.add(childTransaction);
		entries.add(parentTransaction);
		entries.add(childTransaction2);
		entries.add(childTransaction3);
		
		List<GroupedTransactionLogEntry> groupedEntries =
			TransactionLogEntriesSorter.sortByParents(entries);
		
		assertEquals(1, groupedEntries.size());
		GroupedTransactionLogEntry parentEntry = groupedEntries.get(0);
		assertEquals(2, parentEntry.getChildEntries().size());
		assertEquals(parentTransaction.getCommandId(), parentEntry.getCommandId());
		
		/*
		for(TransactionLogEntry entry : parentEntry.getChildEntries())
		{
			
		}*/
		
		
		for(GroupedTransactionLogEntry groupedEntry : groupedEntries)
		{
			System.out.println(groupedEntry.toString());
			if(groupedEntry.getCommandId().equals(childTransaction.getCommandId()))
			{
				assertEquals(1, groupedEntry.getChildEntries().size());
			}
		}
		
	}
}
