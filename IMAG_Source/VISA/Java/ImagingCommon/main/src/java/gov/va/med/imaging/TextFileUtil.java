/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: March 4, 2005
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWPETRB
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
package gov.va.med.imaging;

import gov.va.med.imaging.exceptions.ReadFileException;
import gov.va.med.imaging.exceptions.TextFileException;
import gov.va.med.imaging.exceptions.TextFileExtractionException;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import gov.va.med.logging.Logger;

/**
 *
 * @author William Peterson
 *
 */
public class TextFileUtil 
{
    private static final Logger LOGGER = Logger.getLogger (TextFileUtil.class);
    
    private BufferedReader buffer;
    private final int MAX_SIZE = 5000;

    /**
     * Constructor
     *
     * 
     */
    public TextFileUtil() 
    {
        super();
    }
    
    public void openTextFile(String textFilename)throws TextFileException{
        
        try
        {
            //Get Text file.
            //JUNIT Create test to verify how this fails if not correct permissions.
            this.buffer = new BufferedReader(new FileReader(StringUtil.cleanString(textFilename)));
        }
        catch(FileNotFoundException ex)
        {
        	String msg = "TextFileUtil.openTextFile() --> File [" + textFilename + "] is not found: " + ex.getMessage();
            LOGGER.error(msg);
            throw new TextFileException(msg, ex);
        }
    }
    
    public void openTextFile(File file) throws TextFileException{
        try
        {
            //Get Text file.
            //JUNIT Create test to verify how this fails if not correct permissions.
            
            this.buffer = new BufferedReader(new FileReader(file));
        }
        catch(FileNotFoundException ex)
        {
        	String msg = "TextFileUtil.openTextFile(1) --> File [" + file.getAbsolutePath() + "] is not found: " + ex.getMessage();
            LOGGER.error(msg);
            throw new TextFileException(msg, ex);
        }
    }

    public String getNextTextLine() throws TextFileExtractionException
    {
        String line = null;

        try
        {
            boolean eof = false;
            do
            {
                if((line = this.buffer.readLine()) == null)
                {
                    eof = true;
                    break;
                }
                else
                {
                    if(line.length() > 1)
                    {
                        line.trim();
                        char firstChar;
                        firstChar = line.charAt(0);
                        if(firstChar == '#'){
                            line = "";
                        }
                    }
                    else
                    {
                        line = "";
                    }
                }
            } while(line.equals(""));
            
            if (eof)
            {
                buffer.close();
                return null;
            }
        }
        catch(Exception ex)
        {
        	String msg = "TextFileUtil.getNextTextLine() --> Encountered exception [" + ex.getClass().getSimpleName() + "] while getting next line from text file: " + ex.getMessage();
        	LOGGER.error(msg);
        	throw new TextFileExtractionException(msg, ex);
        }
        
        return line;
    }

    public char[] getAllText()throws ReadFileException{
        char[] text = new char[MAX_SIZE];
        try{
            this.buffer.read(text);
        }
        catch(IOException ioX){
            throw new ReadFileException();
        }
        return text;
    }    
}
