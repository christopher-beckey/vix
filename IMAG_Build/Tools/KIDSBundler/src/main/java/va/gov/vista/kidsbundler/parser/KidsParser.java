package va.gov.vista.kidsbundler.parser;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import org.apache.log4j.Logger;


public class KidsParser  {
	private static final Logger logger = Logger.getLogger(KidsParser.class);
		
	public ArrayList<String> parse(File file) {
		String sCurrentLine;
		
		logger.debug("Parsing file: " + file);
		ArrayList<String> kidsBody = new ArrayList<String>();

		try (BufferedReader reader = new BufferedReader(new FileReader(file))) {

			// Skip first four lines
			for (int i = 1; i <= 4; i++) {
				if (reader.readLine() == null) {
						break;
				}
			}
			
			while ((sCurrentLine = reader.readLine()) != null  && !sCurrentLine.equals("**END**") ) {
		
				kidsBody.add(sCurrentLine);
			}
		} catch (FileNotFoundException fnfe) {
			logger.error(fnfe);
		} catch (IOException ioe) {
			logger.error(ioe);
		}

		return kidsBody;
	}

}
