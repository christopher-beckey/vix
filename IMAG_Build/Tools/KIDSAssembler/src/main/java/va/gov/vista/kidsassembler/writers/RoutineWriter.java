package va.gov.vista.kidsassembler.writers;

import java.io.BufferedWriter;
import java.io.IOException;

import va.gov.vista.kidsassembler.components.GlobalNode;
import va.gov.vista.kidsassembler.components.KernelComponentList;
import va.gov.vista.kidsassembler.components.KidsComponent;
import va.gov.vista.kidsassembler.components.Routine;



public class RoutineWriter extends ComponentWriterImpl{

	
	@Override
	public void writeBody(KernelComponentList<? extends KidsComponent> collection,
			BufferedWriter writer) throws IOException {
		
		if (collection.size() < 1) return;		// do not write anything is there is no elements
		
		writer.write("\"RTN\")");
		writer.newLine();
		writer.write(Integer.toString(collection.size()));
		writer.newLine();
		
		String rtnName;
		GlobalNode node;
		int routineCounter=0;		// Install order - TODO do we need to have the order in the collection as attribute?
									// The post,pre,env routines should be first ? 
		for ( KidsComponent component : collection) {
			routineCounter++;
			Routine routine = (Routine) component;
			rtnName = "\"RTN\",\"" + routine.getName() + "\"";
			
			writer.write(rtnName + ")");
			writer.newLine();
			writer.write("0^" + Integer.toString(routineCounter) + "^B" + routine.getCheckSum());
			writer.newLine();
		
				for (int i=0; i<= routine.getBody().size()-1; i++ ) {
					node = routine.getBody().get(i);
					writer.write(rtnName + "," + node.getKey());	//"RTN","MAGGTU4D",1,0)
					writer.newLine();
					writer.write(node.getData());		// routine line
					writer.newLine();
				}
		}
	
		
	}
	
	@Override
	public void writeHeaderList(KernelComponentList<? extends KidsComponent> collection,
			BufferedWriter writer) throws IOException {
	
		String node ="\"BLD\"," + Integer.toString(this.buildIen) + ",";
		
		node = node +  "\"KRN\"," +  collection.getFileNumberString() + ",";
			
		node = node +  "\"NM\",";
		
		writer.write(node + "0)");								// "BLD",3463,"KRN",.4,"NM",0)
		writer.newLine();
		
		String count = Integer.toString(collection.size());		// Total elements
		
		writer.write("^9.68A^" + count + "^" + count);			// ^9.68A^4^4
		writer.newLine();
		
		for (int i=1; i <= collection.size(); i++) {
			writer.write(node + Integer.toString(i) + ",0)"); 		// "BLD",3463,"KRN",9.8,"NM",13,0)
			writer.newLine();
			
			writer.write(collection.get(i-1).getName() + "^^0^");
			writer.write("B" + ((Routine) collection.get(i-1)).getCheckSum());	// MAGDQR07^^0^B4766521
			writer.newLine();
		}
	}
}
