// reconstruct.cpp : Defines the entry point for the console application.
//

//#include "stdafx.h"
#include "reconstruct.h"


int main(int argc, char* argv[])
{
	char *fileptr[3];
	bool bFFEncodeOption;
	Stdout prt;
	int i;

	bFFEncodeOption = FALSE;
	fileptr[2] = NULL;
	argv++;

	//If no arguments, print usage.
	if ((argc-1) < NUM_ARGS)
	{
		prt.PrintUsage();
		return(0);
	}
	
	Reconstructor obRC;

	i = 0;
	while (--argc)
	{
		//determine if switch.  If not, it must be a filename.
		if (**argv == '-')
		{
			switch (*++*argv)
			{
			case ('i'):
			case ('I'):
				//set variable to change file format from
				//Explicit VR to Implicit VR.
				bFFEncodeOption = TRUE;
				break;
			}
		}
		else
		{
			//Place filenames from arguments into fileptr array
			//Set DICOM filenames and optionally Change filename
			fileptr[i] = *argv;
		}
		//increment fileptr array.
		i++;
		//increment to next command line argument.
		argv++;
	}
	//Compare input and output.  If same, error out.
	if(fileptr[0] == fileptr[1])
	{
		cout<<"Input filename cannot be same as Output filename"<<endl;
		cout<<"-1"<<endl;
		return (0);
	}
	// Load DICOM Object from file.
	// Also load Data Dictionary file.
	if(obRC.LoadDCMObject(fileptr[0]) == SUCCESS)
	{
		//if change file exists, change tags.  If not, continue.
		if (fileptr[2] != NULL)
		{
			//if changing Tags not successful, return -1 and exit
			//All errors are less than 0.
			if ((obRC.ChangeTags(fileptr[2])) < 0 )
			{
				cout<<"-1"<<endl;
				return (0);
			}
		}	
			
		//if bFFEncodeOption is True, convert DICOM Object
		// from Explicit to Implicit VR.  If not, continue.
		if (bFFEncodeOption == TRUE)
		{
			if (obRC.mSetVRConvert() != SUCCESS)
            {
                cout<<"Cannot convert file"<<endl;
                cout<<"-1"<<endl;
                return (0);
            }
		}
		
		//Save DICOM Object to new file.  If not successful,
		//print -1 and exit.
		if (obRC.SaveDCMObject(fileptr[1]) != SUCCESS)
		{
			cout<<"Cannot save DICOM file"<<endl;
			cout<<"-1"<<endl;
			return (0);
		}
	}
	else
	{
		cout<<"Cannot load DICOM file"<<endl;
		cout<<"-1"<<endl;
		return (0);
	}
	//If made it this far, there must have been no errors during
	//course of processing.  Print 0 (Success) and exit.
	cout<<"0"<<endl;
    return (0);
}
