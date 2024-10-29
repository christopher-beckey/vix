//Per VHA Directive 2004-038, this routine should not be modified.
// +---------------------------------------------------------------+
// | Property of the US Government.                                |
// | No permission to copy or redistribute this software is given. |
// | Use of unreleased versions of this software requires the user |
// | to execute a written test agreement with the VistA Imaging    |
// | Development Office of the Department of Veterans Affairs,     |
// | telephone (301) 734-0100.                                     |
// |                                                               |
// | The Food and Drug Administration classifies this software as  |
// | a medical device.  As such, it may not be changed in any way. |
// | Modifications to this software may result in an adulterated   |
// | medical device under 21CFR820, the use of which is considered |
// | to be a violation of US Federal Statutes.                     |
// +---------------------------------------------------------------+
// 
// 

// util.h: interface for the CUtil class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_UTIL_H__27FC5653_7039_11D5_B6CE_000021015B32__INCLUDED_)
#define AFX_UTIL_H__27FC5653_7039_11D5_B6CE_000021015B32__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define TOLERANCE 0.0005// about e-7.6	//for comparison in float and double calculation 

#define LEFT 0//for cohen line clipping function
#define RIGHT 1
#define BOTTOM 2
#define TOP 3
typedef int code[4];
class CUtil  
{
public:
	static BOOL DoesFileExist(LPCTSTR a_lpszPath);
	static HRESULT CreateDirectoryStructure(LPCTSTR a_lpszPath);
	static void GetApplicationPath(CString& a_strFolder);
   static void GetApplicationDataPath(CString& a_strFolder);
   static void GetApplicationConfigPath(CString &a_strFolder);
   static void GetApplicationFullPath(CString &a_strAppFullPath);
	static float Max(float a_fValue1, float a_fValue2, float a_fValue3);
	static void CheckMinMax(float a_fValue, float& a_fMin, float& a_fMax);
	CUtil();
	virtual ~CUtil();

   static long HexStringToHex(LPCTSTR a_strHexString, BOOL* a_bSuccess = NULL);

   static LPCTSTR m_strFileName;
   static HANDLE  m_hStdOut;
   static FILE* m_fStdOut;
   static long NearestPrime(long a_nValue);
   static void FitRect1InsideRect2(CRect a_rect1, CRect a_rect2, CRect *a_prcResult);

   
	//i tried out this lianbarsky implementation, it works for the case
	//CRect rect(0,0,99,99); and CRect line(50,43,150,99);
	//but does NOT work when I define the line as	CRect line(50,99,150,43) !!!
   static CRect ClipLine_LiangBarsky(CRect a_rect, CRect a_line); 

   //this function passed all the test cases i tried!(including the one mentioned above)
   //see mysort.cpp in test directory for details
   static bool cohen_clip_a_line(int xmin, int ymin, int xmax, int ymax,
	    int x1, int y1, int x2, int y2,int& new_x1, int& new_y1, int& new_x2, int& new_y2);
//	static void ReplaceAmp(CString& a_strIn, CString& a_strOut);
private:
	//functions needed for cohen/Sutherland clipping algorithm

	static void encode(int xmin, int ymin, int xmax, int ymax, int x, int y, code c);
	static int accept(code c1, code c2);
	static int reject(code c1, code c2);
	static void swap_if_needed(int *x1, int *y1, int *x2, int *y2, code c1, code c2);
};

namespace Char
{
	const TCHAR			NUL			= _T('\0');
	const TCHAR			TAB			= _T('\t');
	const TCHAR			QUOTE		= _T('\"');
	const TCHAR			SPACE		= _T(' ');
	const TCHAR			SEMICOL		= _T(';');
   const TCHAR			PIPE		= _T('|');
   const TCHAR			DOT		= _T('.');
   const TCHAR			CAP		= _T('^');
};

class CParseOptions
{
public:
	CParseOptions( TCHAR chDelimiter, 
				   TCHAR chQuoter	= Char::QUOTE, 
				   TCHAR chEscape	= Char::NUL, 
				   bool bGather		= false, 
				   bool bRTrim		= true, 
				   bool bKeepQuote	= false )
		: m_chDelimiter( chDelimiter )
		, m_chQuoter( chQuoter )
		, m_chEscape( chEscape )
		, m_bGather( bGather )
		, m_bRTrim( bRTrim )
		, m_bKeepQuote( bKeepQuote )
	{}

	inline void SetDelimiter( TCHAR chDelimiter )	{ m_chDelimiter = chDelimiter; }
	inline void SetQuoter( TCHAR chQuoter )			{ m_chQuoter = chQuoter; }
	inline void SetEscape( TCHAR chEscape )			{ m_chEscape = chEscape; }

	inline TCHAR GetDelimiter() const				{ return( m_chDelimiter ); }
	inline TCHAR GetQuoter() const					{ return( m_chQuoter ); }
	inline TCHAR GetEscape() const					{ return( m_chEscape ); }

	inline void NoDelimiter()						{ m_chDelimiter = Char::NUL; }
	inline void NoQuoter()							{ m_chQuoter = Char::NUL; }
	inline void NoEscape()							{ m_chEscape = Char::NUL; }

	inline bool IsDelimiter( TCHAR ch ) const		{ return( m_chDelimiter != Char::NUL && m_chDelimiter == ch ); }
	inline bool IsQuoter( TCHAR ch ) const			{ return( m_chQuoter != Char::NUL && m_chQuoter == ch ); }
	inline bool IsEscape( TCHAR ch ) const			{ return( m_chEscape != Char::NUL && m_chEscape == ch ); }

	inline void SetGather( bool bGather )			{ m_bGather = bGather; }
	inline bool IsGather() const					{ return( m_bGather ); }

	inline void SetRTrim( bool bRTrim )				{ m_bRTrim = bRTrim; }
	inline bool IsRTrim() const						{ return( m_bRTrim ); }

	inline void SetKeepQuote( bool bKeepQuote )		{ m_bKeepQuote = bKeepQuote; }
	inline bool IsKeepQuote() const					{ return( m_bKeepQuote ); }

protected:

	TCHAR		m_chDelimiter;	// to separate each string
	TCHAR		m_chQuoter;		// to introduce a quoted string
	TCHAR		m_chEscape;		// to escape to next character
	bool		m_bGather;		// to treat adjacent delimiters as one delimiter
	bool		m_bRTrim;		// to ignore empty trailing argument
	bool		m_bKeepQuote;	// to keep the quote of a quoted argument
};

const CParseOptions poCmdLine		( Char::SPACE, Char::QUOTE, Char::NUL, true );
const CParseOptions poCsvLine		( Char::SEMICOL, Char::QUOTE, Char::NUL, false );
const CParseOptions poTabbedCsvLine	( Char::TAB, Char::QUOTE, Char::NUL, false );

class CStringParser  
{
public:
	CStringParser();
	virtual ~CStringParser();

	void Empty();
	int Parse( LPCTSTR pszStr, const CParseOptions& po );
	int GetCount() const;
	LPCTSTR GetAt(int nIndex) const;

	#ifndef NDEBUG 
	void Dump() const;
	#endif // #ifndef NDEBUG

protected:

	BYTE*		m_pAlloc;
	TCHAR**		m_argv;
	int			m_argc;

	void Parse( LPCTSTR pszStr, const CParseOptions& po, int& numargs, int& numchars, TCHAR** argv = NULL, TCHAR* args = NULL );

};

inline int CStringParser::GetCount() const
{
	return( m_argc );
}

inline LPCTSTR CStringParser::GetAt(int nIndex) const
{
	if (!( m_argv != NULL && nIndex >= 0 && nIndex < m_argc ))
   {
      return NULL;
   }

	return( m_argv[nIndex] );
}


class CRectDiv  
{
public:
	CRectDiv()
   {
      m_rect.SetRectEmpty();

      m_sizeLayout.cx = 1;
      m_sizeLayout.cy = 1;
      m_sizeSpacing.cx = 0;
      m_sizeSpacing.cy = 0;

      m_dCellWidth = 0;
      m_dCellHeight = 0;

      m_bShowBoundary = TRUE;
   }
	virtual ~CRectDiv()
   {

   }

   void SetLayout(int a_nRows, int a_nColumns)
   {
      m_sizeLayout.cx = a_nColumns;
      m_sizeLayout.cy = a_nRows;
   }

	virtual RECT GetRect(int a_nRow, int a_nColumn)
   {
      RECT
         rect;

      rect.left = m_rect.left + (long)( (m_bShowBoundary ? (double) m_sizeSpacing.cx : 0.0) + 
                    (double) a_nColumn * (m_dCellWidth + (double) m_sizeSpacing.cx));
      rect.right = rect.left + (long) m_dCellWidth;

      rect.top = m_rect.top + (long)((m_bShowBoundary ? (double) m_sizeSpacing.cy : 0.0) + 
                    (double) a_nRow * (m_dCellHeight + (double) m_sizeSpacing.cy));
      rect.bottom = rect.top + (long) m_dCellHeight;

      return rect;
   }

   virtual void SetRect(const CRect& a_rect)
   {
      SetRect(a_rect, m_sizeLayout.cy, m_sizeLayout.cx);
   }

	virtual void SetRect(const CRect& a_rect, int a_nRows, int a_nColumns)
   {
      m_rect = a_rect;
      m_sizeLayout.cx = a_nColumns;
      m_sizeLayout.cy = a_nRows;
   
      /* Calculate the dimensions of each cell */
      m_dCellWidth  = (double) ((double) m_rect.Width() - 
         ((double)(m_sizeLayout.cx + (m_bShowBoundary ? 1 : -1)) * (double) m_sizeSpacing.cx)) / 
                                 (double) m_sizeLayout.cx;

      m_dCellHeight = (double) ((double) m_rect.Height() - 
                                ((double) (m_sizeLayout.cy + (m_bShowBoundary ? 1 : -1
                                )) * (double) m_sizeSpacing.cy)) / 
                     (double) m_sizeLayout.cy;

   }

   virtual void SetCellSpacing(int a_nCellSpacingX, int a_nCellSpacingY)
   {
      m_sizeSpacing.cx = a_nCellSpacingX;
      m_sizeSpacing.cy = a_nCellSpacingY;

      SetRect(m_rect, m_sizeLayout.cx, m_sizeLayout.cy); 
   }

protected:
   CRect m_rect;
   SIZE m_sizeLayout;
   SIZE m_sizeSpacing;
   double m_dCellWidth;
   double m_dCellHeight;
   BOOL m_bShowBoundary;
};
class CMemStream
{
public:

   CMemStream()
   {
      m_pStream = NULL;
      m_bAutoRelease = TRUE;
   }

   CMemStream(IStream* a_pStream, BOOL a_bAutoRelease = TRUE)
   {
      m_pStream = a_pStream;
      m_bAutoRelease = a_bAutoRelease;
   }

   HRESULT Create()
   {
      return CreateStreamOnHGlobal(NULL, TRUE, &m_pStream);
   }

   CMemStream(LPDISPATCH a_pDispatch, BOOL a_bAutoRelease = TRUE) 
   {
      Attach(a_pDispatch, a_bAutoRelease);
   }

   HRESULT Attach(LPDISPATCH a_pDispatch, BOOL a_bAutoRelease = TRUE)
   {
      CComQIPtr<IStream>
         pStream = a_pDispatch;

      m_pStream = pStream;
      m_bAutoRelease = a_bAutoRelease;

      return (m_pStream != NULL) ? S_OK : E_NOINTERFACE;
   }

   virtual ~CMemStream()
   {
      if ( (m_pStream != NULL) && m_bAutoRelease)
      {
         m_pStream->Release();
         m_pStream = NULL;
      }
   }

   HRESULT Append(LPCTSTR a_pString)
   {
      ULONG 
        ulBytesWritten = 0,
        ulSize = 0;
      HRESULT 
         result = S_OK;

      ATLASSERT(m_pStream != NULL);

      ulSize = _tcslen(a_pString);

      result = m_pStream->Write((void const*) a_pString, 
                                (ULONG) ulSize, 
                                (ULONG*) &ulBytesWritten);
      if (SUCCEEDED(result))
      {
         result = (ulSize == ulBytesWritten) ? S_OK : S_FALSE;
      }

      return result;
   }

   HRESULT ResetPointer()
   {
      if (m_pStream != NULL)
      {
         LARGE_INTEGER 
           liBeggining = { 0 };

         return m_pStream->Seek(liBeggining, STREAM_SEEK_SET, NULL);
      }
      else
      {
         return E_POINTER;
      }
   }

   /* have to call this function twice ( a_lpszReceiver = NULL first time) */
   HRESULT Read(LPTSTR a_lpszReceiver, ULONG* a_lpulSizeReceiver)
   {
      HRESULT
         result = S_OK;
      STATSTG 
         statstg;

      result = ResetPointer();
      if (SUCCEEDED(result))
      {
         memset (&statstg, 0, sizeof(statstg));

         result = m_pStream->Stat(&statstg, STATFLAG_NONAME);
         if SUCCEEDED(result)
         {
            if ((ULONG*) a_lpulSizeReceiver)
            {
               *((ULONG*)a_lpulSizeReceiver) = statstg.cbSize.LowPart;
            }

            if ( (void*) a_lpszReceiver)
            {
               memset( (void*) a_lpszReceiver, 0, statstg.cbSize.LowPart + sizeof(TCHAR));

               m_pStream->Read( (void*)a_lpszReceiver, statstg.cbSize.LowPart, NULL);
            }
         }
      }
      
      return result;
   }

   HRESULT Copy(LPCTSTR a_pString)
   {
      HRESULT
         result = S_OK;
      ULONG 
         ulBytesWritten = 0,
         ulSize = 0;
      ULARGE_INTEGER 
         uliSize = { 0 };

      result = ResetPointer();
      if (SUCCEEDED(result))
      {
         result = m_pStream->SetSize(uliSize);
         if (SUCCEEDED(result))
         {
            ulSize = (ULONG)_tcslen(a_pString);

            result = m_pStream->Write((void const*)a_pString, 
                                      (ULONG)ulSize, 
                                      (ULONG*)&ulBytesWritten);

            if (SUCCEEDED(result))
            {
               result = (ulSize == ulBytesWritten) ? S_OK : S_FALSE;
            }
         }
      }

      return result;
   }

   HRESULT AppendFormat(LPCTSTR a_lpszFormat, ...)
   {
      if (m_pStream != NULL)
      {
	      //ASSERT(AfxIsValidString(a_lpszFormat));

	      va_list 
            argList;
         CString
            str;

	      va_start(argList, a_lpszFormat);

	      str.FormatV(a_lpszFormat, argList);

	      va_end(argList);

         Append(str);
      }
      else
      {
         return E_POINTER;
      }

      return S_OK;
   }

public:
   LPSTREAM m_pStream;
   BOOL     m_bAutoRelease;
};

#ifdef _USE_TOKENIZER
#if !defined(_BITSET_)
#	include <bitset>
#endif // !defined(_BITSET_)

class CTokenizer
{
public:
	CTokenizer(const CString& cs, const CString& csDelim);
	void SetDelimiters(const CString& csDelim);

	bool Next(CString& cs);
	CString	Tail() const;

private:
	CString m_cs;
	std::bitset<256> m_delim;
	int m_nCurPos;
};
#endif

#include <set>
#include <string>
#include <vector>
#include <list>
typedef std::set<std::string> STR_SET;
typedef std::vector< CAdapt< CComQIPtr<IDispatch> > >QIPTRDISP_VEC;

typedef std::list< CAdapt< CComQIPtr<IDispatch> > >QIPTRDISP_LIST;

typedef std::vector< CAdapt< CComPtr<IUnknown> > >SPTR_UNKN_VEC;
typedef std::vector<short> SHORT_VEC;
typedef std::vector<long> LONG_VEC;
typedef std::vector<std::string> STR_VEC;
int GetIndexInVec(QIPTRDISP_VEC& a_vec, LPDISPATCH a_disp);
class CVariantHelper
{
public:
	static HRESULT packStrArrayToVariant(/*[in]*/CStringArray& a_strArray, /*[out]*/VARIANT * a_pv);
	static HRESULT unpackVariantToStrArray(VARIANT a_v, /*[out]*/CStringArray& a_strArray);

	static HRESULT packStrSetToVariant(/*[in]*/STR_SET& a_strArray, /*[out]*/VARIANT * a_pv);
	static HRESULT packStrVecToVariant(/*[in]*/STR_VEC& a_strVec, /*[out]*/VARIANT * a_pv);
	
	static HRESULT unpackVariantToStrSet(VARIANT a_v, /*[out]*/STR_SET& a_strArray);
	static HRESULT unpackVariantToStrVec(VARIANT a_v, /*[out]*/STR_VEC& a_strVec);
	
	static HRESULT convertVecToSafeArray(QIPTRDISP_VEC *a_pQiptrDispVec, VARIANT *a_pDisps);
	static HRESULT fillVecFromSafeArray(VARIANT a_vDispArray, QIPTRDISP_VEC *a_pQiptrDispVec);

	static HRESULT convertVecToSafeArray(QIPTRDISP_LIST *a_pQiptrDispVec, VARIANT *a_pDisps);
	static HRESULT fillVecFromSafeArray(VARIANT a_vDispArray, QIPTRDISP_LIST *a_pQiptrDispVec);

	static HRESULT convertVecToSafeArray( SHORT_VEC* a_pShortVec, VARIANT *a_pShorts);
	static HRESULT fillVecFromSafeArray(VARIANT a_vShortArray, SHORT_VEC *a_pQiptrDispVec);

	static HRESULT convertVecToSafeArray(LONG_VEC* a_pShortVec, VARIANT *a_pLongs);
	static HRESULT fillVecFromSafeArray(VARIANT a_vLongArray, LONG_VEC *a_pVec);

	static HRESULT convertVecToSafeArray(SPTR_UNKN_VEC *a_pQiptrDispVec, VARIANT *a_pDisps);
//	static HRESULT fillVecFromSafeArray(VARIANT a_vDispArray, QIPTRDISP_VEC *a_pQiptrDispVec);

};
class CStringArrayHelper
{
public:
/*=CStringArrayFind===========================================================*/
/*!
 * looks for a_str in a_strArray. If found it returns the 0 based index of the string, if not return -1 
 * 
 * @param a_strArr 
 * @param a_str 
 *
 * @retval int 
 */ 
/*============================================================================*/
static int CStringArrayFind(CStringArray& a_strArr, CString a_str)
{
	int
		nRet = -1;
	int
		nSize = a_strArr.GetSize();
	for(int i=0; i<nSize; i++)
	{
		if(a_str == a_strArr[i])
		{
			nRet = i;
			return nRet;
		}
	}
	return nRet;
}
};
class SetHelper{
public:
	/*	consider a match if any one of set 1 matches any one of set2 */
	static BOOL MatchStrSet(STR_SET& a_strSet1, STR_SET& a_strSet2, BOOL a_equalOrContain)//TRUE for equal and FALSE for contain
	{
		BOOL
			bResult = FALSE;
		//go through all the values in the series specification.
		for(STR_SET::iterator iter2 = a_strSet2.begin();
				iter2 != a_strSet2.end();
				iter2 ++)
		{
			if (a_equalOrContain) 
			{
				STR_SET::iterator iterFound
					= a_strSet1.find(*iter2);
				if(iterFound != a_strSet1.end())
				{
					bResult = TRUE;
					break;
				}
			}else
			{
				for(STR_SET::iterator iter1 = a_strSet1.begin();
												iter1 != a_strSet1.end();
												iter1 ++)
				{
					CString
						strToTest = iter1->c_str();
					if (strToTest.Find(iter2->c_str()) >= 0) 
					{
						bResult = TRUE;
						break;
					}
				}
			}
		}
		return bResult;
	}

	static BOOL MatchStrSetExact(STR_SET& a_strSet1, STR_SET& a_strSet2)
	{
		BOOL
			bResult = FALSE;
		int
			nNumberOfMatches = 0;
		if(a_strSet1.size() != a_strSet2.size())
			return bResult;

		//go through all the values in the series specification.
		for(STR_SET::iterator iter = a_strSet2.begin();
				iter != a_strSet2.end();
				iter ++)
		{
			STR_SET::iterator iterFound
				= a_strSet1.find(*iter);
			if(iterFound != a_strSet1.end())
			{
				nNumberOfMatches ++;
			}
		}
		
		if(nNumberOfMatches == a_strSet1.size())
		{
			bResult = TRUE;
		}
		return bResult;
	}
	static void Add(STR_SET& a_strSetDest, STR_SET& a_strSetSrc)
	{
		for(STR_SET::iterator iter = a_strSetSrc.begin();
				iter != a_strSetSrc.end();
				iter ++)
		{
			a_strSetDest.insert(*iter);
		}
	}
	static void AddFromVec(STR_SET& a_strSetDest, std::vector<std::string>& a_strVecSrc)
	{
		for(std::vector<std::string>::iterator iter = a_strVecSrc.begin();
				iter != a_strVecSrc.end();
				iter ++)
		{
			a_strSetDest.insert(*iter);
		}
	}

};
int ReverseFind(CString& a_str, CString a_strToSearch);
int ExactFind(CString& a_str, CString a_strToSearch, int a_nStart=0);
#endif // !defined(AFX_UTIL_H__27FC5653_7039_11D5_B6CE_000021015B32__INCLUDED_)
