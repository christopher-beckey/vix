/**
 * 
 */
package gov.va.med.imaging.terminology;

import gov.va.med.imaging.utils.FileUtilities;

import java.io.*;

/**
 * @author vhaiswbeckec
 *
 */
public class SwapPropertyFileKeyValue
{
	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		if(args.length != 2)
		{
			System.err.println("SwapPropertyFileKeyValue <infile> <outfile>");
			System.exit(-1);
		}

		FileReader fileReader = null;
		LineNumberReader lineReader = null;
		FileWriter writer = null;
		try
		{
			fileReader = new FileReader(FileUtilities.getFile(args[0]));
			lineReader = new LineNumberReader(fileReader);
			File outFile = FileUtilities.getFile(args[1]);
			if(outFile.exists())
				outFile.delete();
			outFile.createNewFile();
			writer = new FileWriter(outFile);
			
			swapKeyValue(lineReader, writer);
		}
		catch (FileNotFoundException x)
		{
			x.printStackTrace();
			System.exit(-2);
		}
		catch (IOException x)
		{
			x.printStackTrace();
			System.exit(-3);
		}
		finally
		{
			if (fileReader != null) {
				try {
					fileReader.close();
				} catch (Exception e) {
					// Ignore
				}
			}
			if (lineReader != null) {
				try {
					lineReader.close();
				} catch (Exception e) {
					// Ignore
				}
			}
			if (writer != null) {
				try {
					writer.close();
				} catch (Exception e) {
					// Ignore
				}
			}
		}
		
	}

	/**
	 * @param infile
	 * @param outfile
	 * @throws IOException 
	 */
	private static void swapKeyValue(LineNumberReader lineReader, Writer writer) 
	throws IOException
	{
		String lineSeperator = System.getProperty("line.separator");
		for( String line=lineReader.readLine(); line != null; line = lineReader.readLine() )
		{
			if(line.trim().startsWith("#"))
				writer.write(line);
			else
			{
				String[] parts = line.split("=");
				if(parts.length != 2)
					System.err.println("Line '" + line + "' is not in the expected form and is being ignored.");
				else
				{
					writer.write(parts[1]);
					writer.write('=');
					writer.write(parts[0]);
					writer.write(lineSeperator);
				}
			}
		}
	}

}
