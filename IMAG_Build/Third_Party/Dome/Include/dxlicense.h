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
#ifndef _DIMPLXLICENSE_H
#define _DIMPLXLICENSE_H

// License string for distribution with source code

//
// Replace the empty string below with the license string
// from the first line of your license file, "DimplX.lic".
// The result will look something like the following:
//
// #define DIMPLX_LICENSE L"01|DimplX|Valued Customer|DF;;12/31/2035|DF;;12/31/2035|01-0123-4567-89ab-cdef"
//
// Note that the string shown above is NOT a valid license string.
//

#ifndef DIMLPXV44
   #define DIMPLX_LICENSE L"40|DimplX|Veterans Administration CIO Field Office|DF;;12/31/2035|DF;;12/31/2035|40-06f7-7aaf-0afe-84fa"
#else
   #define DIMPLX_LICENSE L"44|DimplX|Veterans Administration CIO Field Office|DF;;12/31/2035|DF;;12/31/2035|44-089b-5786-9dc7-bc07"
   #define DIMPLX_LICENSE_STR "44|DimplX|Veterans Administration CIO Field Office|DF;;12/31/2035|DF;;12/31/2035|44-089b-5786-9dc7-bc07"
#endif

#endif
