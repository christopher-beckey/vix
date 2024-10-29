unit AnnotationPlugIn;

interface

uses
  ComObj, ActiveX, AnnotationTool_TLB, StdVcl, CPRSChart_TLB, Controls,
  Dialogs, Messages, Classes, Maggut1, Windows, Sysutils;//, trpcb;

type
  TAnnotationPlugIn = class(TAutoObject, IAnnotationPlugIn, ICPRSExtension)
  protected
    function Execute(const CPRSBroker: ICPRSBroker;
      const CPRSState: ICPRSState; const Param1, Param2,
      Param3: WideString; var Data1, Data2: WideString): WordBool;
      safecall;
    { Protected declarations }
    function GetComputerNetName: string;
    procedure ParseResultStrings(const RPCResult: string);

  end;



implementation

uses ComServ, fmagcapannotate;

function TAnnotationPlugIn.Execute(const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState; const Param1, Param2, Param3: WideString;
  var Data1, Data2: WideString): WordBool;

Const
cnMaxLen = 255;

var
  indir, outdir: string;
  RootDir : string;
  fname: string;

  description: string;
  ACQS, PXDT: string;
  i: integer;
  ImportRec: Tstringlist;
  Ext : string;



begin
  if CPRSBroker.SetContext('MAG WINDOWS') = False then
  begin
    ShowMessage('Can not establish a connection with the VistA Server... Exiting');
    Exit;
  end;
  try
    CPRSBroker.CallRPC('MAG GET ENV');
    ACQS := trim(magpiece(CPRSBroker.Results,'^',1));
    PXDT := trim(magpiece(CPRSBroker.Results,'^',2));
    CPRSBroker.ParamType[0] := bptLiteral;
    CPRSBroker.Param[0] := 'DGM';
    CPRSBroker.CallRPC('MAG GET NETLOC');
    Indir := magpiece(CPRSBroker.Results, '^',3) + '\in';
    RootDir := Indir;
    if trim(Param3) <> '' then Indir := Indir + '\' + trim(Param3);
    Outdir := magpiece(CPRSBroker.Results, '^',3) + '\out';
    fname := Outdir + '\' + ACQS + '_' + CPRSState.UserDUZ + '_' +
                magpiece(PXDT,'.',1) + '_' + magpiece(PXDT,'.',2);// + '.tif';

    frmCapAnnotate := TfrmCapAnnotate.Create(Nil);
    Result := frmCapAnnotate.Execute(Indir, fname, description, RootDir, Ext);
//    showmessage('The extension is: ' + Ext);

  except
    on E: Exception do Showmessage('ERROR: ' + E.Message);
  end;
  if description <>'' then
  begin
    fname := fname + Ext;

    ImportRec :=Tstringlist.create;
    ImportRec.Add('IMAGE^' + fname);
    ImportRec.Add('ACQD^' + GetComputerNetName);

    ImportRec.Add('ACQS^' + ACQS);
    ImportRec.Add('IDFN^' + CPRSState.PatientDFN);
    ImportRec.Add('STSCB^' + 'ANNCB^MAGGTU6');
    ImportRec.Add('TRKID^' + 'ANN;' + ACQS + '_' + CPRSState.UserDUZ + '_' +
                magpiece(PXDT,'.',1) + '_' + magpiece(PXDT,'.',2));
    ImportRec.Add('PXPKG^' + '8925');
    ImportRec.Add('PXIEN^' + magpiece(magpiece(Data2,'>',3),'<',1));
    ImportRec.Add('PXDT^' + PXDT);
    ImportRec.Add('CDUZ^' + CPRSState.UserDUZ);
    ImportRec.Add('DFLG^' + '1');
    importrec.Add('IXTYPE^' + 'DIAGRAM');
    importrec.add('IXORIGIN^' + 'VA');

    try
      CPRSBroker.ParamType[0] :=bptList;
      for i := 0 to ImportRec.Count - 1 do
      begin
        CPRSBroker.ParamList[0,inttostr(i)] := ImportRec[i];
        //showmessage('paramlist[0,' + inttostr(i) + '] = ' + CPRSBroker.paramlist[0,inttostr(i)]);
      end;
      CPRSBroker.CallRPC('MAG4 REMOTE IMPORT');
      If trim(magpiece(CPRSBroker.results,'^',2))='Data has been Queued.' then
//        Showmessage('Your Diagram has been queued for Import')
        Showmessage('Your Diagram is being sent to the VistA Imaging archive.')
      else
        //Showmessage(magpiece(CPRSBroker.results,'^',2));
        Showmessage('An error occurred when your diagram was sent to VistA Imaging for import.  The error is: ' + CPRSBroker.results);
    except
        on E: Exception do Showmessage('The following error was returned from the VistA Imaging COM object: ' + E.Message);

    end;
    ImportRec.Free;
  end;
  frmCapAnnotate.Destroy;
end;

procedure TAnnotationPlugIn.ParseResultStrings(const RPCResult: string);
var
  strings: TStringList;
  i: integer;
begin
  strings := TstringList.Create;
  try
    strings.Text := RPCResult;
    for i:= 0 to strings.Count-1 do
    begin
     //code here
    end;
  finally
    strings.Free;

  end;
end;



function TAnnotationPlugIn.GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := '';
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAnnotationPlugIn, Class_AnnotationPlugIn,
    ciMultiInstance, tmApartment);
end.
