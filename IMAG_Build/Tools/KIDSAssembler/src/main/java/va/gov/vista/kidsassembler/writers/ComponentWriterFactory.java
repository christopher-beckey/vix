package va.gov.vista.kidsassembler.writers;

import va.gov.vista.kidsassembler.components.KernelComponentList;
import va.gov.vista.kidsassembler.components.KidsComponent;

public class ComponentWriterFactory {
	
	public ComponentWriterFactory() {

	}

	public static ComponentWriter CreateWriter(KernelComponentList<? extends KidsComponent> collection, int buildIen){
		
		
		ComponentWriter result;
		
		if (collection.getFileNumber() == 9.8f) {
			result = new RoutineWriter();
		}
		else {
			result = new ComponentWriterImpl();
		}
	
		result.setBuildIen(buildIen);
		
		return result;
		
	}
}
