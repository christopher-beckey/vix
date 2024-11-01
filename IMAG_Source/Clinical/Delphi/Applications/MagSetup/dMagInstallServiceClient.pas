Unit dMagInstallServiceClient;

{---------------------------------------------------------------------------
This file generated by the IndySoap WSDL -> Pascal translator

Source:   http:\\localhost\imaging\install.asmx?wsdl
Date:     4/14/2004 4:49:18 PM
IndySoap: V0.07
---------------------------------------------------------------------------}

Interface

Uses
  IdSoapClient,
  IdSoapTypeRegistry;

type
  {Soap Address for this Interface: http://localhost/imaging/install.asmx}
  Iinstall = Interface (IIdSoapInterface) ['{ED94CBB7-0051-4AF6-A1E4-46B269593787}']
       {!Namespace: http://www.va.gov/imaging/install;
         SoapAction: http://www.va.gov/imaging/install/RequestInstall;
         Encoding: Document}
    function  RequestInstall(machine : String) : String; stdcall;
  end;

function GetIinstall(AClient : TIdSoapBaseSender; ASetUrl : Boolean = true) : Iinstall;

Implementation

{$R dMagInstallServiceClient.res}

uses
  IdSoapRTTIHelpers,
  IdSoapUtilities,
  SysUtils;


function GetIinstall(AClient : TIdSoapBaseSender; ASetUrl : Boolean = true) : Iinstall;
begin
  if ASetURL and (AClient is TIdSoapWebClient) then
    begin
    (AClient as TIdSoapWebClient).SoapURL := 'http://localhost/imaging/install.asmx';
    end;
  result := IdSoapD4Interface(AClient) as Iinstall;
end;

End.
