unit cRequestInstallThread;

interface

uses Windows, Classes, Forms, SysUtils, IniFiles, Dialogs,
  IdSoapClientHTTP, IdSoapITIProvider, dMagInstallServiceClient,
  IdSoapTypeRegistry;

type
  TRequestInstallThread = class(TThread)
  private
    InstallService: IInstall;
  protected
    procedure Execute; override;
    procedure CreateSoapClient();
    function GetComputerNetName(): string;
end;

implementation

procedure TRequestInstallThread.Execute;
begin
  CreateSoapClient();
  try
     InstallService.RequestInstall(GetComputerNetName());
  except on Fault: EIdSoapFault do
    begin
      Application.ProcessMessages();
      ShowMessage('Error, installation request failed' + #13 + #10 + Fault.FaultString);
    end;
    on E: Exception do
    begin
      Application.ProcessMessages();
      ShowMessage('Error, installation request failed' + #13 + #10 + E.Message);
    end;
  end;
end;

procedure TRequestInstallThread.CreateSoapClient();
var
  MagNetIni: TIniFile;
  SoapClient: TIdSoapClientHTTP;
begin
  SoapClient := TIdSoapClientHTTP.create(Application.MainForm);
  MagNetIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'magnet.ini');
  SoapClient.SoapURL := MagNetIni.ReadString('update_mode', 'InstallService', 'InstallService not found');
  MagNetIni.Free();
  SoapClient.ITISource := islResource;
  SoapClient.ITIResourceName := 'dMagInstallServiceClient';
  SoapClient.Active := true;
  InstallService := GetIinstall(SoapClient, false);
end;

function TRequestInstallThread.GetComputerNetName(): string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

end.
 