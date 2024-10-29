unit MagROIGlobals;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   March, 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==   unit MagROIGlobals.pas
==]

Note:
}
(*
      ;; +---------------------------------------------------------------------------------------------------+
      ;; Property of the US Government.
      ;; No permission to copy or redistribute this software is given.
      ;; Use of unreleased versions of this software requires the user
      ;;  to execute a written test agreement with the VistA Imaging
      ;;  Development Office of the Department of Veterans Affairs,
      ;;  telephone (301) 734-0100.
      ;;
      ;; The Food and Drug Administration classifies this software as
      ;; a medical device.  As such, it may not be changed
      ;; in any way.  Modifications to this software may result in an
      ;; adulterated medical device under 21CFR820, the use of which
      ;; is considered to be a violation of US Federal Statutes.
      ;; +---------------------------------------------------------------------------------------------------+

*)

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, ToolWin, ExtCtrls, CheckLst, Menus,
  ActiveX, Buttons,
  GearCORELib_TLB,
  GearDISPLAYLib_TLB,
  GearFORMATSLib_TLB,
  GearPDFLib_TLB,
  GearPROCESSINGLib_TLB,
  IGGUIDlgLib_TLB,
  GearVIEWLib_TLB,
  GearDIALOGSLib_TLB,
  GearArtXGUILib_TLB,
  GearArtXLib_TLB;

const	WM_MOUSEMOVE = $200;
	WM_LBUTTONDOWN = $201;
	WM_LBUTTONUP = $202;
	WM_LBUTTONDBLCLK = $203;
	WM_RBUTTONDOWN = $204;
	WM_RBUTTONUP = $205;
	WM_RBUTTONDBLCLK = $206;
var
	igFileDialog: IGFileDlg;
	curDoc: IGDocument;
	curPDFDoc: IGPDFDoc;
  curPDFPage: IGPDFPage;
	LinkAction: IGPDFAction;
	curArtXPage: IGArtXPage;
	curPoint: IGPoint;
	DrawParams: IGArtXDrawParams;
	curFormat: enumIGFormats;
	curPageDisp: IGPageDisplay;
	loadOptions: IGLoadOptions;
	ioLocation: IIGIOLocation;
	currentDir, OpenPassword, PermPassword: AnsiString;

implementation

end.
