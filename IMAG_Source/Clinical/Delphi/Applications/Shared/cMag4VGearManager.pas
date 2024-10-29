Unit cmag4VGearManager;

Interface

Uses
  FmagImage,
  UMagDefinitions
  ;

//Uses Vetted 20090929:dialogs, fMag4VGear14

Type
  TMagGearType = (GEAR_TYPE_IG99, GEAR_TYPE_IG14);

  {
type
  TMag4VGearManager = class
  private

  public
  function createVGear(FileExtension : String) : tMagImage;

end;
}

Function CreateVGear(FileExtension: String; GearAbilities: TMagGearAbilities = MagGearAbilityRadiology): TMagImage;
Function DetermineGearToUse(FileExtension: String): TMagGearType;
Function CanUseForFile(GearControl: TMagImage; FileExtension: String): Boolean;

Implementation
Uses
  FMag4VGear14
  ;

Function CreateVGear(FileExtension: String; GearAbilities: TMagGearAbilities = MagGearAbilityRadiology): TMagImage;
Begin
  If (DetermineGearToUse(FileExtension) = GEAR_TYPE_IG99) Then
  Begin
//outfor93
//    result := TMag4VGear99.Create(nil, GearAbilities);
    Result := Nil;
  End
  Else
  Begin
    Result := TMag4VGear14.Create(Nil, GearAbilities);
  End;
End;

Function DetermineGearToUse(FileExtension: String): TMagGearType;
Begin
  Result := GEAR_TYPE_IG14;
  //if FileExtension = '.756' then result := GEAR_TYPE_IG99;
  //result := GEAR_TYPE_IG99;
End;

Function CanUseForFile(GearControl: TMagImage; FileExtension: String): Boolean;
Var
  GearToUse: TMagGearType;
Begin
  Result := False;
  If GearControl = Nil Then Exit;
  GearToUse := cmag4VGearManager.DetermineGearToUse(FileExtension); // determineGearToUse(FileExtension);
  If (GearToUse = GEAR_TYPE_IG14) And (GearControl Is TMag4VGear14) Then
    Result := True;
End;

End.
