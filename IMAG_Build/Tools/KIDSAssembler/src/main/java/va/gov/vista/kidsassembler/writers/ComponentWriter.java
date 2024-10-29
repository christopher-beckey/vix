package va.gov.vista.kidsassembler.writers;

import java.io.BufferedWriter;
import java.io.IOException;

import va.gov.vista.kidsassembler.components.KernelComponentList;
import va.gov.vista.kidsassembler.components.KidsComponent;

public interface ComponentWriter {

	int getBuildIen();

	void setBuildIen(int buildIen);
	
	void writeBody(KernelComponentList<? extends KidsComponent> collection,
			BufferedWriter writer) throws IOException;

	void writeHeader(KernelComponentList<? extends KidsComponent> collection,
			BufferedWriter writer) throws IOException ;
	
	void writeHeaderList(KernelComponentList<? extends KidsComponent> collection,
			BufferedWriter writer) throws IOException ;

	void writeBCrossReference(KernelComponentList<? extends KidsComponent> collection,
			BufferedWriter writer) throws IOException ;
}