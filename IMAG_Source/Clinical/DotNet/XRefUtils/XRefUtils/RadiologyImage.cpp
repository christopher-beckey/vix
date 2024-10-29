// RadiologyImage.cpp : Implementation of CRadiologyImage

#include "stdafx.h"
#include "RadiologyImage.h"


// CRadiologyImage

STDMETHODIMP CRadiologyImage::InterfaceSupportsErrorInfo(REFIID riid)
{
	static const IID* const arr[] = 
	{
		&IID_IRadiologyImage
	};

	for (int i=0; i < sizeof(arr) / sizeof(arr[0]); i++)
	{
		if (InlineIsEqualGUID(*arr[i],riid))
			return S_OK;
	}
	return S_FALSE;
}

STDMETHODIMP CRadiologyImage::get_ProjectionIndex(SHORT* pVal)
{
	*pVal = m_ProjectionIndex;

	return S_OK;
}


STDMETHODIMP CRadiologyImage::put_ProjectionIndex(SHORT newVal)
{
	m_ProjectionIndex = newVal;

	return S_OK;
}

STDMETHODIMP CRadiologyImage::get_TagValue(LONG group, LONG element, BSTR* pVal)
{
	list<CDicomTag*>::iterator iter = m_TagList.begin();
	while (iter != m_TagList.end())
	{
		if (((*iter)->m_Group == group) && ((*iter)->m_Element == element))
		{
			(*iter)->m_Value.CopyTo(pVal);
			return S_OK;
		}
		iter++;
	}

	return E_FAIL;
}


STDMETHODIMP CRadiologyImage::put_TagValue(LONG group, LONG element, BSTR newVal)
{
	CDicomTag* pDicomTag = new CDicomTag();
	pDicomTag->m_Group = group;
	pDicomTag->m_Element = element;
	pDicomTag->m_Value = newVal;

	m_TagList.push_back(pDicomTag);

	return S_OK;
}


STDMETHODIMP CRadiologyImage::get_UserData(VARIANT* pVal)
{
	return ::VariantCopy(pVal, &m_UserData);
}


STDMETHODIMP CRadiologyImage::put_UserData(VARIANT newVal)
{
	m_UserData = newVal;

	return S_OK;
}


STDMETHODIMP CRadiologyImage::SetTag(LONG group, LONG element, BSTR newValue)
{
	this->put_TagValue(group, element, newValue);

	return S_OK;
}
