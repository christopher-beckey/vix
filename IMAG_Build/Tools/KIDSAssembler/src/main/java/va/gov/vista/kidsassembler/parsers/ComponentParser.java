package va.gov.vista.kidsassembler.parsers;

import java.io.File;
import java.util.List;

import va.gov.vista.kidsassembler.components.KidsComponent;

public interface ComponentParser {
	List<KidsComponent> parse(String name, File file);
}
