// Reconstructor.cpp: implementation of the Reconstructor class.
//
//////////////////////////////////////////////////////////////////////

/**********
Class Name: Reconstructor
Base Class: n/a
Author: William Peterson
Copyrighted @ 2001

Purpose: 
Performs the collaboration between the DICOM Object and the
	TagLines collection.  Reads information from the main() and
	dispenses to the proper objects.

Members:
m_obTagLine: TagLine Object representing a single line from the 
	TagLines collection.
m_colTagLines: Collection of TagLine(s).
m_obDICOMmessage: DICOMObject object.
m_cpInputFilename: Input DICOM filename to pass to DICOMObject.
m_cpOutputFilename: Output DICOM filename to pass to DICOMObject.
m_cpChangeFilename: Change text filename to pass to TagLines
	collection.

Changes:
wfp	10/2/2001	Class creation.
wfp 01/23/2002	First build for Development testing.
wfp 01/25/2002	Added additional comments.
wfp 06/21/2003  Improved code to better handle memory leaks.  There were
                some problems initially.
wfp 06/21/2003  Added Error-checking in mSetVRConvert function to make 
                sure it only attempts to convert Explicit VR Little Endian.
                Modified CHANGE keyword functionality. If element is not in
                header, do not error.  Simply call INSERT to add it.

**********/

#include "reconstruct.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

Reconstructor::Reconstructor()
{

}

Reconstructor::~Reconstructor()
{
	//need to manually empty the collection.  Then destroy the collection.
	POSITION rempos;

    //loop thru collection.
    for (rempos = m_colTagLines.GetHeadPosition (); rempos != NULL; rempos = m_colTagLines.GetHeadPosition())
    {
        m_obTagLine = (TagLine *)m_colTagLines.GetAt (rempos);
        //remove object pointer from collection first.
        m_colTagLines.RemoveAt (rempos);
        //the delete/destroy object.
        delete this->m_obTagLine;
    }
    m_colTagLines.RemoveAll ();	
}

signed int Reconstructor::ChangeTags(char *cpChgFile)
{
	signed int err;
	POSITION pos;
	int *action;
	USHORT *group;
	USHORT *element;
	char *vr;
	int *vm;
	char *data;
	char * errString;
	char * errInfo;
	signed int lasterr;

	//initialize
	action = (int *)malloc(sizeof(int));
	memset(action, 0, sizeof(int));
	data = (char *)malloc(512);
	memset(data, 0, 512);
	vm = (int *)malloc(sizeof(int));
	memset(vm, 0, sizeof(int));
	vr = (char *)malloc(3);
	memset(vr, 0, 3);
	element = (USHORT *)malloc(sizeof(USHORT));
	memset(element, 0, sizeof(USHORT));
	group = (USHORT *)malloc(sizeof(USHORT));
	memset(group, 0, sizeof(USHORT));
	err = SUCCESS;
	lasterr = SUCCESS;

	m_cpChangeFilename = cpChgFile;
	//read in the Change text file.
	//  this will load the TagLines collection automatically.
	if ((err = this->ReadChgFile(cpChgFile)) == SUCCESS)
	{

		//Setup loop to get each TagLine from collection
		if((pos = m_colTagLines.GetHeadPosition()) != NULL)
		{
			while (pos != NULL)
			{
				//get next TagLine from collection
				m_obTagLine = (TagLine *)m_colTagLines.GetNext(pos);
				m_obTagLine->GetTagLine(action, group, element, vr, vm, data);
				//and read Action
				//Setup case statement based on Action
				switch (*action)
				{
						//Insert VR Case:
				case (INSERT):
					//run InsertDCMTag method in DICOMObject
					//if other than success, set error and print. Set local error variable to True
					if((err = m_obDICOMMessage.InsertDCMTag (group, element, vr, vm, data)) != 0)
					{
						errInfo = "Failed to Insert DICOM Tag";
						errString = m_obError.CreateErrString(err, errInfo, group, element);
						m_obErrOut.PrintException(errString);
						free(errString);
					}
					break;
						//Change VR Case:
				case (CHANGE):
						//run ChangeDCMTag method in DICOMObject
						//if other than success, set error and print. Set local error variable to True
					if((err = m_obDICOMMessage.ChangeDCMTag (group, element, vr, vm, data)) != 0)
					{
                        //per Peter's request, if Tag does not exist, add it without error.
                        if(err == TAG_DOES_NOT_EXISTS)
                        {
                            if ((m_obDICOMMessage.InsertDCMTag (group, element, vr, vm, data)) != 0)
                            {
						        errInfo = "Failed to Change DICOM Tag";
						        errString = m_obError.CreateErrString(err, errInfo, group, element);
						        m_obErrOut.PrintException(errString);
						        free(errString);
                            }
                            else
                            {
                                err = SUCCESS;
                            }
                        }
                        else
                        {
                            errInfo = "Failed to Change DICOM Tag";
                            errString = m_obError.CreateErrString(err, errInfo, group, element);
                            m_obErrOut.PrintException(errString);
                            free(errString);
                        }
					}
					break;
						//Remove VR Case:
				case (REMOVE):
							//run RemoveDCMTag method in DICOMObject
							//if other than success, set error and print.  Set local error variable to True
					if((err = m_obDICOMMessage.RemoveDCMTag(group, element)) != 0)
					{
						errInfo = "Failes to Remove DICOM Tag";
						errString = m_obError.CreateErrString(err, errInfo, group, element);
						m_obErrOut.PrintException(errString);
						free(errString);
					}
					break;
				}
				//This If statement lets me keep track if the 
				// the error was other than Success at anytime during
				// the process of changing tags.  If so, I return the
				// last non-Success error.
				//Reason.  This allows me to cycle thru the entire 
				// collection before erroring out.  This allows
				// development to correct multiple lines in the change
				// file with a single pass.
				if (err != SUCCESS)
				{
					lasterr = err;
				}
				else
				{
					err = lasterr;
				}
			}
		}
		else
		{
			errString = m_obError.CreateErrString(OUT_OF_RESOURCES,NULL,0,0);
			m_obErrOut.PrintException(errString);
			free(errString);
		}
	}
	else
	{
		errInfo = m_cpChangeFilename;
		errString = m_obError.CreateErrString(err, errInfo, 0,0);
		m_obErrOut.PrintException(errString);
		free(errString);
	}
	free(action);
	free(data);
	free(vm);
	free(vr);
	free(element);
	free(group);
	return (err);
}

signed int Reconstructor::mSetVRConvert()
{
	signed int err;
	char * errString;
	char * errInfo;

	//run mConvertVREncoding method in DICOMObject
	//convert from Explicit VR to Implicit VR
	if ((err = m_obDICOMMessage.ConvertFFEncoding()) < 0)
	{
		errInfo = "Could not convert VR Encoding";
		errString = m_obError.CreateErrString(err, errInfo,0,0);
		m_obErrOut.PrintException(errString);
		free(errString);
	}
	return (err);
}

void Reconstructor::SetDCMFilenames(char *cpInputFile, char *cpOutputFile)
{
	//assign cpInputFile argument to cpInputFilename state
	this->m_cpInputFilename = cpInputFile;
	
	//assign cpOutputFile argument to m_cpOutputFilename state
	this->m_cpOutputFilename = cpOutputFile;
}

void Reconstructor::SetChangeFilename(char *cpChangeFile)
{
	//assign cpChangeFile argument to m_cpChangeFilename state
	this->m_cpChangeFilename = cpChangeFile;
}

signed int Reconstructor::ReadChgFile(char *cpChgFile)
{
	//initialize TagLine object only for this method
	FILE *fp;	//file pointer
	char *bp;	//buffer pointer
	char inputBuf[512];
	char *keyword;
	int lineNbr;
	int dindex;
	Parser parse;
	int action;
	USHORT group;
	USHORT element;
	char *vr;
	int vm;
	char *data;
	char *tempbp;	//temp buffer pointer
	int x;
	int parsedlen;
	char *p;
	int i;

	//initialize
	x = 0;
	vm = 0;
	parsedlen = 0;
	action = 0;


	//Check if valid file and open
	if((fp = fopen(cpChgFile,"rt")) == NULL)
	{
		return (CANNOT_OPEN_FILE);
	}
	lineNbr = 0;
	//Setup a loop to read each line
	while (fgets(inputBuf, sizeof(inputBuf), fp) != NULL)
	{
		lineNbr++;
		bp = parse.NonWhite (inputBuf);
		if ((*bp == '#') || (*bp == EOL))
		{
			continue;
		}
		if ((m_obTagLine = new TagLine) == NULL)
		{
			fclose (fp);
			return (OUT_OF_RESOURCES);
		}
		//allocate memory for keyword pointer.
		keyword = (char *)malloc(strlen(bp)+1);
		memset (keyword,0,sizeof(keyword));

		//assign each argument on the line component to the appriopate variable
		//get to the Action field
		bp = parse.NonWhite(bp);
		//parse Action field
		while (*bp != '|')
		{
			strncat(keyword, bp, 1);
			bp++;
			
		}

		//Turn all characters in string to uppercase.
		i = 0;
		for (p = keyword; p < keyword + strlen(keyword); p++)
		{
			keyword[i] = toupper(*p);
			i = i+1;
		}
		//assign proper action int value
		if (strcmp(keyword,"INSERT") == 0)
		{
			action = INSERT;
		}
		if (strcmp(keyword, "CHANGE") == 0)
		{
			action = CHANGE;
		}
		if (strcmp(keyword, "REMOVE") == 0)
		{
			action = REMOVE;
		}
		
		// Make sure an action was set.  If bogus keyword, error out.
		if (action == 0)
		{
			fclose (fp);
			free (keyword);
			delete this->m_obTagLine;
			return (CANNOT_PARSE_FILE);
		}

		//get to the group field
		bp = parse.NextPipe(bp);
		//bump pass the pipe
		bp++;
		//get word after pipe
		bp = parse.NextWord(bp);
		if((*bp) == EOL)
		{
			fclose (fp);
			free (keyword);
			delete this->m_obTagLine;
			return (CANNOT_PARSE_FILE);
		}
		
		//parse group out of line
		group = (USHORT)strtol(bp,NULL,16);
		if((group < 0x0000) || (group > 0x7fe0))
		{
			fclose (fp);
			free (keyword);
			delete this->m_obTagLine;
			return (CANNOT_PARSE_FILE);
		}
		//get to the element field
		bp = parse.NextComma(bp);
		//bump pass the comma
		bp++;
		bp = parse.NextWord (bp);
		if((*bp) == EOL)
		{
			fclose (fp);
			free (keyword);
			delete this->m_obTagLine;
			return (CANNOT_PARSE_FILE);
		}

		//parse element out of line
		element = (USHORT)strtol(bp,NULL,16);
		if((element < 0x0000) || (element > 0xffff))
		{
			fclose (fp);
			free (keyword);
			delete this->m_obTagLine;
			return (CANNOT_PARSE_FILE);
		}
		//get to the VR field
		bp = parse.NextPipe(bp);
		//bump pass the pipe
		bp++;
		bp = parse.NextCaret(bp);
		//bump pass the carat
		bp++;
		bp = parse.NextWord(bp);
		if ((*bp) == EOL)
		{
			fclose (fp);
			free (keyword);
			delete this->m_obTagLine;
			return (CANNOT_PARSE_FILE);
		}
		
		//parse VR out of line
		vr = (char *)malloc (3);
		memset (vr,0,3);
		for (x=0; x<2; x++)
		{
			strncat (vr, bp, 1);
			bp++;
		}

		//get to the VM field
		bp = parse.NextPipe(bp);
		//bump pass the pipe
		bp++;
		bp = parse.NextWord(bp);

		//parse VM out of line
		vm = strtol(bp,NULL,10);

		//get to the data field
		bp = parse.NextPipe(bp);
		//bump pass the pipe
		bp++;
		bp = parse.NextWord(bp);

		//parse data out of line
		parsedlen = parse.CountToEOL(bp);

		data = (char *)malloc(parsedlen+1);
		memset (data, 0, parsedlen+1);

		dindex = 0;
		while (*bp != EOL)
		{

			if ((*bp == SPACE) || (*bp == TAB))
			{
				tempbp = (char *)malloc(strlen(bp)+1);
				memset (tempbp, 0, strlen(bp)+1);
				strcpy (tempbp, bp);
				if (parse.IsNextWord(tempbp) == FALSE)
				{
					free(tempbp);
					//02212006	wfp	Fix Patch50 bug found during testing.
					//	Code was not properly handling space characters at the end of a string.
					//	The result was going into an infinite loop.  Used the wrong keyword.
					//	Using "continue" still kept me in the while loop.  Changed to "break".
					//continue;
					break;
					
				}
				free(tempbp);
			}
			*data++ = *bp++;
			dindex++;
		}
		data = data - dindex;
		//set states in TagLine	
		m_obTagLine->SetTagLine(action, group, element, vr, vm, data);
		//push line component into the collection
		m_colTagLines.AddTail(m_obTagLine);
		free(keyword);
		free(vr);
		//free(tempbp);
		free(data);
	} //end loop

	//close file
	fclose (fp);
	return (SUCCESS);
}



signed int Reconstructor::LoadDCMObject(char *cpInputFile)
{
	signed int err;
	char *errInfo;
	char *errString;
	USHORT *group;
	USHORT *element;

	//Load DICOM File into DICOM Object.
	err = this->m_obDICOMMessage.LoadDCMFile(cpInputFile);
	if(err != SUCCESS)
	{
		errInfo = "Could not load DICOM Object";
		group = 0;
		element = 0;
		errString = m_obError.CreateErrString(err, errInfo,group,element);
		m_obErrOut.PrintException(errString);
		free(errString);
	}
	return (err);
}

signed int Reconstructor::SaveDCMObject(char *cpOutputFile)
{
	signed int err;
	char *errInfo;
	char *errString;
	//Save DICOM Object to DICOM file.
	err = this->m_obDICOMMessage.SaveDCMFile(cpOutputFile);
	if(err != SUCCESS)
	{
		errInfo = "Could not save DICOM Object";
		errString = m_obError.CreateErrString(err, errInfo,0,0);
		m_obErrOut.PrintException(errString);
		free(errString);
	}
	return (err);
}

