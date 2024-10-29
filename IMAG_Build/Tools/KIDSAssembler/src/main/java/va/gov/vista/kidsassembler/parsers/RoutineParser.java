package va.gov.vista.kidsassembler.parsers;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import va.gov.vista.kidsassembler.components.GlobalNode;
import va.gov.vista.kidsassembler.components.KidsComponent;
import va.gov.vista.kidsassembler.components.Routine;

public class RoutineParser implements ComponentParser {
	private static final Logger logger = Logger.getLogger(RoutineParser.class);
	protected int lineCount;

	@Override
	public List<KidsComponent> parse(String name, File file) {
		logger.debug("Parsing file: " + file);
		List<KidsComponent> routines = new ArrayList<KidsComponent>();
		String sCurrentLine;

		try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
			Routine routine = new Routine();
			routine.setName(name);

			String l1 = reader.readLine();
			String l2 = reader.readLine();
			String l3 = reader.readLine();

			// For %RO exported skip first 3 lines otherwise add them
			if (l3.contains(" ")) {
				routine.getBody().add(createGlobalNode(l1));
				routine.getBody().add(createGlobalNode(l2));
				routine.getBody().add(createGlobalNode(l3));
			}

			while ((sCurrentLine = reader.readLine()) != null) {
				if (sCurrentLine.equals(""))
					continue;

				routine.getBody().add(createGlobalNode(sCurrentLine));
			}
			routines.add(routine);
		} catch (FileNotFoundException fnfe) {
			logger.error(fnfe);
		} catch (IOException ioe) {
			logger.error(ioe);
		}

		return routines;
	}

	private GlobalNode createGlobalNode(String dataLine) {
		lineCount++;
		GlobalNode node = new GlobalNode(Integer.toString(lineCount) + ",0)",
				dataLine);
		return node;
	}
}
