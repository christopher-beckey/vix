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
// sliceProcessing.cpp: implementation of the CsliceProcessing class.
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include <math.h>
#include "sliceProcessing.h"



#include "util.h"
#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

using namespace Mgc;


/*=int round==================================================================*/
/*!
 * 
 * round up a double
 * @param x 
 *
 * @retval int
 */ 
/*============================================================================*/
inline int round(double x) { return x > 0 ? int(x+0.5): -int(-x+0.5); }

CsliceProcessing::CsliceProcessing()
{
   _mImgxSpacing = 0;
   _mImgySpacing = 0;
}

CsliceProcessing::~CsliceProcessing()
{

}

/*=CsliceProcessing::ProjectSlice=============================================*/
/*!
 * 
	 the routine receives the coordinate and position information as appears in the DICOM header.  
	 The scout and image positional information is first chacked for correctness. 
	 It is assumed to be correct if the the coordinates contain 3 float numbers separated by '\'
	 The vectors must form a unit vector with each triplet.  Each image orient vector must contain 
	 two triplets
	 The pixel spacing is assumed to be in mm
	 The rows and columns must be > 0
	 The object stores the results of each calculation a new call to project slice will wipe out the results of the previous calculation
	 if any of the positional information is ommitted (null or 0 length string.) the previous value will be used.

 *  This function does not have output parameter since it will just save all the data into internal
	 member variables.
 
 * 
 * @param scoutPos scout image position string.
 * @param scoutOrient scout image orientation string
 * @param scoutPixSpace scout image spacing
 * @param scoutRows number of rows in the scout image
 * @param scoutCols number of columns in the scout image
 * @param imgPos axial image position string
 * @param imgOrient axial image orientation string
 * @param imgPixSpace axial image spacing
 * @param imgRows number of rows in the axial image
 * @param imgCols number of columns in the axial image
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::ProjectSlice(CString scoutPos, 
							   CString scoutOrient, 
							   CString scoutPixSpace, 
							   int scoutRows, 
							   int scoutCols, 
							   CString imgPos, 
							   CString imgOrient, 
							   CString imgPixSpace, 
							   int imgRows, 
							   int imgCols,
								BOOL* a_parallel)
{
	// Having identified a localizer and a list of images whose locations are to be "posted", drawing the appropriate lines: there are two approaches that are 
	// fundamentally different conceptually. One can either determine the intersection between the planes and extents of the localizer and the orthogonal image, 
	// or one can project the boundaries of the orthogonal image onto the plane of the localizer. 
	// The problem with the "intersection" approach is that no such intersection may exist. For example, CT localizers are theoretically of infinite thickness, 
	// they are projections not slices, and hence the concept of intersection does not apply. Even in the case of orthogonal slices, the boundaries of one slice 
	// may not intersect the orthogonal slice at all. The users requirement is really not to show the intersection, but rather to "project" the boundaries of a 
	// slice onto the plane of the localizer, as if it were viewed from a position along the normal to the plane of the localizer. For the purposes of simplicity, 
	// perspective is ignored. Strictly speaking, the projected boundaries form a polygon, but if the slices are truly orthogonal the polygon will appear as a 
	// straight line (which is what most users expect to see). 


	// The approach I use is to perform a parallel projection of the plane and extent
	// of the source slice onto the plane of the target localizer image. One can think
	// of various ways of calculating angles between planes, dropping normals, etc.,
	// but there is a simple approach ...

	// If one considers the localizer plane as a "viewport" onto the DICOM 3D
	// coordinate space, then that viewport is described by its origin, its
	// row unit vector, column unit vector and a normal unit vector (derived
	// from the row and column vectors by taking the cross product). Now if
	// one moves the origin to 0,0,0 and rotates this viewing plane such that
	// the row vector is in the +X direction, the column vector the +Y direction,
	// and the normal in the +Z direction, then one has a situation where the
	// X coordinate now represents a column offset in mm from the localizer's
	// top left hand corner, and the Y coordinate now represents a row offset in
	// mm from the localizer's top left hand corner, and the Z coordinate can be
	// ignored. One can then convert the X and Y mm offsets into pixel offsets
	// using the pixel spacing of the localizer image.

	// This trick is neat, because the actual rotations can be specified entirely
	// using the direction cosines that are the row, column and normal unit vectors,
	// without having to figure out any angles, arc cosines and sines, which octant
	// of the 3D space one is dealing with, etc. Indeed, simplified it looks like:

	//   dst_nrm_dircos_x = dst_row_dircos_y * dst_col_dircos_z - dst_row_dircos_z * dst_col_dircos_y;
	//   dst_nrm_dircos_y = dst_row_dircos_z * dst_col_dircos_x - dst_row_dircos_x * dst_col_dircos_z;
	//   dst_nrm_dircos_z = dst_row_dircos_x * dst_col_dircos_y - dst_row_dircos_y * dst_col_dircos_x;

	//   src_pos_x -= dst_pos_x;
	//   src_pos_y -= dst_pos_y;
	//   src_pos_z -= dst_pos_z;

	//   dst_pos_x = dst_row_dircos_x * src_pos_x
	// 		  + dst_row_dircos_y * src_pos_y
	// 		  + dst_row_dircos_z * src_pos_z;

	//   dst_pos_y = dst_col_dircos_x * src_pos_x
	// 		  + dst_col_dircos_y * src_pos_y
	// 		  + dst_col_dircos_z * src_pos_z;

	//   dst_pos_z = dst_nrm_dircos_x * src_pos_x
	// 		  + dst_nrm_dircos_y * src_pos_y
	// 		  + dst_nrm_dircos_z * src_pos_z;

	// The traditional homogeneous transformation matrix form of this is:

	//   [ dst_row_dircos_x   dst_row_dircos_y   dst_row_dircos_z   -dst_pos_x ]
	//   [                                                                     ]
	//   [ dst_col_dircos_x   dst_col_dircos_y   dst_col_dircos_z   -dst_pos_y ]
	//   [                                                                     ]
	//   [ dst_nrm_dircos_x   dst_nrm_dircos_y   dst_nrm_dircos_z   -dst_pos_z ]
	//   [                                                                     ]
	//   [ 0                  0                  0                  1          ]

	// So this tells you how to transform arbitrary 3D points into localizer pixel
	// offset space (which then obviously need to be clipped to the localizer
	// boundaries for drawing), but which points to draw ?

	// My approach was to project the square that is the bounding box of the source
	// image (i.e. lines joining the TLHC, TRHC,BRHC and BLHC of the slice). That way,
	// if the slice is orthogonal to the localizer the square will project as a single
	// line (i.e. all four lines will pile up on top of each other), and if it is not,
	// some sort of rectangle or trapezoid will be drawn. I rather like the effect and
	// it provides a general solution, though looks messy with a lot of slices with
	// funky angulations. Other possibilities are just draw the longest projected side,
	// draw a diagonal, etc.

	// Anyway, as I mentioned, I am no math whiz, but this approach seems to work
	// for all the cases I have tried. I would be interested to hear if this method
	// is flawed or if anyone has a better solution.

	// Locals
	bool retVal = true;

	/* First step check if either the scout or the image has to be updated.*/

	if (scoutPos && *scoutPos && scoutOrient && *scoutOrient && scoutPixSpace && *scoutPixSpace && scoutRows && scoutCols) {
		// scout parameters appear to be semi-valid try to update the scout information
		if (setScoutPosition(scoutPos) && setScoutOrientation(scoutOrient) && setScoutSpacing(scoutPixSpace)) {
			_mScoutRows = scoutRows;
			_mScoutCols = scoutCols;
			setScoutDimensions();
			retVal = normalizeScout() && normalizeImage();
		}
	}
	/*  Image and scout information is independent of one and other*/
	if (imgPos && *imgPos && imgOrient && *imgOrient && imgPixSpace && *imgPixSpace && imgRows && imgCols) {
		// Img parameters appear to be semi-valid try to update the Img information
		if (setImgPosition(imgPos) && setImgOrientation(imgOrient) && setImgSpacing(imgPixSpace)) {
			_mImgRows = imgRows;
			_mImgCols = imgCols;
			setImgDimensions();
		}
	}
	if (retVal) {
		// start the calculation of the projected bounding box and the ends of the axes along the sides.
		if(a_parallel)
		{
			isScoutAndAxialParallel(a_parallel, NULL);
			if(*a_parallel == TRUE)
			{
				return true;
			}
		}

		calculateBoundingBox();
		calculateAxisPoints();
	}
	return(retVal);

}

/*=CsliceProcessing::getBoundingBox===========================================*/
/*!
 * retreive the calculated bounding box coordinates.
 * 
 * @param &Ulx [out]
 * @param &Uly [out]
 * @param &Urx [out]
 * @param &Ury [out]
 * @param &Llx [out]
 * @param &Lly [out]
 * @param &Lrx [out]
 * @param &Lry [out]
 *
 * @retval bool always true
 */ 
 /*============================================================================*/
bool CsliceProcessing::getBoundingBox(int &Ulx, int &Uly, int &Urx, int &Ury, int &Llx, int &Lly, int &Lrx, int &Lry)
{
	Ulx = _mBoxUlx;
	Uly = _mBoxUly;
	Urx = _mBoxUrx;
	Ury = _mBoxUry;
	Llx = _mBoxLlx;
	Lly = _mBoxLly;
	Lrx = _mBoxLrx;
	Lry = _mBoxLry;
	return (true);

/*=CsliceProcessing::getAxisPoints============================================*/
/*!
 * retreive the axis endpoints
 * 
 * @param &TopX [out]
 * @param &TopY [out]
 * @param &BottomX [out]
 * @param &BottomY [out]
 * @param &LeftX [out]
 * @param &LeftY [out]
 * @param &RightX [out]
 * @param &RightY [out]
 *
 * @retval bool always true
 */ 
/*============================================================================*/}
bool CsliceProcessing::getAxisPoints(int &TopX, int &TopY, int &BottomX, int &BottomY, int &LeftX, int &LeftY, int &RightX, int &RightY)
{
	TopX		= _mAxisTopx;
	TopY		= _mAxisTopy;
	BottomX		= _mAxisBottomx;
	BottomY		= _mAxisBottomy;
	LeftX		= _mAxisLeftx;
	LeftY		= _mAxisLefty;
	RightX		= _mAxisRightx;
	RightY		= _mAxisRighty;
	return(true);
}


/*=CsliceProcessing::setScoutPosition=========================================*/
/*!
 * set the member variables _mScoutx, _mScouty, _mScoutz to the actual position information
	if the input pointer is null or the string is empty set all position to 0 and
	set the position valid flag (_mScoutvalid) to false
 * 
 * @param *Pos input string
 *
 * @retval bool true if the input is valid, false otherwise
 */ 
/*============================================================================*/
bool CsliceProcessing::setScoutPosition(const char *Pos)
{
	bool retVal= true;
	retVal = checkPosString(Pos);
	if (retVal && Pos && *Pos) {
		// the position information contains valid data.  It has been checked prior to
		// the activation of theis member function
		sscanf (Pos, "%f\\%f\\%f", &_mScoutx, &_mScouty, &_mScoutz);
		_mScoutValid = true;
	} else {
		// The Pos contains no valid information it is assumed that the sout position is to be clweared of all valid 
		// entries
		clearScout();
	}
	return (retVal);

}

/*=CsliceProcessing::setScoutOrientation======================================*/
/*!
 * Puts the sout orientation vector into the local variables and check it for validity
 * 
 * @param *Pos 
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::setScoutOrientation(const char *Pos)
{
	bool retVal;
	
	retVal = checkVectorString(Pos);
	if (retVal) {
		sscanf(Pos, "%f\\%f\\%f\\%f\\%f\\%f", &_mScoutRowCosx, &_mScoutRowCosy, &_mScoutRowCosz,
			   &_mScoutColCosx, &_mScoutColCosy, &_mScoutColCosz);
		_mScoutValid = checkScoutVector();
		if (!_mScoutValid) {
			clearScout();
		}
	}
	return (retVal);
}

/*=CsliceProcessing::setImgPosition===========================================*/
/*!
 * set the member variables 
	 _mImgx, _mImgy, _mImgz to the actual position information
	if the input pointer is null or the string is empty set all position to 0 and
	set the position valid flag (_mImgvalid) to false

 * 
 * @param *Pos 
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::setImgPosition(const char *Pos)
{
	bool retVal= true;
	retVal = checkPosString(Pos);
	if (retVal && Pos && *Pos) {
		// the position information contains valid data.  It has been checked prior to
		// the activation of theis member function
		sscanf (Pos, "%f\\%f\\%f", &_mImgx, &_mImgy, &_mImgz);
		_mImgValid = true;
	} else {
		// The Pos contains no valid information it is assumed that the sout position is to be clweared of all valid 
		// entries
		clearImg();
	}
	return (retVal);
}

/*=CsliceProcessing::setImgOrientation========================================*/
/*!
 * Puts the image orientation vactor into the local variables and check it for validity
 * 
 * @param *Pos 
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::setImgOrientation(const char *Pos)
{
	bool retVal;

	retVal = checkVectorString(Pos);
	if (retVal) {
		sscanf(Pos, "%f\\%f\\%f\\%f\\%f\\%f", &_mImgRowCosx, &_mImgRowCosy, &_mImgRowCosz,
			   &_mImgColCosx, &_mImgColCosy, &_mImgColCosz);
		_mImgValid = checkImgVector();
		if (!_mImgValid) {
			clearImg();
		}
	}
	return (retVal);
}

/*=CsliceProcessing::checkScoutVector=========================================*/
/*!
 * check the row vector and check the column vector to make sure it is unit vector
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::checkScoutVector()
{
	bool retVal;

	retVal = checkVector(_mScoutRowCosx, _mScoutRowCosy, _mScoutRowCosz);
	retVal = checkVector(_mScoutColCosx, _mScoutColCosy, _mScoutColCosz);
	return (retVal);
}

/*=CsliceProcessing::checkImgVector===========================================*/
/*!
 * check the row vector and check the column vector to make sure it is a unit vector
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::checkImgVector()
{
	bool retVal;

	retVal = checkVector(_mImgRowCosx, _mImgRowCosy, _mImgRowCosz);
	retVal = checkVector(_mImgColCosx, _mImgColCosy, _mImgColCosz);
	return (retVal);

}

/*=CsliceProcessing::clearScout===============================================*/
/*!
 * clear all the scout parameters and set the scout valid flag to false.
 *
 * @retval none 
 */ 
/*============================================================================*/
void CsliceProcessing::clearScout()
{
	_mScoutRowCosx = 0;
	_mScoutRowCosy = 0;
	_mScoutRowCosz = 0;
	_mScoutColCosx = 0;
	_mScoutColCosy = 0;
	_mScoutColCosz = 0;
	_mScoutx = 0;
	_mScouty = 0;
	_mScoutz = 0;
	_mScoutValid = false;
}

/*=CsliceProcessing::clearImg=================================================*/
/*!
 * clear all the image prameters and set the image valid flag to false.
 *
 * @retval none 
 */ 
/*============================================================================*/
void CsliceProcessing::clearImg()
{
	_mImgRowCosx = 0;
	_mImgRowCosy = 0;
	_mImgRowCosz = 0;
	_mImgColCosx = 0;
	_mImgColCosy = 0;
	_mImgColCosz = 0;
	_mImgx = 0;
	_mImgy = 0;
	_mImgz = 0;
	_mImgValid = false;
}

/*=CsliceProcessing::checkPosString===========================================*/
/*!
 * check if the string contains three valid floating point numbers separated by '\' characters.
 * 
 * @param *Pos 
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::checkPosString(const char *Pos)
{
	char *t1,*t2, *cp;
	bool retVal = true;

	// The firat step in the process is to tokenize the string.  Find the occurances of '\'
	cp = (char*)Pos;
	t1 = strstr(cp, "\\");
	if (t1) {
		t2 = strstr(t1+1, "\\");
		if (t2) {
			// at this point we have found the two "\" string.  T1 points to the firs occurence and t2 point to
			// second occurence of the "\" string.   Check if all the characters point to 
			// valid numberical values [0..9, -,=,.e,E]
			for (cp = (char*)Pos ; *cp; cp++) {
				if ((*cp < '0' ||
					 *cp > '9' ) &&
					*cp != '-' &&
					*cp != '+' &&
					*cp != '.' &&
					*cp != 'e' &&
					*cp != 'E' &&
					*cp != '\\') {
					retVal = false;
				}
			}
		} else {
			// second token was not located
			retVal = false;
		}
	} else {
		// first token was not located
		retVal = false;
	}
	return (retVal);
}

/*=CsliceProcessing::checkVectorString========================================*/
/*!
 * The routine checks if the position string is valid.  To be a valid position string it shall contain 6 
	float numbers separated by '\'.
 * 
 * @param *Pos 
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::checkVectorString(const char *Pos)
{
	char *t[5];  // separators
	int idx;
	char *cp;
	bool retVal = true;
	//  Locate all the separators.  Make sure there are five of them
	if (Pos && *Pos) {
		for (cp = (char*)Pos, idx = 0; idx < 5 ; idx++)  {
			cp = t[idx] = strstr (cp, "\\");
			if (!cp) {
				retVal = false;
				break;
			}
			cp++;
		}
		// check for the valid characters alloved in the Position string [0..9,-,+,.,e,E]
		for (cp = (char*)Pos ; *cp; cp++) {
			if ((*cp < '0' ||
				 *cp > '9' ) &&
				*cp != '-' &&
				*cp != '+' &&
				*cp != '.' &&
				*cp != 'e' &&
				*cp != 'E' &&
				*cp != '\\') {
				retVal = false;
				break;
			}
		}
	}
	return (retVal);
}

/*=CsliceProcessing::checkVector==============================================*/
/*!
 * if the vector passed is a unit vector
 * 
 * @param CosX 
 * @param CosY 
 * @param CosZ 
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::checkVector(float CosX, float CosY, float CosZ)
{
	if (fabs(CosX*CosX+CosY*CosY+CosZ*CosZ) < 1-TOLERANCE) {
		return (false);
	} else {
		return (true);
	}
}


/*=CsliceProcessing::normalizeScout===========================================*/
/*!
 * Based on the values in scout row direction cosines and column direction cosines,
 * set the variables for the direction cosines for the normal to the scout plane.
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::normalizeScout()
{
	// first create the scout normal vector
	_mNrmScoutCosX = _mScoutRowCosy * _mScoutColCosz - _mScoutRowCosz * _mScoutColCosy;
	_mNrmScoutCosY = _mScoutRowCosz * _mScoutColCosx - _mScoutRowCosx * _mScoutColCosz;
	_mNrmScoutCosZ = _mScoutRowCosx * _mScoutColCosy - _mScoutRowCosy * _mScoutColCosx;
	return (checkVector(_mNrmScoutCosX, _mNrmScoutCosY, _mNrmScoutCosZ));
}

/*=CsliceProcessing::setScoutSpacing==========================================*/
/*!
 * Convert the pixelspacing for the scout image and return true if both values are > 0
	the pixel spacing is specified in adjacent row/adjacent column spacing
 * 
 * @param *Spacing 
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::setScoutSpacing(const char *Spacing)
{
	// in this code ..xSpacing refers to column spacing
	sscanf (Spacing, "%f\\%f", &_mScoutySpacing, &_mScoutxSpacing);
	if (_mScoutxSpacing == 0 || _mScoutySpacing == 0) {
		return (false);
	} else {
		return (true);
	}
}

/*=CsliceProcessing::setImgSpacing============================================*/
/*!
 * Convert the pixelspacing for the Img image and return true if both values are > 0
	the pixel spacing is specified in adjacent row/adjacent column spacing
 * 
 * @param *Spacing 
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::setImgSpacing(const char *Spacing)
{
	// in this code ..xSpacing refers to column spacing
	sscanf (Spacing, "%f\\%f", &_mImgySpacing, &_mImgxSpacing);
	if (_mImgxSpacing == 0 || _mImgySpacing == 0) {
		return (false);
	} else {
		return (true);
	}
}

/*=CsliceProcessing::rotateImage==============================================*/
/*!
 * convert the point passed as input into the space of the normalized scout image
 * 
 * @param imgPosx x coordinate of the input point
 * @param imgPosy y coordinate of the input point
 * @param imgPosz z coordinate of the input point
 * @param &scoutPosx [out] x coordinate of the output point
 * @param &scoutPosy [out] y coordinate of the output point
 * @param &scoutPosz [out] z coordinate of the output point
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::rotateImage(float imgPosx, 
							  float imgPosy, 
							  float imgPosz, 
							  float &scoutPosx, 
							  float &scoutPosy, 
							  float &scoutPosz)
{
	// declare local variables.  The code uses the same variables outside to send in values
	// and retrieve the results !
	float x;
	float y;
	float z;

	x = _mScoutRowCosx*imgPosx + _mScoutRowCosy*imgPosy + _mScoutRowCosz*imgPosz;
	y = _mScoutColCosx*imgPosx + _mScoutColCosy*imgPosy + _mScoutColCosz*imgPosz;
	z = _mNrmScoutCosX*imgPosx + _mNrmScoutCosY*imgPosy + _mNrmScoutCosZ*imgPosz;


	scoutPosx = x;
	scoutPosy = y;
	scoutPosz = z;
	return (true);
}


/*=CsliceProcessing::setScoutDimensions=======================================*/
/*!
 * set the member variables for scout row and column length based on number of rows and columns and pixel spacing
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::setScoutDimensions()
{
	_mScoutRowLen =  _mScoutCols* _mScoutxSpacing;
	_mScoutColLen =  _mScoutRows* _mScoutySpacing;
	return(true);
}

/*=CsliceProcessing::setImgDimensions=========================================*/
/*!
 * set the member variables for image row and column length based on number of rows and columns and pixel spacing
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::setImgDimensions()
{
	_mImgRowLen = _mImgCols * _mImgxSpacing;
	_mImgColLen = _mImgRows * _mImgySpacing;
	return(true);
}

/*=CsliceProcessing::calculateBoundingBox=====================================*/
/*!
 * convert the coordinates of upper left, upper rigth, lower left and lower right points of the axial image
 * into coordinates of the 3D space of the scout image.
 *
 * @retval none 
 */ 
/*============================================================================*/
void CsliceProcessing::calculateBoundingBox()
{
	// the four points in 3d space that defines the corners of the bounding box
	float posX[4];
	float posY[4];
	float posZ[4];
	int rowPixel[4];
	int colPixel[4];
	int i;

	// upper left hand Corner
	posX[0] = _mImgx;
	posY[0] = _mImgy;
	posZ[0] = _mImgz;

	// upper right hand corner

	posX[1] = posX[0] + _mImgRowCosx*_mImgRowLen;
	posY[1] = posY[0] + _mImgRowCosy*_mImgRowLen;
	posZ[1] = posZ[0] + _mImgRowCosz*_mImgRowLen;

	// Buttom right hand corner

	posX[2] = posX[1] + _mImgColCosx*_mImgColLen;
	posY[2] = posY[1] + _mImgColCosy*_mImgColLen;
	posZ[2] = posZ[1] + _mImgColCosz*_mImgColLen;
	
	// bottom left hand corner

	posX[3] = posX[0] + _mImgColCosx*_mImgColLen;
	posY[3] = posY[0] + _mImgColCosy*_mImgColLen;
	posZ[3] = posZ[0] + _mImgColCosz*_mImgColLen;

	// Go through all four corners

	for (i = 0; i < 4; i++) {
		// we want to view the source slice from the "point of view" of
		// the target localizer, i.e. a parallel projection of the source
		// onto the target

		// do this by imaging that the target localizer is a view port
		// into a relocated and rotated co-ordinate space, where the
		// viewport has a row vector of +X, col vector of +Y and normal +Z,
		// then the X and Y values of the projected target correspond to
		// row and col offsets in mm from the TLHC of the localizer image !

		// move everything to origin of target
		posX[i] -= _mScoutx;
		posY[i] -= _mScouty;
		posZ[i] -= _mScoutz;

		rotateImage(posX[i], posY[i], posZ[i],posX[i], posY[i], posZ[i]);
		// at this point the position contains the location on the scout image. calculate the pixel position
		// dicom coordinates are center of pixel 1\1
		colPixel[i] = int(posX[i]/_mScoutxSpacing + 0.5);
		rowPixel[i] = int(posY[i]/_mScoutySpacing + 0.5);
	}
	//  sort out the column and row pixel coordinates into the bounding box named coordinates
	// same order as the position ULC -> URC -> BRC -> BLC
	_mBoxUlx = colPixel[0];
	_mBoxUly = rowPixel[0];
	_mBoxUrx = colPixel[1];
	_mBoxUry = rowPixel[1];
	_mBoxLrx = colPixel[2];
	_mBoxLry = rowPixel[2];
	_mBoxLlx = colPixel[3];
	_mBoxLly = rowPixel[3];
}

/*=CsliceProcessing::calculateAxisPoints======================================*/
/*!
 * convert the coordinates of teh uppder center, right hand center, buttom center and left hand center of the axial image plane
 * into coordinates of the 3 D space of the scout image.
 * @retval none 
 */ 
/*============================================================================*/
void CsliceProcessing::calculateAxisPoints()
{

	// the four points in 3d space that defines the corners of the bounding box
	float posX[4];
	float posY[4];
	float posZ[4];
	int rowPixel[4];
	int colPixel[4];
	int i;

	// upper center
	posX[0] = _mImgx + _mImgRowCosx*_mImgRowLen/2;
	posY[0] = _mImgy + _mImgRowCosy*_mImgRowLen/2;
	posZ[0] = _mImgz + _mImgRowCosz*_mImgRowLen/2;

	// right hand center

	posX[1] = _mImgx + _mImgRowCosx*_mImgRowLen + _mImgColCosx*_mImgColLen/2;
	posY[1] = _mImgy + _mImgRowCosy*_mImgRowLen + _mImgColCosy*_mImgColLen/2;
	posZ[1] = _mImgz + _mImgRowCosz*_mImgRowLen + _mImgColCosz*_mImgColLen/2;

	// Buttom center

	posX[2] = posX[0] + _mImgColCosx*_mImgColLen;
	posY[2] = posY[0] + _mImgColCosy*_mImgColLen;
	posZ[2] = posZ[0] + _mImgColCosz*_mImgColLen;
	
	// left hand center

	posX[3] = _mImgx + _mImgColCosx*_mImgColLen/2;
	posY[3] = _mImgy + _mImgColCosy*_mImgColLen/2;
	posZ[3] = _mImgz + _mImgColCosz*_mImgColLen/2;

	// Go through all four corners

	for (i = 0; i < 4; i++) {
		// we want to view the source slice from the "point of view" of
		// the target localizer, i.e. a parallel projection of the source
		// onto the target

		// do this by imaging that the target localizer is a view port
		// into a relocated and rotated co-ordinate space, where the
		// viewport has a row vector of +X, col vector of +Y and normal +Z,
		// then the X and Y values of the projected target correspond to
		// row and col offsets in mm from the TLHC of the localizer image !

		// move everything to origin of target
		posX[i] -= _mScoutx;
		posY[i] -= _mScouty;
		posZ[i] -= _mScoutz;

		rotateImage(posX[i], posY[i], posZ[i],posX[i], posY[i], posZ[i]);
		// at this point the position contains the location on the scout image. calculate the pixel position
		// dicom coordinates are center of pixel 1\1
		colPixel[i] = int(posX[i]/_mScoutxSpacing + 0.5);
		rowPixel[i] = int(posY[i]/_mScoutySpacing + 0.5);
	}
	//  sort out the column and row pixel coordinates into the bounding box axis named coordinates
	// same order as the position top -> right -> bottom -> left
	_mAxisTopx		= colPixel[0];
	_mAxisTopy		= rowPixel[0];
	_mAxisRightx	= colPixel[1];
	_mAxisRighty	= rowPixel[1];
	_mAxisBottomx	= colPixel[2];
	_mAxisBottomy	= rowPixel[2];
	_mAxisLeftx		= colPixel[3];
	_mAxisLefty		= rowPixel[3];
}

/*=CsliceProcessing::ProjectSlice=============================================*/
/*!
 * similar to the other ProjectSlice method except for different parameter types.
 * This function does not have output parameter since it will just save all the data into internal
	member variables.
 * @param *a_fScoutPosition an array of float number indicating scout image position
 * @param *a_fScoutOrientation an array of float numbers indicating scout image orientation
 * @param *a_fScoutPixelSpacing an array of scout image spacing
 * @param a_nScoutRows number of rows in the scout image
 * @param a_nScoutColumns number of columns in the scout image
 * @param *a_fImagePosition an array of float numbers indicating axial image position string
 * @param *a_fImageOrientation an array of float numbers indicating axial image orientation string
 * @param *a_fImagePixelSpacing an array of axial image spacing
 * @param a_nImageRows number of rows in the axial image
 * @param a_nImageColumns number of columns in the axial image
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::ProjectSlice(float *a_fScoutPosition, 
                                    float *a_fScoutOrientation, 
                                    double *a_fScoutPixelSpacing,
                                    long a_nScoutRows, 
                                    long a_nScoutColumns,
                                    float *a_fImagePosition, 
                                    float *a_fImageOrientation, 
                                    double *a_fImagePixelSpacing,                                    
                                    long a_nImageRows, 
                                    long a_nImageColumns,
												BOOL* a_parallel,
                                    double *a_pAngle)
{
	_mScoutx = a_fScoutPosition[0];
	_mScouty = a_fScoutPosition[1];
	_mScoutz = a_fScoutPosition[2];

	_mScoutRowCosx = a_fScoutOrientation[0];
	_mScoutRowCosy = a_fScoutOrientation[1];
	_mScoutRowCosz = a_fScoutOrientation[2];
	_mScoutColCosx = a_fScoutOrientation[3];
	_mScoutColCosy = a_fScoutOrientation[4];
	_mScoutColCosz = a_fScoutOrientation[5];

	_mScoutySpacing = (float) a_fScoutPixelSpacing[0];
	_mScoutxSpacing = (float) a_fScoutPixelSpacing[1];

	_mScoutRows = a_nScoutRows;
	_mScoutCols = a_nScoutColumns;

	_mImgx = a_fImagePosition[0];
	_mImgy = a_fImagePosition[1];
	_mImgz = a_fImagePosition[2];

	_mImgRowCosx = a_fImageOrientation[0];
	_mImgRowCosy = a_fImageOrientation[1];
	_mImgRowCosz = a_fImageOrientation[2];
	_mImgColCosx = a_fImageOrientation[3];
	_mImgColCosy = a_fImageOrientation[4];
	_mImgColCosz = a_fImageOrientation[5];

	_mImgySpacing = (float) a_fImagePixelSpacing[0];
	_mImgxSpacing = (float) a_fImagePixelSpacing[1];

	_mImgRows = a_nImageRows;
	_mImgCols = a_nImageColumns;


   isScoutAndAxialParallel(a_parallel, a_pAngle);

   setScoutDimensions();
	if (!normalizeScout() || !normalizeImage())
   {
      return false;
   }

   setImgDimensions();
	
	if(a_parallel)
	{
		isScoutAndAxialParallel(a_parallel, NULL);
		if(*a_parallel == TRUE)
		{
			return true;
		}
	}
	calculateBoundingBox();
	calculateAxisPoints();

   return true;
}

/*=CsliceProcessing::normalizeImage============================================*/
/*!
 * calculate the normal to the image and assign resultant values to corresponding member variables.
 *
 * @retval bool 
 */ 
/*============================================================================*/
bool CsliceProcessing::normalizeImage()
{
	_mNrmImgCosX = _mImgRowCosy * _mImgColCosz - _mImgRowCosz * _mImgColCosy;
	_mNrmImgCosY = _mImgRowCosz * _mImgColCosx - _mImgRowCosx * _mImgColCosz;
	_mNrmImgCosZ = _mImgRowCosx * _mImgColCosy - _mImgRowCosy * _mImgColCosx;
	return (checkVector(_mNrmImgCosX, _mNrmImgCosY, _mNrmImgCosZ));
}

/*=CsliceProcessing::ImgCuttingScout==========================================*/
/*!
 * To call this function, you need to first call method Project of the interface, which will initialize all the related member vairables in this object
 * Note:	1)	Please do NOT assume P0X<=P1X or P0Y<=P1Y
 *			2)	When the two image planes intersect at one point only, P0X equals to P1X and P0Y equals P1Y

 * 
 * @param *P0X an [out] value for the x coordinate of the first point	
 * @param *P0Y an [out] value for the y coordinate of the first point
 * @param *P1X an [out] value for the x coordinate of the second point
 * @param *P1Y an [out] value for the y coordinate of the second point
 * @param *Parallel an [out] value, set to true if the normal of the two planes are parallel, false otherwise
 * @param *Intersect an [out] value to indicate whether the two planes intersect. P0X, P0Y, P1X, P1Y would only have valid values when Intersect is 
		true and Parallel is false. When both *Parallel and *Intercept are true, the image plane is on the scout plane and there are infinite number of 
		interception line segments.
 *
 * @retval S_OK 
 */ 
/*============================================================================*/
HRESULT CsliceProcessing::ImgCuttingScout(short *P0X, short *P0Y, short *P1X, short *P1Y, BOOL *Parallel, BOOL *Intersect, double *Angle)
{
	//=============================================================================================
	//Suppose angle theta is the angle between the normals of two planes
	//=============================================================================================

	isScoutAndAxialParallel(Parallel, Angle);
	// the four points in 3d space that defines the corners of the bounding box of the img plane of the slice.
	float posX[4];
	float posY[4];
	float posZ[4];
	int i;

	// upper left hand Corner
	posX[0] = _mImgx;
	posY[0] = _mImgy;
	posZ[0] = _mImgz;

	// upper right hand corner

	posX[1] = posX[0] + _mImgRowCosx*_mImgRowLen;
	posY[1] = posY[0] + _mImgRowCosy*_mImgRowLen;
	posZ[1] = posZ[0] + _mImgRowCosz*_mImgRowLen;

	// Buttom right hand corner

	posX[2] = posX[1] + _mImgColCosx*_mImgColLen;
	posY[2] = posY[1] + _mImgColCosy*_mImgColLen;
	posZ[2] = posZ[1] + _mImgColCosz*_mImgColLen;
	
	// bottom left hand corner

	posX[3] = posX[0] + _mImgColCosx*_mImgColLen;
	posY[3] = posY[0] + _mImgColCosy*_mImgColLen;
	posZ[3] = posZ[0] + _mImgColCosz*_mImgColLen;

	// Go through all four corners

	for (i = 0; i < 4; i++) {
		// we want to view the source slice from the "point of view" of
		// the target localizer, i.e. a parallel projection of the source
		// onto the target

		// do this by imaging that the target localizer is a view port
		// into a relocated and rotated co-ordinate space, where the
		// viewport has a row vector of +X, col vector of +Y and normal +Z,


		// move everything to origin of target
		posX[i] -= _mScoutx;
		posY[i] -= _mScouty;
		posZ[i] -= _mScoutz;

		rotateImage(posX[i], posY[i], posZ[i],posX[i], posY[i], posZ[i]);
		// at this point the position contains the location on the scout image. 

		//calculate the pixel position
		// dicom coordinates are center of pixel 1\1 //comment out from the code where i copied this
		//colPixel[i] = int(posX[i]/_mScoutxSpacing + 0.5);
		//rowPixel[i] = int(posY[i]/_mScoutySpacing + 0.5);
	}

	//Note now we talk in term of the transformed coordinate.
	//so the scout image plane's row vector directon cosines are 1,0,0,  column direction cosines are 0,1,0
	//and normal's direction cosines are 0,0,1 the origin of image plane is 0,0,0
	
	/*	process all cases of parallel */
	if( (*Parallel) == TRUE)
	{
		if( fabs(posZ[0]) < TOLERANCE &&
			fabs(posZ[1]) < TOLERANCE &&
			fabs(posZ[2]) < TOLERANCE &&
			fabs(posZ[3]) < TOLERANCE)
		{
			*Intersect=true;
		}
		else
		{
			*Intersect=false;
		}
		return S_OK;
	}

	//do the following so as not to go through the calculation process for some obvious cases, making it faster. So the only function of next segment is for speed.
	//If all the vertexes are above or below the plane formed by x andy axis, then no intersection point.
	if((posZ[0]>0&&(posZ[1]>0&&posZ[2]>0&&posZ[3]>0))  ||
		(posZ[0]<0&&(posZ[1]<0&&posZ[2]<0&&posZ[3]<0))	)
	{
		*Intersect=false;
		return S_OK;
	}

// vertex0	=========	vertex1	
//			=		=
//			=		=
// vertex3	=========	vertex2
//Calculate the intersections between the four edges and the boundless plane the scout image is residing in.

	Vector3 intersect;
	Vector3 vertex0(posX[0],posY[0],posZ[0]);
//	ATLTRACE("vertex0	x %f,  y  %f,  z  %f\n",vertex0.x,vertex0.y,vertex0.z);
	
	Vector3 vertex1(posX[1],posY[1],posZ[1]);
//	ATLTRACE("vertex1	x %f,  y  %f,  z  %f\n",vertex1.x,vertex1.y,vertex1.z);

	Vector3 vertex2(posX[2],posY[2],posZ[2]);
//	ATLTRACE("vertex2	x %f,  y  %f,  z  %f\n",vertex2.x,vertex2.y,vertex2.z);

	Vector3 vertex3(posX[3],posY[3],posZ[3]);
//	ATLTRACE("vertex3	x %f,  y  %f,  z  %f\n",vertex3.x,vertex3.y,vertex3.z);

	bool startFound=false;
	bool endFound=false;
	Vector3 segStart;//intersection line segment between img slice bounding box and scout boundless plane.
	Vector3 segEnd;

	/*	4 cases when only one line segment is totally on the scout plane */
	if( (fabs(posZ[0]) < TOLERANCE && fabs(posZ[1]) < TOLERANCE && fabs(posZ[2]) > TOLERANCE && fabs(posZ[3]) > TOLERANCE))
	{
		*Intersect = true;
		startFound = true;
		endFound = true;
		segStart = vertex0;
		segEnd = vertex1;
	}else if( (fabs(posZ[1]) < TOLERANCE && fabs(posZ[2]) < TOLERANCE && fabs(posZ[3]) > TOLERANCE && fabs(posZ[0]) > TOLERANCE))
	{
		*Intersect = true;
		startFound = true;
		endFound = true;
		segStart = vertex1;
		segEnd = vertex2;
	}else	if( (fabs(posZ[2]) < TOLERANCE && fabs(posZ[3]) < TOLERANCE && fabs(posZ[0]) > TOLERANCE && fabs(posZ[1]) > TOLERANCE))
	{
		*Intersect = true;
		startFound = true;
		endFound = true;
		segStart = vertex2;
		segEnd = vertex3;
	}else	if( (fabs(posZ[3]) < TOLERANCE && fabs(posZ[0]) < TOLERANCE && fabs(posZ[1]) > TOLERANCE && fabs(posZ[2]) > TOLERANCE))
	{
		*Intersect = true;
		startFound = true;
		endFound = true;
		segStart = vertex3;
		segEnd = vertex0;
	}
	else
	{
		/*	process none of the above case */
		int testResult=CalLineSegAndBoundlessPlaneIntersection(vertex0,vertex1,intersect);
		/*function should not return -1, because if you come here you are not in the situation
			that only one edge in on the plane
		*/
		if(testResult==1)
		{	segStart=intersect;
			startFound=true;
		}

		testResult=CalLineSegAndBoundlessPlaneIntersection(vertex1,vertex2,intersect);
		if(testResult==1 && !SUCCEEDED(findSegEnds(intersect,startFound,endFound,segStart,segEnd)))
		{	return E_FAIL;
		}

		testResult=CalLineSegAndBoundlessPlaneIntersection(vertex2,vertex3,intersect);
		if(testResult==1 && !SUCCEEDED(findSegEnds(intersect,startFound,endFound,segStart,segEnd)))
		{	return E_FAIL;
		}

		testResult=CalLineSegAndBoundlessPlaneIntersection(vertex0,vertex3,intersect);
		if(testResult==1 && !SUCCEEDED(findSegEnds(intersect,startFound,endFound,segStart,segEnd)))
		{	return E_FAIL;
		}

		if(startFound==false)
		{	*Intersect=false;
			return S_OK;
		}
	}

	/*	now stop thinking the scout plane as boundless */
	if(startFound==true && endFound==false)//startFound will always be the first to be true
	{//in this case only segStart has valid values;
		if(pointInsideScoutSlice(Vector2(segStart.x,segStart.y)))
		{
			*Intersect=true;
			*P0X=*P1X=round(segStart.x/_mScoutxSpacing );
			*P0Y=*P1Y=round(segStart.y/_mScoutySpacing );
		}
		else 
			*Intersect=false;
		return S_OK;
	}
	
/////////////////////////////////////////////////////////////////////
//if you come here both startFound and endFound are true
/////////////////////////////////////////////////////////////////////

	//if both segment ends are inside the scout image bounding box, then the whole segment is. I do this test here jsut to avoid expensive calculation.
	if(pointInsideScoutSlice(Vector2(segStart.x,segStart.y)) && pointInsideScoutSlice(Vector2(segEnd.x,segEnd.y)) )
	{	//set the pixel coordinate
		*P0X= round(segStart.x/_mScoutxSpacing);
		*P0Y= round(segStart.y/_mScoutySpacing);
		*P1X= round(segEnd.x/_mScoutxSpacing);
		*P1Y= round(segEnd.y/_mScoutySpacing);
		*Intersect=true;
		return S_OK;		
	}

	//if you are here then only one ending point of the segment is in the scout image box
	//or both two of them are outside. Use Liang Barsky algorithm to clip the line segment between segStart and segEnd
	int new_x1,new_y1,new_x2,new_y2;
	if(CUtil::cohen_clip_a_line(0,0,round(_mScoutRowLen),round(_mScoutColLen),round(segStart.x),round(segStart.y),round(segEnd.x),round(segEnd.y),new_x1,new_y1,new_x2,new_y2))
	{	
		*Intersect=true;
		*P0X=round(new_x1/_mScoutxSpacing);
		*P0Y=round(new_y1/_mScoutySpacing);
		*P1X=round(new_x2/_mScoutxSpacing);
		*P1Y=round(new_y2/_mScoutySpacing);
	}else{
		*Intersect=false;
	}

	return S_OK;
}


/*=CsliceProcessing::CalLineSegAndBoundlessPlaneIntersection==================================*/
/*!
 *
	This function woul calculate the intersection point between a line segment and a BOUNDLESS plane formed by x and y axis.
 * 
 * @param P1 vertex 1 of the line segment
 * @param P2 vertex 2 of the line segment
 * @param interSect1 [out] the point of intersection when return value is 1.
 *
 * @retval int 	return value:	
						-1 for when segment in the plane.
						0 for 2 cases	
								1) segment parallel,not touch the plane 
								2) segment not parallel, not in the plane, but not touching the plane
						1 for one intersecting point. Only in this case, interSect1 has a valid value
 */ 
 /*============================================================================*/
int CsliceProcessing::CalLineSegAndBoundlessPlaneIntersection(Vector3 P1, Vector3 P2, Vector3& interSect1)
{
/*
The equation of a plane (points P are on the plane with normal N and point P3 on the plane) can be written as
N dot (P - P3) = 0

The equation of the line (points P on the line passing through points P1 and P2) can be written as
P = P1 + u (P2 - P1)

The intersection of these two occurs when
N dot (P1 + u (P2 - P1)) = N dot P3

  Solving for u gives
  u= N dot(P3 - P1)
	---------------
	 N dot(P2 - P1)

Note

If the denominator is 0 then the normal to the plane is perpendicular to the line. Thus the line is either parallel to the plane and there are 
	no solutions or the line is on the plane in which case there are an infinite number of solutions
If it is necessary to determine the intersection of the line segment between P1 and P2 then just check that u is between 0 and 1.
*/
	Vector3 N=Vector3::UNIT_Z;
	Vector3 P3(0,0,0);
	if (P1.z == P3.z && P2.z == P3.z) //overloaded == operator
	{	/*	the line segment is on the scout plane */
		return -1;
	}

	float N_dot_P3minusP1=N.Dot(P3-P1);
	float N_dot_P2minusP1=N.Dot(P2-P1);
	if(N_dot_P2minusP1==0)
	{
		return 0;
	}
	float u=N_dot_P3minusP1/N_dot_P2minusP1;
	if(u>1 || u<0)
		return 0;
	Vector3 P;
	P=P1+u*(P2-P1);
	interSect1=P;
	return 1;

/*=CsliceProcessing::pointInsideScoutSlice====================================*/
/*!
 * To see whether a point is in the rectangle of the scout image. This is a 2 D calculation.
 * 
 * @param point a 2D vector representing a point in 2D coordinate.
 *
 * @retval bool true if the point is in, and false otherwise.
 */ 
/*============================================================================*/}
bool CsliceProcessing::pointInsideScoutSlice(Vector2 point)
{
	if(point.x<=_mScoutRowLen && point.y<=_mScoutColLen)//xxxx
		return true;
	else
		return false;
}

/*=CsliceProcessing::findSegEnds==============================================*/
/*!
 * This method is to deal with the case when one vertex of the image slice is on the scout slice, then two calls of CalSegPlaneIntersection
 *	will return two. And if two diagonal vertexes of the image slice are on the scout slice, then all four calls of CalSegPlaneIntersection will return true.
 * 
 * @param _intersect [in] the newly found interception point between one line segment and the scout plane.
 * @param &_startFound [in,out]	true if segment start is found
 * @param &_endFound [in,out] true if segment end is found
 * @param &_segStart [in,out] segment start if segment start is found
 * @param &_segEnd [in,out] segment end if segment end is found
 *
 * @retval S_OK 
 */ 
/*============================================================================*/
HRESULT CsliceProcessing::findSegEnds(Vector3 _intersect, bool &_startFound, bool &_endFound, Vector3 &_segStart, Vector3 &_segEnd)
{
	if(_startFound==false)
	{	_segStart=_intersect;
		_startFound=true;
	}
	else
	{//_startFound==true

//the comparison is to deal with the case when one vertex of the image slice is on the scout slice, then two calls of CalSegPlaneIntersection
//will return two. And if two diagonal vertexes of the image slice are on the scout slice, then all four calls of CalSegPlaneIntersection will return true.
		if(! (_segStart==_intersect))//the equal sign has been overloaded so it will take into consideration of comparing floats.
		{
			if(_endFound==false)
			{
				_segEnd=_intersect;
				_endFound=true;
			}
			else
			{
				if((_segEnd!=_intersect) && (_segStart!=_intersect))
					return E_FAIL;
			}
		}
	}
	return S_OK;
}

void CsliceProcessing::isScoutAndAxialParallel(BOOL* Parallel, double* pAngle)
{
	//Use dot product to find the angle between two vectors.	
	//Theoretically to get the cosine_theta we need to do Dot(Vector_imgNml, Vector_scoutNml)/(|Vector_imgNrm| x |Vector_scoutNrm|)
	//but since we use direction cosines to represent those vectors, the vector's length is always 1
	float cosine_theta = (_mNrmImgCosX*_mNrmScoutCosX + _mNrmImgCosY*_mNrmScoutCosY + _mNrmImgCosZ*_mNrmScoutCosZ)/(1*1);
	
   if (Parallel) 
   {
      //if (fabs(cosine_theta)   >= TOLERANCE)
      if (fabs(cosine_theta)   >= 0.97)
	   {
		   *Parallel=true;
	   }
	   else
	   {
		   *Parallel=false;
	   }
   }

   if (pAngle) 
   {
      *pAngle = cosine_theta;
   }

}
