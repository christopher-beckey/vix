// DICOMObject.cpp: implementation of the DICOMObject class.
//
//////////////////////////////////////////////////////////////////////

/**********
Class Name: DICOMObject
Base Class: n/a
Author: William Peterson
Copyrighted @ 2001

Purpose: 
Encapsulation of the DICOM toolkit.  This class handles all
	interfacing with DICOM ucDavis Toolkit.

Members:
m_obEnDDO: Actual DICOM Message Object.
m_iFFEncodeScheme: The file encoding of the input file as determined
	by the DICOM toolkit.
m_cpFilename:Holds state of DICOM filename accessed.

Changes:
wfp	10/2/2001	Class creation.
wfp 01/23/2002	Completed first build for Development testing.
wfp 01/25/2002	Added additional comments. 
wfp 06/21/2003  Added ability to Store VA Implementation Class and 
                Version in outgoing message. Requires version 1.0.1 of 
                the ucDavis Toolkit.
**********/

//#include "dicom.hpp"
#include "reconstruct.h"


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

EnDICOM::EnDICOM()
{
	m_iFFEncodeScheme = 0;
}

EnDICOM::~EnDICOM()
{
	if(this->m_obEnDDO)
	{
		delete this->m_obEnDDO;
	}
}

signed int EnDICOM::LoadDCMFile(char *cpDCMFile)
{
	//PDUServ is a class in this program.  It is inhierent
	// from PDUService class in ucdavis toolkit.
	//Reason I needed to modify method to return file format.
	PDUServ df;
	unsigned int *iInputFF;
	iInputFF = (unsigned int *)malloc(sizeof(unsigned int));

	//Check if valid file and open
	//if not, return proper error
	//determine input file format.
	//set iInputFileFormat state accordingly.
	//assign data in file to member DICOM Object.
	if((this->m_obEnDDO = (df.LoadDICOMDataObject(cpDCMFile, iInputFF))) == NULL)
	{
		free(iInputFF);
		return (CANNOT_OPEN_FILE);
	}

	this->m_iFFEncodeScheme = *iInputFF;
	
	//not necessary to close file using this dicom toolkit.
	//return success

	free(iInputFF);
	return (SUCCESS);

}

signed int EnDICOM::SaveDCMFile(char *cpDCMFile)
{
	PDUServ pf;
	unsigned int encode_vr;
    ImplementationClass IC;
    ImplementationVersion IV;

	encode_vr = this->m_iFFEncodeScheme;
    //Set the implementation Class and Version.
    IC.Set ((unsigned char *) IMPL_CLASS_UID);
    IV.Set ((unsigned char *) IMPL_VERSION_NAME);

    //Set Implementation Class and Version in the outgoing message.
    pf.SetImplementationClass (IC);
    pf.SetImplementationVersion (IV);

	//verify output file does not exists
	//if exist, return proper error
	//open file to write data
	//if cannot open, return error
	//copy member DICOM Object to output file.
	//if not, return proper error
	if(pf.SaveDICOMDataObject(cpDCMFile, encode_vr, this->m_obEnDDO) == FALSE)
	{
		return (CANNOT_SAVE_FILE);
	}

	//DICOM toolkit closes file automatically.
	//if all ok, return success
	return (SUCCESS);

}

signed int EnDICOM::ConvertFFEncoding()
{
	//if this has to be done at the time of writing the DICOM
	//  Object to disk, set a flag state and have it read
	//  when calling the mWriteDCMFile method.

    //make sure incoming file format is Explicit VR Little Endian.
    if (m_iFFEncodeScheme == EXPL_LITTLE_ENDIAN)
    {
	    //this->m_iFFEncodeScheme = iOutputFF;
		this->m_iFFEncodeScheme = IMPL_LITTLE_ENDIAN;
	    return (SUCCESS);
    }
    else
    {
        return (INVALID_FILETYPE);
    }
}

signed int EnDICOM::ChangeDCMTag(USHORT *ipDCMGroup, USHORT *ipDCMElement, char *cpDCMVR, int *ipDCMVM, char *cpDCMValue)
{
	VR *vr;
	VR *vrpop;
	DICOMDataObject *tempddo;
	bool isChanged;
	int errchange;

	errchange = SUCCESS;
	isChanged = FALSE;
	tempddo = new DICOMDataObject;

	//create new VR with method parameters.
	vr = new VR(*ipDCMGroup, *ipDCMElement, strlen(cpDCMValue), TRUE);
	//Loop thru DICOM Object.
	while (vrpop = m_obEnDDO->Pop())
	{
		//If VR exists, pop new VR onto temp DICOM Object
		// and delete popped VR from DICOM Object.
		//if VR does not exists, return proper error.
		if (*vrpop == *vr)
		{
			//if sequence, error out with proper error code.
			//Currently, the code can not add seqence VRs to
			// DICOM Object.
			if(!vr->SQObjectArray)
			{
				//***verify value meets the conditions of VR.
				//***if not, return proper error.

				//***verify value meets the conditions of VM.
				//***if not, return proper error.
		
				//If VM > 1, setup to place change value into proper position.
				//***need UL to perform this.
				vr->TypeCode = vrpop->TypeCode;
				memcpy(vr->Data, cpDCMValue, strlen(cpDCMValue));
				delete vrpop;
				vrpop = vr;
				tempddo->Push(vrpop);
				isChanged = TRUE;
			}
			else
			{
				errchange = SEQUENCE_TAG;
			}
		}
		else
		{	
			//if popped VR did not match new VR, push popped VR 
			// onto temp DICOM Object.
			tempddo->Push(vrpop);
		}
	}
	//copy temp DICOM Object to member DICOM Object.
	delete m_obEnDDO;
	m_obEnDDO = tempddo;

	//If VR is not a sequence and did not exists, return this error.
	if(errchange != SEQUENCE_TAG)
	{
		if(isChanged == FALSE)
		{
			errchange = TAG_DOES_NOT_EXISTS;
            //de-allocate memory if not used in new DICOM Object.
            delete vr;
		}
	}
	
	//return error
	return (errchange);

}

signed int EnDICOM::RemoveDCMTag(USHORT *ipDCMGroup, USHORT *ipDCMElement)
{
	USHORT group;
	USHORT element;
	VR *vr;
	DICOMDataObject *tempddo;
	int errremove;

	errremove = SUCCESS;
	//break DCMTag into a group and element local variable
	group = *ipDCMGroup;
	element = *ipDCMElement;
	tempddo = new DICOMDataObject;

	//loop thru m_obEnDDO and copy all VRs to temp DICOM Object.
	while (vr = m_obEnDDO->Pop())
	{
		//Find matching VR.
		if((vr->Group == group) && (vr->Element == element))
		{
			//***find out if tag is Type 1
			//***if type 1, return proper error.
			//If VR is a sequence, return error.
			if(!vr->SQObjectArray)
			{
				delete vr;
				continue;
				errremove = SEQUENCE_TAG;
			}
		}
		//If no match, push VR onto temp DICOM Object.
		tempddo->Push(vr);
	}
	//Re-assign temp DICOM Object back to member DICOM Object.
	delete m_obEnDDO;
	m_obEnDDO = tempddo;
	//return success
	return (errremove);
	
}

signed int EnDICOM::InsertDCMTag(USHORT *ipDCMGroup, USHORT *ipDCMElement, char *cpDCMVR, int *ipDCMVM, char *cpDCMValue)
{
	VR *vr;
	bool errnbr;
	unsigned short vrType;

	errnbr = TRUE;
	vrType = 0;

	//get DICOM Object VR by matching group/element 
	// from method parameters.
	vr = m_obEnDDO->GetVR(*ipDCMGroup, *ipDCMElement);
	//if tag does exists, return proper error.  I do not want to
	//insert if VR already exists.
	if (vr)
	{
		return (TAG_ALREADY_EXISTS);
	}
			
	//***verify value meets the conditions of VR.
	//***if not, return proper error.
	//Generate TypeCode integer for member in VR object.
	errnbr = PackVR(cpDCMVR[0], cpDCMVR[1], vrType);
	//Make sure VR is not a sequence. If so, exit with error.
	if(vrType != 'SQ')
	{
		//if all ok, push changes into DICOM Object
		//Create new VR with method parameters.
		vr = new VR(*ipDCMGroup, *ipDCMElement,strlen(cpDCMValue),TRUE);
		vr->TypeCode = vrType;
		memcpy(vr->Data, (void *)cpDCMValue, strlen(cpDCMValue));
		//Push VR onto member DICOM Object.
		m_obEnDDO->Push(vr);
	}
	else
	{
		//return failure
		return(SEQUENCE_TAG);
	}
	//return success
	return (SUCCESS);
}

bool EnDICOM :: PackVR(unsigned char	c1,unsigned char c2,unsigned short &u1)
{
	//Utility to create integer TypeCode from 2 BTYE characters.
	if('OB'==20290)
		u1 = (((unsigned short)c1)<<8)+((unsigned short)c2);
	else
		u1 = (((unsigned short)c2)<<8)+((unsigned short)c1);

	return ( TRUE );
}


int EnDICOM::PrintElement()
{
//	VR *vrpop;
//	while (vrpop = m_obEnDDO->Pop())
//	{
//			//if sequence, error out with proper error code.
//			//Currently, the code can not add seqence VRs to
//			// DICOM Object.
//			if(!vrpop->SQObjectArray)
//			{
//				
//				//sprintf("%4x %4x //// %i //// %s",
//				vrpop->TypeCode;
//				memcpy(vrpop->Data, cpDCMValue, strlen(cpDCMValue));
//				delete vrpop;
//			}
//			else
//			{
//				errprint = SEQUENCE_TAG;
//			}
//	}
//
//
//
	return 0;
}
