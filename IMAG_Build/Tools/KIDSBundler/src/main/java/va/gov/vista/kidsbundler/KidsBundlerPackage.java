package va.gov.vista.kidsbundler;

import java.nio.file.Path;
import java.util.LinkedList;
import java.util.List;

import va.gov.vista.kidsbundler.manifest.Patch;

public class KidsBundlerPackage {
	
	protected String comment;
	protected Path kidsExportPath;
	protected String name;
	protected short patch;
	protected final List<Patch> patches;
	protected String patchName;
	protected int testVersion;

	public KidsBundlerPackage() {
		
		patches = new LinkedList<Patch>();
	}

	public String getComment() {
		return comment;
	}

	public Path getKidsExportPath() {
		return kidsExportPath;
	}

	public String getName() {
		return name;
	}

	public short getPatch() {
		return patch;
	}
	
	public List<Patch> getPatches() {
	return patches;
}

	public String getPatchName() {
		return patchName;
	}
	
	public int getTestVersion() {
		return testVersion;
	}
	
	public void setComment(String comment) {
		this.comment = comment;
	}

		public void setKidsExportPath(Path kidsExportPath) {
			this.kidsExportPath = kidsExportPath;
		}

	public void setName(String name) {
		this.name = name;
	}


	public void setPatch(short patch) {
		this.patch = patch;
	}

	public void setPatchName(String patchName) {
		this.patchName = patchName;
	}


	public void setTestVersion(int testVersion) {
		this.testVersion = testVersion;
	}

}
