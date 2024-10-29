Unit cMagPatPhoto;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==  unit cMagPatPhoto;
 Description:  Image Patient Photo Component.
 Inherits from TFrame.  We use TFrame as the ancestor
 for some imaging components when the component being developed needs multiple visual
 controls.  All the needed controls can be placed on the Frame and function as
 one component.

 TMagPatPhoto implements the ImagObserver interface with Tmag4Pat as the subject.
 When the patient changes, Tmag4pat Notifies TMagPatPhoto, and TMagPatPhoto updates
 the Patient Photo.
 TMagPatPhoto also has properties:
  MagDBBroker :  TMagDBBroker
        The Object can make RPC Call to get the Patient Photo from the Image File.
  MagSecurity :  TMag4Security
        The Object can open secure connections to the Imaging Servers.

  memPhoto : Tmemo
        The component can also display information beside the Patient's Photo.

  Display Styles - called from PopupMenu (Popup Menu items.  Not implemented.)
        Photo - Name : also Shows patient name
        Photo - Info : also shows the memPhoto control for informational display
        Photo Only   : Patient Photograph is all that is displayed. (Default Style)

        Photo on Top : Default.  If memPhoto is visible this property is querried.
        Photo to Left:  If memPhoto is visible this property is querried.
     Patch 59

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
Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  Stdctrls,
  AxCtrls,
  OleCtrls, {GEARLib_TLB,} {GearDef,}
  ImagInterfaces,
  cMagDBBroker,
  Menus,
  cMagUtils,
  cMagSecurity,
  UMagClasses,
  UMagDefinitions,
  cMagVUtils,
  Fmxutils,
  MagImageManager,
  cMag4Vgear
  ,
  cMagPat
  ;
Type
  TMagPatPhoto = Class(TFrame, IMagObserver)
    MemPhoto: TMemo;
    //gearPat: TGear;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    PhotoName1: TMenuItem;
    PhotoInfo1: TMenuItem;
    PhotoOnly1: TMenuItem;
    N1: TMenuItem;
    PhotoonTop1: TMenuItem;
    PhototoLeft1: TMenuItem;
    Mag4Vgear1: TMag4VGear;
    PnlProfilePhoto: Tpanel;
    ImgProfilePhoto: TImage;
    {Popup Menu items.  Not implemented.}
    Procedure PhotoName1Click(Sender: Tobject);
    Procedure PhotoInfo1Click(Sender: Tobject);
    Procedure PhotoonTop1Click(Sender: Tobject);
    Procedure PhototoLeft1Click(Sender: Tobject);
    Procedure PhotoOnly1Click(Sender: Tobject);
  Private
    FDFN: String; { Private declarations }
    FMagpat: TMag4Pat;
    FMagDBBroker: TMagDBBroker;
    Fmut: TMagUtils;
    FMagSecurity: TMag4Security;
    FHideWhenNull: Boolean;
    Procedure AttachMyself();
    Procedure InitGear();
    Procedure SetMagPat(Const Value: TMag4Pat);
    Procedure ClearPat;
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
        {       This class implements the ImagObserver interface}
    Procedure UpDate_(SubjectState: String; Sender: Tobject); { Public declarations }
  Published
        {       MagHideWhenNull not implemented.}
    Property MagHideWhenNull: Boolean Read FHideWhenNull Write FHideWhenNull;
        {       Reference to the Patient Object.}
    Property MagPat: TMag4Pat Read FMagpat Write SetMagPat;
        {       Reference to the DataBase broker component.}
    Property MagDBBroker: TMagDBBroker Read FMagDBBroker Write FMagDBBroker;
        {       Imaging security component.  This Class opens images.}
    Property MagSecurity: TMag4Security Read FMagSecurity Write FMagSecurity;
  End;

Procedure Register;

Implementation
Uses Maggmsgu;
{$R *.DFM}

{ TFrame1 }

Procedure TMagPatPhoto.AttachMyself;
Begin
  If Assigned(FMagpat) Then
    FMagpat.Attach_(IMagObserver(Self));
End;

Constructor TMagPatPhoto.Create(AOwner: TComponent);
Begin
  Inherited;
  Fmut := TMagUtils.Create(Nil);
  InitGear;
End;

Destructor TMagPatPhoto.Destroy;
Begin
  Fmut.Free;
  If Assigned(FMagpat) Then
  Begin
    FMagpat.Detach_(Self);
    FMagpat := Nil;
  End;
  Inherited;
  //
End;

Procedure TMagPatPhoto.InitGear;
Begin
{   Not sure if we need these here.}
  Mag4Vgear1.FitToWindow; //probably not.
  Mag4Vgear1.ReDrawImage; //probably not
  Mag4Vgear1.ShowImageOnly := True;
End;

{  * TMagPatPhoto.SetMagPat *
  When set, this component also attaches itself as ImagObserver to TMag4Pat Subject}

Procedure TMagPatPhoto.SetMagPat(Const Value: TMag4Pat);
Begin
  If (FMagpat <> Nil) Then
    FMagpat.Detach_(Self);
  FMagpat := Value;
  If Value = Nil Then
    Exit;
  FDFN := FMagpat.M_DFN;
  AttachMyself();
End;

{   Clear the Image}

Procedure TMagPatPhoto.ClearPat;
Begin
  MemPhoto.Lines.Clear;
  Mag4Vgear1.ClearImage;
End;

{Notified from Subject. Update the Patient Photo.}

Procedure TMagPatPhoto.UpDate_(SubjectState: String; Sender: Tobject);
Var
  t: Tstringlist;
  Xmsg, PhotoImage: String;
  SiteAbbr,
    Vhint, Vsex: String;
Begin
  {debug94} If (ImsgObj <> Nil) Then IMsgObj.MagMsg('s', '**--**-- -- -- TMagPatPhoto.Update_  state ' + SubjectState);
  ClearPat;

  If (SubjectState = '') Then
    Exit;

  If (SubjectState = '-1') Then
    FMagpat := Nil
  Else
  Begin
    {DONE : Need to make use of MagSecurity - getImageFile uses security }
    {DONE: and change Gear1 to Mag4VGear; }
    t := Tstringlist.Create;

    {Call MagDBBroker to get patient Photo.}
    If Not Assigned(FMagDBBroker) Then
      Exit;

    FMagDBBroker.RPMaggGetPhotoIDs(FMagpat.M_DFN, t);
    If FMagpat.M_Sex = 'M' Then
      Vsex := 'Male'
    Else
      Vsex := 'Female';
    Vhint := FMagpat.M_NameDisplay + #13 //p93t10 SSN Out.   + Fmagpat.M_SSNdisplay + #13
      + Vsex + ',  Age ' + FMagpat.M_Age + #13
      + 'DOB: ' + FMagpat.M_DOB;

    PhotoImage := Fmut.MagPiece(t[0], '^', 3); // 3 is full, 4 is abstract;

    {JK 1/12/2009 - put up the profile image when there is no image to display
     for the selected patient.}
    If PhotoImage = '' Then
    Begin
      PnlProfilePhoto.BringToFront;
    //  pnlProfilePhoto.Align := alClient;
      PnlProfilePhoto.ShowHint := True;
      PnlProfilePhoto.Hint := #13 + 'No Photo on record.' + #13 + #13 + Vhint;
    End
    Else
    Begin
      PnlProfilePhoto.SendToBack;
      PnlProfilePhoto.ShowHint := False;
    End;

    SiteAbbr := Fmut.MagPiece(t[0], '^', 17);

    {//gek  Patch 93 info
        1    2                       3
       'B2^19393^c:\image\GVB0\00\00\01\93\GVB00000019393.JPG^
                     4                                 5          6
      c:\image\GVB0\00\00\01\93\GVB00000019393.ABS^PHOTO ID^3081023.0842^
            8          9                       17    20          21
      18^PHOTO ID^10/23/2008 08:42^^M^A^^^1^1^SLC^^^1033^IMAGPATIENT1033,1033^
          22            23               24              27      28
      ADMIN/CLIN^10/23/2008 08:46:21^10/23/2008^0^0:0^127.0.0.1^9400^0^^^'
    }

    If PhotoImage <> '' Then
    Begin
      Try
        Screen.Cursor := crHourGlass;
        PhotoImage := MagImageManager1.GetImageFile(PhotoImage, SiteAbbr, Xmsg);
        {   Load the image}
        Mag4Vgear1.LoadTheImage(PhotoImage);

        {   Hint for the Image}
        Mag4Vgear1.ImageHint(Vhint);

            {JK 1/21/2009}
      //  Mag4VGear1.pnlImage.Align := alClient;
      //  Mag4VGear1.Bevel1.Align := alClient;
      Finally
        Screen.Cursor := crDefault;
      End;
    End;
  End;
End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagPatPhoto]);
End;

{Not implememted.  If Patient Name control is visible.  User can Show/Hide the
 patient Photo if desired.}

Procedure TMagPatPhoto.PhotoName1Click(Sender: Tobject);
Begin
  {Make it visible}
  Mag4Vgear1.Visible := True;
  MemPhoto.Visible := True;
End;

Procedure TMagPatPhoto.PhotoInfo1Click(Sender: Tobject);
Begin
  {Make it visible}
  Mag4Vgear1.Visible := True;
  MemPhoto.Visible := True;
End;

Procedure TMagPatPhoto.PhotoonTop1Click(Sender: Tobject);
Begin
  MemPhoto.Visible := True;
  Splitter1.Align := altop;
End;

Procedure TMagPatPhoto.PhototoLeft1Click(Sender: Tobject);
Begin
  MemPhoto.Visible := True;
  Splitter1.Align := alLeft;
End;

Procedure TMagPatPhoto.PhotoOnly1Click(Sender: Tobject);
Begin
  MemPhoto.Visible := False;
End;

End.

{ values for nFitMethod parameter of IG_display_fit_method
const IG_DISPLAY_FIT_TO_WINDOW=0  ;
const IG_DISPLAY_FIT_TO_WIDTH=1;
const IG_DISPLAY_FIT_TO_HEIGHT=2  ;
const IG_DISPLAY_FIT_1_TO_1=3;
.................
Const IG_ASPECT_NONE = 0;
Const IG_ASPECT_DEFAULT = 1;
Const IG_ASPECT_HORIZONTAL = 2;
Const IG_ASPECT_VERTICAL = 3;
Const IG_ASPECT_MAXDIMENSION = 4;
Const IG_ASPECT_MINDIMENSION = 1;
}
