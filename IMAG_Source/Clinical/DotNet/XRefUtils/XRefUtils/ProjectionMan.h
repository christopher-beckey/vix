#pragma once

#include <set>
#include <vector>
#include <string>
#include <map>
#include <comdef.h>

#import <SliceCalc.dll>  no_namespace raw_native_types raw_interfaces_only named_guids

//#define CALCULATE_PLANEID 
#define WID_CREATEPROJECTIONDATA 1001

class CImageData
{
public:
	CImageData()
	{
		m_nProjectionIndex = -1;
	}

	CComVariant m_vImagePosition;
	CComVariant m_vImageOrientation;
	CComVariant m_vImagePixelSpacing;
	CComBSTR m_bstrFrameOfReference;
	long m_nImageWidth;
	long m_nImageHeight;
	short m_nProjectionIndex;
#ifdef CALCULATE_PLANEID
	CComBSTR m_bstrIndicator[4];
#endif 

	HRESULT Create(IRadiologyImage* a_pImage)
	{
		CComBSTR bstrValue;
		CString strText;

		// image position
		float posX, posY, posZ;
		if (FAILED(a_pImage->get_TagValue(0x0020, 0x0032, &bstrValue)))
		{
			return E_FAIL;
		}
		strText.Empty(); strText = bstrValue;
		if (_stscanf(strText,_T("%f\\%f\\%f"), 
                     &posX, &posY, &posZ) != 3)
		{
			return E_FAIL;
		}
		CComSafeArray<FLOAT> saFloat;
		saFloat.Add(posX);
		saFloat.Add(posY);
		saFloat.Add(posZ);
		m_vImagePosition.vt = (VT_ARRAY | VT_R4);
		m_vImagePosition.parray = saFloat.Detach();

		// image orientation
		bstrValue.Empty();
		if (FAILED(a_pImage->get_TagValue(0x0020, 0x0037, &bstrValue)))
		{
			return E_FAIL;
		}
		float dirCosineRowX, dirCosineRowY, dirCosineRowZ;
		float dirCosineColX, dirCosineColY, dirCosineColZ;
		strText.Empty(); strText = bstrValue;
		if (_stscanf(strText,_T("%f\\%f\\%f\\%f\\%f\\%f"), 
                     &dirCosineRowX, &dirCosineRowY, &dirCosineRowZ,
					 &dirCosineColX, &dirCosineColY, &dirCosineColZ) != 6)
		{
			return E_FAIL;
		}
		saFloat.Add(dirCosineRowX);
		saFloat.Add(dirCosineRowY);
		saFloat.Add(dirCosineRowZ);
		saFloat.Add(dirCosineColX);
		saFloat.Add(dirCosineColY);
		saFloat.Add(dirCosineColZ);
		m_vImageOrientation.vt = (VT_ARRAY | VT_R4);
		m_vImageOrientation.parray = saFloat.Detach();

		// pixel spacing
		bstrValue.Empty();
		if (FAILED(a_pImage->get_TagValue(0x0028, 0x0030, &bstrValue)))
		{
			return E_FAIL;
		}
		strText.Empty(); strText = bstrValue;
		if (strText.IsEmpty()) return E_FAIL;
		double pixelSpacingX, pixelSpacingY; 
		LPTSTR lpPixelSpacing = strText.GetBuffer(strText.GetLength());
        LPTSTR lpPSX = _tcstok(lpPixelSpacing, _T("\\"));
        LPTSTR lpPSY = _tcstok(NULL, _T("\\"));
		if ((lpPSX == NULL) || (lpPSY == NULL)) return E_FAIL;

		LPTSTR lpStop = NULL;
		pixelSpacingX = _tcstod(lpPSX, &lpStop);
		lpStop = NULL;
		pixelSpacingY = _tcstod(lpPSY, &lpStop);
		CComSafeArray<DOUBLE> saDouble;
		saDouble.Add(pixelSpacingX);
		saDouble.Add(pixelSpacingY);
		m_vImagePixelSpacing.vt = (VT_ARRAY | VT_R8);
		m_vImagePixelSpacing.parray = saDouble.Detach();

		// frame of reference
		if (FAILED(a_pImage->get_TagValue(0x0020, 0x0052, &m_bstrFrameOfReference)))
		{
			return E_FAIL;
		}

		// height
		bstrValue.Empty();
		if (FAILED(a_pImage->get_TagValue(0x0028, 0x0010, &bstrValue)))
		{
			return E_FAIL;
		}
		strText.Empty(); strText = bstrValue;
		m_nImageHeight = _ttol(strText);

		// width
		bstrValue.Empty();
		if (FAILED(a_pImage->get_TagValue(0x0028, 0x0011, &bstrValue)))
		{
			return E_FAIL;
		}
		strText.Empty(); strText = bstrValue;
		m_nImageWidth = _ttol(strText);

		// indicators
#ifdef CALCULATE_PLANEID
		char szOrientation[4], cOrientationX, cOrientationY, cOrientationZ, *pszOrientation = szOrientation;
		double dAbsX = 0.0, dAbsY = 0.0, dAbsZ = 0.0;
		int i = 0;
		CString strIndicator, strOtherIndicator;
		CComBSTR bstrLeft, bstrTop, bstrRight,bstrBottom;

		/* row orientation */
		*pszOrientation = '\0';

		cOrientationX = (dirCosineRowX < 0) ? 'R' : 'L';
		cOrientationY = (dirCosineRowY < 0) ? 'A' : 'P';
		cOrientationZ = (dirCosineRowZ < 0) ? 'F' : 'H';

		dAbsX = fabs(dirCosineRowX);
		dAbsY = fabs(dirCosineRowY);
		dAbsZ = fabs(dirCosineRowZ);

		for (i = 0; i < 3; ++i) 
		{
			if ((dAbsX > 0.0001) && (dAbsX > dAbsY) && (dAbsX > dAbsZ))
			{
				*pszOrientation++ = cOrientationX;
				dAbsX=0;
			}
			else if ((dAbsY > 0.0001) && (dAbsY>dAbsX) && (dAbsY > dAbsZ))
			{
				*pszOrientation++ = cOrientationY;
				dAbsY=0;
			}
			else if ((dAbsZ > 0.0001) && (dAbsZ > dAbsX) && (dAbsZ > dAbsY))
			{
				*pszOrientation++ = cOrientationZ;
				dAbsZ=0;
			}
			else 
			{
				break;
			}

			*pszOrientation='\0';
		}

		strIndicator = szOrientation;
		strOtherIndicator = GetOtherIndicator(strIndicator);
		bstrRight.Attach(strIndicator.AllocSysString());
		bstrLeft.Attach(strOtherIndicator.AllocSysString());

		/* column orientation */
		pszOrientation = szOrientation;
		*pszOrientation = '\0';

		cOrientationX = (dirCosineColX < 0) ? 'R' : 'L';
		cOrientationY = (dirCosineColY < 0) ? 'A' : 'P';
		cOrientationZ = (dirCosineColZ < 0) ? 'F' : 'H';

		dAbsX = fabs(dirCosineColX);
		dAbsY = fabs(dirCosineColY);
		dAbsZ = fabs(dirCosineColZ);

		for (i = 0; i < 3; ++i) 
		{
			if ((dAbsX > 0.0001) && (dAbsX > dAbsY) && (dAbsX > dAbsZ))
			{
				*pszOrientation++ = cOrientationX;
				dAbsX=0;
			}
			else if ((dAbsY > 0.0001) && (dAbsY>dAbsX) && (dAbsY > dAbsZ))
			{
				*pszOrientation++ = cOrientationY;
				dAbsY=0;
			}
			else if ((dAbsZ > 0.0001) && (dAbsZ > dAbsX) && (dAbsZ > dAbsY))
			{
				*pszOrientation++ = cOrientationZ;
				dAbsZ=0;
			}
			else 
			{
				break;
			}

			*pszOrientation='\0';
		}

		strIndicator = szOrientation;
		strOtherIndicator = GetOtherIndicator(strIndicator);
		bstrBottom.Attach(strIndicator.AllocSysString());
		bstrTop.Attach(strOtherIndicator.AllocSysString());

		m_bstrIndicator[0] = bstrLeft;
		m_bstrIndicator[1] = bstrTop;
		m_bstrIndicator[2] = bstrRight;
		m_bstrIndicator[3] = bstrBottom;
#endif

		return S_OK;
	}

private:
   CString GetOtherIndicator(CString& a_strIndicator)
   {
      CString
         strTemp;

      if (a_strIndicator.Find("L") != -1)
         strTemp += "R";
      if (a_strIndicator.Find("R") != -1)
         strTemp += "L";
      if (a_strIndicator.Find("A") != -1)
         strTemp += "P";
      if (a_strIndicator.Find("P") != -1)
         strTemp += "A";
      if (a_strIndicator.Find("F") != -1)
         strTemp += "H";
      if (a_strIndicator.Find("H") != -1)
         strTemp += "F";

      return strTemp;
   }

};

class CProjection
{
public:
	CProjection()
	{
		m_nPlaneID = -1;
	}

	long m_nPlaneID;
	CComVariant m_vCoords;
};

class CProjectionMap
{
public:

   CProjectionMap()
	  : m_nPlaneIDCounter(1)
   {
   }

   virtual ~CProjectionMap()
   {
	  CleanUp();
   }

	CProjection* GetProjection(CImageData* a_pImageData1, CImageData* a_pImageData2)
	{
		long key = MAKELONG(a_pImageData1->m_nProjectionIndex, a_pImageData2->m_nProjectionIndex);
		std::map<long, CProjection*>::iterator iter = m_imageMap.find(key);
		return (iter == m_imageMap.end())? NULL : iter->second;
	}

	void SetProjection(CImageData* a_pImageData1, CImageData* a_pImageData2, CProjection* a_pProjection)
	{
		long key = MAKELONG(a_pImageData1->m_nProjectionIndex, a_pImageData2->m_nProjectionIndex);
		m_imageMap[key] = a_pProjection;
	}

	CImageData* GetImageData(short a_nImageId)
	{
		if ((a_nImageId >= 1) && (a_nImageId <= (short) m_imageData.size()))
		{
			return m_imageData[a_nImageId - 1];
		}
		else
		{
			return NULL;
		}
	}

	HRESULT CreateImageData(IRadiologyImage* a_pImage)
	{
		HRESULT result = S_OK;
		CImageData* pImageData = new CImageData();

		result = pImageData->Create(a_pImage);
		if (FAILED(result))
		{
			delete pImageData;
			return result;
		}

		m_imageData.push_back(pImageData);
		pImageData->m_nProjectionIndex = m_imageData.size();
		a_pImage->put_ProjectionIndex(pImageData->m_nProjectionIndex);

		return ProcessImage(pImageData);
	}


	HRESULT ProcessImage(CImageData* pCurrentImageData)
	{
		if (!(pCurrentImageData->m_vImagePosition.vt & VT_ARRAY) ||
			!(pCurrentImageData->m_vImageOrientation.vt & VT_ARRAY) ||
			!(pCurrentImageData->m_vImagePixelSpacing.vt & VT_ARRAY))
		{
			// invalid image data
			return S_OK;
		}

		CImageData* pImageData = NULL;
		CComVariant vSliceLine;			
		HRESULT result = S_OK;

		for (int i = 0; i < (int) m_imageData.size(); i++)
		{
			pImageData = m_imageData[i];
			if ((pImageData == NULL) || (pImageData == pCurrentImageData)) continue;

			if (!(pImageData->m_vImagePosition.vt & VT_ARRAY) ||
				!(pImageData->m_vImageOrientation.vt & VT_ARRAY) ||
				!(pImageData->m_vImagePixelSpacing.vt & VT_ARRAY))
			{
				// invalid image data
				continue;
			}

			if (pImageData->m_bstrFrameOfReference != pCurrentImageData->m_bstrFrameOfReference)
			{
				// not same frame of reference
				continue;
			}

			if (this->m_spSliceCalc == NULL)
			{
				result = this->m_spSliceCalc.CoCreateInstance(CLSID_slicesX);
				if (FAILED(result)) return result;
			}

			// calculate projection in both directions
			CalculateProjection(pImageData, pCurrentImageData);
			CalculateProjection(pCurrentImageData, pImageData);
		}

		return S_OK;
	}

	// Note: both images must have valid image data and same FOR
	void CalculateProjection(CImageData* pImageData1, CImageData* pImageData2)
	{
		HRESULT result = S_OK;
		CComVariant vSliceLine;
		double dAngle = 0.0;
	    long bParallel = FALSE, bIntersect = FALSE, *pSliceLine = NULL;
		CProjection *pProjection = NULL;

		result = m_spSliceCalc->ProjectSlice(&pImageData2->m_vImagePosition, 
			&pImageData2->m_vImageOrientation, 
			&pImageData2->m_vImagePixelSpacing, 
			pImageData2->m_nImageHeight, 
			pImageData2->m_nImageWidth,
			&pImageData1->m_vImagePosition, 
			&pImageData1->m_vImageOrientation, 
			&pImageData1->m_vImagePixelSpacing, 
			pImageData1->m_nImageHeight, 
			pImageData1->m_nImageWidth,
			&vSliceLine,
			&dAngle);
		 if (FAILED(result))
		 {
			return;
		 }

	    short nX0, nY0, nX1, nY1;
		SafeArrayAccessData(vSliceLine.parray, (void**) &pSliceLine);
		nX0 = (short) pSliceLine[0];
		nY0 = (short) pSliceLine[1];
		nX1 = (short) pSliceLine[2];
		nY1 = (short) pSliceLine[3];
		SafeArrayUnaccessData(vSliceLine.parray);

		/* make sure scout and image are not parallel */
		result = m_spSliceCalc->IntersectLine(&nX0, &nY0, &nX1, &nY1, &bParallel, &bIntersect);
		/* Note: Following change was made when images in MrScout folder did not projected properly */
		/* It is ok if the planes are not parallel, they dont have to intersect */
		if (FAILED(result) || bParallel)   
		{
			return;
		}

		/* get or create projection */
		pProjection = GetProjection(pImageData1, pImageData2);
		if (!pProjection)
		{
			pProjection = new CProjection();
			SetProjection(pImageData1, pImageData2, pProjection);
		}

		pProjection->m_vCoords = vSliceLine;

		/* get plane id */
#ifdef CALCULATE_PLANEID
		pProjection->m_nPlaneID = GetPlaneID(pImageData2->m_bstrIndicator[0],
											 pImageData2->m_bstrIndicator[1],
											 pImageData2->m_bstrIndicator[2],
											 pImageData2->m_bstrIndicator[3]);
#endif
	}

	void CleanUp()
	{
		std::map<long, CProjection*>::iterator iter = m_imageMap.begin();
		while (iter != m_imageMap.end())
		{
			if (iter->second) delete iter->second;
			iter++;
		}
		m_imageMap.clear();

		for (int i = m_imageData.size() - 1; i >= 0; i--)
		{
			delete m_imageData[i];
		}
		m_imageData.clear();
	}

   long GetPlaneID(BSTR a_bstrLeft, BSTR a_bstrTop, BSTR a_bstrRight, BSTR a_bstrBottom)
   {
	  CString
		 strLeft = _bstr_t(a_bstrLeft),
		 strTop = _bstr_t(a_bstrTop),
		 strRight = _bstr_t(a_bstrRight),
		 strBottom = _bstr_t(a_bstrBottom),
		 strText;
	  std::map<std::string, long>::iterator
		 iter;
	  std::string
		 sText;

	  strText.Format("%s,%s,%s,%s", strLeft, strTop, strRight, strBottom);
	  sText = strText;
	  iter = m_planeIDMap.find(sText);
	  if (iter != m_planeIDMap.end())
		 return iter->second;
	  else
	  {
		 m_planeIDMap[sText] = m_nPlaneIDCounter++;
		 return (m_nPlaneIDCounter - 1);
	  }
   }

private:
	long m_nImageCount;
	std::map<std::string, long> m_planeIDMap;
	std::map<long, CProjection*> m_imageMap;
	std::vector<CImageData*> m_imageData;
	long m_nPlaneIDCounter;
	CComPtr<IslicesX> m_spSliceCalc;
};

class CProjectionManager
{
public:

   CProjectionManager()
   {
	   
   }

   HRESULT RegisterImage(IRadiologyImage* a_pImage)
   {
	   return m_projectionMap.CreateImageData(a_pImage);
   }

   HRESULT ProjectImage(IRadiologyImage* a_pActiveImage,  IRadiologyImage* a_pOtherImage,
						long* success,
						long* a_pPlaneID, VARIANT* a_pCoords)
   {
	    CImageData* pImageData1 = GetImageData(a_pActiveImage);
		if (!pImageData1) return E_FAIL; //not registered
	    CImageData* pImageData2 = GetImageData(a_pOtherImage);
		if (!pImageData2) return E_FAIL; //not registered

		CProjection* pProjection = m_projectionMap.GetProjection(pImageData1, pImageData2);
		if (pProjection)
		{
			if (a_pPlaneID) 
				*a_pPlaneID = pProjection->m_nPlaneID;

			if (a_pCoords) 
				::VariantCopy(a_pCoords, &pProjection->m_vCoords);

			if(success)
				*success = 1;
		}
		else
		{
			//return E_FAIL;
			if(success)
				*success = 0;
			return S_OK;
		}

		return S_OK;
   }

   HRESULT GetNearestSlice(IRadiologyImage* a_pScoutImage, VARIANT a_vImages, long a_nX, long a_nY, IRadiologyImage** a_ppNearestImage)
   {
		if (a_vImages.vt != (VT_DISPATCH | VT_ARRAY))
		{
			return E_INVALIDARG;
		}

		CImageData* pImageDataScout = GetImageData(a_pScoutImage);
		if (!pImageDataScout) return E_FAIL; //not registered

		CImageData* pImageData = NULL;
		CComSafeArray<IDispatch*> saImages(a_vImages.parray);
		CComQIPtr<IRadiologyImage> spImage, spNearestImage;
		CProjection *pProjection = NULL;
		double dDistance = 0.0, dMinDistance = 0.0;
		long nPlaneID = 0;
		BOOL bFirst = TRUE;

		for (int i = 0; i < (int) saImages.GetCount(); i++)
		{
			spImage = saImages[i];
			if (spImage == NULL) continue;


			pImageData = GetImageData(spImage);
			if (!pImageData) continue; // not registered
					  
			pProjection = m_projectionMap.GetProjection(pImageData, pImageDataScout);
			if (!pProjection) continue;

			dDistance = GetDistance(pProjection, a_nX, a_nY);

			if (bFirst)
			{
				nPlaneID = pProjection->m_nPlaneID;
				dMinDistance = dDistance;
				spNearestImage = spImage;
				bFirst = FALSE;
			}
			else
			{
				/* ignore if plane not similar to the top-most image */
				if (nPlaneID != pProjection->m_nPlaneID) continue;
				
				if (dDistance < dMinDistance)
				{
					dMinDistance = dDistance;
					spNearestImage = spImage;
				}
			}
		}

		if (a_ppNearestImage)
		{
			*a_ppNearestImage = spNearestImage;
			if (*a_ppNearestImage) (*a_ppNearestImage)->AddRef();
		}

		return S_OK;	
	}

private:
   CImageData* GetImageData(IRadiologyImage* a_pImage)
   {
		short nProjectionIndex = 0;
		a_pImage->get_ProjectionIndex(&nProjectionIndex);

		return m_projectionMap.GetImageData(nProjectionIndex);
   }

   // calculates the distance between a point and a projection. 
   double GetDistance(CProjection* a_pProjection, long a_nX, long a_nY)
   {
	  double 
		 dDistance  = 0.0,
		 dA, dB, dC;
	  CComSafeArray<long>
		 saCoordinates;

	  saCoordinates.Attach(a_pProjection->m_vCoords.parray);

	  if (saCoordinates[0] == saCoordinates[2])
	  {
		 dA = 1;
		 dB = 0.0;
		 dC = -saCoordinates[0];
	  }
	  else
	  {
		 dA = saCoordinates[3] - saCoordinates[1];
		 dB = saCoordinates[0] - saCoordinates[2];
		 dC = saCoordinates[2] * saCoordinates[1] - saCoordinates[0] * saCoordinates[3];
	  }

	  dDistance = ( (dA * a_nX) + (dB * a_nY) + dC ) /
					( sqrt((dA * dA) + (dB * dB)) );
	  if (dDistance < 0)
	  {
		 dDistance = -dDistance;
	  }

	  saCoordinates.Detach();

	  return dDistance;
   }

   CProjectionMap m_projectionMap;
};

