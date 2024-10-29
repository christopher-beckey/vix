#include <windows.h>
#include <string.h>
#include "gear.h"		/* Include for AccuSoft Image Gear */
#include "i_med.h"		/* Header for Medical Extension API	*/

#define NUM_ARGS	2
#define MAX_ABSTRACT_ROWS	    189
#define MAX_ABSTRACT_COLUMNS 	121


//***Variable Declaration
AT_MODE xfersyntax = MED_DCM_TS_AUTODETECT;

HIGEAR	hIGear = (HIGEAR)NULL;	//represents input image in memory
HIGEAR absGear = (HIGEAR)NULL;	//represents output abstract in memory

UINT	 loadPage = 1;	//only interested in first image of a multi-frame object
AT_LMODE 	saveType = IG_SAVE_JPG;	//save all images as JPEG


//***Methods declarations
int CreateAbstract();

int CALLBACK WinMain(
  _In_  HINSTANCE hInstance,
  _In_  HINSTANCE hPrevInstance,
  _In_  LPSTR lpCmdLine,
  _In_  int nCmdShow
)
{
	int ErrCode= 0;
	char * inputFile=lpCmdLine;
	char * p=strchr(lpCmdLine,' ');
	if (!p)
		return -1;
	*p=0;
	p++;
	char * outputFile=p;
    p=strchr(p,' ');
	if (p)
		*p=0;

	//MAKE SURE THE FILENAMES ARE NOT THE SAME
	if(_stricmp(inputFile, outputFile)){

		//INITIALIZE THE IMAGEGEAR ENVIROMENT
		char p[] = "Vista";
		char key[] = "1.0.RiRL10JLtjbIJZt2E9k2cLRmRvcsw9EmPIwmJFEvwswFE4wstD69b4wsPmPX727DC91Zn0CFkmz4JjwDt9b0PsJFn0CjCIzLR2zZtvwgbXc2zmCDA9tsc0tmA9zX6g7vnjcXnDJ9zj10Aj7mksEiw2AmcFbXJIALt4bI6mzFPinXcmngEDtR1ZzIkF1D1XnIcFwF6sw9zgbD64Cmzics6mkIcswFnm72c9Rgzj7ikD1gk26L1ZAZJI7vnDcsk0EZCXAZ7Lk4nF1InIn4P0wjCj19nDnZJD7sEXzscv7I7ZzZtX70ni6DnvAiz9EmzjPv6gCZCF1jCLzgw2JDkXE2tDc01FAj1itIz4626Un24";

		IG_lic_solution_name_set(p);
		IG_lic_solution_key_set( 0xBDFAA6FB,0x9D6555BA,0xD65F1910,0xA61FF100);
		IG_lic_OEM_license_key_set( key );
		ErrCode = IG_comm_comp_attach("MED");
		if(ErrCode == 0){
			//LOAD DICOM OBJECT INTO MEMORY
			ErrCode = MED_DCM_load_DICOM(inputFile, &hIGear, xfersyntax, loadPage);
			if(ErrCode == 0){
				if(IG_image_is_valid(hIGear)){
					//CREATE ACTUAL ABSTRACT IMAGE IN MEMORY
					ErrCode = CreateAbstract();
					if(ErrCode == 0){
						//SAVE ABSTRACT TO FILE AS JPEG
						ErrCode = IG_save_file(absGear, outputFile, saveType);
					}
				}
				else
					ErrCode = -1;
			}
		}
	}
	else
		ErrCode = -1;
	

	IG_image_delete(hIGear);
	IG_image_delete(absGear);

	return ErrCode;
}

int CreateAbstract(){
	AT_DIMENSION 	rows;
	AT_DIMENSION 	columns;
    AT_DIMENSION    w, h;
    UINT bpp;
	int ErrCode = 0;
	double factor;
	
	LONG wWidth, wCenter;
	DOUBLE rSlope, rIntercept;
	BOOL wFound=FALSE, rFound=FALSE;

	rows = MAX_ABSTRACT_ROWS;
	columns = MAX_ABSTRACT_COLUMNS;
	wWidth = 0;
	wCenter = 0;
	rSlope = 1.0;
	rIntercept = 0.0;
	factor = 0.0;
	w = 0;
	h = 0;
	bpp = 0;


	//Int nResDpi = 200;
	//IG_fltr_ctrl_set(IG_FORMAT_PDF, "RESOLUTION_X", (LPVOID)nResDpi, sizeof(nResDpi)); 
	//IG_fltr_ctrl_set(IG_FORMAT_PDF, "RESOLUTION_Y", (LPVOID)nResDpi, sizeof(nResDpi));
	//IG_vector_data_to_dib(hIGear, &hRaster);


	//get rows, columns, and, and bit depth.
	if(!IG_image_dimensions_get(hIGear, &w, &h, &bpp)){
		//Calculate best rows x columnns for the abstract image.
		if((w/MAX_ABSTRACT_ROWS) > (h/MAX_ABSTRACT_COLUMNS)){
			factor = (double)w/MAX_ABSTRACT_ROWS;
		}
		else{
			factor = (double)h/MAX_ABSTRACT_COLUMNS;
		}
		
		if(factor == 0){
			factor = 1;
		}

		rows = int(double(w)/factor);
		columns = int(double(h)/factor);
	}
	else{
		//If the rows and columns are not available, use default.
		rows = MAX_ABSTRACT_ROWS;
		columns = MAX_ABSTRACT_COLUMNS;
	}

	//get the Window Width and Center from the DICOM object.
	MED_DCM_DS_Window_Level_get(hIGear, &wWidth, &wCenter, &wFound);
	//get the Rescale Slope and Intercept from the DICOM object.
	MED_DCM_DS_Rescale_get(hIGear, &rSlope, &rIntercept, &rFound);
	
	//if Windows W/L values and Rescale values exist, apply both to the pixel data.
	if(wFound && rFound){
		ErrCode = MED_IP_contrast(hIGear, rSlope, rIntercept, wCenter, wWidth, 1.0);
	}
	//if Windows W/L values exist but Rescale values do not exist, apply Windows W/L to the pixel data.
	else if(wFound && (!rFound)){
		ErrCode = MED_IP_contrast(hIGear, 1.0, 0.0, wCenter, wWidth, 1.0);
	}
	//if Windows W/L values and Rescale values do not exist, automatically calculate Windows W/L values and 
	//	apply to pixel data.
	else if(!wFound){
		ErrCode = MED_IP_contrast_auto(hIGear, NULL, 1.0, 0.0, 1.0, 0, NULL, NULL);
	}
	
	ErrCode = IG_IP_thumbnail_create(hIGear, &absGear, rows, columns, IG_INTERPOLATION_NONE);

	return ErrCode;
}

