package va.gov.vista.kidsassembler.parsers;

import java.io.File;



public class ComponentParserFactory {
	public ComponentParserFactory() {

	}

	public static ComponentParser CreateParser(File file){
		String filename = file.getName().toLowerCase();
		if (filename.endsWith(".rtn")){
			return new RoutineParser();
		}
		else if (filename.endsWith(".kid")){
			return new KidsParser();
		}
		
		return null;
	}
}
