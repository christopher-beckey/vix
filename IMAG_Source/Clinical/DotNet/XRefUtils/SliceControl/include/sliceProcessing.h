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
// sliceProcessing.h: interface for the CsliceProcessing class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SLICEPROCESSING_H__952C43F4_6A25_11D3_BACB_00A0C95655DB__INCLUDED_)
#define AFX_SLICEPROCESSING_H__952C43F4_6A25_11D3_BACB_00A0C95655DB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "MgcVector3.h"
#include "MgcVector2.h"
//##ModelId=3A6C889E01A3
class CsliceProcessing  
{
public:
	static HRESULT findSegEnds(Mgc::Vector3 _intersect,bool & _startFound, bool & _endFound, Mgc::Vector3 & _segStart, Mgc::Vector3 & _segEnd);
	bool pointInsideScoutSlice(Mgc::Vector2 point);
	static int CalLineSegAndBoundlessPlaneIntersection(Mgc::Vector3 P1,Mgc::Vector3 P2,Mgc::Vector3 & interSect1);//, Mgc::Vector3 & interSect2);
   bool ProjectSlice(float *a_fScoutPosition, 
                     float *a_fScoutOrientation, 
                     double *a_fScoutPixelSpacing,
                     long a_nScoutRows, 
                     long a_nScoutColumns,
                     float *a_fImagePosition, 
                     float *a_fImageOrientation, 
                     double *a_fImagePixelSpacing,                                    
                     long a_nImageRows, 
                     long a_nImageColumns,
							BOOL* a_parallel = NULL,
                     double *a_pAngle = NULL);
	bool ProjectSlice(CString scoutPos, 
							   CString scoutOrient, 
							   CString scoutPixSpace, 
							   int scoutRows, 
							   int scoutCols, 
							   CString imgPos, 
							   CString imgOrient, 
							   CString imgPixSpace, 
							   int imgRows, 
							   int imgCols,
								BOOL* a_parallel = NULL);
	
	CsliceProcessing();
	
	virtual ~CsliceProcessing();
	
	bool getAxisPoints (int &TopX, int &TopY, int &BottomX, int &BottomY, int &LeftX, int &LeftY, int &RightX, int &RightY);
	
	bool getBoundingBox (int &Ulx, int &Uly, int &Urx, int &Ury, int &Llx, int &Lly, int &Lrx, int &Lry);
	
	HRESULT ImgCuttingScout(short *P0X, short *P0Y, short *P1X, short *P1Y, BOOL *Parallel, BOOL *Intersect, double *Angle);
private:
	void isScoutAndAxialParallel(BOOL*, double*);
	bool normalizeImage();

	void calculateAxisPoints(void);

	void calculateBoundingBox(void);

	bool setImgDimensions(void);

	bool setScoutDimensions(void);

	bool rotateImage(float imgPosx, float imgPosy, float imgPosz, float &scoutPosx, float &scoutPosy, float &scoutPosz);

	bool setImgSpacing(const char* Spacing);

	bool setScoutSpacing(const char* Spacing);

	bool normalizeScout(void);

	bool setImgOrientation(const char* Pos);

	bool setImgPosition (const char* Pos);

	bool checkImgVector(void);

	void clearImg(void);

	void clearScout(void);

	bool checkVector(float CosX, float CosY, float CosZ);

	bool checkScoutVector(void);

	bool setScoutOrientation (const char* Pos);

	bool checkVectorString (const char* Pos);

	bool checkPosString(const char* Pos);

	bool setScoutPosition(const char* Pos);
	//	scout parameters
	/*!
	 * internal flag indicating whether scout related data is valid
	 */
	bool   _mScoutValid;

	/*!
	 * member variable for scout image position
	 */
	float _mScoutx;

	/*!
	 * member variable for scout image position
	 */
	float _mScouty;

	/*!
	 * member variable for scout image position
	 */
	float _mScoutz;
	
	/*!
	 * scout image row direction cosine
	 */
	float _mScoutRowCosx;

	/*!
	 * scout image row direction cosine
	 */
	float _mScoutRowCosy;

	/*!
	 * scout image row direction cosine
	 */
	float _mScoutRowCosz;

	/*!
	 * scout image column direction cosine
	 */
	float _mScoutColCosx;

	/*!
	 * scout image column direction cosine
	 */
	float _mScoutColCosy;

	/*!
	 * scout image column direction cosine
	 */
	float _mScoutColCosz;
	
	/*!
	 * scout column spacing
	 */
	float _mScoutxSpacing;
	
	/*!
	 * scout row spacing
	 */
	float _mScoutySpacing;
	
	/*!
	 * length of scout row based on number of columns and column spacing.
	 */
	float _mScoutRowLen;
	
	/*!
	 * length of scout column based on number of rows and row spacing.
	 */
	float _mScoutColLen;

	/*!
	 * scout image number of rows
	 */
	int	   _mScoutRows;

	/*!
	 * scout image number of columns
	 */
	int    _mScoutCols;


	// Image parameters
	/*!
	 * internal flag indicating whether axial image related data is valid
	 */
	bool   _mImgValid;
	
	/*!
	 * member variable for axial image position
	 */
	float _mImgx;
	
	/*!
	 * member variable for axial image position
	 */
	float _mImgy;
	
	/*!
	 * member variable for axial image position
	 */
	float _mImgz;

	/*!
	 * axial image row direction cosine
	 */
	float _mImgRowCosx;

	/*!
	 * axial image row direction cosine
	 */
	float _mImgRowCosy;

	/*!
	 * axial image row direction cosine
	 */
	float _mImgRowCosz;

	/*!
	 * axial image column direction cosine
	 */
	float _mImgColCosx;
	
	/*!
	 * axial image column direction cosine
	 */
	float _mImgColCosy;

	/*!
	 * axial image column direction cosine
	 */
	float _mImgColCosz;
	
	/*!
	 * axial image column spacing
	 */
	float _mImgxSpacing;
	
	/*!
	 * axial image row spacing
	 */
	float _mImgySpacing;

	/*!
	 * length of axial image row based on number of columns and column spacing.
	 */	
	float _mImgRowLen;

	/*!
	 * length of axial image column based on number of columns and column spacing.
	 */
	float _mImgColLen;

	/*!
	 * axial image number of rows
	 */
	int	   _mImgRows;
	
	/*!
	 * axial image number of columns
	 */
	int    _mImgCols;

	// normal vector
	/*!
	 * direction cosine of the normal to scout image
	 */
	float _mNrmScoutCosX;

	/*!
	 * direction cosine of the normal to scout image
	 */
	float _mNrmScoutCosY;

	/*!
	 * direction cosine of the normal to scout image
	 */
	float _mNrmScoutCosZ;

	//bounding box data 
	/*!
	 *In a new coordinate where the first row of scout is +X, first column of scout is +Y, the following members hold the bounding box of the axial image.
	  This is x of upper left corner.
	 */
	int _mBoxUlx;
	
	/*!
	 * y of the upper left corner.
	 */
	int _mBoxUly;
	
	/*!
	 * x of teh upper right corner
	 */
	int _mBoxUrx;
	
	/*!
	 * y of the upper right corner
	 */
	int _mBoxUry;
	
	/*!
	 * x of the lower left corner
	 */
	int _mBoxLlx;
	
	/*!
	 * y of the lower left corner
	 */
	int _mBoxLly;
	
	/*!
	 * x of the lower right corner
	 */
	int _mBoxLrx;
	
	/*!
	 * y of the lower right corner
	 */
	int _mBoxLry;

	//axis data
	/*!
	 *In a new coordinate where the first row of scout is +X, first column of scout is +Y, the following members hold the axis information of the axial image.
	 The horizontal axis is the line segment from top middle point to bottom middle point.
	 The vertical axis is the line segmetn from the left middle point to the right middle point
	  This is x of the top middle point.
	 */
	int _mAxisTopx;
	
	/*!
	 * y of the top middle point
	 */
	int _mAxisTopy;
	
	/*!
	 * x of the left middle point
	 */
	int _mAxisLeftx;
	
	/*!
	 * y of the left middle point
	 */
	int _mAxisLefty;
	
	/*!
	 * x of the bottom middle point
	 */
	int _mAxisBottomx;
	
	/*!
	 * y of the bottom middle point
	 */
	int _mAxisBottomy;
	
	/*!
	 * x of the right middle point
	 */
	int _mAxisRightx;
	
	/*!
	 * y of teh right middle point
	 */
	int _mAxisRighty;

/*!
 * direction cosine of the normal to axial image plane
 */
	float _mNrmImgCosX;

/*!
 * direction cosine of the normal to axial image plane
 */
	float _mNrmImgCosY;

/*!
 * direction cosine of the normal to axial image plane
 */
	float _mNrmImgCosZ;
};

#endif // !defined(AFX_SLICEPROCESSING_H__952C43F4_6A25_11D3_BACB_00A0C95655DB__INCLUDED_)
