/*
 * Created on Apr 15, 2008
// Per VHA Directive 2004-038, this routine should not be modified.
//+---------------------------------------------------------------+
//| Property of the US Government.                                |
//| No permission to copy or redistribute this software is given. |
//| Use of unreleased versions of this software requires the user |
//| to execute a written test agreement with the VistA Imaging    |
//| Development Office of the Department of Veterans Affairs,     |
//| telephone (301) 734-0100.                                     |
//|                                                               |
//| The Food and Drug Administration classifies this software as  |
//| a medical device.  As such, it may not be changed in any way. |
//| Modifications to this software may result in an adulterated   |
//| medical device under 21CFR820, the use of which is considered |
//| to be a violation of US Federal Statutes.                     |
//+---------------------------------------------------------------+
 */
package gov.va.med.imaging.business.exceptions;

/**
 *
 *
 *
 * @author William Peterson
 *
 */
public class MoveSCPException extends Exception {

	/**
	 * Constructor
	 */
	public MoveSCPException() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * Constructor
	 * @param arg0
	 */
	public MoveSCPException(String arg0) {
		super(arg0);
		// TODO Auto-generated constructor stub
	}

	/**
	 * Constructor
	 * @param arg0
	 */
	public MoveSCPException(Throwable arg0) {
		super(arg0);
		// TODO Auto-generated constructor stub
	}

	/**
	 * Constructor
	 * @param arg0
	 * @param arg1
	 */
	public MoveSCPException(String arg0, Throwable arg1) {
		super(arg0, arg1);
		// TODO Auto-generated constructor stub
	}

}