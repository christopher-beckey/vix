#ifndef __DXCOMMON_H_
#define __DXCOMMON_H_

#include <vector>
#include <atlsafe.h>

class CDxShutterData
{
public:
   
   enum
   {
      RECTANGULAR = 1,
      CIRCULAR = 2,
      POLYGONAL = 4
   };

   CDxShutterData()
   {
      m_nShapes = 0;
      m_nLeft = 0;
      m_nTop = 0;
      m_nRight = 0;
      m_nBottom = 0;
      m_nCenterX = 0;
      m_nCenterY = 0;
      m_nRadius = 0;
      m_pPoints = NULL;
      m_nrPoints = 0;
      m_crValue = RGB(0, 0, 0);
   }

   long m_nShapes;
   long m_nLeft;
   long m_nTop;
   long m_nRight;
   long m_nBottom;
   long m_nCenterX;
   long m_nCenterY;
   long m_nRadius;
   long *m_pPoints;
   long m_nrPoints;
   COLORREF m_crValue;
};

class CDxOverlayDataParent
{
public:
   virtual long GetPixelSpacing(long a_PixelSpacingState, double *a_pPixSpacingX, double *a_pPixSpacingY) = 0;
};

class CDxVOILut
{
public:
   CDxVOILut(BSTR a_bstrDesc): m_bstrDesc(NULL)
   {
      if (a_bstrDesc)
      {
         m_bstrDesc = ::SysAllocStringByteLen((char*)a_bstrDesc, 
                                               ::SysStringByteLen(a_bstrDesc));
      }
   }

   virtual ~CDxVOILut()
   {
      if (m_bstrDesc) ::SysFreeString(m_bstrDesc);
   }

   HRESULT SetLutData(VARIANT a_vLutDesc, VARIANT a_vLutData)
   {
      m_vLutDesc = a_vLutDesc;
      m_vLutData = a_vLutData;
      return S_OK;
   }

   BSTR m_bstrDesc;
   CComVariant m_vLutDesc;
   CComVariant m_vLutData;
};

class CDxWinLevel
{
public:
   CDxWinLevel(double a_dWindow, double a_dLevel)
      : m_dWindow(a_dWindow)
      , m_dLevel(a_dLevel)
   {
   }

   double m_dWindow;
   double m_dLevel;
   CComBSTR m_bstrExplanation;
};

class CDxImageData
{
public:
   CDxImageData()
   {
      compression.bCompressed = FALSE;
      VariantInit(&compression.vDetails);
      compression.bstrRatio = NULL;
      compression.bstrMethod = NULL;

      VariantInit(&indicators.left);
      VariantInit(&indicators.top);
      VariantInit(&indicators.right);
      VariantInit(&indicators.bottom);

      photometricInterpretation = 0;
   }

   virtual ~CDxImageData()
   {
      VariantClear(&compression.vDetails);
      if (compression.bstrRatio) ::SysFreeString(compression.bstrRatio);
      if (compression.bstrMethod) ::SysFreeString(compression.bstrMethod);

      for (std::vector<CDxVOILut*>::iterator iter = winlevel.voilut.arr.begin();
           iter != winlevel.voilut.arr.end(); iter++)
      {
         delete *iter;
      }

      for (std::vector<CDxWinLevel*>::iterator iter = winlevel.alt.arr.begin();
           iter != winlevel.alt.arr.end(); iter++)
      {
         delete *iter;
      }

      VariantClear(&indicators.left);
      VariantClear(&indicators.top);
      VariantClear(&indicators.right);
      VariantClear(&indicators.bottom);
   }

   void SetCompression(BOOL a_bCompressed, BSTR a_bstrCompRatio, BSTR a_bCompMethod)
   {
      compression.bCompressed = a_bCompressed;
      if (compression.bstrRatio) ::SysFreeString(compression.bstrRatio);
      if (compression.bstrMethod) ::SysFreeString(compression.bstrMethod);
      compression.bstrRatio = NULL;
      compression.bstrMethod = NULL;

      if (a_bstrCompRatio)
         compression.bstrRatio = ::SysAllocStringByteLen((char*)a_bstrCompRatio, 
                                                         ::SysStringByteLen(a_bstrCompRatio));

      if (a_bCompMethod)
         compression.bstrMethod = ::SysAllocStringByteLen((char*)a_bCompMethod, 
                                                          ::SysStringByteLen(a_bCompMethod));
   }

   void SetIndicators(BSTR a_bstrRight, BSTR a_bstrLeft, BSTR a_bstrBottom, BSTR a_bstrTop)
   {
      VariantClear(&indicators.left);
      VariantClear(&indicators.top);
      VariantClear(&indicators.right);
      VariantClear(&indicators.bottom);

      indicators.left.vt = VT_BSTR;
      indicators.left.bstrVal = SysAllocStringByteLen((char*)a_bstrLeft, ::SysStringByteLen(a_bstrLeft));
      indicators.top.vt = VT_BSTR;
      indicators.top.bstrVal = SysAllocStringByteLen((char*)a_bstrTop, ::SysStringByteLen(a_bstrTop));
      indicators.right.vt = VT_BSTR;
      indicators.right.bstrVal = SysAllocStringByteLen((char*)a_bstrRight, ::SysStringByteLen(a_bstrRight));
      indicators.bottom.vt = VT_BSTR;
      indicators.bottom.bstrVal = SysAllocStringByteLen((char*)a_bstrBottom, ::SysStringByteLen(a_bstrBottom));
   }

   void AddVOILut(BSTR a_bstrDesc)
   {
      CDxVOILut
         *pDxVOILut = new CDxVOILut(a_bstrDesc);

      winlevel.voilut.arr.push_back(pDxVOILut);
   }

   HRESULT GetVOILut(long a_nIndex, BSTR* a_pLabel, VARIANT* a_pLUTData)
   {
      /* lut index is 1 based */
      if ((a_nIndex >= 1) && (a_nIndex <= winlevel.voilut.arr.size()))
      {
         CDxVOILut
            *pDxVOILut = winlevel.voilut.arr[a_nIndex - 1];

         if (a_pLabel)
         {
            *a_pLabel = ::SysAllocStringByteLen((char*)pDxVOILut->m_bstrDesc, 
                                                 ::SysStringByteLen(pDxVOILut->m_bstrDesc));
         }
      }
      else
         return E_INVALIDARG;

      return S_OK;
   }

   HRESULT GetVOILut(long a_nIndex, CDxVOILut** a_pDxVOILut)
   {
      /* lut index is 1 based */
      if ((a_nIndex >= 1) && (a_nIndex <= winlevel.voilut.arr.size()))
      {
         if (a_pDxVOILut)
         {
            *a_pDxVOILut = winlevel.voilut.arr[a_nIndex - 1];;
         }
      }
      else
         return E_INVALIDARG;

      return S_OK;
   }

   HRESULT SetVOILut(long a_nIndex, VARIANT a_vLUTDesc, VARIANT a_vLUTData)
   {
      /* lut index is 1 based */
      if ((a_nIndex >= 1) && (a_nIndex <= winlevel.voilut.arr.size()))
      {
         CDxVOILut
            *pDxVOILut = winlevel.voilut.arr[a_nIndex - 1];

         return pDxVOILut->SetLutData(a_vLUTDesc, a_vLUTData);
      }
      else
         return E_INVALIDARG;
   }

   HRESULT GetVOILutCount(long* a_pVOILutCount)
   {
      if (a_pVOILutCount)
      {
         *a_pVOILutCount = winlevel.voilut.arr.size();
      }

      return S_OK;
   }

   void SetAltWinLevel(VARIANT a_vWindow, VARIANT a_vLevel, VARIANT a_vWinLevExp)
   {
      if ((a_vWindow.vt == (VT_ARRAY | VT_R8)) && (a_vLevel.vt == (VT_ARRAY | VT_R8)))
      {
         CComSafeArray<double>
            saWindow,
            saLevel;
         CComSafeArray<BSTR>
            saWinLevExp;
         int
            nCount = 0;
         CDxWinLevel
            *pDxWinLevel = NULL;
         BOOL
            bFound = FALSE;

         saWindow.Attach(a_vWindow.parray);
         saLevel.Attach(a_vLevel.parray);

         nCount = saWindow.GetCount();

         if (a_vWinLevExp.vt == (VT_ARRAY | VT_BSTR))
         {
            saWinLevExp.Attach(a_vWinLevExp.parray);
            if (nCount != saWinLevExp.GetCount()) saWinLevExp.Detach();
         }

         if (nCount == saLevel.GetCount())
         {
            for (int i = 0; i < nCount; i++)
            {
               /* check for duplicates */
               bFound = FALSE;
               for (int j = winlevel.alt.arr.size() - 1; j >= 0; j--)
               {
                  pDxWinLevel = winlevel.alt.arr[j];
                  if (((long) pDxWinLevel->m_dWindow == (long) saWindow[i]) && 
                      ((long) pDxWinLevel->m_dLevel == (long) saLevel[i]))
                  {
                     bFound = TRUE;
                     break;
                  }
               }
               if (bFound) continue;

               pDxWinLevel = new CDxWinLevel(saWindow[i], saLevel[i]);

               /* set explanation */
               if (saWinLevExp.m_psa)
               {
                  pDxWinLevel->m_bstrExplanation = saWinLevExp[i];
               }

               winlevel.alt.arr.push_back(pDxWinLevel);
            }
         }

         saWindow.Detach();
         saLevel.Detach();
         if (saWinLevExp.m_psa) saWinLevExp.Detach();
      }
   }

   HRESULT GetAltWinLevel(VARIANT* a_pWindow, VARIANT* a_pLevel, VARIANT* a_pWinLevExp)
   {
      CComSafeArray<double>
         saWindow,
         saLevel;
      CComSafeArray<BSTR>
         saWinLevExp;
      CDxWinLevel
         *pDxWinLevel = NULL;

      for (std::vector<CDxWinLevel*>::iterator iter = winlevel.alt.arr.begin();
           iter != winlevel.alt.arr.end(); iter++)
      {
         pDxWinLevel = *iter;

         saWindow.Add(pDxWinLevel->m_dWindow);
         saLevel.Add(pDxWinLevel->m_dLevel);
         saWinLevExp.Add(pDxWinLevel->m_bstrExplanation);
      }

      if (a_pWindow)
      {
         a_pWindow->vt = (VT_ARRAY | VT_R8);
         a_pWindow->parray = saWindow.Detach();
      }

      if (a_pLevel)
      {
         a_pLevel->vt = (VT_ARRAY | VT_R8);
         a_pLevel->parray = saLevel.Detach();
      }

      if (a_pWinLevExp)
      {
         a_pWinLevExp->vt = (VT_ARRAY | VT_BSTR);
         a_pWinLevExp->parray = saWinLevExp.Detach();
      }

      return S_OK;
   }

   HRESULT GetAltWinLevelCount(long* a_pAltWinLevelCount)
   {
      if (a_pAltWinLevelCount)
      {
         *a_pAltWinLevelCount = winlevel.alt.arr.size();
      }

      return S_OK;
   }

   struct
   {
      BOOL bCompressed;
      VARIANT vDetails;
      BSTR bstrRatio;
      BSTR bstrMethod;

   } compression;

   struct winlevel_struct
   {
      struct voilut_struct
      {
         std::vector<CDxVOILut*> arr;

      } voilut;

      struct alt_struct
      {
         std::vector<CDxWinLevel*> arr;

      } alt;

   } winlevel;

   struct indicators_struct
   {
      VARIANT left;
      VARIANT top;
      VARIANT right;
      VARIANT bottom;

   } indicators;

   int photometricInterpretation;
};

class CDxOverlayData
{
public:

   enum
   {
      VIEWED = 2,
      HIDDEN = 4,
      PARTIAL = 8,
      ALERT = 16,
      WINLEVEL = 32
   };

   enum
   {
      DONOTHING = 0,
      SAVESESSIONONLY = 1,
      DELETEALLANNOTATIONS = 2,
      MERGELAYERS = 3,
      REVERTTOSTOREDLAYER = 4
   };

   enum
   {
      NEWANNOT = 1,
      EDITEXISTING = 2,
      DELETEEXISTING = 4,
      EDITNEW = 8,
		DELETENEW = 16
   };

   virtual long Clone(CDxOverlayData** a_ppOverlayData) = 0;
   //virtual long SetIndicators(BSTR bstrLeft, BSTR bstrTop, BSTR bstrRight, BSTR bstrBottom) = 0;
   virtual long Save(VARIANT a_vData, long a_nOption) = 0;
   virtual long Read(VARIANT a_vData) = 0;
   virtual long SetPixelSpacingState(long a_nState) = 0;
   virtual long SetHounsfield(long a_nHounsfield) = 0;
   virtual long Repaint() = 0;
   virtual long SetNextAutoLabel(long type, BSTR value) = 0;
   virtual long GetNextAutoLabel(long *type, BSTR *value) = 0;
   virtual long GetElementCount() = 0;
   virtual long Project(VARIANT data) = 0;
   virtual long SetViewedState(long viewedState) = 0;
   virtual long GetViewedState() = 0;
   virtual long CreateShutterData(CDxShutterData** a_ppShutterData) = 0;
   virtual void AddRef() = 0;
   virtual long Release() = 0;
   virtual long IsDirty() = 0;
   virtual long GetEditState() = 0;
   virtual long GetElementFromUID(BSTR bstrUID) = 0;
   virtual long DeleteElement(long elementID) = 0;
   virtual long DeleteElement(BSTR bstrUID) = 0;
   virtual long ChangeElementUID(BSTR bstrOldUID) = 0;
   virtual long SetParent(CDxOverlayDataParent* pParent) = 0;
	virtual long DeleteElements() = 0;
   virtual long GetRedactElements(VARIANT* elements) = 0;
   virtual long GetIsVisible(long type, long *pVal) = 0;
   virtual long SetIsVisible(long type, long newVal) = 0;
   virtual long SetVOILutIndex(long voiLutIndex) = 0;
   virtual long GetVOILutIndex(long *voiLutIndex) = 0;
   virtual long AddElement(long type, VARIANT data) = 0;
   virtual long GetElementByID(VARIANT elementID, long *type, VARIANT *data) = 0;
};

class CDxOverlayProperties
{
public:

   enum
   {
      SHOWTEXTOUTLINE = 1
   };

   enum
   {
      DEFAULTVIEW = 0,
      THUMBNAILVIEW = 1,
      MULTIFRAME = 2
   };

   enum
   {
      ANNOTLAYER_DEFAULT = 0,
      ANNOTLAYER_INDICATORS = 1,
      ANNOTLAYER_ALERTS = 2,
      ANNOTLAYER_USER = 3,
      ANNOTLAYER_SESSION = 4,
      ANNOTLAYER_STORED = 5,
		ANNOTLAYER_MENSURATEDSCALE = 6,
      ANNOTLAYER_WINLEVEL = 7,
      ANNOTLAYER_BOTH = 8,
      ANNOTLAYER_NONE = 9
   };

   virtual void SetElementColor(long element, DWORD color) = 0;
   virtual void SetElementFont(long element, VARIANT font) = 0;
   virtual void SetElementLineWidth(long element, long width) = 0;
   virtual void SetMeasurementUnit(long element, long unit) = 0;
   virtual void SetElementOptions(long element, long options) = 0;
   virtual void RefreshDisplay() = 0;
   virtual long GetViewMode() = 0;
   virtual long SetViewMode(long viewMode) = 0;
   virtual long EnableInteraction(long enable) = 0;
   virtual long SetLayerVisible(long layer, BOOL show, BOOL refresh) = 0;
   virtual long ElementEdit(long layerID, long elementID) = 0;
   virtual long ShowAnnotations(long show) = 0;
	virtual long IsLayerVisible(long layer, BOOL* visible) = 0;
};



#endif //__DXCOMMON_H_