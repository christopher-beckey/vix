/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 23, 2011
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

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.router.commands.dd.provider.DataDictionaryCommandContext;

/**
 * @author VHAISWTITTOC
 *
 */
public class GetFileManEntryByValueCommandImpl
extends AbstractDataDictionaryCommandImpl<String[]>
{
	private static final long serialVersionUID = 6006373136676240475L;
	private final String fileNumber;
	private final String keyName;
	private final String keyValue;
	
	public GetFileManEntryByValueCommandImpl(
			String fileNum, String keyName, String keyValue)
	{
		super();
		this.fileNumber = fileNum;
		this.keyName = keyName;
		this.keyValue = keyValue;
	}

	@Override
	public String[] callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		setInitialTransactionContextFields();
		DataDictionaryCommandContext dataDictionaryCommandContext = getDataDictionaryCommandContext();
		String[] result = dataDictionaryCommandContext.getDataDictionaryService().getFileManEntryByValue(fileNumber, keyName, keyValue);
		setDataSourceEntriesReturned(result == null ? 0 : result.length);
		return result;
	}

	@Override
	public boolean equals(Object obj)
	{
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}
}