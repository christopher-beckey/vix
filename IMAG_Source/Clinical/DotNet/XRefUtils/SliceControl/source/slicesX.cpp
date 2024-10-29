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
// slicesX.cpp : Implementation of CslicesX
#include "stdafx.h"
#include "SliceCalc.h"
#include "slicesX.h"
#include <math.h>

/////////////////////////////////////////////////////////////////////////////
// CslicesX


/*=CslicesX::Axis=============================================================*/
/*!
 * get the coordinates of the upper center, right hand center, buttom center and left hand center of the axial image plane
 * in the 3 D space of the scout image, where scout's first row is positive x axis and first column is positive y axis.
 * Z axis is ignored since they are all 0.
 * 
 * @param *TopX [out]
 * @param *TopY [out]
 * @param *RightX [out]
 * @param *RightY [out]
 * @param *BottomX [out]
 * @param *BottomY [out]
 * @param *LeftX [out]
 * @param *LeftY [out]
 *
 * @retval S_OK 
 */ 
/*============================================================================*/
STDMETHODIMP CslicesX::Axis(short *TopX, short *TopY, short *RightX, short *RightY, short *BottomX, short *BottomY, short *LeftX, short *LeftY)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	//  Processing class
	CsliceProcessing slice;

	int  _topX, _topY, _bottomX, _bottomY, _leftX, _leftY, _rightX, _rightY;
	short retVal;

	retVal = (_mslice.getAxisPoints (_topX, _topY, _bottomX, _bottomY, _leftX, _leftY, _rightX, _rightY));
	*TopX =		_topX;
	*TopY =		_topY;
	*BottomX =	_bottomX;
	*BottomY =	_bottomY;
	*LeftX =	_leftX;
	*LeftY =	_leftY;
	*RightX =	_rightX;
	*RightY =	_rightY;

	return S_OK;
}

/*=CslicesX::BoundingBox======================================================*/
/*!
 * get the coordinates of the upper left, upper right, lower right and lower left corners of the axial image plane in the 3 D space of the scout image,
	, where scout's first row is positive x axis and first column is positive y axis.
 * Z axis is ignored since they are all 0.
 * 
 * @param *UlX [out]
 * @param *UlY [out]
 * @param *UrX [out]
 * @param *UrY [out]
 * @param *LrX [out]
 * @param *LrY [out]
 * @param *LlX [out]
 * @param *LlY [out]
 *
 * @retval S_OK 
 */ 
/*============================================================================*/
STDMETHODIMP CslicesX::BoundingBox(short *UlX, short *UlY, short *UrX, short *UrY, short *LrX, short *LrY, short *LlX, short *LlY)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())

	int  _ulx, _uly, _urx, _ury, _llx, _lly, _lrx, _lry;
	short retVal;

	retVal = (_mslice.getBoundingBox (_ulx, _uly, _urx, _ury, _llx, _lly, _lrx, _lry));
	*UlX = _ulx;
	*UlY = _uly;
	*UrX = _urx;
	*UrY = _ury;
	*LrX = _lrx;
	*LrY = _lry;
	*LlX = _llx;
	*LlY = _lly;

	return S_OK;
}

/*=CslicesX::Project==========================================================*/
/*!
 * The caller supplies this method with all the input in the parameter, the method will process data and project the axial image onto the scout image space
	, where scout's first row is positive x axis and first column is positive y axis. The result of this projection is saved in a internal data structure,
	waiting for the caller to retrieve in the next call.
 * 
 * @param *ScoutPos scout image position string
 * @param *ScoutOrient scout orientation string
 * @param *ScoutPixSpace scout pixel spacing string
 * @param ScoutRows scout number of rows of the image
 * @param ScoutCols scout number of columns of the image
 * @param *ImgPos axial image position string
 * @param *ImgOrient axial image orientation string
 * @param *ImgPixSpace axial image pixel spacing string
 * @param ImgRows axial image number of rows
 * @param ImgCols axial image number of columns
 *
 * @retval S_OK for success and E_FAIL if input data is invalid
 */ 
/*============================================================================*/
STDMETHODIMP CslicesX::Project(BSTR *ScoutPos, BSTR *ScoutOrient, BSTR *ScoutPixSpace, short ScoutRows, short ScoutCols, BSTR *ImgPos, BSTR *ImgOrient, BSTR *ImgPixSpace, short ImgRows, short ImgCols)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())

	_mslice.ProjectSlice(*ScoutPos, *ScoutOrient, *ScoutPixSpace, ScoutRows, ScoutCols,
		                          *ImgPos, *ImgOrient, *ImgPixSpace, ImgRows, ImgCols);

	return S_OK;
}

/*=CslicesX::ProjectSlice=====================================================*/
/*!
 * similar as Project except the last parameter will be filled with information of the longer of the axis as projection line, if a projection line exists.
 * 
 * @param scoutPosition 
 * @param scoutOrientation 
 * @param scoutPixelSpacing 
 * @param scoutRows 
 * @param scoutColumns 
 * @param imagePosition 
 * @param imageOrientation 
 * @param imagePixelSpacing 
 * @param imageRows 
 * @param imageColumns 
 * @param sliceLine [out] safearray of VT_I4, that has 4 elements in it, indicating the x y coordinates of the start point and 
	x y coordinates of the end point of the projection line, if there is one.
 * @param a_isParallel[out] true if the two planes are parallel and thus no projection line exists.
 *
 * @retval S_OK 
 */ 
/*============================================================================*/
STDMETHODIMP CslicesX::ProjectSlice(VARIANT* scoutPosition, 
                                    VARIANT* scoutOrientation, 
                                    VARIANT* scoutPixelSpacing, 
                                    long scoutRows, 
                                    long scoutColumns, 
                                    VARIANT* imagePosition, 
                                    VARIANT* imageOrientation, 
                                    VARIANT* imagePixelSpacing, 
                                    long imageRows, 
                                    long imageColumns,
                                    VARIANT* sliceLine,
                                    double * Angle)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())

   HRESULT
      result = S_OK;
   float
      *pScoutPosition = NULL,
      *pScoutOrientation = NULL,
      *pImagePosition = NULL,
      *pImageOrientation = NULL;
   double
      *pScoutPixelSpacing = NULL,      
      *pImagePixelSpacing = NULL;
   bool
      bRet = false;
   int
      nTopX, nTopY, 
      nBottomX, nBottomY, 
      nLeftX, nLeftY, 
      nRightX, nRightY;
   double
      dLength0,
      dLength1;
   COleSafeArray
      saSliceLine;
   long
      line[4];

   SafeArrayAccessData(scoutPosition->parray, (void**) &pScoutPosition);
   SafeArrayAccessData(scoutOrientation->parray, (void**) &pScoutOrientation);
   SafeArrayAccessData(scoutPixelSpacing->parray, (void**) &pScoutPixelSpacing);
   SafeArrayAccessData(imagePosition->parray, (void**) &pImagePosition);
   SafeArrayAccessData(imageOrientation->parray, (void**) &pImageOrientation);
   SafeArrayAccessData(imagePixelSpacing->parray, (void**) &pImagePixelSpacing);

   bRet = _mslice.ProjectSlice(pScoutPosition,
                               pScoutOrientation,
                               pScoutPixelSpacing, 
                               scoutRows, 
                               scoutColumns,
                               pImagePosition,
                               pImageOrientation,
                               pImagePixelSpacing,
                               imageRows, 
                               imageColumns,
                               NULL,
                               Angle);

   SafeArrayUnaccessData(scoutPosition->parray);
   SafeArrayUnaccessData(scoutOrientation->parray);
   SafeArrayUnaccessData(scoutPixelSpacing->parray);
   SafeArrayUnaccessData(imagePosition->parray);
   SafeArrayUnaccessData(imagePixelSpacing->parray);
   SafeArrayUnaccessData(imageOrientation->parray);


	bRet = (_mslice.getAxisPoints (nTopX, nTopY, nBottomX, nBottomY, nLeftX, nLeftY, nRightX, nRightY));
   if (!bRet)
   {
      goto exit;
   }

   /* Find the lengths of the axes */
   dLength0 = sqrt( (double) ( pow((float)nTopX - nBottomX, 2) + 
                               pow((float)nTopY - nBottomY, 2) ) );

   dLength1 = sqrt( (double) ( pow((float)nLeftX - nRightX, 2) + 
                               pow((float)nLeftY - nRightY, 2) ) );

   /* Find the greater of them and return the coods */
   if (dLength0 >= dLength1)
   {
      line[0] = (long) nTopX;
      line[1] = (long) nTopY;
      line[2] = (long) nBottomX;
      line[3] = (long) nBottomY;
   }
   else
   {
      line[0] = (long) nLeftX;
      line[1] = (long) nLeftY;
      line[2] = (long) nRightX;
      line[3] = (long) nRightY;
   }

   saSliceLine.CreateOneDim(VT_I4, 4, line);
   *sliceLine = saSliceLine.Detach();

exit:
   result = bRet ? S_OK : E_FAIL;

   return result;

}
/*=CslicesX::IntersectLine====================================================*/
/*!
 * 
 * see documentation for CsliceProcessing::ImgCuttingScout 
 * @param *P0X 
 * @param *P0Y 
 * @param *P1X 
 * @param *P1Y 
 * @param *Parallel 
 * @param *Intersect 
 *
 * @retval S_OK 
 */ 
/*============================================================================*/
STDMETHODIMP CslicesX::IntersectLine(short *P0X, short *P0Y, short *P1X, short *P1Y, BOOL *Parallel, BOOL *Intersect)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	return _mslice.ImgCuttingScout(P0X, P0Y, P1X, P1Y, Parallel,Intersect, NULL);
}
