// DCMabstract.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

//***Variable Declaration
AT_MODE xfersyntax = MED_DCM_TS_AUTODETECT;

HIGEAR	hIGear = (HIGEAR)NULL;	//represents input image in memory
HIGEAR absGear = (HIGEAR)NULL;	//represents output abstract in memory

UINT	loadPage = 1;	//only interested in first image of a multi-frame object
AT_LMODE	saveType = IG_SAVE_JPG;	//save all images as JPEG
char* inputFile;
char* outputFile;


//***Methods declarations
void PrintUsage();
void ErrorExit(int);
int CreateAbstract();

int main(int argc, char* argv[])
{
	int ErrCode= 0;

	//CHECK ARGUMENTS PASSED
	//If no arguments, print usage.
	if ((argc-1) < NUM_ARGS){
		PrintUsage();
		return 0;
	}


	inputFile = argv[1];	//assign 1st argument to input file.
	outputFile = argv[2];	//assign 2nd argument to output file.


	//MAKE SURE THE FILENAMES ARE NOT THE SAME
	if(!stricmp(inputFile, outputFile)){
		cout<<"-1"<<endl;
		return 0;
	}


	//INITIALIZE THE IMAGEGEAR ENVIROMENT
	char p[] = "Vista";
	char key[] = "1.0.RiRL10JLtjbIJZt2E9k2cLRmRvcsw9EmPIwmJFEvwswFE4wstD69b4wsPmPX727DC91Zn0CFkmz4JjwDt9b0PsJFn0CjCIzLR2zZtvwgbXc2zmCDA9"
					"tsc0tmA9zX6g7vnjcXnDJ9zj10Aj7mksEiw2AmcFbXJIALt4bI6mzFPinXcmngEDtR1ZzIkF1D1XnIcFwF6sw9zgbD64Cmzics6mkIcsw"
					"Fnm72c9Rgzj7ikD1gk26L1ZAZJI7vnDcsk0EZCXAZ7Lk4nF1InIn4P0wjCj19nDnZJD7sEXzscv7I7ZzZtX70ni6DnvAiz9EmzjPv6gCZ"
					"CF1jCLzgw2JDkXE2tDc01FAj1itIz4626Un24";

	IG_lic_solution_name_set(p);
	IG_lic_solution_key_set( 3187320571,2640663994,3596556560,2787111168);
	IG_lic_OEM_license_key_set( key );

	//IG_lic_solution_name_set("AccuSoft 1-100-15");
	ErrCode = IG_comm_comp_attach("MED");
	if(ErrCode){
		cout<<ErrCode<<endl;
		return 0;
	}


	//LOAD DICOM OBJECT INTO MEMORY
	ErrCode = MED_DCM_load_DICOM(inputFile, &hIGear, xfersyntax, loadPage);
	if(ErrCode) ErrorExit(ErrCode);
	
	if(!IG_image_is_valid(hIGear)) ErrorExit(-1);
	

	//CREATE ACTUAL ABSTRACT IMAGE IN MEMORY
	ErrCode = CreateAbstract();
	if(ErrCode) ErrorExit(ErrCode);


	//SAVE ABSTRACT TO FILE AS JPEG
	ErrCode = IG_save_file(absGear, outputFile, saveType);
	if(ErrCode) ErrorExit(ErrCode);

	cout<<"0"<<endl;
	return 0;
}


int CreateAbstract(){
	AT_DIMENSION	rows;
	AT_DIMENSION	columns;
    AT_DIMENSION    w, h;
    UINT bpp;
	int ErrCode = 0;
	double factor;
	
	LONG wWidth, wCenter;
	DOUBLE rSlope, rIntercept;
	BOOL wFound, rFound;

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

		rows = (int) w/factor;
		columns = (int) h/factor;
	}
	else{
		//If the rows and columns are not available, use default.
		rows = MAX_ABSTRACT_ROWS;
		columns = MAX_ABSTRACT_COLUMNS;
	}

	//get the Window Width and Center from the DICOM object.
	ErrCode = MED_DCM_DS_Window_Level_get(hIGear, &wWidth, &wCenter, &wFound);
	//get the Rescale Slope and Intercept from the DICOM object.
	ErrCode = MED_DCM_DS_Rescale_get(hIGear, &rSlope, &rIntercept, &rFound);
	
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


void ErrorExit(int err){

	delete inputFile;
	delete outputFile;
	IG_image_delete(hIGear);
	IG_image_delete(absGear);

	cout<<err<<endl;
	exit(0);
}


void PrintUsage()
{
	cout <<"DICOM Abstract Maker "<<endl;
	cout <<endl;
	cout <<"MAG_DCMAbstract <input file> <output file> "<<endl;
	cout <<endl;
	cout <<"	Where,"<<endl;
	cout <<"<input file> is the input DICOM file,"<<endl;
	cout <<"<output file> is the new abstract file,"<<endl;
}

