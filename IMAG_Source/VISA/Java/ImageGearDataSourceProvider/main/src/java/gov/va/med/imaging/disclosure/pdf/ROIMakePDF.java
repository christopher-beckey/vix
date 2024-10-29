package gov.va.med.imaging.disclosure.pdf;

public class ROIMakePDF {
			
	/*
	static
	{ 
		System.loadLibrary("P130_DLL_Project");		
	}
			
	native public void displayHelloJerry();
	static native public String MakePdfDoc(String JobID,
			                        String DebugMode,
			                        String ROI_Office_Name, 
			                        String InputFileDir, 
			                        String ManifestRoot,
			                        String ManifestPatDir,
			                        String PatName, 
			                        String PatICN, 
			                        String PatSSN,
			                        String PatDOB,			                        
			                        String discl_date, 
			                        String discl_time);	
	
	static native public void displayPDFJobCompleted();
	
	static native public void displayAnnotatedJobCompleted();
	
	static native public String MakeAnnotatedFile(
			                     String JobID,
			                     String DebugMode,
			                     String ImageFileFullPath,
			                     String XMLFileFullPath,
			                     String OutputBurnedImageFullPath);
		*/
	/*
	public static void main(String[] args) throws Exception {
		
		System.out.println("Hello Jerry from Java");
	
		String ROI_Office_Name = "James A. Haley Veteran's Hospital, Tampa Florida";
		String JobID;
		
		String PatName;
		String PatICN;
		String PatSSN;
		String PatDOB;
		
		String manifestRoot = "C:\\work\\Patch130\\disclose\\manifest";
		String inputFileDir = "C:\\work\\Patch130\\disclose\\";	
		String DebugMode = "T";  //F = False, T=True
				
		JobID   = "Job12345";
		PatName = "Kashtan, Jerry";
		PatICN  = "123V9876";
		PatSSN = "*****1234";
		PatDOB = "08/22/12";
		disclose(JobID, DebugMode, ROI_Office_Name, PatName, PatICN, PatSSN, PatDOB, inputFileDir, manifestRoot);
		
	}
		
	private static void disclose(String JobID, 
			                     String DebugMode, 
			                     String ROI_Office_Name, 
			                     String Patname, 
			                     String PatICN, 
			                     String PatSSN,
			                     String PatDOB,		                     
			                     String inputFileDir, 
			                     String manifestRoot) 
	{
		ROIMakePDF HA = new ROIMakePDF();
		
		String ReturnCode;
		
		DateFormat dateFormat = new SimpleDateFormat("MMMM_dd_yyyy");
		DateFormat timeFormat = new SimpleDateFormat("kk_mm_ss");
		
		Date disc_date;
		Date disc_time;
		
		disc_date = new Date();
		disc_time = new Date();
		
		String manifestPatDir = Patname + "_" + PatICN + "_" + dateFormat.format(disc_date) + "_" + timeFormat.format(disc_time);
				
		//ReturnCode = HA.MakePdfDoc(
		ReturnCode = MakePdfDoc(
				JobID,
                DebugMode,
                ROI_Office_Name, 
                inputFileDir + JobID + ".txt", 
                manifestRoot,
                manifestPatDir,
                Patname,
                PatICN,
                PatSSN,
                PatDOB,                
                dateFormat.format(disc_date),
                timeFormat.format(disc_time));		
		
        System.out.println(JobID + " MakePdfDoc ReturnCode = " + ReturnCode);
        
		HA.displayHelloJerry();	
		
	}*/
		
}
