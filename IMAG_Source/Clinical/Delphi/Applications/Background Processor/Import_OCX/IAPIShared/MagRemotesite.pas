Unit MagRemotesite;

Interface

Type
  cMagRemoteToolbarSite = Class(Tobject)
  Private
    FSiteName: String;
    Fsitecode: String;
    FButtonIndex: Integer;
    FImageCount: Integer;
    FSiteStatus: Integer;
    FErrorMessage: String;
    FPatientVisited: Boolean;

    Procedure SetSiteName(Const Value: String);
    Procedure SetSiteCode(Const Value: String);
    Procedure SetButtonIndex(Const Value: Integer);
//      procedure SetSiteNumber(const Value: String);
    Procedure SetImageCount(Const Value: Integer);
    Procedure SetSiteStatus(Const Value: Integer);
    Procedure SetErrorMessage(Const Value: String);
    Procedure SetPatientVisited(Const Value: Boolean);

  Public
    Constructor Create(SiteName: String; Sitecode: String; aButtonIndex: Integer = 0);

    Property SiteName: String Read FSiteName Write SetSiteName;
    Property Sitecode: String Read Fsitecode Write SetSiteCode;
//      property SiteNumber : string read FSiteNumber write SetSiteNumber;
    Property ImageCount: Integer Read FImageCount Write SetImageCount;
    Property SiteStatus: Integer Read FSiteStatus Write SetSiteStatus;
    Property ErrorMessage: String Read FErrorMessage Write SetErrorMessage;
    Property ButtonIndex: Integer Read FButtonIndex Write SetButtonIndex;
    Property PatientVisited: Boolean Read FPatientVisited Write SetPatientVisited;

  Protected

  End;

Const
  SITESTATUS_ACTIVE = 1;
Const
  SITESTATUS_INACTIVE = 2;
Const
  SITESTATUS_DISCONNECTED = 3;

Function GetStatusCode(StatusCode: Integer): String;

Implementation

Function GetStatusCode(StatusCode: Integer): String;
Var
  Res: String;
Begin
  Res := '';
  Case StatusCode Of
    SITESTATUS_ACTIVE:
      Begin
        Res := 'Patient Active';
      End;
    SITESTATUS_INACTIVE:
      Begin
        Res := 'Patient Inactive'
      End;
    SITESTATUS_DISCONNECTED:
      Begin
        Res := 'Disconnected';
      End;
  Else
    Begin
      Res := 'Invalid status';
    End;
  End;
  Result := Res;
End;

Constructor cMagRemoteToolbarSite.Create(SiteName: String; Sitecode: String; aButtonIndex: Integer = 0);
Begin
  Inherited Create();
  FSiteName := SiteName;
  Fsitecode := Sitecode;
  FImageCount := 0;
  FSiteStatus := SITESTATUS_DISCONNECTED;
  FErrorMessage := '';
  FButtonIndex := aButtonIndex;
  FPatientVisited := True;
End;

Procedure cMagRemoteToolbarSite.SetButtonIndex(Const Value: Integer);
Begin
  FButtonIndex := Value;
End;

Procedure cMagRemoteToolbarSite.SetSiteName(Const Value: String);
Begin
  FSiteName := Value;
End;

Procedure cMagRemoteToolbarSite.SetPatientVisited(Const Value: Boolean);
Begin
  FPatientVisited := Value;
End;

Procedure cMagRemoteToolbarSite.SetSiteCode(Const Value: String);
Begin
  Fsitecode := Value;
End;
                             {
procedure cMagRemoteToolbarSite.SetSiteNumber(const Value: String);
begin
  FSiteNumber := Value;
end;
}

Procedure cMagRemoteToolbarSite.SetImageCount(Const Value: Integer);
Begin
  FImageCount := Value;
End;

Procedure cMagRemoteToolbarSite.SetSiteStatus(Const Value: Integer);
Begin
  FSiteStatus := Value;
End;

Procedure cMagRemoteToolbarSite.SetErrorMessage(Const Value: String);
Begin
  FErrorMessage := Value;
End;

End.
