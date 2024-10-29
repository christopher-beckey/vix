unit uMagDCMLoadFile;
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+

*)
interface
uses
Windows, Messages, SysUtils, Classes, Graphics, Controls,
Forms, Dialogs, comctrls, GearFORMATSLib_TLB, AxCtrls, GearVIEWLib_TLB,
GearDISPLAYLib_TLB, GearPROCESSINGLib_TLB, OleCtrls, GearCORELib_TLB,
GearDIALOGSLib_TLB, comobj, GearMEDLib_TLB, uMagRMakeAbsError;{MEDXLib_TLB,}
{GEARLib_TLB,} {DataDict, dcm, geardef, geardef7,}  {magriimage, magrgeartrans}

Procedure LoadImageWithHDR;

//type

//end;
//var

implementation

uses frmMagMakeAbsMainForm;

Procedure LoadImageWithHDR;
var
adjustmentdone: boolean;
//currentMedPage: IGMedPage;
pContrast: IGMedContrast;
//MedContrast: IGMedContrast;
//MedDataDict: IGMedDataDict;
//MinMax: IGMedMinMax;

begin
adjustmentdone := false;
//If ((adicomrec[winnum].Window_Center > 0) or (adicomrec[winnum].window_width > 0)) then
//        begin

//frmMagMakeAbsMainForm.IGMeddisplay.AdjustContrastAutoFrom(pContrast As IGMedContrast);
//pcontrast := frmMMagMakeAbsMainForm.medpage.Display.GetContrastAttrs;
pContrast.WindowCenter := 4096;
pContrast.WindowWidth := 1024;
//frmMagMakeAbsMain.medpage.Display.AdjustContrastAutoFrom(pcontrast);
frmMagMakeAbsMain.IGPageViewCtl1.UpdateView;

//        window_wid := adicomrec[winnum].window_width;
//        window_cen := adicomrec[winnum].window_center;
//        If adicomrec[winnum].haunsfield <> 0 then
//          begin
//          window_wid := adicomrec[winnum].window_width; {RED 03/02/03}
//          window_cen := adicomrec[winnum].window_center - adicomrec[winnum].haunsfield;
//          end; {end haunsfield adjustment}
//        setwindowlevel(adicomrec[winnum].gearcontrol, adicomrec[winnum].medcontrol, window_wid, window_cen, winnum, max, min, true);

//        //setscrollbars(adicomrec[winnum].window_width, adicomrec[winnum].window_center); {RED 01/21/03}
//        ChangeWindowLevelScrollbars(winnum, winnum, window_wid, window_cen, 'NOINITIMAGES');

//        application.processmessages;
        adjustmentdone := true;
        end; {end center width values <> 0}
(*      If ((adjustmentdone = false) and ((adicomrec[winnum].smallest_pixelval > 0) or (adicomrec[winnum].largest_pixelval > 0))) then
        begin
        setdisplaymaxmin(winnum, winnum, adicomrec[winnum].largest_pixelval, adicomrec[winnum].smallest_pixelval); {RED 7/25/02 - must be olevariants}
        setwinlevscrollbarPos(frmDCMViewer.win, frmDCMVIewer.level1, winnum, adicomrec[winnum].largest_pixelval, adicomrec[winnum].smallest_pixelval, winnum, winnum); {RED 12/21/02}
        nochange := 0;
//        If holdsettings = 0 then SaveBaseWindowSettings(winnum); {RED 02/15/03}
//        If holdsettings = 0 then SaveLastWindowSettings(winnum);  {RED 02/21/03}
        application.processmessages;
        adjustmentdone := true;
        end; {end if smallest_pixelval}
    end; {initmode = 'HDR' and no previous adjustment}*)
//end;
end.
