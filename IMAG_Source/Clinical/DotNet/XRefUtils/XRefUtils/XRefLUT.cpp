// XRefLUT.cpp : Implementation of CXRefLUT

#include "stdafx.h"
#include "XRefLUT.h"


// CXRefLUT

STDMETHODIMP CXRefLUT::InterfaceSupportsErrorInfo(REFIID riid)
{
	static const IID* const arr[] = 
	{
		&IID_IXRefLUT
	};

	for (int i=0; i < sizeof(arr) / sizeof(arr[0]); i++)
	{
		if (InlineIsEqualGUID(*arr[i],riid))
			return S_OK;
	}
	return S_FALSE;
}

STDMETHODIMP CXRefLUT::GetXRefLine(IRadiologyImage* image1, IRadiologyImage* image2, LONG* success, LONG* planeId, VARIANT* line)
{
	return CProjectionManager::ProjectImage(image1, image2, success, planeId, line);
}


STDMETHODIMP CXRefLUT::GetNearestImage(IRadiologyImage* image, VARIANT images, LONG posX, LONG posY, IRadiologyImage** nearestImage)
{
	return CProjectionManager::GetNearestSlice(image, images, posX, posY, nearestImage);
}


STDMETHODIMP CXRefLUT::RegisterImage(IRadiologyImage* image)
{
	return CProjectionManager::RegisterImage(image);
}
