package va.gov.vista.kidsbundler;

	import java.io.BufferedWriter;
	import java.io.FileWriter;
	import java.io.IOException;
	import java.nio.file.Path;
	import java.text.SimpleDateFormat;
	import java.util.Date;
	import java.util.List;
	import org.apache.log4j.Logger;

import va.gov.vista.kidsbundler.KidsBundlerPackage;
import va.gov.vista.kidsbundler.manifest.Patch;
import va.gov.vista.kidsbundler.parser.KidsParser;

	
	public class KidsBundlerWriter {
		private static final Logger logger = Logger.getLogger(KidsBundlerWriter.class);
		protected final KidsBundlerPackage kidsBundlerPackage;
		

		public KidsBundlerWriter(KidsBundlerPackage kidsBundlerPackage) {
			this.kidsBundlerPackage = kidsBundlerPackage;
			
		}


		// write the KIDS out
		public void writeKidsBundler(Path outputFilePath) {
			try (BufferedWriter writer = new BufferedWriter(new FileWriter(
					outputFilePath.toFile()))) {

				writeFileHeader(writer); // writes first two lines

				writeKIDSHeader(writer); // **KIDS**:

				writeAllPatches(writer);	// writes all patches
				
				writeFooter(writer); // **END**

				writer.flush();
			} catch (IOException e) {
				logger.error(e);
			}
		}
		
		private void writeFooter(BufferedWriter writer) throws IOException {
			writer.write("**END**");
			writer.newLine();
			writer.write("**END**");
			writer.newLine();
		}
		
		private void writeFileHeader(BufferedWriter writer) throws IOException {
			// e.g.,
			//
			// KIDS Distribution saved on Nov 06, 2012@08:53:15
			// VistA Imaging V3.0 - Patch 118 - Test 33 11/06/2012 08:53AM

			Date date = new Date();
			SimpleDateFormat commentDateFormat = new SimpleDateFormat(
					"MMM dd, yyyy@HH:mm:ss");
			SimpleDateFormat commentDateFormat2 = new SimpleDateFormat(
					"MM/dd/yyyy hh:mma");

			writer.write("KIDS Distribution saved on ");
			writer.write(commentDateFormat.format(date));
			writer.newLine();
			writer.write(this.kidsBundlerPackage.getComment());
			writer.write(" - ");
			if (this.kidsBundlerPackage.getTestVersion() > 0) {
				writer.write("Test " + this.kidsBundlerPackage.getTestVersion() + " ");
			}
			writer.write(commentDateFormat2.format(date));
			writer.newLine();
		}
		
		private void writeKIDSHeader(BufferedWriter writer) throws IOException {
			// KIDS Header:
			// **KIDS**: (build 1^build 2^…^build n)
			// Build 1 is the primary build

			writer.write("**KIDS**:");
			for (Patch patch : this.kidsBundlerPackage.getPatches()) {
				writer.write(patch.getName() + "^");
			}
			writer.newLine();

			writer.newLine();
		}
		
		private void writeAllPatches(BufferedWriter writer) throws IOException {
			Path sourceKids;
			
			List<String> kidsBody;
			KidsParser kidsParser = new KidsParser();
			
			for (Patch patch : this.kidsBundlerPackage.getPatches()) {
				
				sourceKids = this.kidsBundlerPackage.getKidsExportPath().resolve(patch.getExport());
				if (!sourceKids.toFile().exists()) {
					logger.error("File not found: " + sourceKids.toString());
					continue;
				}
				
				kidsBody = kidsParser.parse(sourceKids.toFile());	
				
				for (String str : kidsBody) {
					writer.write(str);
					writer.newLine();
				}
								
			}
		}
		
}
