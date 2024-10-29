/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWBECKEC
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
package gov.va.med.imaging.exchange;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.nio.CharBuffer;

/**
 * @author VHAISWBECKEC
 *
 */
public class LineReader
{
	private final static int DEFAULT_BUFFER_SZ = 16384;
	private final char[] lineTerminator;
	private BufferedReader bufferedReader;
	private CharBuffer targetBuffer;

	public LineReader(Reader reader, char[] lineTerminator)
	{
		this.lineTerminator = lineTerminator;
		this.bufferedReader = new BufferedReader(reader, DEFAULT_BUFFER_SZ);
		// DO NOT use allocateDirect, we need the accessible character array
		this.targetBuffer = CharBuffer.allocate(DEFAULT_BUFFER_SZ);
	}

	private Object lock = new Object();
	
	/**
	 * Read a line from the wrapped reader. A line is terminated by the
	 * character sequence defined in the constructor.
	 * @throws IOException 
	 */
	public String readLine() 
	throws IOException
	{
		char[] lineBuilder = new char[DEFAULT_BUFFER_SZ];
		
		int index=0;
		while(true)
		{
			for(; index < lineBuilder.length; ++index)
			{
				int charRead = this.bufferedReader.read();
				if(charRead == -1)
					return index == 0 ? null : new String(lineBuilder, 0, index+1).trim();
	
				lineBuilder[index] = (char) charRead;
				if(isTerminator(lineBuilder, index, lineTerminator))
					return new String(lineBuilder, 0, index+1).trim();
			}
			
			// we should never get here, but just in case ...
			char[] biggerLineBuilder = new char[lineBuilder.length * 2];
			System.arraycopy(lineBuilder, 0, biggerLineBuilder, 0, lineBuilder.length);
			lineBuilder = biggerLineBuilder;
		}		
	}

	/**
	 * 
	 */
	public static boolean isTerminator(char[] lineBuilder, int index, char[] lineTerminator) 
	{
		int lineTerminatorLength = lineTerminator.length;
		int lineBuilderLength = index + 1;
		
		// if there are more characters in the terminator than in the read buffer, we have not found the terminator yet
		if(lineTerminatorLength > lineBuilderLength)
			return false;
		
		// compare from the 
		int lineTerminatorStartIndex = index - (lineTerminatorLength - 1);
		for(int lineTerminatorIndex = 0; lineTerminatorIndex < lineTerminatorLength; ++lineTerminatorIndex)
			if(lineTerminator[lineTerminatorIndex] != lineBuilder[lineTerminatorStartIndex + lineTerminatorIndex])
				return false;
		
		return true;
	}

	public void close() 
	throws IOException
	{
		this.bufferedReader.close();
	}
	
	//============================================================================================================
	// THe code below here is not used, it needs debugging.
	// Theoretically it will be much faster.
	//============================================================================================================
	
	private String fastReadLine() 
	throws IOException
	{
		synchronized(lock)
		{
			int lineTermination = fillBufferUntilLineTerminatorOrEnd();
			if(lineTermination == -1)
				return null;
			
			char[] lineAsChar = new char[lineTermination+1];
			
			targetBuffer.flip();
			targetBuffer.get(lineAsChar);
			if(targetBuffer.hasRemaining())
				targetBuffer.get(new char[2]);
			targetBuffer.flip();
			targetBuffer.compact();
			
			return new String(lineAsChar);
		}
	}
	/**
	 * 
	 * @return
	 * @throws IOException
	 */
	private int fillBufferUntilLineTerminatorOrEnd() 
	throws IOException
	{
		char[] backingArray = targetBuffer.array();
		int lineTermination = -1;
		boolean lineTerminationFound = false;
		
		while( ! lineTerminationFound )
		{
			for(int index = 0; (! lineTerminationFound) && index < targetBuffer.position(); ++index )
			{
				int lineTerminatorIndex;
				for( lineTerminatorIndex = 0; 
					lineTerminatorIndex < lineTerminator.length && 
						lineTerminator[lineTerminatorIndex] == backingArray[index+lineTerminatorIndex] &&
						lineTerminatorIndex < backingArray.length;
					++lineTerminatorIndex );
				if(lineTerminatorIndex >= lineTerminator.length)		// match found
				{
					lineTerminationFound = true;
					lineTermination = index-1;
				}
			}
			
			// read more characters into targetBuffer
			// if we reach the end of the input reader then return, indicating the last read char as the end of the line
			if( this.bufferedReader.read(targetBuffer) == -1)
				return targetBuffer.limit() > 0 ? targetBuffer.limit() : -1;
			
		}
		
		return lineTermination;
	}
}
