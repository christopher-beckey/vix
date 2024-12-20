/**********************************************************************
 *
 * Copyright 1994-1996 Aware, Inc.
 *
 * $Workfile: aw_j2k_dtypes.h $    $Revision: 1 $   
 * Last Modified: $Date: 11/04/10 10:17a $ by: $Author: Admin $
 *
 **********************************************************************/

#ifndef _DTYPES_H_
#define _DTYPES_H_
#ifndef Macintosh
static const char id_dtypes_h[] = "@(#) $Header: /Baseline/Source Code/MAG_Decompressor/aw_j2k_dtypes.h 1     11/04/10 10:17a Admin $ Aware Inc.";
#endif /* Macintosh */

#include <stdio.h>

#ifndef _WINDEF_
# define BOOL unsigned char
# define BYTE unsigned char
# define WORD unsigned short
# define DWORD unsigned long
#endif /* !_WINDEF_ */
#define SWORD short

/* some platforms don't have TRUE and FALSE */
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE !FALSE
#endif

#define FIXED32 long
#define FIXED16 short

typedef struct {
    void *user_data;
    int  (*TestAbortProc)          (void *user_data);
    void (*UpdateProgressProc)     (void *user_data);
    void (*SetProgressDoneProc)    (void *user_data, int done);
    void (*SetProgressTotalProc)   (void *user_data, int total);
    int  (*GetProgressDoneProc)    (void *user_data);
    void*(*AllocateMemory)         (void *user_data, size_t size);
    void (*FreeMemory)	           (void *user_data, void *ptr);
} AccuPressInterfaceSuite;

typedef AccuPressInterfaceSuite AccuRadInterfaceSuite;
typedef AccuPressInterfaceSuite AccuSatInterfaceSuite;

/* do not add anything beyond this line! */
#endif /* _DTYPES_H_ */
