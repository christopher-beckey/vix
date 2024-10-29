Unit cMagImport;

{
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
        [==
 Description: Imaging Import API Delphi component

        ==]
 Note:
  }
Interface
//{$DEFINE DEBUG}
Uses
  Windows,
  SysUtils,
  Classes,
  Stdctrls,
//va
  Trpcb,
//imaging
  cMagSecurity,
  cMagUtils,
  cMagDBBroker
  ;

//Uses Vetted 20090929:FileCtrl, Controls, Graphics, Messages, uMagClasses, umagdefinitions, cmagdbmvista, hash, Dialogs, Forms

Type
  EInvalidData = Class(Exception)
    ErrorCode: Integer;
  End;
  TMytest4Event = Procedure(i: Integer; s: String) Of Object;
  TMagImport = Class(TCustomListbox)
  Private
    FUnStrings: TStrings;
    FMyLogFile: Textfile;
    FLogStrs: TStrings;
    FMyTest4Event: TMytest4Event;
    FImageAdd: String;
    {each image (listItem in FImages) can have 2nd '^' piece as Short Description.}
    FImages: TStrings;
    FDFN: String;
    FProcPKG: String;
    FProcIEN: String;
    FProcDt: String;
    {   tracking number is a ';' delimited string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
    FTrkNum: String;
    FAcqDev: String;
    FAcqSite: String;
    FAcqLoc: String;
    FExcpHandler: String;
    {  Above are required by the 'M' Import API Call.{}
    FImgType: String;
    FMethod: String;
    FCapBy: String;
    FUsername: String;
    FPassword: String;
    FGroupDesc: String;
    FDeleteFlag: Boolean;
    FTransType: String;
    FDOCCTG: String;
    FixType: String;
    FixSpec: String;
    FixProc: String;
    FixOrigin: String;
    FDocDT: String;
    {   rest of fields are not Implemented in 'M' ImportAPI Call. {}
    FProcType: String;
    FProcDesc: String;
    FCapDt: String;
    FGroupIEN: String;
    FGroupLongDesc: TStrings;
    {   other processing fields {}
    Flist: Tstringlist;
    Rlist: TStrings;
    Fstat: Boolean;
    FBroker: TRPCBroker;
    FDBBroker: TMagDBBroker;
    FMagSecurity: TMag4Security;
    FCaptureKeys: Tstringlist;
    FLogList: Tstringlist;
    FMagUtils: TMagUtils;
    Function GetTrkNum: String;
    Function GetImages: TStrings;
    Function GetAcqSite: String;
    Function GetAcqLoc: String;
    Function GetCapBy: String;
    Function GetCapDt: String;
    Function GetDFN: String;
    Function GetImgType: String;
    Function GetMethod: String;
    Function GetProcDesc: String;
    Function GetProcDt: String;
    Function GetProcPKG: String;
    Function GetProcIEN: String;
    Function GetProcType: String;
    Function GetAcqDev: String;
    Function GetGroupIEN: String;
    Function GetGroupDesc: String;
    Function GetGroupLongDesc: TStrings;
    Function GetExcpHandler: String;
    Function GetPassword: String;
    Function GetUsername: String;
    Function GetDeleteFlag: Boolean;
    Function GetTransType: String;
    Function GetDOCCTG: String;
    Function GetDocDt: String;
    Function GetIndexProc: String;
    Function GetIndexSpec: String;
    Function GetIndexType: String;
    Function GetIndexOrigin: String;
    Procedure SetTrkNum(Const Value: String);
    Procedure SetImages(Const Value: TStrings);
    Procedure SetAcqSite(Const Value: String);
    Procedure SetAcqLoc(Const Value: String);
    Procedure SetCapBy(Const Value: String);
    Procedure SetCapDt(Const Value: String);
    Procedure SetDFN(Const Value: String);
    Procedure SetImgType(Const Value: String);
    Procedure SetMethod(Const Value: String);
    Procedure SetProcDesc(Const Value: String);
    Procedure SetProcDt(Const Value: String);
    Procedure SetProcPKG(Const Value: String);
    Procedure SetProcIEN(Const Value: String);
    Procedure SetProcType(Const Value: String);
    Procedure SetAcqDev(Const Value: String);
    Procedure SetGroupIEN(Const Value: String);
    Procedure SetGroupDesc(Const Value: String);
    Procedure SetGroupLongDesc(Const Value: TStrings);
    Procedure SetExcpHandler(Const Value: String);
    Procedure SetPassword(Const Value: String);
    Procedure SetUsername(Const Value: String);
    Procedure SetDeleteFlag(Const Value: Boolean);
    Procedure SetTransType(Const Value: String);
    Procedure SetDOCCTG(Const Value: String);
    Procedure SetDocDt(Const Value: String);
    Procedure SetIndexProc(Const Value: String);
    Procedure SetIndexSpec(Const Value: String);
    Procedure SetIndexType(Const Value: String);
    Procedure SetIndexOrigin(Const Value: String);
    Function GetBroker: TRPCBroker;
    Function GetMag4Security: TMag4Security;
    Function GetDBBroker: TMagDBBroker;
    Procedure SetBroker(Const Value: TRPCBroker);
    Procedure SetMag4Security(Const Value: TMag4Security);
    Procedure SetDBBroker(Const Value: TMagDBBroker);
    Function Validate(Var Xmsg: String): Boolean;
    Function CreateGroup(Var Xmsg: String): Boolean;
    Function CreateImageEntry(Var Xmsg: String; Var ImageID: String; Imagefile: String): Boolean;
    Function CopyImageToServer(Var Xmsg: String; ImageID, Imagefile: String): Boolean;
    Function ValidInteger(s: String): Boolean;
    Function Save(Var Xmsg: String): Boolean;
    Function ImageArrayToFields(Var Xmsg: String; Imgarray: Tstringlist): Boolean;
    Function CopyTheFile(Var Xmsg: String; FromFile, ToFile: String): Boolean;
    Procedure FileSpecialtyPointers(ImageID: String);
    Procedure CreateTheQueues(ImageID: String);
    Function DelimitedParam(s: String): Boolean;
    Function SetNetUsernamePassword(User, Pass: String; Var MagSec: TMag4Security;
      Var Xmsg: String): Boolean;
    Procedure DeleteImageEntry(Var Xmsg: String; Ien: String);
    Procedure CreateNewlog;
    Procedure LogTheMsg(s: String);
    Procedure LogTheList(t: Tstringlist); Overload;
    Procedure LogTheList(t: TStrings); Overload;
    Function ImageTypeAllowAbs(FileExt: String): Boolean;
    Function CreateAndSaveImageTextFile(ImageToFile: String; Var Xmsg: String): Boolean;
    Procedure InitIfNeeded;
    Procedure ConnectIfNeeded(Var Vserver: String; Var Vport: String; AccessCode:
      String = ''; Verifycode: String = '');
    Procedure ImageArrayFromFields(Var t: Tstringlist);
    Procedure LogMsg(s: String); Overload;
    Procedure LogMsg(t: TStrings; Pf: String = ''); Overload;
    Function BoolToStr(Val: Boolean): String;
  Protected
    Property Height Default 30;
    Property Width Default 30;
  Public
    Constructor Create(AOwner: TComponent);
      Override;
    Destructor Destroy;
      Override;
    Procedure ClearProperties;
    Procedure Showproperties;
    Procedure SaveDirect(Var Status: Boolean; Var Xmsglist: TStrings);
    Procedure VistAInit(Var Status: Boolean; Var Xmsg: String; Var Vserver: String;
      Var Vport: String; AccessCode: String =
      ''; Verifycode: String = '');
    Function ImportDataArray(Var Xmsglist: Tstringlist; InArray: Tstringlist):
      Boolean;
    Procedure ImportQueue(Var Status: Boolean; Qnum: String; Var Reslist: TStrings;
      Var StatusCB: String; NoCallBackOnError: Boolean = False);
    Procedure ImageAdd(Imagefile: String);
  Published
    Property OnMyTest4Event: TMytest4Event Read FMyTest4Event Write
      FMyTest4Event;
    Property TrkNum: String Read GetTrkNum Write SetTrkNum;
    Property Images: TStrings Read GetImages Write SetImages;
    Property DFN: String Read GetDFN Write SetDFN;
    Property CapBy: String Read GetCapBy Write SetCapBy;
    Property AcqDev: String Read GetAcqDev Write SetAcqDev;
    Property ExcpHandler: String Read GetExcpHandler Write SetExcpHandler;
    Property ProcPKG: String Read GetProcPKG Write SetProcPKG;
    Property ProcIEN: String Read GetProcIEN Write SetProcIEN;
    Property ProcType: String Read GetProcType Write SetProcType;
    Property Username: String Read GetUsername Write SetUsername;
    Property Password: String Read GetPassword Write SetPassword;
    Property ProcDt: String Read GetProcDt Write SetProcDt;
    Property ProcDesc: String Read GetProcDesc Write SetProcDesc;
    Property CapDt: String Read GetCapDt Write SetCapDt;
    Property ImgType: String Read GetImgType Write SetImgType;
    Property AcqSite: String Read GetAcqSite Write SetAcqSite;
    Property Method: String Read GetMethod Write SetMethod;
    Property Groupien: String Read GetGroupIEN Write SetGroupIEN;
    Property GroupDesc: String Read GetGroupDesc Write SetGroupDesc;
    Property GroupLongDesc: TStrings Read GetGroupLongDesc Write
      SetGroupLongDesc;
    Property DeleteFlag: Boolean Read GetDeleteFlag Write SetDeleteFlag;
    Property TransType: String Read GetTransType Write SetTransType;
    Property AcqLocation: String Read GetAcqLoc Write SetAcqLoc;
    Property DocCategory: String Read GetDOCCTG Write SetDOCCTG;
    Property DocDate: String Read GetDocDt Write SetDocDt;
    Property IndexType: String Read GetIndexType Write SetIndexType;
    Property IndexSpec: String Read GetIndexSpec Write SetIndexSpec;
    Property IndexProc: String Read GetIndexProc Write SetIndexProc;
    Property IndexOrigin: String Read GetIndexOrigin Write SetIndexOrigin;
    Property MagBroker: TRPCBroker Read GetBroker Write SetBroker;
    Property MagSecurity: TMag4Security Read GetMag4Security Write
      SetMag4Security;
    Property MagDBBroker: TMagDBBroker Read GetDBBroker Write SetDBBroker;
  End;

Procedure Register;

Implementation
Uses
  Dialogs,
  Forms,
  Hash,
  cMagDBMVista,
  UMagClasses,
  UMagDefinitions
  ;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagImport])
End;

{ TMagImport }

Constructor TMagImport.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  Flist := Tstringlist.Create;
  Rlist := Tstringlist.Create;
  FImages := Tstringlist.Create;
  FGroupLongDesc := Tstringlist.Create;
  FMagUtils := TMagUtils.Create(Self);
  FCaptureKeys := Tstringlist.Create;
  FLogList := Tstringlist.Create;
  Height := 30;
  Width := 30;
  FLogStrs := Tstringlist.Create
End;

Destructor TMagImport.Destroy;
Begin
  Application.Processmessages;
  Flist.Free;
  Rlist.Free;
  FImages.Free;
  FGroupLongDesc.Free;
  FMagUtils.Free;
  FCaptureKeys.Free;
  FLogList.Free;
  Inherited Destroy
End;

Function TMagImport.ValidInteger(s: String): Boolean;
Begin
  Result := True;
  Try
    Strtoint(s)
  Except
    On e: Exception Do
      Result := False;
  End;
End;

Function TMagImport.DelimitedParam(s: String): Boolean;
Begin
  Result := True;
  If (FMagUtils.Maglength(s, ';') <> 2) Then
  Begin
    Result := False
  End;
End;

Function TMagImport.Save(Var Xmsg: String): Boolean;
Var
  i: Integer;
  ImageCopyErrors,
    ImageCopyOK: TStrings;
  Imsg,
    Dmsg,
    ImageID,
    Imagefile: String;
  AllOrNone: Boolean;
  Xien,
    Xfile,
    x: String;
  IObj: TImageData;
Begin
  // FUnstrings.add(inttostr(FUnstrings.count));
  Rlist.Clear;
  Flist.Clear;
  AllOrNone := True;
  Result := False;
  FMagSecurity.MagCloseSecurity(Imsg);
  Imsg := '';
  ImageCopyErrors := Tstringlist.Create;
  ImageCopyOK := Tstringlist.Create;
  Try
    Try
      If Not Validate(Xmsg) Then // etrap ok.
      Begin
        LogMsg('2- Failed Validate');
        Result := False;
        Exit
      End;
    {--------------------------------}
      If FImages.Count = 0 Then
      Begin
        Xmsg := '0^Error: The list of Images to be imported is Empty.';
        Result := False;
        Exit
      End;
    //fUnStrings.Add(Inttostr(Funstrings.count)); // force error
    {--------------------------------}
      If ((FImages.Count > 1) And (FGroupIEN = '')) Then
      Begin
        If CreateGroup(Xmsg) Then //etrap okk
        Begin
        {error in FileSpecialtyPointers doesn't stop the process
               but the error is logged in LogTheMsg, which is returned to
               the calling App {}
          LogMsg('2- Group Creating Image Group  OK');
          LogMsg('2- Filing Package Pointers.');
          FileSpecialtyPointers(Xmsg); //etrap ok.
          LogMsg('2- ------ ' + Xmsg);
        End
        Else
        Begin
          LogMsg('2- Error Creating Group.  Exiting Save.');
          Result := False;
          Exit //Can't Create the Group entry, so Stop here EXIT
        End;
      End;
    {--------------------------------}
    {  Here , we don't care if multiple images exist.
      IF FGroupIEN exists, we add each image to the Group.
      ELSE Each Image points to the Specialty(Procedure).{}
    //    if (FImages.Count > 0) then
    //    begin
      LogMsg('2- Starting Save  Images.');
      For i := 0 To FImages.Count - 1 Do
      Begin
      // we stop if one image fails, we wait untill
      // we have tried them all.  Unless AllorNone is True
        If Not CreateImageEntry(Imsg, ImageID, FImages[i]) Then // etrap ok
        Begin
          LogTheMsg('Error creating VistA Image Entry:');
        //LogTheMsg('    '+FImages[i]+'|'+imsg);
          LogTheMsg('    ' + Imsg);
          ImageCopyErrors.Add('|' + FImages[i] + '|' + Imsg);
          If AllOrNone Then
          Begin
            LogMsg('2- Breaking from Save Loop ');
            Result := False;
            Break
          End
          Else
          Begin
            Continue
          End;
        End;
         { - - - - - - - - - }
        If FGroupIEN = '' Then
        Begin
          FileSpecialtyPointers(ImageID) //etrap ok
        End;
      //FUnstrings.add(inttostr(FUnstrings.count));
        Imagefile := FMagUtils.MagPiece(FImages[i], '^', 1);
      // we don't stop if one copy fails, we wait untill
      // we have tried them all. Unless AllorNone is True
        LogMsg('2- Copying to Server...');
         { - - - - }
        If Not CopyImageToServer(Imsg, ImageID, Imagefile) Then //
        Begin
          ImageCopyErrors.Add(ImageID + '|' + FImages[i] + '|' + Imsg);
          LogTheMsg('Error copying ' + Imagefile + ' to Server : ' + ImageID);
          LogTheMsg('   :' + Imsg);
        // special return code, the Connection to the network failed.
        // so we stop processing.
          If ((FMagUtils.MagPiece(Imsg, '^', 1) = '-1')
            Or
            AllOrNone) Then
          Begin
            Xmsg := Imsg;
            Result := False;
            Break
          //exit;
          End;
          Continue
        End
        Else // success copying to server.
        Begin
          LogMsg('2- Copy To Server OK ' + Imagefile);
        End;
         { - - - - }
        ImageCopyOK.Add(ImageID + '|' + FImages[i] + '|' + 'OK')
      End; //for I := 0 to Fimages.count - 1 do

    { TODO : if FMethod then CallMethodHandler(GenImages) }

    { We delete bad image entries now, that way only if all images were bad,
    will the group be deleted.{}
      If (ImageCopyErrors.Count > 0) Then
      Begin
        For i := 0 To ImageCopyErrors.Count - 1 Do
        Begin
          DeleteImageEntry(Dmsg, FMagUtils.MagPiece(FMagUtils.MagPiece(ImageCopyErrors[i], '|', 1), '^', 1));
          LogTheMsg(Dmsg)
        End;
        If (AllOrNone And (ImageCopyOK.Count > 0)) Then
        Begin
          For i := ImageCopyOK.Count - 1 Downto 0 Do
          Begin
            x := FMagUtils.MagPiece(ImageCopyOK[i], '|', 1);
            Xien := FMagUtils.MagPiece(x, '^', 1);
            Xfile := FMagUtils.MagPiece(x, '^', 2) + FMagUtils.MagPiece(x,
              '^', 3);
            DeleteImageEntry(Dmsg, Xien);
            LogTheMsg(Dmsg + '  Delete Queue set for: ' + Xfile);
          // have to delete the Images from this list.  Because
          // the delete flag tests this list, for deleting images from import directory
            ImageCopyOK.Delete(i)
          End;
        End;
      End;
    //
    // HERE if things worked OK we have entries in ImageCopyOK list.
    //    ( we have things in ImageCopyOK list if some failed, and
    //      the allornothing flag wasn't set.
    //  So for all images in ImageCopyOK list,
    //           we should set the Queue's Here
      If (ImageCopyOK.Count > 0) Then
      Begin
        For i := 0 To ImageCopyOK.Count - 1 Do
        Begin
        //CPMOD, ADMINMOD  12/6/2001
        //ImageCopyOK.add(imageID + '|' + FImages[i] + '|' + 'OK');
        {we LogTheMsg if CreateQueues fails. }
          CreateTheQueues(FMagUtils.MagPiece(ImageCopyOK[i], '|',
            1));
        // JMW 4/21/2005 p45
          IObj := TImageData.Create();
          IObj.ServerName := MagDBBroker.GetServer();
          IObj.ServerPort := MagDBBroker.GetListenerPort();
          MagDBBroker.RPMag3Logaction('CAP-IMPORT^' + FDFN + '^'
            + FMagUtils.MagPiece(ImageCopyOK[i], '^', 1) + '$$' + FTrkNum, IObj)
        End;
      End;
      If (ImageCopyOK.Count = 0) Then
      Begin
        Xmsg := '0^ERROR: 0 Images copied';
        Result := False
      End
      Else
      Begin
        Result := True;
        Xmsg := '1^' + Inttostr(ImageCopyOK.Count) + ' Image(s) Copied OK. ' +
          Inttostr(ImageCopyErrors.Count) + ' Errors.'
      End;
    // If this was a group, we have at least One image that was successful.
      If FDeleteFlag Then
      Begin
      // iterate through the ImageCopyOK array and delete all the
      //  2nd '|' pieces.
        For i := 0 To ImageCopyOK.Count - 1 Do
        Begin
          If Not DeleteFile(FMagUtils.MagPiece(FMagUtils.MagPiece(ImageCopyOK[i], '|', 2), '^', 1)) Then
          Begin
            LogTheMsg('0^Warning: Couldn''t Delete file: ' +
              (FMagUtils.MagPiece(FMagUtils.MagPiece(ImageCopyOK[i], '|', 2), '^', 1)))
          End
          Else
          Begin
            LogTheMsg('1^Deleted the Imported File: ' + (FMagUtils.MagPiece(FMagUtils.MagPiece(ImageCopyOK[i], '|', 2), '^', 1)))
          End;
        End;
      End;

    Except
      On e: Exception Do
      Begin
        Result := False;
        Xmsg := '0^' + e.Message;
      End;
    End;
  Finally
    ImageCopyErrors.Free;
    ImageCopyOK.Free
  End;
End;

Procedure TMagImport.CreateTheQueues(ImageID: String);
Var
  CreatAbsIEN,
    JBCopyIEN,
    Imagefile,
    Ext: String;
  XStat: Boolean;
  Xlist: Tstringlist;
Begin
  Xlist := Tstringlist.Create;
  Try
    CreatAbsIEN := '';
    JBCopyIEN := FMagUtils.MagPiece(ImageID, '^', 1);
    Imagefile := FMagUtils.MagPiece(ImageID, '^', 3);
    Ext := FMagUtils.MagPiece(Imagefile, '.', 2);
    {Set Queues :  ABSTRACT, CopyToJukeBox
    First '^' piece is  CreateAbstract Queue
     2nd '^' piece is CopyToJukeBox }
    If ImageTypeAllowAbs(Ext) Then
    Begin
      CreatAbsIEN := JBCopyIEN
    End;
    {RPMagABSJB(var Fstat: boolean; var Flist: tstringlist; CreatAbsIEN, JBCopyIEN: string)}
    FDBBroker.RPMagABSJB(Fstat, Flist, CreatAbsIEN, JBCopyIEN);
    If Not Fstat Then
    Begin
      LogTheList(Flist)
    End;
    FDBBroker.RPMag4PostProcessActions(XStat, Xlist, JBCopyIEN)
  Finally
    Xlist.Free
  End;
End;

Function TMagImport.ImageTypeAllowAbs(FileExt: String): Boolean;
Var
  e: String;
Begin
  e := ',' + Uppercase(FileExt) + ',';
  Result := Not (Pos(e, ',MPG,ASC,AVI,DOC,HTM,PDF,RTF,WAV,TXT,MPEG,MHT,MHTML,HTML,MP3,MP4,') > 0)
End;

{   Create a New Image Entry in the Image File, and Get IEN and FullPath  }

Function TMagImport.CreateImageEntry(Var Xmsg: String; Var ImageID: String;
  Imagefile: String): Boolean;
Var
  t: Tstringlist;
  TmpExt: String;
Begin
  Xmsg := '0^Error. Calling Remote Procedure.';
  t := Tstringlist.Create;
  Try
    t.Add('5^' + FDFN);
    If (FGroupIEN = '') Then
    Begin
      If (FProcPKG <> '') Then
      Begin
        t.Add('16^' + FProcPKG)
      End;
      If (FProcIEN <> '') Then
      Begin
        t.Add('17^' + FProcIEN)
      End;
    End
    Else
    Begin
      t.Add('14^' + FGroupIEN)
    End;
    If (FProcDt <> '') Then
    Begin
      t.Add('15^' + FProcDt)
    End;
    If (FDOCCTG <> '') Then
    Begin
      t.Add('100^' + FDOCCTG)
    End;
    If (FDocDT <> '') Then
    Begin
      t.Add('110^' + FDocDT)
    End;
    If (FixType <> '') Then
    Begin
      t.Add('42^' + FixType)
    End;
    If (FixSpec <> '') Then
    Begin
      t.Add('44^' + FixSpec)
    End;
    If (FixProc <> '') Then
    Begin
      t.Add('43^' + FixProc)
    End;
    If (FixOrigin <> '') Then
    Begin
      t.Add('45^' + FixOrigin)
    End;
    {tracking number is a ';' delimited  string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
    { DONE : Do we want these with each image, or only the group?. A: YES }
    If (FTrkNum <> '') Then
    Begin
      t.Add('108^' + FTrkNum)
    End;
    If (FAcqDev <> '') Then
    Begin
      t.Add('ACQD^' + FAcqDev)
    End;
    If (FAcqSite <> '') Then
    Begin
      t.Add('ACQS^' + FAcqSite)
    End;
    If (FAcqLoc <> '') Then
    Begin
      t.Add('ACQL^' + FAcqLoc)
    End;
    //t.add...(FExcpHandler)
    { We don't care about the Status handler from this call
    The BP will send any error message to the calling package.
      It has the Exception handler }
    { The next fields are NOT Required}
    // The Image Type (OBJECT TYPE) can be internal number or free text
    If (FImgType <> '') Then
    Begin
      t.Add('3^' + FImgType)
    End;
    //ResolveImageType);
    If (FMethod <> '') Then
    Begin
      t.Add('109^' + FMethod)
    End;
    Begin

      { TODO -ogarrett -cFields : Stuarts Component to Generate Images. }
      (*TImageMethodComponent.ResolveImages(FMethod,FImages);
        if (FImages.count = 0)
          then
            begin
              result := false;
              xmsg := 'Call to Generate Images returned ''0'' Images.');
              exit;
            end
         *)
    End;
    { example imagefile:= "c:\import\consent.tif^image description"
     P48 Fix to allow "." in image description
         Fix to allow "." in fullpath\filename
         Fix to allow extensions greater than 3 characters  i.e. ".HTML"}
    TmpExt := Uppercase(Copy(ExtractFileExt(FMagUtils.MagPiece(Imagefile, '^', 1)), 2, 99));
    If (TmpExt = 'TXT') Then
    Begin
      TmpExt := 'ASC'
    End;
    t.Add('EXT^' + TmpExt);
    { CapturedBy is Not Implemented, we get from DUZ in VistA}
    If (FCapBy <> '') Then
    Begin
      t.Add('8^' + FCapBy)
    End;
    { FUsernamePassword not validated here}
    If (FGroupDesc <> '') Then
    Begin
      t.Add('10^' + FGroupDesc)
    End;
    { If image has own description, use that. {}
    If (FMagUtils.MagPiece(Imagefile, '^', 2) <> '') Then
    Begin
      t.Add('10^' + FMagUtils.MagPiece(Imagefile, '^', 2))
    End;
    { FDeleteFlag not used here.  It is queried later, after image has been copied.}
    { FTransType  not validated here, used in the 'Save' Call.    }
    { This is end of Fields that are sent as parameters }
    // FProcType
    If (FProcDesc <> '') Then
    Begin
      t.Add('6^' + FProcDesc)
    End;
    If (FCapDt <> '') Then
    Begin
      t.Add('7^' + FCapDt)
    End;
    { FGroupLongDesc not validated, it is sent as is ( if it exists)}
    FDBBroker.RPMag4AddImage(Fstat, Flist, t);
    //in procedure CreateImageEntry
    Xmsg := Flist[0];
    Result := Fstat;
    If Not Fstat Then
    Begin
      LogMsg('3- Error AddImage');
      LogMsg('3- ' + Xmsg);
      Exit
    End;
    ImageID := Xmsg;
    LogMsg('3- Image IEN: ' + ImageID);
  Finally
    t.Free
  End;
End;

Function TMagImport.CreateGroup(Var Xmsg: String): Boolean;
Var
  t: Tstringlist;
Begin
  { here we Create a New Group in the Image File  {}
  t := Tstringlist.Create;
  Try
    { Add the fields that say, this is a group}
    t.Add('2005.04^0');
    // A group with no children
    t.Add('3^11');
    //  11 says this is group; OBJECT TYPE
    t.Add('5^' + FDFN);
    If (FProcPKG <> '') Then
    Begin
      t.Add('16^' + FProcPKG)
    End;
    If (FProcIEN <> '') Then
    Begin
      t.Add('17^' + FProcIEN)
    End;
    If (FProcDt <> '') Then
    Begin
      t.Add('15^' + FProcDt)
    End;
    If (FDOCCTG <> '') Then
    Begin
      t.Add('100^' + FDOCCTG)
    End;
    If (FDocDT <> '') Then
    Begin
      t.Add('110^' + FDocDT)
    End;
    If (FixType <> '') Then
    Begin
      t.Add('42^' + FixType)
    End;
    If (FixSpec <> '') Then
    Begin
      t.Add('44^' + FixSpec)
    End;
    If (FixProc <> '') Then
    Begin
      t.Add('43^' + FixProc)
    End;
    If (FixOrigin <> '') Then
    Begin
      t.Add('45^' + FixOrigin)
    End;
    { Tracking number is a ';' delimited string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
    If (FTrkNum <> '') Then
    Begin
      t.Add('108^' + FTrkNum)
    End;
    If (FAcqDev <> '') Then
    Begin
      t.Add('ACQD^' + FAcqDev)
    End;
    If (FAcqSite <> '') Then
    Begin
      t.Add('ACQS^' + FAcqSite)
    End;
    If (FAcqLoc <> '') Then
    Begin
      t.Add('ACQL^' + FAcqLoc)
    End;
    //t.add...(FExcpHandler)
    { We don't care about the exception handler. From this call
    The BP will send any error message to the calling package.
      It has the Exception handler }
    { The next fields are NOT Required}
    // The Image Type is already set by default for groups to '3^11';
    //if (FImgType <> '') then  t.add('3^'+FImgType); //ResolveImageType);
    If (FMethod <> '') Then
    Begin
      t.Add('109^' + FMethod)
    End;
    Begin

      { TODO -ogarrett -cFields : Stuarts Component to Generate Images. }
      (*TImageMethodComponent.ResolveImages(FMethod,FImages);
        if (FImages.count = 0)
          then
            begin
              result := false;
              xmsg := 'Call to Generate Images returned ''0'' Images.');
              exit;
            end
         *)
    End;

    If (FCapBy <> '') Then
    Begin
      t.Add('8^' + FCapBy)
    End;
    // FUsernamePassword not validated here
    If (FGroupDesc <> '') Then
    Begin
      t.Add('10^' + FGroupDesc)
    End;
    // FDeleteFlag not used here.  It is queried later, after image has been copied.
    // FTransType  not validated here, used in the 'Save' Call.
    { This is end of Fields that are sent as parameters }
    // FProcType
    // FProcDesc
    // if (FCapDt <> '') then t.add('7^' + FCapDt);
    // FGroupIEN
    // FGroupLongDesc not validated, it is sent as is ( if it exists)
    // TESTING  Test sending a write directory ... did it work ?
    //t.add('WRITE^4');
    FDBBroker.RPMag4AddImage(Fstat, Flist, t);
    //procedure CreateGroup
    Xmsg := Flist[0];
    Result := Fstat;
    If Not Fstat Then
    Begin
      LogMsg('3- Error Creating Group Image entry');
      Exit;
    End;

    FGroupIEN := FMagUtils.MagPiece(Xmsg, '^', 1);
    LogMsg('3- Group IEN: ' + FGroupIEN);
  Finally
    t.Free
  End;
End;

(*
Procedure TMagImport.FormatData;
//var
//  SS: string;
//  FileEXT: string;
//  tempimagetype: shortint;
begin
// Here we take the data and make the ImageArray
//   in the format Field^Data  or ActionCode^Data

// this is copy of FileImage from Tele19nu.pas
//   we following it to make sure we have all data we need.
//  to make a new call to Save Image Data.

// If this is a group, File the Group entry, then Loop through the Images
//  and file each one.
//  If one Image is successfully saved to VistA and Image Network Server.
//  then call will be successful.  EVEN if other Images fail.
//  other Images will be saved locally, or to network and somehow flagged ,
//  as a failed copy.  A File (.inf) or something will be saved along side the
//  image file.  This file will have pertinant information.  i.e. the info that
//  was in this component when the attempt to save the image failed.

  tempimagetype := 0;
  msg('', 'Filing the Image data...');
  if not xBrokerx.Connected then
  begin
    imagefiled := false;
    msg('d', 'No VistA Connection. Cannot Save Image.');
    exit;
  end;
  screen.cursor := crHourGlass;
  Memo2.Clear;
  xBrokerx.Param[0].Value := '.X';
  xBrokerx.Param[0].PType := list;
  LoadStaticFields;
  LoadSpecialtyFields;
  ss := uppercase(extractfileext(filenmx));
  if (uppercase(extractfileext(filenmx)) = '.AVI') and (imagetype <> 21)
    then if messagedlg('Importing Motion Video  (*.AVI) File ' + ss,
      mtconfirmation, [mbok, mbcancel], 0) <> mrOK then
    begin
      imagefiled := false;
      exit;
    end
    else
    begin
      tempimagetype := imagetype;
      imagetype := 21;
    end;
  if MagConfig.PhotoID.checked then
  begin
    tempimagetype := imagetype;
    imagetype := 18;
  end;
  if MagConfig.imagegroup.checked then
  begin
    xBrokerx.Param[0].Mult['"GROUP"'] := '14^' + GrpPtr;
    if DoesFormExist('DicomNumbers')
      then
    begin
      xBrokerx.Param[0].Mult['"DICOMSN"'] := 'DICOMSN^' + DicomNumbers.eDSN.TEXT;
      xBrokerx.Param[0].Mult['"DICOMIN"'] := 'DICOMIN^' + DicomNumbers.eDIN.TEXT;
    end;
  end;
  xBrokerx.Param[0].Mult['"OBJTYPE"'] := '3^' + IntToStr(ImageType);
  Memo2.Lines.Add('OBJTYPE^' + '3^' + IntToStr(ImageType));
  if tempimagetype <> 0 then
  begin
    imagetype := tempimagetype;
  end;
  FileEXT := Copy(Format, 2, 3);
  if Scanmode = 'Import' then
  begin
    if ImportIni = 'COPY' then FileEXT := Copy(ExtractFileExt(FileNmx), 2, 3);
    if ImportIni = 'TGA' then FileEXT := 'TGA';
  end;
  xBrokerx.Param[0].Mult['"FileExt"'] := 'EXT^' + FileExt;
//  gek 2/18/97 { TEST PETE'S "WRITE^PACS"  }
{--  xBrokerx.Param[0].Mult['"PACSWRITE"']:='WRITE^PACS';   gek 2/18/97}
{-- the TEST worked OK, but DON'T uncomment these lines}
{ test the BIG File flag  }

// If importing w/copy all and big file exists, set fbig node in 2005 saf 12/8/98
  if (MagBatchAdv.CopyAll.Checked and FileExists(lbImport.caption + '\' + FMagUtils.magpiece(FileNmx, '.', 1) + '.big')) then
    SaveBig := True;

  if SaveBig then xBrokerx.Param[0].Mult['"bigfile"'] := 'BIG^1';
  Memo2.Lines.Add('FileExt^EXT^' + FileEXT);
{ABS created on ws}
  if (ABSCreated and ABSforImage) then xBrokerx.Param[0].Mult['"NETLOCABS"'] := 'ABS^STUFFONLY';
   {GEK 4/16/97 STOP ABS ON 1 BIT TIF.}

  if (AbsCreated and MagBatchAdv.CopyAll.Checked) then xBrokerx.Param[0].Mult['"NETLOCABS"'] := 'ABS^STUFFONLY';
   // if copying abs on import, set abs pointer saf 12/8/98

  if (Writedir <> '') then xBrokerx.Param[0].Mult['"WRITEDIR"'] := '2^' + WRITEDIR;
  screen.cursor := crHourglass;
  //oldcopy  xBrokerx.remoteprocedure := 'MAGGADDIMAGE';
  ss := xBrokerx.STRcall;
  screen.cursor := crDefault;
  msg('s', ss);
  ImgPtr := FMagUtils.magpiece(sS, '^', 1);
  magien := ImgPtr;
  if ((ImgPtr = '0') or (ImgPtr = '')) then
  begin
    msg('', 'Image data NOT FILED : ' + FMagUtils.magpiece(sS, '^', 2));
    messagebeep(0);
    imagefiled := false;
    magien := '';
    exit;
  end;
  msg('', 'The Image data was filed OK');
  dirx := FMagUtils.magpiece(sS, '^', 2);
  FileSave := FMagUtils.magpiece(sS, '^', 3);
  MagImageFullPathAndName := dirx + filesave;
  FileSave := FMagUtils.magpiece(FileSave, '.', 1);
  if MagConfig.imagegroup.checked then ImagePtrLst.Items.Add(ImgPtr + '^' + FileSave);
  Memo2.Lines.Add('FILENAME^1^' + FileSave + Format);

//If not(UpperCase(Remote)='NONE') then
//      begin
//      Memo2.Lines.SaveToFile(tempdir + FileSave + '.txt');
//      Memo2.Clear;
//      end;
  imagefiled := true;

end;  *)

Procedure TMagImport.ClearProperties;
Begin
  FDFN := '';
  FImages.Clear;
  FProcPKG := '';
  FProcIEN := '';
  FProcDt := '';
  FTrkNum := '';
  FAcqDev := '';
  FAcqSite := '';
  FExcpHandler := '';

  FImgType := '';
  FMethod := '';
  FCapBy := '';
  FUsername := '';
  FPassword := '';
  FAcqLoc := '';
  FDOCCTG := '';
  FDocDT := '';
  FixType := '';
  FixSpec := '';
  FixProc := '';
  FixOrigin := '';

  FGroupDesc := '';
  FDeleteFlag := False;
  FTransType := 'NEW';

  FCapDt := '';
  FProcType := '';
  FProcDesc := '';
  FGroupIEN := '';
  FGroupLongDesc.Clear
End;

Procedure TMagImport.ImageArrayFromFields(Var t: Tstringlist);
Var
  Ict: Integer;
Begin
  { here we reformat the Imaging Fields from the component into an array
  and call The RPValidate function. {}
  t.Clear;
  t := Tstringlist.Create;

  t.Add('IDFN^' + FDFN);
  If (FProcPKG <> '') Then
  Begin
    t.Add('PXPKG^' + FProcPKG)
  End;
  If (FProcIEN <> '') Then
  Begin
    t.Add('PXIEN^' + FProcIEN)
  End;
  If (FProcDt <> '') Then
  Begin
    t.Add('PXDT^' + FProcDt)
  End;
  { Tracking Number is ';' delimited string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
  If (FTrkNum <> '') Then
  Begin
    t.Add('TRKID^' + FTrkNum)
  End;
  { Acq Dev Field = Computer Name}
  If (FAcqDev <> '') Then
  Begin
    t.Add('ACQD^' + FAcqDev)
  End;
  If (FAcqSite <> '') Then
  Begin
    t.Add('ACQS^' + FAcqSite)
  End;
  If (FAcqLoc <> '') Then
  Begin
    t.Add('ACQL^' + FAcqLoc)
  End;
  t.Add('STSCB^' + FExcpHandler);

  { The next fields are NOT Required, so test for ''}
  If (FImgType <> '') Then
  Begin
    // t.add(ResolveImageType);
    {TODO: make an RPC so other vendors can get list of
         image types and image type IENS, then this field will
         valildate just like any other.
        HERE we assume the image type is from our list.}
    t.Add('ITYPE^' + FImgType)
  End;
  { TODO -ogarrett -cFields : create Function ResloveImageType }
  If (FMethod <> '') Then
  Begin

    { TODO -ogarrett -cFields : Stuarts Component to Generate Images. }
    (*TImageMethodComponent.ResolveImages(FMethod,FImages);
        if (FImages.count = 0)
          then
            begin
              result := false;
              xmsg := 'Call to Generate Images returned ''0'' Images.');
              exit;
            end
         *)
  End;
  If (FCapBy <> '') Then
  Begin
    t.Add('CDUZ^' + FCapBy)
  End;
  { DONE :  FDOCCTG and FDocDt. DocDt and PXDT could both have values.
           DocDT is field 110 in image file.  DOCUMENT DATE}
  If (FDOCCTG <> '') Then
  Begin
    t.Add('DOCCTG^' + FDOCCTG)
  End;
  If (FDocDT <> '') Then
  Begin
    t.Add('DOCDT^' + FDocDT)
  End;
  If (FixType <> '') Then
  Begin
    t.Add('IXTYPE^' + FixType)
  End;
  If (FixSpec <> '') Then
  Begin
    t.Add('IXSPEC^' + FixSpec)
  End;
  If (FixProc <> '') Then
  Begin
    t.Add('IXPROC^' + FixProc)
  End;
  If (FixOrigin <> '') Then
  Begin
    t.Add('IXORIGIN^' + FixOrigin)
  End;
  // FUsername
  // FPassword not validated here
  If (FGroupDesc <> '') Then
  Begin
    t.Add('GDESC^' + FGroupDesc)
  End;
  // FDeleteFlag not used here.  It is queried later, after image has been copied.
  // FTransType  not validated here, used in the 'Save' Call.
  { This is end of Fields that are implemented }
  // FProcType
  // FProcDesc
  // if (FCapDt <> '') then t.add('7^' + FCapDt);
  // FGroupIEN
  // FGroupLongDesc not validated, it is sent as is ( if it exists)
  If (FImages.Count > 0) Then
  Begin
    For Ict := 0 To FImages.Count - 1 Do
    Begin
      t.Add('IMAGE^' + FImages[Ict])
    End;
  End;
End;

Function TMagImport.Validate(Var Xmsg: String): Boolean;
Var
  t: Tstringlist;
Begin
  { here we reformat the Imaging Fields from the component into an array
  and call The RPValidate function. {}
  //result := false;
  t := Tstringlist.Create;
  Try
    t.Add('5^' + FDFN);
    If (FProcPKG <> '') Then
    Begin
      t.Add('16^' + FProcPKG)
    End;
    If (FProcIEN <> '') Then
    Begin
      t.Add('17^' + FProcIEN)
    End;
    If (FProcDt <> '') Then
    Begin
      t.Add('15^' + FProcDt)
    End;
    { Field for Tracking Number is a delimited string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
    t.Add('108^' + FTrkNum);
    { Acq Dev Field = Computer Name}
    //10-23-03 GEK p8t31 Changed 107 to ACQD  We add new entries to the
    //   Acquisition Device File, if they don't exist.  BUT the Action Code
    //    ACQD does this, not Field 107
    //10-23-03 gek p8t31 t.add('107^' + FAcqDev);
    // THIS WORKED it added the new Acquisition Device FM entry.
    //   but not
    t.Add('ACQD^' + FAcqDev);
    //p8t21 t.add('.05^' + FacqSite);
    t.Add('ACQS^' + FAcqSite);
    //P8T21 if (FAcqLoc <> '') then t.add('101^' + FacqLoc);
    If (FAcqLoc <> '') Then
    Begin
      t.Add('ACQL^' + FAcqLoc)
    End;
    { DONE : We need to send ACQS and ACQL instead of the field #'s to populate
the Acquisition Device file.}
    //t.add...(FExcpHandler)
    { We don't care about the exception handler. From this call
    The BP will send any error message to the calling package.
      It needs the Exception handler }
    { The next fields are NOT Required, so  need to test for ''}
    If (FImgType <> '') Then
    Begin

      // t.add(ResolveImageType);
      // WE might make an RPC so other vendors can get list of
      //  image types and image type IENS, then this field will
      //  valildate just like any other.
    End;
    { TODO -ogarrett -cFields : create Function ResloveImageType }
    If (FMethod <> '') Then
    Begin

      { TODO -ogarrett -cFields : Stuarts Component to Generate Images. }
      (*TImageMethodComponent.ResolveImages(FMethod,FImages);
        if (FImages.count = 0)
          then
            begin
              result := false;
              xmsg := 'Call to Generate Images returned ''0'' Images.');
              exit;
            end
         *)
    End;
    If (FCapBy <> '') Then
    Begin
      t.Add('8^' + FCapBy)
    End;
    { DONE :  FDOCCTG and FDocDt. DocDt and PXDT could both have values.
           DocDT is field 110 in image file.  DOCUMENT DATE}
    If (FDOCCTG <> '') Then
    Begin
      t.Add('100^' + FDOCCTG)
    End;
    If (FDocDT <> '') Then
    Begin
      t.Add('110^' + FDocDT)
    End;
    If (FixType <> '') Then
    Begin
      t.Add('42^' + FixType)
    End;
    If (FixSpec <> '') Then
    Begin
      t.Add('44^' + FixSpec)
    End;
    If (FixProc <> '') Then
    Begin
      t.Add('43^' + FixProc)
    End;
    If (FixOrigin <> '') Then
    Begin
      t.Add('45^' + FixOrigin)
    End;
    // FUsername
    // FPassword not validated here
    If (FGroupDesc <> '') Then
    Begin
      t.Add('10^' + FGroupDesc)
    End;
    // FDeleteFlag not used here.  It is queried later, after image has been copied.
    // FTransType  not validated here, used in the 'Save' Call.
    { This is end of Fields that are sent as parameters }
    // FProcType
    // FProcDesc
    // if (FCapDt <> '') then t.add('7^' + FCapDt);
    // FGroupIEN
    // FGroupLongDesc not validated, it is sent as is ( if it exists)
    FDBBroker.RPMag4ValidateData(Fstat, Flist, t, '1');
    Xmsg := Flist[0];
    Result := Fstat;
    If Not Fstat Then
    Begin
      LogTheList(Flist)
    End

  Finally
    t.Free
  End;
End;

Function TMagImport.ImportDataArray(Var Xmsglist: Tstringlist; InArray: Tstringlist):
  Boolean;
Var
  Stat: Boolean;
Begin
  FDBBroker.RPMag4RemoteImport(Stat, Xmsglist, InArray);
  Result := Stat
End;

Procedure TMagImport.ImportQueue(Var Status: Boolean; Qnum: String; Var Reslist:
  TStrings; Var StatusCB: String;
  NoCallBackOnError: Boolean = False);
Var
  Xmsg: String;
  Ok: Boolean;
  Vserver,
    Vport,
    Savestat: String;
  DoStatusCB: Boolean;
Begin
  VistAInit(Ok, Xmsg, Vserver, Vport);
  If Not FBroker.Connected Then
  Begin
    Status := False;
    Qnum := '0';
    Reslist.Add('0^No Connection to VISTA.');
    Exit
  End;
  Try
   // reslist.Add('Connected: ' + vserver + ',' + vport);

    FLogList.Clear;
    //CreateNewLog;
    LogMsg('1- Log cleared.');
    LogMsg('Param: Qnum= ' + Qnum);
    LogMsg('Param: StatusCB= ' + StatusCB);
    LogMsg('Param: NoCallBckErr= ' + BoolToStr(NoCallBackOnError));

    Reslist.Clear;
    Status := False;

    FDBBroker.RPMag4DataFromImportQueue(Fstat, Flist, Qnum);
    If Not Fstat Then
    Begin
      Reslist.Assign(Flist);
      Exit
    End;
    LogMsg('1- Data from Queue OK.');

    Try
      // all Properties are defined in the next call, FtrkNUM is one of them
      If ImageArrayToFields(Xmsg, Flist) Then
      Begin
        LogMsg('1- Image Array To Fields. OK.');
        LogMsg('1- Calling SAVE...');
        Status := Save(Xmsg);
        Savestat := BoolToStr(Status);
        LogMsg('1- Save Status :  ' + Savestat)
      End
      Else
      Begin
        LogMsg('1- ArrayToFields FALSE');
        LogMsg('1- ' + Xmsg);
        If (FMagUtils.MagPiece(Xmsg, '^', 1) <> '0') Then
        Begin
          LogMsg('1-  ERROR Status and 0 node mismatch')
        End;
      End;

    Except
      On e: Exception Do
      Begin
        LogMsg('1- Exception:  ' + e.Message);
        Status := False;
        Xmsg := '0^' + e.Message
          //logmsg('Exception : ' + E.message);
      End;
    End;
    { Status Callback : our M routine will call their Status Callback{}
    {Patch P8T32  IMport API will call the Status Callback routine.}
    {  if success, but warnings, then change the '1^' to a '2^'.{}
    If ((FMagUtils.MagPiece(Xmsg, '^', 1) = '1') And (FLogList.Count >
      0)) Then
    Begin
      Xmsg := '2' + Copy(Xmsg, 2, 999)
    End;
    FLogList.Insert(0, Xmsg);
    FLogList.Insert(1, FTrkNum);
    FLogList.Insert(2, Qnum);
    LogMsg('End- Status: ' + BoolToStr(Status));
    LogMsg('End- NoCallBackOnError: ' + BoolToStr(NoCallBackOnError));
    LogMsg('End- Status Callback:  ' + FExcpHandler);
    Reslist.Assign(FLogList);
    StatusCB := FExcpHandler
  Finally
    {Patch P8T32  IMport API will call the Status Callback routine.
      based on new param NoCallBackOnError    {}
    DoStatusCB := ((Status) Or ((Not Status) And (Not NoCallBackOnError)));

    MagDBBroker.RPMag4StatusCallback(Reslist, FExcpHandler, DoStatusCB)
  End;
End;

Procedure TMagImport.CreateNewlog;
Begin
  FLogList.Clear
  //FLogList.add(FormatDateTime('hh:mm ', now) + 'Start Session.');
End;

Procedure TMagImport.LogTheMsg(s: String);
Begin
  FLogList.Add(s)
End;

Procedure TMagImport.LogTheList(t: Tstringlist);
Var
  i: Integer;
Begin
  For i := 0 To t.Count - 1 Do
  Begin
    LogTheMsg(t[i])
  End;
End;

Procedure TMagImport.LogTheList(t: TStrings);
Var
  i: Integer;
Begin
  For i := 0 To t.Count - 1 Do
  Begin
    LogTheMsg(t[i])
  End;
End;

Function TMagImport.ImageArrayToFields(Var Xmsg: String; Imgarray: Tstringlist):
  Boolean;
Var
  i: Integer;
  Fld,
    Data: String;
// TEMPORARILY WE WILL PUT THE Acqs;Acql TOGETHER TO FORM ACQS
Begin
  ClearProperties;
  Result := True;
  Xmsg := '1^Image Array to Component fields. OK.';
  For i := 0 To Imgarray.Count - 1 Do
  Begin
    Try
      Fld := FMagUtils.MagPiece(Imgarray[i], '^', 1);
      Data := Copy(Imgarray[i], Pos('^', Imgarray[i]) + 1, 999);
      //data := FMagUtils.magpiece(imgarray[i], '^', 2);
      //if (FMagUtils.magpiece(imgarray[i], '^', 3) <> '') then data := data + '^' + FMagUtils.magpiece(imgarray[i], '^', 3);
      If Fld = 'IMAGE' Then
      Begin
        FImages.Add(Data)
      End;
      If Fld = '101' Then
      Begin
        SetAcqLoc(Data)
      End;
      //ACQL
      If Fld = '.05' Then
      Begin
        SetAcqSite(Data)
      End;
      //ACQS
      If Fld = '5' Then
      Begin
        SetDFN(Data)
      End;
      If Fld = '16' Then
      Begin
        SetProcPKG(Data)
      End;
      If Fld = '17' Then
      Begin
        SetProcIEN(Data)
      End;
      If Fld = '15' Then
      Begin
        SetProcDt(Data)
      End;
      If Fld = '108' Then
      Begin
        SetTrkNum(Data)
      End;
      If Fld = 'ACQD' Then
      Begin
        SetAcqDev(Data)
      End;
      If Fld = '107' Then
      Begin
        SetAcqDev(Data)
      End;
      If Fld = 'ACQL' Then
      Begin
        SetAcqLoc(Data)
      End;
      If Fld = '101' Then
      Begin
        SetAcqLoc(Data)
      End;
      If Fld = 'ACQS' Then
      Begin
        SetAcqSite(Data)
      End;
      If Fld = '.05' Then
      Begin
        SetAcqSite(Data)
      End;
      If Fld = 'STATUSCB' Then
      Begin
        SetExcpHandler(Data)
      End;
      { The next fields are NOT Required}
      If Fld = 'ITYPE' Then
      Begin
        SetImgType(Data)
      End;
      (*if (FImgType <> '')
    then
      begin
       // t.add(ResolveImageType);
      end;
    { TODO -ogarrett -cFields : create Function ResloveImageType }
    *)
      If Fld = 'CALLMTH' Then
      Begin
        SetMethod(Data)
      End;
      If Fld = '8' Then
      Begin
        SetCapBy(Data)
      End;
      If Fld = 'USERNAME' Then
      Begin
        SetUsername(Data)
      End;
      If Fld = 'PASSWORD' Then
      Begin
        SetPassword(Data)
      End;
      If Fld = '10' Then
      Begin
        SetGroupDesc(Data)
      End;
      If Fld = 'DELFLAG' Then
      Begin
        SetDeleteFlag(Magstrtobool(Data))
      End;
      If Fld = 'TRNSTYP' Then
      Begin
        SetTransType(Data)
      End;
      If Fld = '100' Then
      Begin
        SetDOCCTG(Data)
      End;
      If Fld = '110' Then
      Begin
        SetDocDt(Data)
      End;
      { This is end of Fields that are sent as parameters }
      // FProcType
      // FProcDesc
      If Fld = '7' Then
      Begin
        SetCapDt(Data)
      End;
      If Fld = 'IEN' Then
      Begin
        SetGroupIEN(Data)
      End;
      If Fld = '42' Then
      Begin
        SetIndexType(Data)
      End;
      If Fld = '43' Then
      Begin
        SetIndexProc(Data)
      End;
      If Fld = '44' Then
      Begin
        SetIndexSpec(Data)
      End;
      If Fld = '45' Then
      Begin
        SetIndexOrigin(Data)
      End

    { TODO : Have to account for ANY Image Field NUMBER.  here }
    // FGroupLongDesc not validated, it is sent as is ( if it exists)
    Except
      On e: Exception Do
      Begin
        LogTheMsg(e.Message);
        Xmsg := '0^Invalid Data.';
        Result := False
      End;
    End;
  End;
  { DONE : ACQSite used to be Site;HospLOC, we now have two fields. ACQS and ACQL }
End;

Procedure TMagImport.SetDFN(Const Value: String);
Begin
  FDFN := Value
End;

Procedure TMagImport.SetImages(Const Value: TStrings);
Var
  i: Integer;
Begin
  For i := 0 To Value.Count - 1 Do
  Begin
    If Value[i] = '' Then
    Begin
      Continue
    End;
    If Value[i] = ' ' Then
    Begin
      Continue
    End;
  End;
  FImages.Assign(Value)
End;

Procedure TMagImport.SetProcPKG(Const Value: String);
Begin
  FProcPKG := Value
End;

Procedure TMagImport.SetProcIEN(Const Value: String);
Begin
  FProcIEN := Value
End;

Procedure TMagImport.SetProcDt(Const Value: String);
Begin
  FProcDt := Value
End;

Procedure TMagImport.SetTrkNum(Const Value: String);
Begin
  If Not DelimitedParam(Value) Then
  Begin
    Raise EInvalidData.Create('Invalid format for Tracking ID: ' + Value)
  End;
  FTrkNum := Value
End;

Procedure TMagImport.SetAcqDev(Const Value: String);
Begin
  FAcqDev := Value
End;

Procedure TMagImport.SetAcqSite(Const Value: String);
Begin
  FAcqSite := Value
End;

Procedure TMagImport.SetExcpHandler(Const Value: String);
Begin
  FExcpHandler := Value
End;

{ the Above are documented as required in the "M" API Call' }

Procedure TMagImport.SetImgType(Const Value: String);
Begin
  FImgType := Value
End;

Procedure TMagImport.SetMethod(Const Value: String);
Begin
  FMethod := Value
End;

Procedure TMagImport.SetCapBy(Const Value: String);
Begin
  If ((Value <> '') And (Not ValidInteger(Value))) Then
  Begin
    Raise EInvalidData.Create('Invalid format for DUZ: ' + Value)
  End;
  FCapBy := Value
End;

Procedure TMagImport.SetGroupDesc(Const Value: String);
Begin
  FGroupDesc := Value
End;

Procedure TMagImport.SetDeleteFlag(Const Value: Boolean);
Begin
  FDeleteFlag := Value
End;

Procedure TMagImport.SetTransType(Const Value: String);
Begin
  { Possible values are  NEW.   Later we may implement MOD or DEL{}
  FTransType := Value
End;

{ The fields below aren't in the Parameters passed .. Yet}

Procedure TMagImport.SetProcType(Const Value: String);
Begin
  FProcType := Value
End;

Procedure TMagImport.SetProcDesc(Const Value: String);
Begin
  FProcDesc := Value
End;

Procedure TMagImport.SetCapDt(Const Value: String);
Begin
  FCapDt := Value
End;

Procedure TMagImport.SetGroupIEN(Const Value: String);
Begin
  FGroupIEN := Value
End;

Procedure TMagImport.SetGroupLongDesc(Const Value: TStrings);
Begin
  FGroupLongDesc.Assign(Value)
End;

Procedure TMagImport.SetBroker(Const Value: TRPCBroker);
Begin
  FBroker := Value
End;

Function TMagImport.GetDeleteFlag: Boolean;
Begin
  Result := FDeleteFlag
End;

Function TMagImport.GetTransType: String;
Begin
  Result := FTransType
End;

Function TMagImport.GetGroupIEN: String;
Begin
  Result := FGroupIEN
End;

Function TMagImport.GetAcqDev: String;
Begin
  Result := FAcqDev
End;

Function TMagImport.GetAcqSite: String;
Begin
  Result := FAcqSite
End;

Function TMagImport.GetBroker: TRPCBroker;
Begin
  Result := FBroker
End;

Function TMagImport.GetCapBy: String;
Begin
  Result := FCapBy
End;

Function TMagImport.GetCapDt: String;
Begin
  Result := FCapDt
End;

Function TMagImport.GetDFN: String;
Begin
  Result := FDFN
End;

Function TMagImport.GetImages: TStrings;
Begin
  Result := FImages
End;

Function TMagImport.GetImgType: String;
Begin
  Result := FImgType
End;

Function TMagImport.GetMethod: String;
Begin
  Result := FMethod
End;

Function TMagImport.GetProcDesc: String;
Begin
  Result := FProcDesc
End;

Function TMagImport.GetProcDt: String;
Begin
  Result := FProcDt
End;

Function TMagImport.GetProcPKG: String;
Begin
  Result := FProcPKG
End;

Function TMagImport.GetProcIEN: String;
Begin
  Result := FProcIEN
End;

Function TMagImport.GetProcType: String;
Begin
  Result := FProcType
End;

Function TMagImport.GetTrkNum: String;
Begin
  Result := FTrkNum
End;

Function TMagImport.GetExcpHandler: String;
Begin
  Result := FExcpHandler
End;

Function TMagImport.GetGroupDesc: String;
Begin
  Result := FGroupDesc
End;

Function TMagImport.GetGroupLongDesc: TStrings;
Begin
  Result := FGroupLongDesc
End;

Function TMagImport.GetMag4Security: TMag4Security;
Begin
  Result := FMagSecurity
End;

Procedure TMagImport.SetMag4Security(Const Value: TMag4Security);
Begin
  FMagSecurity := Value
End;

Function TMagImport.CopyImageToServer(Var Xmsg: String; ImageID, Imagefile: String): Boolean;
Var
  NFullName,
    OFullName: String;
Begin
  Try
    NFullName := FMagUtils.MagPiece(ImageID, '^', 2) + FMagUtils.MagPiece(ImageID, '^', 3);
    OFullName := Imagefile;
    //fUnStrings.Add(Inttostr(Funstrings.count)); // force error
    If CopyTheFile(Xmsg, OFullName, NFullName) Then
      Result := True
    Else
      Result := False;
  Except
    On e: Exception Do
    Begin
      Result := False;
      Xmsg := '0^' + e.Message;
    End;
  End;
End;

Function TMagImport.CopyTheFile(Var Xmsg: String; FromFile, ToFile: String): Boolean;
Var
  Ndir: String;
  TmpUser,
    TmpPass,
    Zmsg,
    Textmsg: String;
Begin
  TmpUser := '';
  TmpPass := '';
  Result := False;
  { Here we copy the File to the Image Write Directory ( Image Network Server )}
  Try
    { Quit if we can't connect to the Image Network Server }
    If ((FUsername <> '') And (FPassword <> '')) Then
    Begin
      Try

        TmpUser := FUsername
      // tmpPass := decrypt(FPassword);
      Except
        On e: Exception Do
        Begin
          Xmsg := '-1^Error: Invalid Password.';
          FMagSecurity.MagCloseSecurity(Zmsg);
          Exit
        End;
      End;
    End;
    { TODO : Passed Username and Password is for FROM directory }
    If Not FMagSecurity.MagOpenSecurePath(FromFile, Xmsg, TmpUser, TmpPass) Then
    Begin
      FLogList.AddStrings(FMagSecurity.Msglist);
      Exit
    End;
    { DONE : Test if File Exists : }
    If Not FileExists(FromFile) Then
    Begin
      Xmsg := 'File doesn''t exist : ' + FromFile;
      Exit
    End;
    Try
      If Not FMagSecurity.MagOpenSecurePath(ToFile, Xmsg, '', '', True) Then
      Begin
      //FLogList.AddStrings(FMagSecurity.msglist);
        Result := False;
        Exit
      End;
    Except
      On e: Exception Do
      Begin
        Result := False;
        Xmsg := '0^Error during Open Network Connection';
        LogTheMsg(e.Message);
      End;
    End;
    { Quit if we need to create the directory, but can't.
                             ( mainly for Hashed Directories )}
    If Not Directoryexists(ExtractFileDir(ToFile)) Then
    Begin
      Ndir := ExtractFileDir(ToFile);
      Forcedirectories(Ndir);
      If Not Directoryexists(Ndir) Then
      Begin
        Xmsg := '0^Can''t create directory: ' + ExtractFileDir(ToFile);
        Exit
      End;
    End;
    Try
      If CopyFile(PChar(FromFile), PChar(ToFile), True) Then
      Begin
        Result := True;
        // CPMOD  make the text file.
        CreateAndSaveImageTextFile(ToFile, Textmsg); // etrap ok
      End
      Else
      Begin
        Result := False;
        Xmsg := '0^FAILED to Copy File: ' + FromFile + ' to: ' + ToFile
      End;
      { TODO : Test for existance and Size > 0 }
      FMagSecurity.MagCloseSecurity(Zmsg)
    Except
      On e: Exception Do
      Begin
        Xmsg := '0^' + e.Message;
        FMagSecurity.MagCloseSecurity(Zmsg)
      End;
    End;

  Except
    On e: Exception Do
    Begin
      Xmsg := '0^Exception -  during CopyTheFile function';
      LogTheMsg(e.Message);
    End;
  End;
End;

Procedure TMagImport.FileSpecialtyPointers(ImageID: String);
Var
  Magien: String;
Begin
  { Were only doing TIU documents for now, so this code will have to be
     modified later to enable importing images via this API to other packages.{}
  Magien := FMagUtils.MagPiece(ImageID, '^', 1);
  If (Uppercase(FProcPKG) = 'TIU')
    Or
    (FProcPKG = '8925') Then
  Begin
    If (FProcIEN = '') Then
    Begin
      LogMsg('3- FileSpecPointers:  Procedure IEN is Null.');
      Exit
    End;
    FDBBroker.RPMag3TIUImage(Fstat, Flist, Magien, FProcIEN);
    If Not Fstat Then
    Begin
      LogMsg('3- FileSpecialtyPointers Failed');
      LogMsg('3- ImageIEN: ' + Magien + 'TIU DA: ' + FProcIEN);
      LogMsg('3- ' + Flist[0]);
      LogTheList(Flist);
    End
    Else
    Begin
      LogMsg('3- FileSpecialtyPointers OK.');
      LogMsg('3- Image IEN: ' + Magien + 'Procedure IEN: ' + FProcIEN);
    End;
  End;
End;

{ VistAInit assures we can connect, and get UserName password from Site.{}

Procedure TMagImport.InitIfNeeded;
Begin
  If Not Assigned(FDBBroker) Then
  Begin
    FDBBroker := TMagDBMVista.Create();
  End;
  If Not Assigned(FBroker) Then
  Begin
    FBroker := TRPCBroker.Create(Self)
  End;
  FDBBroker.SetBroker(FBroker);
  // .broker := FBroker;
  If Not Assigned(FMagSecurity) Then
  Begin
    FMagSecurity := TMag4Security.Create(Self)
  End;
End;

Procedure TMagImport.ConnectIfNeeded(Var Vserver: String; Var Vport: String;
  AccessCode: String = ''; Verifycode: String
  = '');
Begin
  InitIfNeeded;
  If Not FDBBroker.IsConnected Then
  Begin
    If (Vserver = '')
      Or
      (Vport = '') Then
    Begin
      FDBBroker.DBSelect(Vserver, Vport, 'MAG WINDOWS')
    End
    Else
    Begin
      FDBBroker.DBConnect(Vserver, Vport, 'MAG WINDOWS', AccessCode, Verifycode)
    End;
  End;
End;

Procedure TMagImport.VistAInit(Var Status: Boolean; Var Xmsg: String; Var
  Vserver: String; Var Vport: String; AccessCode: String
  = ''; Verifycode: String = '');
Var
  Duz,
    Username: String;
  Rlist: TStrings;
  Rmsg: String;
Begin
  Status := False;
  Rlist := Tstringlist.Create;
  Try
    Try
      ConnectIfNeeded(Vserver, Vport, AccessCode, Verifycode)
    Except
      On e: Exception Do
      Begin
        Xmsg := e.Message;
        Exit
      End;
    End;
    If Not FDBBroker.IsConnected Then
    Begin
      Xmsg := 'No Connection to VISTA.';
      Exit
    End;
    FDBBroker.RPMaggUser2(Fstat, Rmsg, Rlist, 'Import API');
    If Not Fstat Then
    Begin
      Xmsg := Rlist[0];
      Exit
    End;
    Duz := FMagUtils.MagPiece(Rlist[1], '^', 1);
    If Not SetNetUsernamePassword(FMagUtils.MagPiece(Rlist[2], '^', 1),
      FMagUtils.MagPiece(Rlist[2], '^', 2), FMagSecurity, Xmsg) Then
    Begin
      Exit
    End;
    (*MagFileSecurity.Username := magpiece(xBrokerx.RESULTS[2],'^',1);
   MagFileSecurity.Password := decrypt(magpiece(xBrokerx.RESULTS[2],'^',2));*)
    If Duz = '0' Then
    Begin
      Xmsg := FMagUtils.MagPiece(Rlist[1], '^', 2) + ' Disconnecting from VistA';
      Status := False;
      FBroker.Connected := False
    End
    Else
    Begin
      Status := True;
      Username := FMagUtils.MagPiece(Rlist[1], '^', 2);
      Xmsg := Username + ': ' + Vserver + ' connection OK. ';
      FCaptureKeys.Clear
    End;

  Finally
    Rlist.Free
  End;
End;

Function TMagImport.SetNetUsernamePassword(User, Pass: String; Var MagSec:
  TMag4Security; Var Xmsg: String): Boolean;
Begin
  Result := False;
  If (User = '')
    Or
    (Pass = '') Then
  Begin
    Xmsg := '0^Invalid Imaging Network Username or Password.'
  End
  Else
  Begin
    Try
      MagSec.Username := User;
      MagSec.Password := Decrypt(Pass);
      Result := True
    Except
      On e: Exception Do
      Begin
        Xmsg := '0^Error during password decryption.'
      End;
    End;
  End;
End;

Procedure TMagImport.DeleteImageEntry(Var Xmsg: String; Ien: String);
Var
  s: String;
  Rmsg: String;
  Rlist: TStrings;
Begin
  Rlist := Tstringlist.Create;
  Try
    s := '';
    If (Ien = '') Then
    Begin
      Exit
    End;
    FDBBroker.RPMaggImageDelete(Fstat, Rmsg, Rlist, Ien, '1');
    Xmsg := Rlist[0];
    If Not Fstat Then
    Begin
      LogTheList(Rlist)
    End

  Finally
    Rlist.Free
  End;
End;

Function TMagImport.GetDBBroker: TMagDBBroker;
Begin
  Result := FDBBroker
End;

Procedure TMagImport.SetDBBroker(Const Value: TMagDBBroker);
Begin
  FDBBroker := Value
End;

Function TMagImport.GetAcqLoc: String;
Begin
  Result := FAcqLoc
End;

Function TMagImport.GetDOCCTG: String;
Begin
  Result := FDOCCTG
End;

Function TMagImport.GetDocDt: String;
Begin
  Result := FDocDT
End;

Function TMagImport.GetPassword: String;
Begin
  Result := FPassword
End;

Function TMagImport.GetUsername: String;
Begin
  Result := FUsername
End;

Procedure TMagImport.SetAcqLoc(Const Value: String);
Begin
  FAcqLoc := Value
End;

Procedure TMagImport.SetDOCCTG(Const Value: String);
Begin
  FDOCCTG := Value
End;

Procedure TMagImport.SetDocDt(Const Value: String);
Begin
  FDocDT := Value
End;

Procedure TMagImport.SetPassword(Const Value: String);
Begin
  FPassword := Value
End;

Procedure TMagImport.SetUsername(Const Value: String);
Begin
  FUsername := Value
End;

Function TMagImport.CreateAndSaveImageTextFile(ImageToFile: String; Var Xmsg: String):
  Boolean;
Var
  ImageTextfile: String;
  t,
    T1: Tstringlist;
  Stat: Boolean;
  Patinfo: String;
Begin
  Result := False;
  Xmsg := 'Attempting to save .txt file...';
  t := Tstringlist.Create;
  T1 := Tstringlist.Create;
  Try
    ImageTextfile := FMagUtils.MagPiece(ImageToFile, '.', 1) +
      '.txt';
    t.Add('$$BEGIN IMAGE DATA');
    t.Add('TRANSACTION_ID=' + FTrkNum);

    FDBBroker.RPMagPatInfo(Stat, Patinfo, FDFN);
    t.Add('PATIENTS_NAME=' + FMagUtils.MagPiece(Patinfo, '^',
      3));
    //Pt Name );
    t.Add('PATIENTS_ID=' + FMagUtils.MagPiece(Patinfo, '^', 6));
    //Pt SSN );
    t.Add('PATIENTS_BIRTH_DATE=' + FMagUtils.MagPiece(Patinfo,
      '^', 5));
    //Pt DOB );
    t.Add('PATIENTS_SEX=' + FMagUtils.MagPiece(Patinfo, '^',
      4));
    // PT SEX );
    t.Add('IMAGE_DATE=' + CapDt);
    t.Add('CAPTURED BY=' + CapBy);
    t.Add('ACQ_DEVICE=' + FAcqDev);
    // t.Add('SHORT DESCRIPTION=' + (FMagUtils.magpiece(FMagUtils.magpiece(imageID,'|',2),'^',2)));    (*
    (*if imagelongdesc.lines.count > 0 then
    begin
      t.add('LONG DESCRIPTION');
      for i := 0 to imagelongdesc.lines.count - 1 do
      begin
        t.Add(imagelongdesc.lines[i]);
      end;
    end;   *)
    t.Add('$$END IMAGE DATA');
    Try
      t.SaveToFile(ImageTextfile);
      Xmsg := 'Notes saved to .txt file: ' + ImageTextfile;
      Result := True
    Except
      Xmsg := 'Failed to copy .txt File to Imaging Network';
      Exit
    End;

  Finally
    t.Free;
    T1.Free
  End;
End;

Procedure TMagImport.SaveDirect(Var Status: Boolean; Var Xmsglist: TStrings);
Var
  Xmsg: String;
  Vserver,
    Vport: String;
  t: Tstringlist;
  Relist: Tstringlist;
  Stat: Boolean;
Begin
  VistAInit(Stat, Xmsg, Vserver, Vport);
  If Not Stat Then
  Begin
    Status := Stat;
    Xmsglist.Insert(0, Xmsg);
    Exit
  End;
  //  ConnectIfNeeded(vserver ,vport );
  If Not FBroker.Connected Then
  Begin
    Status := False;
    Xmsglist.Insert(0, 'No Connection to VISTA');
    Exit
  End;
  t := Tstringlist.Create;
  Try
    Relist := Tstringlist.Create;
    FLogList.Clear;
    ImageArrayFromFields(t);
    // new
    t.Add('TRTYPE^NOQUEUE');
    Stat := ImportDataArray(Relist, t);
    // with transaction type = NOQUEUE, it'll do Req Field check
    //  and validate, then stop. without creating the queue.
    If Not Stat Then
    Begin
      Status := Stat;
      Xmsglist.Assign(Relist);
      Exit
    End;
    Status := Save(Xmsg);

    If ((FMagUtils.MagPiece(Xmsg, '^', 1) = '1') And (FLogList.Count >
      0)) Then
    Begin
      Xmsg := '2' + Copy(Xmsg, 2, 999)
    End;
    //^' + FMagUtils.magpiece(xmsg, '^', 2);
    FLogList.Insert(0, Xmsg);
    FLogList.Insert(1, FTrkNum);
    Xmsglist.Assign(FLogList)
  Finally
    // P8t32  Weren't we calling the Status Callback Routine.
    MagDBBroker.RPMag4StatusCallback(Xmsglist, FExcpHandler);

    { TODO : take out the // testing }
    ClearProperties;
    t.Free;
    Relist.Free
  End;
End;

Procedure TMagImport.ImageAdd(Imagefile: String);
Begin
  Images.Add(Imagefile)
End;

Procedure TMagImport.Showproperties;
Var
  s: String;
Begin
  s := '';
  s := s + ('IDFN: ' + FDFN) + ' [' + Inttostr(Length(FDFN)) +
    ']' + #13#10;
  s := s + ('PXPKG: ' + FProcPKG) + ' [' + Inttostr(Length(FProcPKG)) +
    ']' + #13#10;
  s := s + ('PXIEN: ' + FProcIEN) + ' [' + Inttostr(Length(FProcIEN)) +
    ']' + #13#10;
  s := s + ('PXDT: ' + FProcDt) + ' [' + Inttostr(Length(FProcDt)) +
    ']' + #13#10;
  s := s + ('TRKID: ' + FTrkNum) + ' [' + Inttostr(Length(FTrkNum)) +
    ']' + #13#10;
  s := s + ('ACQD: ' + FAcqDev) + ' [' + Inttostr(Length(FAcqDev)) +
    ']' + #13#10;
  s := s + ('ACQS: ' + FAcqSite) + ' [' + Inttostr(Length(FAcqSite)) +
    ']' + #13#10;
  s := s + ('ACQL: ' + FAcqLoc) + ' [' + Inttostr(Length(FAcqLoc)) +
    ']' + #13#10;
  s := s + ('STSCB: ' + FExcpHandler) + ' [' + Inttostr(Length(FExcpHandler)) +
    ']' + #13#10;
  s := s + ('ITYPE: ' + FImgType) + ' [' + Inttostr(Length(FImgType)) +
    ']' + #13#10;
  s := s + ('CDUZ: ' + FCapBy) + ' [' + Inttostr(Length(FCapBy)) +
    ']' + #13#10;
  s := s + ('DOCCTG: ' + FDOCCTG) + ' [' + Inttostr(Length(FDOCCTG)) +
    ']' + #13#10;
  s := s + ('DOCDT: ' + FDocDT) + ' [' + Inttostr(Length(FDocDT)) +
    ']' + #13#10;

  s := s + ('IXTYPE: ' + FixType) + ' [' + Inttostr(Length(FixType)) +
    ']' + #13#10;
  s := s + ('IXSPEC: ' + FixSpec) + ' [' + Inttostr(Length(FixSpec)) +
    ']' + #13#10;
  s := s + ('IXPROC: ' + FixProc) + ' [' + Inttostr(Length(FixProc)) +
    ']' + #13#10;
  s := s + ('IXORIGIN: ' + FixOrigin) + ' [' + Inttostr(Length(FixOrigin)) +
    ']' + #13#10;

  s := s + ('GDESC: ' + FGroupDesc) + ' [' + Inttostr(Length(FGroupDesc)) +
    ']' + #13#10;
  Showmessage(s)
End;

Function TMagImport.GetIndexProc: String;
Begin
  Result := FixProc
End;

Function TMagImport.GetIndexSpec: String;
Begin
  Result := FixSpec
End;

Function TMagImport.GetIndexType: String;
Begin
  Result := FixType
End;

Function TMagImport.GetIndexOrigin: String;
Begin
  Result := FixOrigin
End;

Procedure TMagImport.SetIndexProc(Const Value: String);
Begin
  FixProc := Value
End;

Procedure TMagImport.SetIndexSpec(Const Value: String);
Begin
  FixSpec := Value
End;

Procedure TMagImport.SetIndexType(Const Value: String);
Begin
  FixType := Value
End;

Procedure TMagImport.SetIndexOrigin(Const Value: String);
Begin
  FixOrigin := Value
End;

(*procedure TmagImport.LogFileInit;
var
   filex : string;
begin
  filex := ExtractFilePath(Application.ExeName)+ 'MagIAPI'+FormatDateTime('mmddyy', NOW)+'.log';
  AssignFile(FMyLogFile,filex);
  if not FileExists(filex)
    then ReWrite(FMyLogFile)
    else Append(FMyLogFile);
end;  *)

Procedure TMagImport.LogMsg(s: String);
Begin
{$IFDEF DEBUG}
  FLogList.Add(s)
{$ENDIF}
End;

Procedure TMagImport.LogMsg(t: TStrings; Pf: String = '');
Var
  i: Integer;
Begin
{$IFDEF DEBUG}
  If (Pf <> '') Then Pf := Pf + ' - ';
  For i := 0 To t.Count - 1 Do
  Begin
    LogTheMsg(Pf + t[i])
  End;

{$ENDIF}
End;

Function TMagImport.BoolToStr(Val: Boolean): String;
Begin
  If Val Then
    Result := 'True'
  Else
    Result := 'False';
End;

End.
