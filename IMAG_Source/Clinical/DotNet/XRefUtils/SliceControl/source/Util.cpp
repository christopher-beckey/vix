/* 
+---------------------------------------------------------------+
| Property of the US Government.                                |
| No permission to copy or redistribute this software is given. |
| Use of unreleased versions of this software requires the user |
| to execute a written test agreement with the VistA Imaging    |
| Development Office of the Department of Veterans Affairs,     |
| telephone (301) 734-0100.                                     |
|                                                               |
| The Food and Drug Administration classifies this software as  |
| a medical device.  As such, it may not be changed in any way. |
| Modifications to this software may result in an adulterated   |
| medical device under 21CFR820, the use of which is considered |
| to be a violation of US Federal Statutes.                     |
+---------------------------------------------------------------+

DESCRIPTION:

HISTORY:

*/
// Util.cpp: implementation of the CUtil class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "util.h"
#include <math.h>
#include <sstream>

using namespace std;

FILE* CUtil::m_fStdOut = NULL;
HANDLE CUtil::m_hStdOut = NULL;

#import <scrrun.dll> raw_native_types raw_interfaces_only named_guids

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

//=============================================================================
// 
// CUtil::CUtil()
// 
// Purpose: constructor
// 
// Parameters: None
// 
// Returns: None
// 
// Notes: 
// PDL: 
//=============================================================================
CUtil::CUtil()
{
   
}

//=============================================================================
// 
// CUtil::~CUtil()
// 
// Purpose: destructor
// 
// Parameters: None
// 
// Returns: None
// 
// Notes: 
// PDL: 
//=============================================================================
CUtil::~CUtil()
{

}

//=============================================================================
// 
// CUtil::HexStringToHex()
// 
// Purpose: convert hex string to hex number
// 
// Parameters:  
// 	a_strHexString - hex string
//		a_bSuccess - if not null, will return the status of the conversion. This argument is optional for backward compatability
// Returns: long
// 
// Notes: //2004/08/17 Yunlai Sun change the implementation since the original implementaiton will parse "0008103e" as 0008105e
// PDL: 
//=============================================================================

long CUtil::HexStringToHex(LPCTSTR a_strHexString, BOOL* a_bSuccess)
{
   CString 
      strHexString(a_strHexString);
//the following code can not handle fffffff0
//   long 
//      res = 0;
//
//	std::istringstream iss((const char*)strHexString);
//	iss >> std::hex  >>res;	
//	if(iss.fail())
//	{
//		CString
//			strMsg;
//		strMsg.Format("Failed to extract hex number from %s", strHexString);
//		AfxMessageBox(strMsg);
//	}
	
	long 
		res2;
	int
		nResult = sscanf(strHexString, "%x", &res2);
	if (a_bSuccess) 
	{
		if (nResult == 1) 
		{
			*a_bSuccess = TRUE; 
		}
		else
		{
			*a_bSuccess = FALSE;
#ifdef _DEBUG
		CString
			strMsg;
		strMsg.Format("Failed to extract hex number from %s", strHexString);
		AfxMessageBox(strMsg, MB_OK|MB_TOPMOST);			
#endif
		}
	}

	return res2;
}


//=============================================================================
// 
// CUtil::CheckMinMax()
// 
// Purpose: 
// 
// Parameters:  
// 	a_fValue - 
// 	&a_fMin - 
// 	&a_fMax - 
// 
// Returns: None
// 
// Notes: 
// PDL: 
//=============================================================================
void CUtil::CheckMinMax(float a_fValue, float &a_fMin, float &a_fMax)
{
   if (a_fValue < a_fMin)
   {
      a_fMin = a_fValue;
   }

   if (a_fValue > a_fMax)
   {
      a_fMax = a_fValue;
   }
}

//=============================================================================
// 
// CUtil::Max()
// 
// Purpose: 
// 
// Parameters:  
// 	a_fValue1 - 
// 	a_fValue2 - 
// 	a_fValue3 - 
// 
// Returns: float
// 
// Notes: 
// PDL: 
//=============================================================================
float CUtil::Max(float a_fValue1, float a_fValue2, float a_fValue3)
{
   if (a_fValue1 > a_fValue2)
   {
      return (a_fValue1 > a_fValue3) ? a_fValue1 : a_fValue3;
   }
   else
   {
      return (a_fValue2 > a_fValue3) ? a_fValue2 : a_fValue3;
   }
}

long CUtil::NearestPrime(long a_nValue)
{
   long 
      i,
      n = a_nValue;
  
   /* Ensure we have a larger number and then force to odd.  */
   n++;  
   n |= 0x01; 

   /* All odd numbers < 9 are prime.  */
   if (n >= 9)
   {
      /* Otherwise find the next prime using a sieve.  */
next:
      for (i = 3; i * i <= n; i += 2)
      {
         if (n % i == 0)
         {
            n += 2;
            goto next;
         }
      }
   }

   return n;
}


void CUtil::FitRect1InsideRect2(CRect a_rect1, CRect a_rect2, CRect *a_prcResult)
{
   float
      fAspectRatio = (float) a_rect1.Width() / (float) a_rect1.Height(),
      fWidth = (float) a_rect2.Width(),
      fHeight = (float) a_rect2.Height();
   CRect
      rcResult;

   if ( (fWidth / fHeight) > fAspectRatio)
   {
      fWidth = fAspectRatio * fHeight;
   }
   else
   {
      fHeight = fWidth / fAspectRatio;
   }

   rcResult.left = a_rect2.left + (long) (((float) a_rect2.Width() - fWidth) / 2.0);
   rcResult.top = a_rect2.top + (long) (((float) a_rect2.Height() - fHeight) / 2.0);
   rcResult.right = rcResult.left + (long) fWidth;
   rcResult.bottom = rcResult.top + (long) fHeight;

   (*a_prcResult) = rcResult;
}

CStringParser::CStringParser()
{
	m_pAlloc		= NULL;
	m_argv			= NULL;
	m_argc			= 0;
}

CStringParser::~CStringParser()
{
	Empty();
}

void CStringParser::Empty()
{
	if ( m_pAlloc )
	{
		free( m_pAlloc );
		m_pAlloc		= NULL;
		m_argv			= NULL;
		m_argc			= 0;
	}
}

int CStringParser::Parse( LPCTSTR pszCmd, const CParseOptions& po )
{
	Empty();

	if ( pszCmd )
	{
		int         numargs;
		int         numchars;
		TCHAR*		pBuf;

		Parse( pszCmd, po, numargs, numchars );

		#ifndef NDEBUG 
		ASSERT( numargs > 0 );
		ASSERT( numchars >= 0 );
		_tprintf( _T("Count of args needed = %d\n"), numargs );
		_tprintf( _T("Count of chars needed = %d\n"), numchars );
		#endif // #ifndef NDEBUG

		m_pAlloc = (BYTE*)malloc( sizeof(TCHAR) * numchars + sizeof(TCHAR*) * numargs );
		if (!m_pAlloc) {
			::SetLastError(ERROR_OUTOFMEMORY);
			return( 0 );
		}

		m_argv	= (TCHAR**)m_pAlloc;
		pBuf	= (TCHAR*)( m_pAlloc  + ( sizeof(TCHAR*) * numargs ) );
		Parse( pszCmd, po, numargs, numchars, m_argv, pBuf );
		m_argc	= numargs - 1;

		#ifndef NDEBUG 
		ASSERT( numargs > 0 );
		_tprintf( _T("Count of args returned = %d\n"), numargs );
		_tprintf( _T("Count of chars returned = %d\n"), numchars );
		#endif // #ifndef NDEBUG
	}
    return( m_argc );
}

void CStringParser::Parse( LPCTSTR pszStr, const CParseOptions& po, int& numargs, int& numchars, TCHAR** argv, TCHAR* args )
{
    numchars	= 0;
    numargs		= 1;

	ASSERT( (argv == NULL && args == NULL) || (argv != NULL && args != NULL) );

    if ( NULL == pszStr || *pszStr == _T('\0') ) 
	{
        if ( argv ) argv[0] = NULL;
        return;
    }

    LPCTSTR         p			= pszStr;
    bool            bInQuote	= false;    /* true = inside quotes */
    bool            bCopyChar	= true;     /* true = copy char to *args */
	bool			bNeedArg	= false;	/* true = found delimiter and not gathering */
    unsigned        numslash	= 0;		/* num of backslashes seen */

	ASSERT( *p != _T('\0') );

	if ( po.IsQuoter( *p ) && p[1] != _T('\0') )
	{
		bInQuote = true;
		p++;
	}

    /* loop on each argument */
    for (;;) 
	{
        if (*p == _T('\0'))
		{
			if ( bNeedArg && !po.IsRTrim() )
			{
				/* scan an empty argument */
				if (argv)
					*argv++ = args;     /* store ptr to arg */
				++numargs;
				/* add an empty argument */
				if (args)
					*args++ = _T('\0');	/* terminate string */
				++numchars;
			}
			break;              /* end of args */
		}

        /* scan an argument */
        if (argv)
            *argv++ = args;     /* store ptr to arg */
        ++numargs;

        /* loop through scanning one argument */
        for (;;) 
		{     
			bCopyChar = true;
			numslash = 0;

			if ( po.IsEscape( *p )  )
			{
				/* 
				** Rules:	2N backslashes + " ==> N backslashes and begin/end quote
				**			2N+1 backslashes + " ==> N backslashes + literal "
                **			N backslashes ==> N backslashes 
				*/				
				/* count number of backslashes for use below */
				do { ++p; ++numslash; } while (*p == po.GetEscape());
			}
			
			if ( po.IsQuoter( *p ) ) 
			{
				/*
				** if 2N backslashes before, start/end quote, otherwise
				** copy literally 
				*/
				if (numslash % 2 == 0) 
				{
					if (bInQuote) 
					{
						if (p[1] == po.GetQuoter())
							p++;    /* Double quote inside quoted string */
						else        /* skip first quote char and copy second */
							bCopyChar = po.IsKeepQuote();
					} else
						bCopyChar = po.IsKeepQuote();       /* don't copy quote */
					bInQuote = !bInQuote;
				}
				numslash /= 2;          /* divide numslash by two */
			}

			/* copy slashes */
			while (numslash--) 
			{
				if (args)
					*args++ = po.GetEscape();
				++numchars;
			}

            /* if at end of arg, break loop */
            if ( *p == _T('\0') )
			{
                break;
			}

			if ( !bInQuote && *p == po.GetDelimiter() )
			{
				do
				{
					p++;
				} while ( po.IsGather() && *p == po.GetDelimiter() );
				bNeedArg = true;
				break;
			}

            /* copy character into argument */
            if (bCopyChar) 
			{
                if (args)
                    *args++ = *p;
                ++numchars;
            }
            ++p;

			bNeedArg = false;
        }

        /* null-terminate the argument */
        if (args)
            *args++ = _T('\0');          /* terminate string */
        ++numchars;
    }

    /* We put one last argument in -- a null ptr */
    if (argv)
        *argv++ = NULL;
}

#ifndef NDEBUG 
void CStringParser::Dump() const
{
	_tprintf( _T("Count of args = %d\n"), GetCount() );
	for ( int i = 0; i < GetCount(); i++ )
		_tprintf( _T("Arg[%d] = <%s>\n"), i, GetAt(i) );
}
#endif // #ifndef NDEBUG

CRect CUtil::ClipLine_LiangBarsky(CRect a_rect, CRect a_line)
{
   CRect
      rect;
   float 
      u1 = 0.0,
      u2 = 1.0;
   long  	
      p1 , q1 , p2 , q2 , p3 , q3 , p4 ,q4 ;
   float 
      r1 = 0.0, r2 = 0.0, r3 = 0.0, r4 = 0.0;

   p1 = - (a_line.right - a_line.left); 
   q1 = a_line.left - a_rect.left ;

   p2 = -p1; 
   q2 = a_rect.right - a_line.left ;

   p3 = - (a_line.bottom - a_line.top);
   q3 = a_line.top - a_rect.top;

   p4 = -p3;
   q4 = a_rect.bottom - a_line.top ;

   if ( ( ( p1 == 0.0 ) && ( q1 < 0.0 ) ) ||
        ( ( p2 == 0.0 ) && ( q2 < 0.0 ) ) ||
        ( ( p3 == 0.0 ) && ( q3 < 0.0 ) ) ||
        ( ( p4 == 0.0 ) && ( q4 < 0.0 ) ) )
   {
      /* reject line */
      rect.SetRectEmpty();
   }
   else
   {
      if (p1 != 0.0)
      {
         r1 = (float) q1 / p1 ;
         if (p1 < 0 )
         {
            u1 = max(r1, u1 );
         }
         else
         {
            u2 = min(r1, u2 );
         }
      }

      if (p2 != 0.0)
      {
         r2 = (float ) q2 / p2 ;

         if (p2 < 0)
         {
            u1 = max(r2, u1);
         }
         else
         {
            u2 = min(r2, u2);
         }
      }

      if (p3 != 0.0 )
      {
         r3 = (float) q3 / p3 ;

         if (p3 < 0)
         {
            u1 = max(r3, u1);
         }
         else
         {
            u2 = min(r3, u2);
         }
      }

      if (p4 != 0.0)
      {
         r4 = (float) q4 / p4 ;
         if (p4 < 0)
         {
            u1 = max(r4, u1);
         }
         else
         {
            u2 = min(r4, u2);
         }
      }

      if (u1 > u2)
      {
         /* line is rejected */
         rect.SetRectEmpty();
      }
      else
      {
         rect.left   = a_line.left + (long) (u1 * (float) a_line.Width());
         rect.top    = a_line.top + (long) (u1 * (float) a_line.Height());
         rect.right  = a_line.left + (long) (u2 * (float)  a_line.Width());
         rect.bottom = a_line.top + (long) (u2 * (float)  a_line.Height());
      }
   }
 
   return rect;
}


//the following code is cohen/Sutherland line clipping algorithm

void CUtil::encode(int xmin, int ymin, int xmax, int ymax, int x, int y, code c)
{
   c[LEFT] = (x < xmin);
   c[RIGHT] = (x > xmax);
   c[BOTTOM] = (y < ymin);
   c[TOP] = (y > ymax);
}

int CUtil::accept(code c1, code c2)
{
   int k;
   int result;

   // If either pt has any bit setin region code, solution not trivial

   result = true;
   for (k=LEFT; k<=TOP; ++k)
		if (c1[k] || c2[k])
			result = false;
   return result;
}

int CUtil::reject(code c1, code c2)
{
   int k;
   int result;

   // If endpoints have matching bits set, reject entire line

   result = false;
   for (k=LEFT;  k<=TOP; ++k)
		if (c1[k] && c2[k])
			result = true;
   return result;
}

void CUtil::swap_if_needed(int *x1, int *y1, int *x2, int *y2, code c1, code c2)
{

   // Ensures (x1,y1) is outside window and swaps coords and codes
   // if necessary

   int tempi;
   code tempc;
   int k;
   int inside;
   int i;

   inside = true;
   for (k=LEFT; k<=TOP; ++k)
		if (c1[k])
			inside = false;
   if (inside)        // (x1,y1) is inside window so swap
   {
      tempi = *x1;
      *x1 = *x2;
      *x2 = tempi;
      tempi = *y1;
      *y1 = *y2;
      *y2 = tempi;
      for (i=LEFT; i<=TOP; ++i)
      {
		 tempc[i] = c1[i];
		 c1[i] = c2[i];
		 c2[i] = tempc[i];
      }
   }
}

bool CUtil::cohen_clip_a_line(int xmin, int ymin, int xmax, int ymax,
	    int x1, int y1, int x2, int y2,int& new_x1, int& new_y1, int& new_x2, int& new_y2)
{

      code code1, code2;
      int done, display;
      double m;

      done = false;
      display = false;
      while (!done)
      {
         encode(xmin,ymin,xmax,ymax,x1,y1,code1);
         encode(xmin,ymin,xmax,ymax,x2,y2,code2);
		 if (accept(code1,code2))
		 {
			done = true;
			display = true;
		 }
		 else{
			if (reject(code1,code2))
			   done = true;
			else
			{  // Find intersection
			   swap_if_needed(&x1,&y1,&x2,&y2,code1,code2);
			   if (x1 != x2)
				  m = (double)(y1-y2)/(double)(x1-x2);
			   else
				  m = 1.0e38;
			   if (code1[LEFT])
			   {
				  y1 = (int)((y1 + (xmin - x1) * m) + 0.5);
				  x1 = xmin;
			   }
			   else if (code1[RIGHT])
			   {
				  y1 = (int)((y1 + (xmax - x1) * m) + 0.5);
				  x1 = xmax;
			   }
			   else if (code1[BOTTOM])
			   {
				  x1 = (int)((x1 + (ymin - y1) / m) + 0.5);
				  y1 = ymin;
			   }
			   else if (code1[TOP])
			   {
					x1 = (int)((x1 + (ymax - y1) / m) + 0.5);
					y1 = ymax;
			   }
			}
		 }
      }//end of while

      if (display)
	  {
		new_x1=x1;
		new_y1=y1;
		new_x2=x2;
		new_y2=y2;			
		return true;
	  }
	  return false;
}

void CUtil::GetApplicationPath(CString &a_strFolder)
{
   char 
      szFullPath[_MAX_PATH],
      szDrive[_MAX_DRIVE],
      szDir[_MAX_DIR],
      szFName[_MAX_FNAME],
      szExt[_MAX_EXT];

   GetModuleFileName(NULL, szFullPath, _MAX_PATH);

   _splitpath(szFullPath, szDrive, szDir, szFName, szExt);

   a_strFolder = szDrive;
   a_strFolder += szDir;
}

void CUtil::GetApplicationDataPath(CString &a_strFolder)
{
   char szPath[1024];

   SHGetFolderPath(NULL, CSIDL_COMMON_APPDATA, NULL, 0, szPath);

   a_strFolder.Format("%s\\%s\\", szPath, "VistA\\Imaging\\MAG_VistARad\\");
}

void CUtil::GetApplicationConfigPath(CString &a_strFolder)
{
   GetApplicationDataPath(a_strFolder);
   a_strFolder += "Config\\";
}

void CUtil::GetApplicationFullPath(CString &a_strAppFullPath)
{
   char 
      szFullPath[_MAX_PATH];

   GetModuleFileName(NULL, szFullPath, _MAX_PATH);
   
   a_strAppFullPath = szFullPath;
   
}

//////////////////////////////////////////////////////////////////////
// CTokenizer Class
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

#ifdef _USE_TOKENIZER
CTokenizer::CTokenizer(const CString& cs, const CString& csDelim):
	m_cs(cs),
	m_nCurPos(0)
{
	SetDelimiters(csDelim);
}

void CTokenizer::SetDelimiters(const CString& csDelim)
{
	for(int i = 0; i < csDelim.GetLength(); ++i)
		m_delim.set(static_cast<BYTE>(csDelim[i]));
}

bool CTokenizer::Next(CString& cs)
{
	cs.Empty();

	while(m_nCurPos < m_cs.GetLength() && m_delim[static_cast<BYTE>(m_cs[m_nCurPos])])
		++m_nCurPos;

	if(m_nCurPos >= m_cs.GetLength())
		return false;

	int nStartPos = m_nCurPos;
	while(m_nCurPos < m_cs.GetLength() && !m_delim[static_cast<BYTE>(m_cs[m_nCurPos])])
		++m_nCurPos;
	
	cs = m_cs.Mid(nStartPos, m_nCurPos - nStartPos);

	return true;
}

CString	CTokenizer::Tail() const
{
	int nCurPos = m_nCurPos;

	while(nCurPos < m_cs.GetLength() && m_delim[static_cast<BYTE>(m_cs[nCurPos])])
		++nCurPos;

	CString csResult;

	if(nCurPos < m_cs.GetLength())
		csResult = m_cs.Mid(nCurPos);

	return csResult;
}


#endif //_USE_TOKENIZER
HRESULT CVariantHelper::convertVecToSafeArray(QIPTRDISP_VEC *a_pQiptrDispVec, VARIANT *a_pDisps)
{
   HRESULT
   	result = S_OK;

   if (a_pQiptrDispVec->size() > 0) 
   {
      SAFEARRAYBOUND
         rgsa = {a_pQiptrDispVec->size(), 0};
      SAFEARRAY
         *psa = SafeArrayCreate(VT_DISPATCH, 1, &rgsa);
		if (psa == NULL) 
		{
			//::MessageBox(NULL, "SafeArrayCreate returns NULL", "Fatal Error", MB_OK|MB_TOPMOST);
			return E_FAIL;
		}

      long
         nIndex = 0;
      CComQIPtr<IDispatch>
   	   spDispatch;

      if (psa != NULL) 
      {
         QIPTRDISP_VEC::iterator
            iterArray = a_pQiptrDispVec->begin();

         while (iterArray != a_pQiptrDispVec->end()) 
         {
            spDispatch =  *iterArray;

            SafeArrayPutElement(psa, &nIndex, (IDispatch*) spDispatch);
            iterArray++, nIndex++;
         }

         a_pDisps->vt = VT_ARRAY | VT_DISPATCH;
         a_pDisps->parray = psa;

      }
      else
      {
         result = E_OUTOFMEMORY;
      }
   }
   else
   {
      a_pDisps->vt = VT_EMPTY;
   }
    
   return result;
}

HRESULT CVariantHelper::convertVecToSafeArray(SPTR_UNKN_VEC *a_pQiptrUnknVec, VARIANT *a_pDisps)
{
   HRESULT
   	result = S_OK;


   if (a_pQiptrUnknVec->size() > 0) 
   {
      SAFEARRAYBOUND
         rgsa = {a_pQiptrUnknVec->size(), 0};
      SAFEARRAY
         *psa = SafeArrayCreate(VT_UNKNOWN, 1, &rgsa);
     	if (psa == NULL) 
		{
			//::MessageBox(NULL, "SafeArrayCreate returns NULL", "Fatal Error", MB_OK|MB_TOPMOST);
			return E_FAIL;
		}

		long
         nIndex = 0;
      CComPtr<IUnknown>
   	   spUnkown;

      if (psa != NULL) 
      {
         SPTR_UNKN_VEC::iterator
            iterArray = a_pQiptrUnknVec->begin();

         while (iterArray != a_pQiptrUnknVec->end()) 
         {
            spUnkown =  *iterArray;

            SafeArrayPutElement(psa, &nIndex, (IUnknown*) spUnkown);
            iterArray++, nIndex++;
         }

         a_pDisps->vt = VT_ARRAY | VT_UNKNOWN;
         a_pDisps->parray = psa;

      }
      else
      {
         result = E_OUTOFMEMORY;
      }
   }
   else
   {
      a_pDisps->vt = VT_EMPTY;
   }
    
   return result;
}

HRESULT CVariantHelper::convertVecToSafeArray( SHORT_VEC* a_pShortVec, VARIANT *a_pShorts)
{
   HRESULT
   	result = S_OK;

   if (a_pShortVec->size() > 0) 
   {
      SAFEARRAYBOUND
         rgsa = {a_pShortVec->size(), 0};
      SAFEARRAY
         *psa = SafeArrayCreate(VT_I2, 1, &rgsa);
		if (psa == NULL) 
		{
			//::MessageBox(NULL, "SafeArrayCreate returns NULL", "Fatal Error", MB_OK|MB_TOPMOST);
			return E_FAIL;
		}

      long
         nIndex = 0;

      if (psa != NULL) 
      {
         SHORT_VEC::iterator
            iterArray = a_pShortVec->begin();

         while (iterArray != a_pShortVec->end()) 
         {
            SafeArrayPutElement(psa, &nIndex, &(*iterArray));
            iterArray++, nIndex++;
         }

         a_pShorts->vt = VT_ARRAY | VT_I2;
         a_pShorts->parray = psa;

      }
      else
      {
         result = E_OUTOFMEMORY;
      }
   }
   else
   {
      a_pShorts->vt = VT_EMPTY;
   }
    
   return result;
}

HRESULT CVariantHelper::convertVecToSafeArray( LONG_VEC* a_pShortVec, VARIANT *a_pShorts)
{
   HRESULT
   	result = S_OK;

   if (a_pShortVec->size() > 0) 
   {
      SAFEARRAYBOUND
         rgsa = {a_pShortVec->size(), 0};
      SAFEARRAY
         *psa = SafeArrayCreate(VT_I4, 1, &rgsa);
		if (psa == NULL) 
		{
			//::MessageBox(NULL, "SafeArrayCreate returns NULL", "Fatal Error", MB_OK|MB_TOPMOST);
			return E_FAIL;
		}

      long
         nIndex = 0;

      if (psa != NULL) 
      {
         LONG_VEC::iterator
            iterArray = a_pShortVec->begin();

         while (iterArray != a_pShortVec->end()) 
         {
            SafeArrayPutElement(psa, &nIndex, &(*iterArray));
            iterArray++, nIndex++;
         }

         a_pShorts->vt = VT_ARRAY | VT_I4;
         a_pShorts->parray = psa;

      }
      else
      {
         result = E_OUTOFMEMORY;
      }
   }
   else
   {
      a_pShorts->vt = VT_EMPTY;
   }
    
   return result;
}


HRESULT CVariantHelper::fillVecFromSafeArray(VARIANT a_vDispArray, QIPTRDISP_VEC *a_pQiptrDispVec)
{
   HRESULT
   	result = S_OK;
	if(a_vDispArray.vt != (VT_ARRAY|VT_DISPATCH))
		return E_INVALIDARG;
	
	LPDISPATCH*
		pDispArray;
	SafeArrayAccessData(a_vDispArray.parray, reinterpret_cast<void**>(&pDispArray));
	for(int nIndex=0; nIndex<a_vDispArray.parray->rgsabound->cElements; nIndex++)
	{
		CComQIPtr<IDispatch>
			qiptrDisp(pDispArray[nIndex]);
		a_pQiptrDispVec->push_back(qiptrDisp);
	} 
	SafeArrayUnaccessData(a_vDispArray.parray);
   return result;
}
HRESULT CVariantHelper::packStrArrayToVariant(/*[in]*/CStringArray& a_strArray, /*[out]*/VARIANT * a_pv)
{	int nSize = a_strArray.GetSize();

	VariantInit(a_pv);
	a_pv->vt = VT_ARRAY|VT_BSTR;

	SAFEARRAYBOUND bounds = { nSize, 0};
	a_pv->parray = SafeArrayCreate(VT_BSTR, 1, &bounds);
	if (a_pv->parray == NULL) 
	{
		//::MessageBox(NULL, "SafeArrayCreate returns NULL", "Fatal Error", MB_OK|MB_TOPMOST);
		return E_FAIL;
	}

	BSTR* bstrArray;
	SafeArrayAccessData(a_pv->parray, reinterpret_cast<void**>(&bstrArray));	
	for(int i=0;i<nSize; i++)
	{	bstrArray[i] = a_strArray.ElementAt(i).AllocSysString();
		//ATLTRACE("i is %d, 0x%x  \n", i, &(bstrArray[i]));
	}		
	SafeArrayUnaccessData(a_pv->parray);
	return S_OK;
}
HRESULT CVariantHelper::unpackVariantToStrArray(VARIANT a_v, /*[out]*/CStringArray& a_strArray)
{	USES_CONVERSION;
	if(a_v.vt == VT_EMPTY)
		return S_OK;

	if(a_v.vt != (VT_ARRAY|VT_BSTR))
		return E_INVALIDARG;
	a_strArray.RemoveAll();

	BSTR* bstrArray;
	SafeArrayAccessData(a_v.parray, reinterpret_cast<void**>(&bstrArray));	
	int nSize = a_v.parray->rgsabound->cElements;
	for(int i=0;i<nSize; i++)
	{	a_strArray.Add(OLE2T(bstrArray[i]));
	}		
	SafeArrayUnaccessData(a_v.parray);
	return S_OK;
}
HRESULT CVariantHelper::packStrSetToVariant(/*[in]*/STR_SET& a_strSet, /*[out]*/VARIANT * a_pv)
{	
	int 
		nSize = a_strSet.size();
	int 
		i = 0;
	USES_CONVERSION;

	VariantInit(a_pv);
	a_pv->vt = VT_ARRAY|VT_BSTR;

	SAFEARRAYBOUND bounds = { nSize, 0};
	a_pv->parray = SafeArrayCreate(VT_BSTR, 1, &bounds);
	if (a_pv->parray == NULL) 
	{
		//::MessageBox(NULL, "SafeArrayCreate returns NULL", "Fatal Error", MB_OK|MB_TOPMOST);
		return E_FAIL;
	}

	BSTR* bstrArray;
	SafeArrayAccessData(a_pv->parray, reinterpret_cast<void**>(&bstrArray));	
	
	for(STR_SET::iterator iter = a_strSet.begin();
		iter != a_strSet.end();
		iter ++)
	{
		bstrArray[i] = SysAllocString(T2OLE((iter->c_str())));
		i++;
	}		
	SafeArrayUnaccessData(a_pv->parray);
	return S_OK;
}
HRESULT CVariantHelper::unpackVariantToStrSet(VARIANT a_v, /*[out]*/STR_SET& a_strSet)
{	USES_CONVERSION;
	if(a_v.vt == VT_EMPTY)
		return S_OK;

	if(a_v.vt != (VT_ARRAY|VT_BSTR))
		return E_INVALIDARG;
	a_strSet.clear();

	BSTR* bstrArray;
	SafeArrayAccessData(a_v.parray, reinterpret_cast<void**>(&bstrArray));	
	int nSize = a_v.parray->rgsabound->cElements;
	for(int i=0;i<nSize; i++)
	{	a_strSet.insert(OLE2T(bstrArray[i]));
	}		
	SafeArrayUnaccessData(a_v.parray);
	return S_OK;
}

HRESULT CVariantHelper::packStrVecToVariant(/*[in]*/STR_VEC& a_strVec, /*[out]*/VARIANT * a_pv)
{
	int 
		nSize = a_strVec.size();
	int 
		i = 0;
	USES_CONVERSION;

	VariantInit(a_pv);
	a_pv->vt = VT_ARRAY|VT_BSTR;

	SAFEARRAYBOUND bounds = { nSize, 0};
	a_pv->parray = SafeArrayCreate(VT_BSTR, 1, &bounds);
	if (a_pv->parray == NULL) 
	{
		//::MessageBox(NULL, "SafeArrayCreate returns NULL", "Fatal Error", MB_OK|MB_TOPMOST);
		return E_FAIL;
	}

	BSTR* bstrArray;
	SafeArrayAccessData(a_pv->parray, reinterpret_cast<void**>(&bstrArray));	
	
	for(STR_VEC::iterator iter = a_strVec.begin();
		iter != a_strVec.end();
		iter ++)
	{
		bstrArray[i] = SysAllocString(T2OLE((iter->c_str())));
		i++;
	}		
	SafeArrayUnaccessData(a_pv->parray);
	return S_OK;
}

HRESULT CVariantHelper::unpackVariantToStrVec(VARIANT a_v, /*[out]*/STR_VEC& a_strVec)
{	USES_CONVERSION;
	if(a_v.vt == VT_EMPTY)
		return S_OK;

	if(a_v.vt != (VT_ARRAY|VT_BSTR))
		return E_INVALIDARG;
	a_strVec.clear();

	BSTR* bstrArray;
	SafeArrayAccessData(a_v.parray, reinterpret_cast<void**>(&bstrArray));	
	int nSize = a_v.parray->rgsabound->cElements;
	for(int i=0;i<nSize; i++)
	{	a_strVec.push_back(OLE2T(bstrArray[i]));
	}		
	SafeArrayUnaccessData(a_v.parray);
	return S_OK;
}
HRESULT CVariantHelper::fillVecFromSafeArray(VARIANT a_vShortArray, SHORT_VEC *a_pQiptrDispVec)
{
   HRESULT
   	result = S_OK;
	if(a_vShortArray.vt != (VT_ARRAY|VT_I2))
		return E_INVALIDARG;
	
	short*
		pShortArray;
	SafeArrayAccessData(a_vShortArray.parray, reinterpret_cast<void**>(&pShortArray));
	for(int nIndex=0; nIndex<a_vShortArray.parray->rgsabound->cElements; nIndex++)
	{
		a_pQiptrDispVec->push_back(pShortArray[nIndex]);
	} 
	SafeArrayUnaccessData(a_vShortArray.parray);
   return result;
}
/*===========================================================================*/
/* fillVecFromSafeArray 
 * This function converts a variant of VT_ARRAY | VT_I4 to a LONG_VEC
 * @param a_vLongArray input, array of long integers
 * @param a_pVec output vector
 *
 * @retval HRESULT
 */
/*===========================================================================*/
HRESULT CVariantHelper::fillVecFromSafeArray(VARIANT a_vLongArray, LONG_VEC *a_pVec)
{
   HRESULT
      result = S_OK;
   if(a_vLongArray.vt != (VT_ARRAY|VT_I4))
      return E_INVALIDARG;

   long*
      pLongtArray;
   SafeArrayAccessData(a_vLongArray.parray, reinterpret_cast<void**>(&pLongtArray));
   for(int nIndex=0; nIndex<a_vLongArray.parray->rgsabound->cElements; nIndex++)
   {
      a_pVec->push_back(pLongtArray[nIndex]);
   } 
   SafeArrayUnaccessData(a_vLongArray.parray);
   return result;
}

int ReverseFind(CString& a_str, CString a_strToSearch)
{
	int
		nRet = a_str.Find(a_strToSearch);
	int
		nLastFound = -1;
	while (nRet != -1) 
	{
		nLastFound = nRet;
		nRet = a_str.Find(a_strToSearch, nLastFound+1);
	}
	return nLastFound;
}

/*=ExactFind==================================================================*/
/*!
 * make sure that for the string to search, there is space or NULL after that
 * 
 * @param a_str 
 * @param a_strToSearch 
 * @param a_nStart 
 *
 * @retval int 
 */ 
/*============================================================================*/
int ExactFind(CString& a_str, CString a_strToSearch, int a_nStart)
{
	int
		nRet;
	int
		nLen = a_strToSearch.GetLength();
	int
		nFindStart = 0;
	if (a_nStart != 0) 
	{
		nFindStart = a_nStart;
	}

	do
	{
		nRet =  a_str.Find(a_strToSearch, nFindStart);
		CString
			strMid =	a_str.Mid(nRet, nLen+1); //just return nLen if it is the end of string
		if (strMid.GetLength() == nLen) 
		{	//end of string
			break;
		}
		
		char
			chLastInStrMid = strMid.GetAt(strMid.GetLength() -1 );
		if (chLastInStrMid=='\n' || chLastInStrMid=='\t' || chLastInStrMid==0xd)//carriage return 
		{
			break;
		}
		//nRet = a_str.Find(a_strToSearch, nLastFound+1);
		nFindStart = nRet + 1;
	}while (nRet != -1);
	return nRet;
}
int GetIndexInVec(QIPTRDISP_VEC& a_vec, LPDISPATCH a_disp)
{
	int
		nRet = -1;
	int nIndex = 0;
	for(QIPTRDISP_VEC::iterator iter = a_vec.begin();
		iter != a_vec.end();
		iter ++, nIndex ++)
	{
		if (iter->m_T == a_disp) 
		{
			nRet = nIndex;
			break;
		}
	}
	return nRet;
}
HRESULT CVariantHelper::fillVecFromSafeArray(VARIANT a_vDispArray, QIPTRDISP_LIST *a_pQiptrDispList)
{
   HRESULT
   	result = S_OK;
	if(a_vDispArray.vt != (VT_ARRAY|VT_DISPATCH))
		return E_INVALIDARG;
	
	LPDISPATCH*
		pDispArray;
	SafeArrayAccessData(a_vDispArray.parray, reinterpret_cast<void**>(&pDispArray));
	for(int nIndex=0; nIndex<a_vDispArray.parray->rgsabound->cElements; nIndex++)
	{
		CComQIPtr<IDispatch>
			qiptrDisp(pDispArray[nIndex]);
		a_pQiptrDispList->push_back(qiptrDisp);
	} 
	SafeArrayUnaccessData(a_vDispArray.parray);
   return result;
}

HRESULT CVariantHelper::convertVecToSafeArray(QIPTRDISP_LIST *a_pQiptrDispList, VARIANT *a_pDisps)
{
   HRESULT
   	result = S_OK;

   if (a_pQiptrDispList->size() > 0) 
   {
      SAFEARRAYBOUND
         rgsa = {a_pQiptrDispList->size(), 0};
      SAFEARRAY
         *psa = SafeArrayCreate(VT_DISPATCH, 1, &rgsa);
		if (psa == NULL) 
		{
			//::MessageBox(NULL, "SafeArrayCreate returns NULL", "Fatal Error", MB_OK|MB_TOPMOST);
			return E_FAIL;
		}

      long
         nIndex = 0;
      CComQIPtr<IDispatch>
   	   spDispatch;

      if (psa != NULL) 
      {
         QIPTRDISP_LIST::iterator
            iterArray = a_pQiptrDispList->begin();

         while (iterArray != a_pQiptrDispList->end()) 
         {
            spDispatch =  *iterArray;

            SafeArrayPutElement(psa, &nIndex, (IDispatch*) spDispatch);
            iterArray++, nIndex++;
         }

         a_pDisps->vt = VT_ARRAY | VT_DISPATCH;
         a_pDisps->parray = psa;

      }
      else
      {
         result = E_OUTOFMEMORY;
      }
   }
   else
   {
      a_pDisps->vt = VT_EMPTY;
   }
    
   return result;
}

HRESULT CUtil::CreateDirectoryStructure(LPCTSTR a_lpszPath)
{
   HRESULT
       result = S_OK;
   CString
      strPath = a_lpszPath,
      strSection,
      strDirPath;
   int 
      nSlash = -1,
      nIndex = 0,
      nCount = 0,
      nIsDrive = 0;
   DWORD
      dwAttrs = 0;

   strPath += "\\";

   do 
   {
      nSlash = strPath.Find("\\", nIndex);
      if (nSlash == -1) 
      { 
         break; 
      }

      strSection = strPath.Mid(nIndex, nSlash - nIndex );
      strSection += L"\\";
      strDirPath += strSection;

      nIsDrive = ::GetDriveType(strDirPath);
      if (nIsDrive == DRIVE_UNKNOWN || nIsDrive == DRIVE_NO_ROOT_DIR) 
      {
         BOOL
            bAttemptSucceeded = FALSE;

         dwAttrs = ::GetFileAttributes(strDirPath);
         if (dwAttrs == 0xffffffff)
         {
            if (::CreateDirectory(strDirPath, NULL) != 0) 
            {
               // directory created, jump to next one
               bAttemptSucceeded = TRUE;
            }
            else 
            {
               result = E_FAIL;
               break;
            }
         }

         if ( !bAttemptSucceeded && ( dwAttrs & FILE_ATTRIBUTE_DIRECTORY ) ) 
         {
            // directory already found, jump to next one
            bAttemptSucceeded = TRUE;
         }

         if (!bAttemptSucceeded) 
         {
            result = E_FAIL;
            break;
         }
      }

      nCount ++;
      nIndex = nSlash + 1;
   }
   while (TRUE);

   return result;
}

BOOL CUtil::DoesFileExist(LPCTSTR a_lpszPath)
{
   CComQIPtr<Scripting::IFileSystem> 
      spFileSystem;
   
   spFileSystem.CoCreateInstance(Scripting::CLSID_FileSystemObject);      
   if (spFileSystem) 
   {
      VARIANT_BOOL
         bRet = VARIANT_FALSE;

      spFileSystem->FileExists(_bstr_t(a_lpszPath), &bRet);

      return (bRet == VARIANT_TRUE);
   }

   return FALSE;
}
