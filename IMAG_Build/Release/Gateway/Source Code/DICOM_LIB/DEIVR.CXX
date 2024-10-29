/*
19990318    ljz    Added 'DICOMObject::DeleteVR'
20001106    mvh    Used delete [] operator for vr->Data
20010426    ljz    Fixed small leaks in 'DICOMObject::DeleteVR'
*/


/****************************************************************************
          Copyright (C) 1995, University of California, Davis

          THIS SOFTWARE IS MADE AVAILABLE, AS IS, AND THE UNIVERSITY
          OF CALIFORNIA DOES NOT MAKE ANY WARRANTY ABOUT THE SOFTWARE, ITS
          PERFORMANCE, ITS MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
          USE, FREEDOM FROM ANY COMPUTER DISEASES OR ITS CONFORMITY TO ANY
          SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND PERFORMANCE OF
          THE SOFTWARE IS WITH THE USER.

          Copyright of the software and supporting documentation is
          owned by the University of California, and free access
          is hereby granted as a license to use this software, copy this
          software and prepare derivative works based upon this software.
          However, any distribution of this software source code or
          supporting documentation or derivative works (source code and
          supporting documentation) must include this copyright notice.
****************************************************************************/

/***************************************************************************
 *
 * University of California, Davis
 * UCDMC DICOM Network Transport Libraries
 * Version 0.1 Beta
 *
 * Technical Contact: mhoskin@ucdavis.edu
 *
 ***************************************************************************/

#	include	"dicom.hpp"
//#	include	"mini.hpp"

/********************************
 *
 * Base VR Type
 *
 ********************************/
VR	::	VR(UINT16 g, UINT16 e, UINT32 l, BOOL	Alloc)
	{
	BYTE	*bptr = NULL;
	BOOL	cLast = FALSE;

	if ( l & 0x01 )
		{
		++l;
		cLast = TRUE;
		}


	Group = g;
	Element = e;
	Length = l;
	if(Alloc)
		Data = new BYTE [ Length ];
	else
		Data = NULL;

	if ( cLast )
		{
		bptr = (BYTE*)Data;
		bptr[Length-1] = '\0';
		}
	ReleaseMemory = TRUE;
	SQObjectArray = NULL;
	TypeCode = 0;
	Valid = FALSE;
	}

VR	::	VR(UINT16 g, UINT16 e, UINT32 l, void	*d)
	{
	BYTE	*bptr = NULL;
	BOOL	cLast = FALSE;

/*	if ( l & 0x01 )
		{
		++l;
		cLast = TRUE;
		}*/

	Group = g;
	Element = e;
	Length = l;
//	if(Length&1)
//		++Length;
	Data = d;
	if ( cLast )
		{
		bptr = (BYTE*)Data;
		bptr[Length-1] = '\0';
		}
	ReleaseMemory = TRUE;
	SQObjectArray = NULL;
	TypeCode = 0;
	Valid = FALSE;
	}

VR	::	VR(UINT16 g, UINT16 e, UINT32 l, void	*d, BOOL	mFlag)
	{
	BYTE	*bptr = NULL;
	BOOL	cLast = FALSE;

/*	if ( l & 0x01 )
		{
		++l;
		cLast = TRUE;
		}*/

	Group = g;
	Element = e;
	Length = l;
//	if(Length&1)
//		++Length;
	Data = d;
	if ( cLast )
		{
		bptr = (BYTE*)Data;
		bptr[Length-1] = '\0';
		}
	ReleaseMemory = mFlag;
	SQObjectArray = NULL;
	TypeCode = 0;
	Valid = FALSE;
	}

VR	::	~VR()
	{
	Array<DICOMObject	*>	*ArrayDO;
/*
	printf("~VR()\n\tGroup = %4.4x Element = %4.4x Data = %x Length = %d\n",
		Group, Element, Data, Length);
	printf("\tReleasememory = %d, SQObjectArray = %x, RID = %x Valid = %d\n",
		ReleaseMemory, SQObjectArray, ReferentialIntegrityDatabase, Valid);
	fflush(stdout);
*/
	if(ReleaseMemory)
		if(Data)
			delete [] Data;
	if(SQObjectArray)
		{
		ArrayDO = (Array<DICOMObject *> *) SQObjectArray;
		while(ArrayDO->GetSize())
			{
			delete ArrayDO->Get(0);
			ArrayDO->RemoveAt(0);
			}
		delete ArrayDO;
		SQObjectArray = NULL;
		}
		
	}


UINT	VR	::	operator	>	(VR	&vr)
	{
	if(Group > vr.Group)
		return ( 1 );
	if(Group == vr.Group)
		{
		if(Element > vr.Element)
			return ( 1 );
		}
	return ( 0 );
	}

UINT	VR	::	operator	<	(VR	&vr)
	{
	if(Group < vr.Group)
		return ( 1 );
	if(Group == vr.Group)
		{
		if(Element < vr.Element)
			return ( 1 );
		}
	return ( 0 );
	}

UINT	VR	::	operator	==	(VR	&vr)
	{
	if(Group == vr.Group)
	if(Element == vr.Element)
			return ( 1 );
	return ( 0 );
	}

/*****************************************************
 *
 * VR Group P-Queues
 *
 *****************************************************/

BOOL	VRGroupPQueue	::	Push(VR	*vr)
	{
//	printf("[VRGroupPQueue : Push(%x)]\n", vr);
	if(vr->Group!=Group)
		return ( FALSE );
	Length += vr->Length + sizeof(UINT16) + sizeof(UINT16) + sizeof(UINT32);
	if(vr->Length&0x01)
		++Length;	// Transfer Syntax Encodeder will +1 here
	PQueueOfPtr<VR *> :: Push ( vr );
	return ( TRUE );
	}

VR	*	VRGroupPQueue	::	Pop()
	{
	VR	*tv;

//	printf("[VRGroupPQueue : Pop()]\n");
	if ( !PQueueOfPtr<VR *> :: GetSize())
		return ( (VR *) NULL );
	tv = PQueueOfPtr<VR *> :: Pop ();
	if(!tv)
		return ( tv );
	Length -= (tv->Length + sizeof(UINT16) + sizeof(UINT16) + sizeof(UINT32));
	if(tv->Length&0x01)
		--Length;	// See Push
	return ( tv );
	}

VR	*	VRGroupPQueue	::	GroupLength()
	{
	LE_UINT32	*puint32;

	Element0 = new VR ( Group, 0x0000, 4, TRUE);
	if(!Element0)
		return ( NULL );
	puint32 = (LE_UINT32 *) Element0->Data;
	(*puint32) = (LE_UINT32) Length;// + sizeof(UINT16) + sizeof(UINT16) + sizeof(UINT32) + sizeof(UINT32);
	Element0->TypeCode = 'UL';
	return ( Element0 );
	}

UINT	VRGroupPQueue	::	operator	>	(VRGroupPQueue	&vrgroup)
	{
	if(Group > vrgroup.Group)
		return ( 1 );
	return ( 0 );
	}

UINT	VRGroupPQueue	::	operator	<	(VRGroupPQueue	&vrgroup)
	{
	if(Group < vrgroup.Group)
		return ( 1 );
	return ( 0 );
	}

UINT	VRGroupPQueue	::	operator	==	(VRGroupPQueue	&vrgroup)
	{
	if(Group == vrgroup.Group)
		return ( 1 );
	return ( 0 );
	}

/*****************************************************
 *
 * DICOM Objects
 *
 *****************************************************/

DICOMObject	::	DICOMObject()
	{
	Packaged = FALSE;
	Length = 0;
	VRGroupPQueues.ClearType = FALSE;
	SQObjectArray = NULL;
	LastVR = NULL;
	LastVRG = NULL;
	FreeSQObjectSize = 0;
	AutoMakeDO = NULL;
	FixedSize = 0;
	UseFixedSize = FALSE;
	}
	
DICOMObject	::	~DICOMObject()
 	{
	VR	*VRPtr;

	if ( !Packaged)
		if ( !Package() )
			return;

	if ( Packaged )
		{
		while ( VRPtr = this->Pop())
			delete VRPtr;
		return;
		}
	while ( VRGroupPQueues.GetSize() )
		VRGroupPQueues.RemoveAt(0);
	}

BOOL	DICOMObject	::	Push(DICOMObject	*SQDO)
	{
	Array<DICOMObject *>	*ArrayPtr;

	if ( Packaged )
		return ( FALSE );
	if ( ! LastVR )
		{
		return ( FALSE );	// not-supported yet
		if (!SQObjectArray)
			{
			SQObjectArray = new Array<DICOMObject *>;
			if ( !SQObjectArray )
				return ( FALSE );
			}
		SQObjectArray->Add ( SQDO );
		FreeSQObjectSize += SQDO->Length;
		return ( TRUE );
		}
	if (!LastVR->SQObjectArray)
		{
		ArrayPtr = new Array<DICOMObject *>;
		if (!ArrayPtr)
			return ( FALSE );
		LastVR->SQObjectArray = (void *) ArrayPtr;
		// "new sequence"
		LastVRG->Length += (2 * (sizeof(UINT16) + sizeof(UINT16) +
						sizeof(UINT32) ));
		Length += (2 * (sizeof(UINT16) + sizeof(UINT16) +
						sizeof(UINT32) ));
		}
	ArrayPtr = (Array<DICOMObject *> *) LastVR->SQObjectArray;
	ArrayPtr->Add ( SQDO );	
	LastVRG->Length += SQDO->Length + 
			(2 * (sizeof(UINT16) + sizeof(UINT16) + sizeof(UINT32)));
	Length += SQDO->Length + 
			(2 * (sizeof(UINT16) + sizeof(UINT16) + sizeof(UINT32)));
	return ( TRUE );
	}

BOOL	DICOMObject	::	Push(VR	*vr)
	{
	UINT			Index;
 	VRGroupPQueue	*VRGroupPQueuePtr;
	BOOL			rBOOL;

//	printf("[Push]\n");
	if ( Packaged )
		return ( FALSE );	// already Pop() from this object

	if(vr->Length == 0xffffffff)
		{
//		fprintf(stdout, "Attemping to push -1 length\n");
		vr->Length = 0;
		}
	if(AutoMakeDO)
		{
		rBOOL = AutoMakeDO->Push ( vr );
		if ( rBOOL )
			LastVRG->Length += vr->Length + sizeof(UINT16) +
						sizeof(UINT16) + sizeof(UINT32);
		return ( rBOOL );
		}

	Index = 0;
	if(vr->Element == 0x0000)
		{
//		fprintf(stderr, "Attemping to push GLC: %d\n",
//			(*((UINT32 *) vr->Data)));
		delete vr;
		return ( TRUE );	// ignore Group Length Codes (auto calculated)
		}
	LastVR = vr;
	if(LastVRG)
		if(LastVRG->Group == vr->Group)
			{
			Length += vr->Length + sizeof(UINT16) + sizeof(UINT16) +
						sizeof(UINT32);
			if(vr->Length&0x01)
				++Length;
			return ( LastVRG->Push ( vr ));
			}
//	printf("[VRGroupPQueues.GetSize() : %d]\n", VRGroupPQueues.GetSize());
	while ( Index < VRGroupPQueues.GetSize())
		{
		VRGroupPQueuePtr = VRGroupPQueues.Get(Index);
		if(!VRGroupPQueuePtr)
			return ( FALSE );
		if(VRGroupPQueuePtr->Group == vr->Group)
			{
			LastVRG = VRGroupPQueuePtr;
			Length += vr->Length + sizeof(UINT16) + sizeof(UINT16) +
						sizeof(UINT32);
			if(vr->Length&0x01)
				++Length;
//			printf("[VRGroupPQueuePtr->Group : %d]\n", VRGroupPQueuePtr->Group);
			return ( VRGroupPQueuePtr->Push ( vr ));
			}
		++Index;
		}

	VRGroupPQueuePtr = new VRGroupPQueue(vr->Group);
	if(!VRGroupPQueuePtr)
		return ( FALSE );

	Length += sizeof(UINT16) + sizeof(UINT16) + sizeof(UINT32) +
			sizeof(UINT32);
	Length += vr->Length + sizeof(UINT16) + sizeof(UINT16) +
			sizeof(UINT32);
	if(vr->Length&0x01)
		++Length;
	LastVRG = VRGroupPQueuePtr;	
//	printf("[VRGroupPQueues.Push]\n");
	VRGroupPQueues.Add(VRGroupPQueuePtr);
	return ( VRGroupPQueuePtr->Push(vr) );
	}

VR	*	DICOMObject	::	Pop()
	{
	VR	*VRPtr;

	//return ( (VR *) NULL );

	if(!Packaged)
		if(!Package())
			return ( (VR *) NULL );
	if(!Packaged)
		return ( (VR *) NULL );

	if ( ! CurrentGroup )
		{
//		printf("[Pop : CurrentGroup = NULL]\n");
		if ( !PQueueOfPtr<VRGroupPQueue *>::GetSize())
			{
			Packaged = FALSE;
			LastVRG = NULL;
			LastVR = NULL;
			return ( (VR *) NULL );
			}
		CurrentGroup = PQueueOfPtr<VRGroupPQueue *>::Pop();
		if ( ! CurrentGroup )
			return ( (VR *) NULL );
		Length -= ( sizeof(UINT16) + sizeof(UINT16) + sizeof(UINT32) +
				sizeof(UINT32) );
	
		return ( CurrentGroup->GroupLength() );
		}
	if ( ! ( VRPtr = CurrentGroup->Pop() ) )
		{
		delete CurrentGroup;
		CurrentGroup = NULL;
		return ( this->Pop() );
		}
	Length -= (VRPtr->Length + sizeof(UINT16) + sizeof(UINT16) +
			sizeof(UINT32) );
	if(VRPtr->Length&0x01)
		--Length;	// See Push
	return ( VRPtr );
	}

// this needs to be replaced with a more efficient algorithm in the
// future, but it will do for now.
VR		*DICOMObject	::	GetVR(UINT16	g, UINT16	e)
	{
	VR				*vr;
	UINT			Index,Index2;
		VRGroupPQueue	*VRGroupPQueuePtr;

	Index = 0;

	while ( Index < VRGroupPQueues.GetSize())
		{
		VRGroupPQueuePtr = VRGroupPQueues.Get(Index);
		if(!VRGroupPQueuePtr)
			return ( FALSE );
		if(VRGroupPQueuePtr->Group == g)
			{
			Index2 = 0;
			while ( Index2 < VRGroupPQueuePtr->GetSize() )
				{
				vr = VRGroupPQueuePtr->Get(Index2);
				if(!vr)
					return ( 0 );
				if(vr->Element == e)
					{
					return ( vr );
					}
				++Index2;
				}
			return ( NULL );
			}
		++Index;
		}
	return ( NULL );
	}
		
	
LE_UINT16	DICOMObject	::	GetUINT16(UINT16	g, UINT16	e)
	{
	VR				*vr;
	//UINT			Index,Index2;
	//	VRGroupPQueue	*VRGroupPQueuePtr;
	LE_UINT16		Val;

	vr = this->GetVR ( g, e );
	if(!vr)
		return(0);
		
	if ( vr->Data )
		if(vr->Length == sizeof(UINT16))
			{
			memcpy(&Val, vr->Data, 2);
			return ( Val );
			}
	return ( 0 );
	}


BOOL	DICOMObject::DeleteVR(VR* pVR)
{
  VR*			vr;
  UINT			Index,Index2;
  VRGroupPQueue*	VRGroupPQueuePtr;

  if ( Packaged )
    return ( FALSE );	// already Pop() from this object
  /* Search the pVR */
  Index = 0;
  while ( Index < VRGroupPQueues.GetSize())
  { VRGroupPQueuePtr = VRGroupPQueues.Get(Index);
    if(!VRGroupPQueuePtr)
      return FALSE;
    if(VRGroupPQueuePtr->Group == pVR->Group)
    { Index2 = 0;
      while ( Index2 < VRGroupPQueuePtr->GetSize() )
      { vr = VRGroupPQueuePtr->Get(Index2);
	if(!vr)
	  return FALSE;
	if(vr->Element == pVR->Element)
	{ /* OK, the pVR has been found.
	     Remove from Array of VrPointers */
	  VRGroupPQueuePtr->RemoveAt(Index2);
	  VRGroupPQueuePtr->Length -= (pVR->Length + sizeof(UINT16) + sizeof(UINT16) +
			sizeof(UINT32) );
	  if (VRGroupPQueuePtr->Length & 0x01)
	    VRGroupPQueuePtr->Length--;
	  Length -= (pVR->Length + sizeof(UINT16) + sizeof(UINT16) +
			sizeof(UINT32) );
	  if (Length & 0x01)
	    Length--;
	  /* Maybe remove from Array of GroupPointers */
	  if (!VRGroupPQueuePtr->Length)
	  { VRGroupPQueues.RemoveAt(Index);
	    delete VRGroupPQueuePtr;		/* LJ: leak */
	    Length -= (sizeof(UINT16) + sizeof(UINT16) + sizeof(UINT32));
	  }
	  /* Get rid of the data */
	  vr->Reset();
	  delete vr;				/* LJ: leak */
	  return TRUE;
	}
	++Index2;
      }
      return FALSE;
    }
    ++Index;
  }
  return FALSE;
}


BOOL	DICOMObject	::	Reset()
	{
	VR	*vr;

	while ( vr = Pop() )
		delete vr;

	LastVRG = NULL;
	LastVR = NULL;

	return ( TRUE );
	}

BOOL	DICOMObject	::	Package()
	{
	UINT	Index;
	
	CurrentGroup = NULL;
	Index = 0;
//	printf("[start: Package()]\n");
	while ( Index < VRGroupPQueues.GetSize())
		{
		PQueueOfPtr<VRGroupPQueue *> :: Push (VRGroupPQueues.Get(Index) );
		++Index;
		}
	while ( VRGroupPQueues.GetSize() )
		VRGroupPQueues.RemoveAt(0);
		
//	printf("[Packaged : %d Groups]\n", Index);
	Packaged = TRUE;
	if ( Index )
		return ( TRUE );
	Packaged = FALSE;
	return ( FALSE );
	}

BOOL
VR	::	SetIf(
	VR	*vr)
	{
	Array<DICOMObject	*>	*ArrayDO;

	if(!vr)
		return ( FALSE );
	if(vr->Group==Group)
		if(vr->Element==Element)
			{
			if(ReleaseMemory)
				delete [] Data;
			if(SQObjectArray)
				{
				ArrayDO = (Array<DICOMObject *> *) SQObjectArray;
				while(ArrayDO->GetSize())
					{
					delete ArrayDO->Get(0);
					ArrayDO->RemoveAt(0);
					}
				delete ArrayDO;
				SQObjectArray = NULL;
				}
			Length = vr->Length;
			Data = vr->Data;
			SQObjectArray = vr->SQObjectArray;
			ReleaseMemory = vr->ReleaseMemory;
			vr->Data = NULL;
			vr->Length = 0;
			vr->SQObjectArray = NULL;
			vr->ReleaseMemory = FALSE;
			vr->Valid = TRUE;
			return ( TRUE );
			}
	return ( FALSE );
	}

BOOL
VR	::	Morph (
	DICOMObject	*DDO)
	{
	Array<DICOMObject	*>	*ArrayDO;

	if (!Length)
		if(!Valid)
			return ( FALSE );

	VR	*vr = new VR(Group, Element, 0, (BOOL) FALSE);
	vr->Length = Length;
	vr->Data = Data;
	vr->ReleaseMemory = ReleaseMemory;
	Length = 0;
	Data = NULL;
	ReleaseMemory = FALSE;
	DDO->Push(vr);

	if(SQObjectArray)
		{
		ArrayDO = (Array<DICOMObject *> *) SQObjectArray;
		while(ArrayDO->GetSize())
			{
			DDO->Push(ArrayDO->Get(0));
			ArrayDO->RemoveAt(0);
			}
		delete ArrayDO;
		SQObjectArray = NULL;
		}
	return ( TRUE );
	}

BOOL
VR	::	Reset ()
	{
	Array<DICOMObject	*>	*ArrayDO;

	if(ReleaseMemory)
		if(Data)
			delete [] Data;
	if(SQObjectArray)
		{
		ArrayDO = (Array<DICOMObject *> *) SQObjectArray;
		while(ArrayDO->GetSize())
			{
			delete ArrayDO->Get(0);
			ArrayDO->RemoveAt(0);
			}
		delete ArrayDO;
		SQObjectArray = NULL;
		}
	ReleaseMemory = FALSE;
	Data = NULL;
	Length = 0;
	return ( TRUE );
	}



