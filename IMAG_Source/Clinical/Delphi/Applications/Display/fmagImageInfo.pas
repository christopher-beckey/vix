Unit FMagImageInfo;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   Version 3 Patch 8   (8/1/2003)
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==   unit fMagImageInfo;
   Description: Window to display VistA information and the Image Abstract
    for a Selected Image or Images.
      Creates an instance of TfraMagImageInfo for each requested image.
    User can view multiple panels of image information in this window.
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+

*)
Interface

Uses
  Buttons,
  Classes,
  cMag4Vgear,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  UMagClasses,
  Stdctrls  ,
  umagdefinitions, Graphics
  ;

//Uses Vetted 20090929:OleCtrls, AxCtrls, StdCtrls, Dialogs, Graphics, Messages, Windows, MagImageManager, fraMagImageInfo, umagutils, magpositions, dmsingle, SysUtils

Type
  TfrmMagImageInfo = Class(TForm)
    StatusBar1: TStatusBar;
    ScboxFrames: TScrollBox;
    PnlClose: Tpanel;
    btnClose: TBitBtn;
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure MemImageInfoKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure btnCloseClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
   // procedure Mag4Vgear1ImageClick(sender: TObject;   Gearclicked: TMag4Vgear);
    Procedure Mag4VGear1MouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure BitBtn1Click(Sender: Tobject);
  Private
    FDisplaying: Boolean;
    FHiGear: Integer;
    FHdib: Integer;
    Fiptr: Integer;
    FSize: Integer;
    Fsize2: Integer;
//    procedure GearToGear(GearFr,GearTo : TGear);
  Public
        {       Show Image information in this information window}
    Procedure ShowInfo(IObj: TImageData; VGear: TMag4VGear = Nil);
  End;

Var
  FrmMagImageInfo: TfrmMagImageInfo;

Implementation
Uses
ImagDMinterface, //RCA  DmSingle,
  FraMagImageInfo,
  MagImageManager,
  Magpositions,
  SysUtils,
  Umagdisplaymgr,
  Umagutils8
  ;

{$R *.DFM}

{ TfrmMagImageInfo }
{TODO: make execute method instead of ShowInfo
{ Can load the abstract from IObj, or from vGear paramter}

Procedure TfrmMagImageInfo.ShowInfo(IObj: TImageData; VGear: TMag4VGear = Nil);
Var
  t: TStrings;
  ImgData: TImageData;
  Tstr: Tstringlist;
  Xmsg: String;
  ImageFilename: String;
  ImgResult: TMagImageTransferResult;

  Function IsImageHere(IObj: TImageData): Boolean;
  Var
    i: Integer;
    s: String;
    // cntrl : TControl;
  Begin
    Result := False;
    s := Self.Name;

    For i := 0 To ScboxFrames.ControlCount - 1 Do
    Begin
      If ScboxFrames.Controls[i] Is TfraImageInfo Then
        If IObj.Mag0 = TfraImageInfo(ScboxFrames.Controls[i]).Mag4Vgear1.PI_ptrData.Mag0 Then
        Begin
          ScboxFrames.ScrollInView(ScboxFrames.Controls[i]);
          Result := True;
        End;
    End;
  End;

Begin
  t := Tstringlist.Create;
  Tstr := Tstringlist.Create;

  Try
    ImgResult := Nil;
    Visible := True;
    {TODO: We are creating the frame, then populating all of it's controls.
     in a future version, move all the coding to the TfraImageInfo.  Because
     this way, it is not reuseable}
    If IsImageHere(IObj) Then
      Exit;

    With TfraImageInfo.Create(Self) Do
    Begin
      Parent := ScboxFrames; //self;
      Visible := True;
      Align := altop;

      // JMW 1/29/2007 P72 Need to create new ImageData object to put data into and give to vGear because vGear destroys the ImageData object when it is destroyed
      ImgData := TImageData.Create();
      ImgData.MagAssign(IObj);
      Mag4Vgear1.PI_ptrData := ImgData;
      Mag4Vgear1.LblImage.caption := '';
      { could open image from here }
      Mag4Vgear1.OnImageMouseDown := Mag4VGear1MouseDown;
      Visible := True;

      // JMW 2/15/08 P72 - Need to use getFile because it handles images from the ViX
      ImgResult := MagImageManager1.GetFile(IObj.AFile, IObj.PlaceCode,
        IObj.ImgType, False);

      ImageFilename := ImgResult.FDestinationFilename;

      {/ P117 - JK 9/7/2010 - if the image was deleted put up the canned bitmap /}
      if IObj.IsImageDeleted then
        Mag4Vgear1.LoadTheImage(MagImageManager1.GetCannedBMP(MagAbsDeletedImage))
      else
      begin
        {/ JK 9/7/2010 - the Happy Path /}
        If ImgResult.FTransferStatus = IMAGE_COPIED Then
        Begin
          Mag4Vgear1.LoadTheImage(ImageFilename);
          //Mag4VGear1.Align := alclient;
        End
        else
          {/ P117 - JK 9/22/2010 - If FTransferStatus is not IMAGE_COPIED then get the canned bitmap for the abstract in the image info window /}
          Mag4Vgear1.LoadTheImage(MagImageManager1.ResolveAbstract(IObj));
      end;

      {/ P122 JK 8/25/2011 - Created a common TMag4VGear method to show the annotation indicator overlay as a result of the WPR /}
      Mag4VGear1.ShowAnnotIndicator;

      If ImgResult <> Nil Then
        FreeAndNil(ImgResult);

      Lbinfo.caption := IObj.ExpandedDescription;
      //Dmod.MagDBBroker1.RPMag4GetImageInfo(IObj, t, umagdisplaymgr.ShowDeletedImagePlaceholderInfo);
      {/ P117 - JK 9/21/2010 - added 3rd param /} {/p117 gek used Upref instead of umagdisplay variable.}
       idmodobj.GetMagDBBroker1.RPMag4GetImageInfo(IObj, t, upref.UseDelImagePlaceHolder);  {}
      {  TODO:   thread to get image information }

      Tstr.Assign(t);

      If idmodobj.GetMagPat1.M_UseFakeName Then
      Begin
        MagReplaceStrings(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay, Tstr);

        {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
        if GSess.Agency.IHS then
        begin
          MagReplaceStrings(idmodobj.GetMagPat1.M_SSN, '000000', Tstr);
          MagReplaceStrings(idmodobj.GetMagPat1.M_SSNdisplay, '000000', Tstr);
        end
        else
        begin
          MagReplaceStrings(idmodobj.GetMagPat1.M_SSN, '000000000', Tstr);
          MagReplaceStrings(idmodobj.GetMagPat1.M_SSNdisplay, '000-00-0000', Tstr);
        end;
      End;

      Lbimageinfo.caption := Tstr.Text;
      Height := Lbimageinfo.Height + 20;
    End;
  Finally
    MagImageManager1.SafeCloseNetworkConnections();
    t.Free;
    Tstr.Free;
  End;
End;

(*
procedure TfrmMagImageInfo.GearToGear(GearFr,GearTo : TGear);
var I : integer;
begin
{no use working on fixing this.  Latest Version of Accusoft make this unneeded.}
FHIGEAR := Gearfr.HiGear;
FHdib := Gearfr.ImageHdib;
fiptr := Gearfr.ImagePtr;
Fsize := Gearfr.InstanceSize;
// Fsize didn't do it.
i := Gearfr.ImageBitsPerPixel;
Fsize2 := Gearfr.ImageWidth * Gearfr.imageheight;
case i of
        1 : Fsize2 := (Fsize2 div 8)+ 4096; //2048;
        else Fsize2 := (Fsize2 * 3) + 2048;
  end;

GearTo.MemSize := Fsize2;
GearTo.mempage := 0;
GearTo.MemLoad := Fiptr ;
  Gearto.AspectRatio := IG_ASPECT_MINDIMENSION;
GearTo.redraw := true;

end;
*)

Procedure TfrmMagImageInfo.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  action := caFree;
End;

Procedure TfrmMagImageInfo.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = 27 Then Close;
End;

Procedure TfrmMagImageInfo.MemImageInfoKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key = 27 Then Close;
End;

Procedure TfrmMagImageInfo.btnCloseClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmMagImageInfo.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
  ScboxFrames.Align := alClient;
//constraints.MinHeight := 306 + 40;
//self.ClientHeight := 306;
End;

Procedure TfrmMagImageInfo.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

(*procedure TfrmMagImageInfo.Mag4Vgear1ImageClick(sender: TObject;  Gearclicked: TMag4Vgear);
var Iobj : TimageData;
begin
  Iobj := Gearclicked.PI_ptrData;
  if (Iobj = nil) then exit;
  {Fdisplaying := true; update;
  //?? lvImageList.enabled := false; lvImageList.update;
  ToolBar1.enabled := false; ToolBar1.update;
  StatusBar1.panels[1].text := 'Loading...'; StatusBar1.update;
  LogActions('IMAGE-INFO','IMAGE',Iobj.Mag0);
  Open SelectedImage(Iobj, 1, 0, 1, 0);
  }
end;*)

Procedure TfrmMagImageInfo.BitBtn1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmMagImageInfo.Mag4VGear1MouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Var
  IObj: TImageData;
Begin
  IObj := TMag4VGear(Sender).PI_ptrData;
  If (IObj = Nil) Then Exit;
  If Button = Mbright Then Exit;

  If FDisplaying Then Exit;
  Try
    FDisplaying := True;
    Update;
  //?? lvImageList.enabled := false; lvImageList.update;
  //ToolBar1.enabled := false; ToolBar1.update;
    StatusBar1.Panels[1].Text := 'Loading...';
    StatusBar1.Update;
    LogActions('IMAGE-INFO', 'IMAGE', IObj.Mag0);
    OpenSelectedImage(IObj, 1, 0, 1, 0);
  Finally
    StatusBar1.Panels[1].Text := '';
    FDisplaying := False;
  End;

//
End;

End.
