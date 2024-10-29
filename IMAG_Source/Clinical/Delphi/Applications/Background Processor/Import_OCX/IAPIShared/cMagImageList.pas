Unit cMagImageList;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==    unit cMagImageList;
 Description: Image list functions and data.
  This component is central to any list of images in the application.
  cMagListView, cMagTreeView in the Image list window, or other windows.
  TmagViewer component in Abs, Group and Full.
  and Other components have Properties or fields that are of type : TMagImageList.
  and are associated with a cMagImageList object. Other Objects may attach
  themselves as Observers of TmagImageList.

 This list component has information specific to the list.
 i.e. Patient, Filter, List Description.
        Has a TStringList (baseList) of the data retrieved from the DataBase.
        and a cooresponding Tlist (objlist) of the baselist data converted to
         TImageData objects.

 TmagImageList implements the ImagObserver interface and Attaches itself to a
 TMag4Pat object (TMag4Pat implements the ImagSubject Interface) .
 TMagImageList implements the ImagSubject interface and accepts a list of Observers
 (Objects the support the ImagObserver interface can Attach themselves to
  TmagImageList as the Subject)
 the Update_ method of TMagImageList will be called by the TMag4Pat subject whenever
 the subject has a change of state.
 (State change of Tmag4Pat is New patient or Clear patient)
 In the Update_ method, TmagImageList Notifies all Observers of a change of state
  by calling the UpDate_ method of each Observer.
 TmagImageList Notifies all observers whenever the list changes.  As when the user
 selects a new Filtered list of Images.
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
  Classes,
  cMagDBBroker,
  cMagPat,
  cMagUtils,
  cMagVUtils,
  Controls,
  ImagInterfaces,
  UMagClasses,
  UMagDefinitions
  ,
  Maggmsgu {in 94.. for 93 debug issue.}  
  ;

//Uses Vetted 20090929:maggut1, Graphics, Messages, Windows, Dialogs, Forms, SysUtils

Type
 {Implements the 2 Interfaces}
  TMagImageList = Class(TComponent, IMagObserver, IMagSubject)
  Private
    FObserversList: Array Of IMagObserver;
    FDFN: String;
    FImageFilter: TImageFilter;
    FMagpat: TMag4Pat;
    FMagDBBroker: TMagDBBroker;
    FVutils: TMagVUtils;
    FUtils: TMagUtils;
    FbaseList: TStrings;
    FObjList: Tlist;
    FIsGroupList: Boolean;
    FGroupIEN: String;
    FListDesc: String;
    FlistName: String;
    // server and port are only to be used in magImageListManager, not needed in full res, abs, etc
    FServer: String;
    Fport: Integer;

    FStudyObj: TImageData;
    Procedure ConvertBaseListToObjectList;
    Procedure AttachMyself();
    Procedure SetFimageFilter(Const Value: TImageFilter);
    Procedure SetFlistdesc(Const Value: String);
    Procedure SetFlistName(Const Value: String);

  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    {   This is the Tstringlist that is retrieved from VistA}
    Property BaseList: TStrings Read FbaseList Write FbaseList;
    {   This is items in the BaseList converted to TimageData objects.}
    Property ObjList: Tlist Read FObjList Write FObjList;
    {   The TImageData object that was used when compiling the list.}
    Property ImageFilter: TImageFilter Read FImageFilter Write SetFimageFilter;

    {ImagSubject}
    {   Observers can Attach to a TMagImageList as a Subject with this call.}
    Procedure Attach_(Observer: IMagObserver);
    {   Observers can Detach themselves from subjects}
    Procedure Detach_(Observer: IMagObserver);
    {   Not Implemented.}
    Procedure GetState_(Var State: String);
    {   Not Implemented.}
    Procedure SetState_(State: String);
    {   All Observers will be notified by a call to their Update_ method}
    Procedure Notify_(SubjectState: String);

    Procedure ClearAll();
    //Testing function. future.
    Function GetAnImage(IObj: TImageData; Direction: Integer): TImageData;
    Procedure SetMagPat(Const Value: TMag4Pat);
    {ImagObserver}
    {   This is called by the ImagSubject when a change of state occurs.}
    Procedure UpDate_(SubjectState: String; Sender: Tobject); { Public declarations }
    {   A group list behaves differently than a filter images list.  So a
        seperate call to load it.}
    Procedure LoadGroupList(t: TStrings; Groupien: String; DFN: String);
    {   Returns the Filters description if it is a filtered list.}
    Function ListDetails(): String;
    Procedure SiteToPatName();
    //72 GEK this isn't called by any routine.
    // function ConvertImageListToTImageData(ImageList : TStrings; groupIEN : String) : TList;

  Published
    Property MagPat: TMag4Pat Read FMagpat Write SetMagPat Default Nil;
    Property MagDBBroker: TMagDBBroker Read FMagDBBroker Write FMagDBBroker;
    {   If a group list, it behaves differently than filtered list, when }
    Property IsGroupList: Boolean Read FIsGroupList Write FIsGroupList;
    Property ListDesc: String Read FListDesc Write SetFlistdesc;
    Property ListName: String Read FlistName Write SetFlistName;
    //72
    Property Groupien: String Read FGroupIEN;
    Property Server: String Read FServer Write FServer;
    Property Port: Integer Read Fport Write Fport;
    Property StudyObj: TImageData Read FStudyObj Write FStudyObj;
    //end72
  End;

Procedure Register;

Implementation
Uses
  Dialogs,
  Forms,
  SysUtils
  ;

{ TMagImageList }

Procedure TMagImageList.AttachMyself;
Begin
  If Assigned(FMagpat) Then
  Begin
    FMagpat.Attach_(IMagObserver(Self));
  End;
End;

Procedure TMagImageList.Attach_(Observer: IMagObserver);
Begin
  //IMagSubject
  SetLength(FObserversList, Length(FObserversList) + 1);
  FObserversList[High(FObserversList)] := Observer;
End;

Procedure TMagImageList.ClearAll;
Begin
  //
End;

Constructor TMagImageList.Create(AOwner: TComponent);
Begin
  Inherited;

  FbaseList := Tstringlist.Create;
  FObjList := Tlist.Create;
  FImageFilter := TImageFilter.Create();
  FImageFilter.Packages := [];
  FImageFilter.Classes := [];
  FVutils := TMagVUtils.Create(Nil);
  FUtils := TMagUtils.Create(Nil);
  FDFN := '';
  FGroupIEN := '';
  FMagpat := Nil;
  //72
  FServer := '';
  Fport := 0;
  FStudyObj := Nil;
  //end72
End;

Destructor TMagImageList.Destroy;
Begin
  FbaseList.Free;
  FObjList.Free;
  FImageFilter.Free;
  FVutils.Free;
  FUtils.Free;
  If Assigned(FMagpat) Then
  Begin
    FMagpat.Detach_(IMagObserver(Self));
    FMagpat := Nil;
  End;
  Notify_('-1');
  Inherited;
End;

{   Detach_ :  an Observer is detaching itself from the subject TMagImageList}

Procedure TMagImageList.Detach_(Observer: IMagObserver);
Var
  i: Integer;
Begin
//IMagSubject
  For i := 0 To (High(FObserversList)) Do
  Begin
    If (Observer = FObserversList[i]) Then
    Begin
      FObserversList[i] := Nil;
    End;
  End;
End;

Procedure TMagImageList.GetState_(Var State: String);
Begin
  //IMagSubject
End;

{.Notify_: Subject TMagImageList will call Update_ method of all Observers }

Procedure TMagImageList.Notify_(SubjectState: String);
Var
  i: Integer;
  IvObserver: IMagObserver;
Begin
  For i := 0 To (High(FObserversList)) Do
  Begin
    If FObserversList[i] <> Nil Then
    Begin
      IvObserver := (FObserversList[i]);
      {debugt94}//p117 try Log, with debug // If (ImsgObj <> Nil) Then ImsgObj.LogMsg('s', '**--** -- -- -- TMagImageList.Notify_ Observer[' + Inttostr(i) + ']   state ' + SubjectState);
       If (ImsgObj <> Nil) then IMsgObj.Log(msglvlDEBUG,'**--** -- -- -- TMagImageList.Notify_ Observer[' + Inttostr(i) + ']   state ' + SubjectState);
      IvObserver.UpDate_(SubjectState, Self);
    End;
  End;
End;

Procedure TMagImageList.SetMagPat(Const Value: TMag4Pat);
Begin
  If (FMagpat <> Nil) Then FMagpat.Detach_(Self);
  FMagpat := Value;
  If Value = Nil Then Exit;
  FDFN := FMagpat.M_DFN;
  AttachMyself();
End;

Procedure TMagImageList.SetState_(State: String);
Begin
  //IMagSubject
End;

{Update_ : Observer TmagImageList has been Notified by Subject of a change}

Procedure TMagImageList.UpDate_(SubjectState: String; Sender: Tobject);
Var
  Stat: Boolean;
  Statmsg: String;
  Oldcursor: TCursor;
  RRIValso: Boolean;
Begin
  {debug94} If (ImsgObj <> Nil) Then ImsgObj.LogMsg('s', '**--** -- -- -- TMagImageList.Update_  state ' + SubjectState);
  RRIValso := True;
  FbaseList.Clear;
  FObjList.Clear;
  FGroupIEN := '';
  FListDesc := '';
  //FlistName := '';
  Try
    Oldcursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    If SubjectState = '' Then
    Begin
      Notify_(SubjectState);
      Exit;
    End;
    If SubjectState = '-1' Then
    Begin
      FDFN := '';
      FMagpat := Nil;
      Notify_('');
      Exit;
    End;
  //  LocalImagesOnly
    If FIsGroupList Then Exit;
    If Not Assigned(FMagDBBroker) Then
    Begin
      Showmessage('Error: DB Broker UnAssigned in TMagImageList.');
      Exit;
    End;

    If DebugUseOldImageListCall Then
      FMagDBBroker.RPMag4PatGetImages(Stat, Statmsg, FMagpat.M_DFN, FbaseList, FImageFilter)
    Else
      FMagDBBroker.RPMag4ImageList(Stat, Statmsg, FMagpat.M_DFN, FbaseList, FImageFilter); //93

    FListDesc := Statmsg;
  //FlistName := FImageFilter.Name;
    If FlistName = '' Then FlistName := FListDesc;
    If Stat Then
    Begin
      ConvertBaseListToObjectList;
      If (FMagpat.M_DFN <> '') Then
        Notify_(FMagpat.M_DFN)
      Else
        Notify_('1');
    End
    Else
    Begin
      If Pos('No images for filter', Statmsg) > 0 Then
        Notify_('0 Images. ' + Statmsg)
      Else
      Begin
        Messagedlg(Statmsg, Mterror, [Mbok], 0);
        Notify_('');
      End;
    End;

  Finally
    Screen.Cursor := Oldcursor;

  End;

End;

{ConvertBaseListToObjectList: convert the Baselist to a list of TImageData Objects}

Procedure TMagImageList.ConvertBaseListToObjectList;
Var
  i: Integer;
  IObj: TImageData;
  Vserver: String;
  Vport: Integer;
Begin
  Vserver := '';
  Vport := 0;
  If Assigned(FMagDBBroker) Then
  Begin
    Vserver := FMagDBBroker.GetServer;
    Vport := FMagDBBroker.GetListenerPort;
  End;
  For i := 1 To FbaseList.Count - 1 Do
  Begin
    Try
//        Iobj := FVutils.StringToIMageObj('xx^' + Futils.magPiece(FbaseList[i], '|', 2));
      IObj := IObj.StringToTImageData('xx^' + FUtils.MagPiece(FbaseList[i], '|', 2), Vserver, Vport);

      FObjList.Add(IObj);
        // Need to rething the GroupIEN, maybe the pointer to cMagImagelist
        //   in the Iobj  ? ?
      If (FGroupIEN <> '') Then IObj.IGroupIEN := Strtoint(FGroupIEN);
      IObj.IGroupIndex := (FObjList.Count - 1);
      FbaseList[i] := FUtils.MagPiece(FbaseList[i], '|', 1) + '|' + Inttostr(FObjList.Count - 1);
    Except
      //
    End;
  End;
End;

Procedure TMagImageList.LoadGroupList(t: TStrings; Groupien, DFN: String);
Var
  i: Integer;
  Oldcursor: TCursor;
Begin
    {    here clear the old list, if needed,}
  Oldcursor := Screen.Cursor;
  Notify_('');
  If Screen.Cursor <> Oldcursor Then Screen.Cursor := Oldcursor;
  FGroupIEN := Groupien;
{ TODO : Have to check if the DFN Parameter is the same as FMagPat.M_DFN
if not do ?  ? ? ? ? }
  FDFN := DFN;
  FbaseList.Clear;
  FObjList.Clear;
// convert the OLD Style BaseList to Object list
// the first OLD Style BaseList didn't have a column header list. so lets fake it.
  FbaseList.Add('old^Style');
  For i := 0 To t.Count - 1 Do
  Begin
//s := t[i];
      // JMW P72 12/28/2006 - strings can now be more than 999 characters long (with info from DOD)
    FbaseList.Add('conv^|' + Copy(t[i], Pos('^', t[i]) + 1, 2099)); //

  End;
  ConvertBaseListToObjectList;
// Then Call Update;
{ TODO : Can't send DFN for now, don't have it., and don't have GroupIEN.
        But also don't need to.  The observers will querry the subject (if they
        need to)  when they get notified of a change of state. }
//Notify_(FDFN);
  Notify_('1');
End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagImageList]);
End;

Procedure TMagImageList.SetFimageFilter(Const Value: TImageFilter);
Begin
  If Value = Nil Then Exit;
  If Assigned(FImageFilter) Then FImageFilter.Free;
  FImageFilter := Value;
  FlistName := FImageFilter.Name;
End;

Procedure TMagImageList.SetFlistdesc(Const Value: String);
Begin
// do nothing from the property Setter.  i.e. Readonly  Flistdesc := Value;
End;

Function TMagImageList.ListDetails: String;
Begin
  If Not Assigned(FImageFilter) Then
    Result := 'List is not filtered.'
  Else
    Result := ImageFilter.Detailstring;
End;

Procedure TMagImageList.SetFlistName(Const Value: String);
Begin
//  Read Only don't allow sets from Property value.  FListName := Value;
End;

//Testing function. future.

Function TMagImageList.GetAnImage(IObj: TImageData; Direction: Integer): TImageData;
Var
  i: Integer;
Begin
  Result := IObj;
  Case Direction Of
    -2: Result := ObjList[ObjList.Count - 1];
    0: Result := ObjList[0];
  Else
    Begin
      For i := 0 To ObjList.Count - 1 Do
      Begin
        If TImageData(ObjList.Items[i]).Mag0 = IObj.Mag0 Then
          Case Direction Of
            -1:
              Begin
                If i = 0 Then
                  Result := Nil //Objlist[i];
                Else
                  Result := ObjList[i - 1];
              End;
            +1:
              Begin
                If i = ObjList.Count - 1 Then
                  Result := Nil // objlist[objlist.count-1];
                Else
                  Result := ObjList[i + 1];
              End;
          End;
      End;
    End;
  End;

End;

Procedure TMagImageList.SiteToPatName;
Var
  i: Integer;
Begin
{We are changing the 'Site' column to 'Patient', and changing the data in each.}
  BaseList[0] := FUtils.MagSetPiece(BaseList[0], '^', 2, 'Patient'); //'Patient^Status');
  For i := 1 To BaseList.Count - 1 Do
  Begin
    BaseList[i] := FUtils.MagSetPiece(BaseList[i], '^', 2, TImageData(ObjList[i - 1]).PtName); // TImageData(objlist[i-1]).PtName + '^' + inttostr(TImageData(objlist[i-1]).magstatus));
  End;

End;

End.
