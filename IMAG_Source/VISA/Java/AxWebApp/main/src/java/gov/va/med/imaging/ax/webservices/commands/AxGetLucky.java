/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 1, 2016
  Developer:  vacotittoc
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
package gov.va.med.imaging.ax.webservices.commands;

import gov.va.med.imaging.ax.webservices.rest.types.LuckyType;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;

/**
 * @author vacotittoc
 *
 */
public class AxGetLucky
{	
	private String aWord;
	private String aNumber;
	
	public AxGetLucky(String aWord, String aNumber)
	{
		this.aWord = aWord;
		this.aNumber = aNumber;
	}

	public LuckyType crunch()
		throws MethodException {
		
		Integer theNumber = null;
		String theMessage = "Nothig to say!";

		// check input
		if ((aWord==null) || (aNumber==null))
			throw new MethodException("invalid input parameter(s)! Please Enter a non-blank word and an integer number!");

		if (aWord.isEmpty())
			theMessage = "Please Enter a word!";

		try {
			theNumber = Integer.parseInt(aNumber);
			theMessage = "Today your lucky word is '" + aWord + "' and your lucky number is " + theNumber + ".";
		}
		catch (NumberFormatException ne) {
			theMessage += "Illegal number format. Must be a [signed] integer!";
		}
		
		
		LuckyType lucky = new LuckyType(aWord, theNumber, theMessage);
				
		return lucky;
	}

}
