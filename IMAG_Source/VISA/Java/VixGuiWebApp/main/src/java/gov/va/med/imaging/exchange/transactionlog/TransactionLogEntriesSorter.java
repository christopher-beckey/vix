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

import gov.va.med.imaging.access.TransactionLogEntry;

import java.util.ArrayList;
import java.util.List;

/**
 * Utility methods for sorting transaction log entries
 * 
 * @author VHAISWWERFEJ
 *
 */
public class TransactionLogEntriesSorter
{
	/**
	 * Sorts all of the transaction log entries into a tree like structure based on the command ID and parent
	 * command ID.  Each GroupedTransactionLogEntry returned will be a parent command (a command without a parent
	 * command ID).  Each GroupedTransactionLogEntry may have 0 to n child entries
	 * @param entries
	 * @return
	 */
	public static List<GroupedTransactionLogEntry> sortByParents(List<TransactionLogEntry> entries)
	{
		//Collections.sort(entries, new ParentTransactionLogEntryComparer());
		// entries are sorted so all commands without a parent are first
		
		// using an array to be able to set some to null
		GroupedTransactionLogEntry [] groupedEntries = 
			new GroupedTransactionLogEntry[entries.size()];
		
		List<GroupedTransactionLogEntry> result = 
			new ArrayList<GroupedTransactionLogEntry>();
		
		// put into grouped transaction log entry array
		for(int i = 0; i < entries.size(); i++)
		{
			TransactionLogEntry entry = entries.get(i);
			groupedEntries[i] = new GroupedTransactionLogEntry(entry);			
		}
		
		for(int i = 0; i < groupedEntries.length; i++)
		{
			GroupedTransactionLogEntry entry = groupedEntries[i];
			if(entry.isChildCommand())
			{
				// find the parent and null this entry
				//boolean parentFound = false;	
				
				GroupedTransactionLogEntry parentEntry = 
					findGroupedTransactionLogEntry(entry.getParentCommandId(), groupedEntries);
				if(parentEntry != null)
				{
					parentEntry.addChildCommand(entry);
					groupedEntries[i] = null;
				}
				
			}
		}
		for(GroupedTransactionLogEntry entry : groupedEntries)
		{
			// any entries that are null should not be added to the result
			if(entry != null)
				result.add(entry);
		}
		return result;
		
	}
	
	private static GroupedTransactionLogEntry findGroupedTransactionLogEntry(String parentCommandId, 
			GroupedTransactionLogEntry [] groupedEntries)
	{
		for(GroupedTransactionLogEntry entry : groupedEntries)
		{
			if(entry != null)
			{
				if(entry.getCommandId().equals(parentCommandId))
				{
					return entry;
				}
				GroupedTransactionLogEntry childResult = findGroupedTransactionLogEntry(parentCommandId, entry.getChildEntries().toArray(new GroupedTransactionLogEntry[entry.getChildEntries().size()]));
				if(childResult != null)
					return childResult;
			}
		}
		return null;
	}
	
	/**
	 * This takes a list of GroupedTransactionLogEntries which have already been grouped into a tree structure and flattens it
	 * so the first entry is the parent, the next is its child, then its child and so forth
	 * 
	 * @param groupedEntries
	 * @return
	 */
	public static List<LeveledTransactionLogEntry> flattenGroupedTransactionLogEntries(
			List<GroupedTransactionLogEntry> groupedEntries)
	{
		return flattenGroupedTransactionLogEntries(groupedEntries, 0);
	}
	
	private static List<LeveledTransactionLogEntry> flattenGroupedTransactionLogEntries(
			List<GroupedTransactionLogEntry> groupedEntries, int level)
	{
		//System.out.println("Adding entries at level '" + level + "'.");
		List<LeveledTransactionLogEntry> entries = new ArrayList<LeveledTransactionLogEntry>();
		for(GroupedTransactionLogEntry entry : groupedEntries)
		{
			entries.add(new LeveledTransactionLogEntry(entry, level));
			int newLevel = level + 1;
			entries.addAll(flattenGroupedTransactionLogEntries(entry.getChildEntries(), newLevel));
		}
		return entries;
	}
}
