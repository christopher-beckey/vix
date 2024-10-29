Unit FMagRadiologyImageInfo;

Interface

Uses
  cMag4Vgear,
  Controls,
  Forms,
  Stdctrls,
  Classes
  ;

//Uses Vetted 20090929:Dialogs, Graphics, Classes, Variants, Messages, Windows, SysUtils

Type
  TfrmRadiologyImageInfo = Class(TForm)
    LbModality: Tlabel;
    LbSeriesNo: Tlabel;
    LbImageNo: Tlabel;
    DataModality: Tlabel;
    DataSeries: Tlabel;
    DataImageNo: Tlabel;
    LbSliceTh: Tlabel;
    DataSliceTh: Tlabel;
    LbContrast: Tlabel;
    DataContrast: Tlabel;
    LbProtocol: Tlabel;
    DataProtocol: Tlabel;
    btOK: TButton;
    Procedure btOKClick(Sender: Tobject);
  Private
    FCurrentVGear: TMag4VGear;
  Public
    Procedure Execute(VGear: TMag4VGear);
  End;

//var
//  frmRadiologyImageInfo: TfrmRadiologyImageInfo;

Implementation
Uses
  SysUtils
  ;

{$R *.dfm}

Procedure TfrmRadiologyImageInfo.btOKClick(Sender: Tobject);
Begin
  ModalResult := MrOK;
End;

Procedure TfrmRadiologyImageInfo.Execute(VGear: TMag4VGear);
Begin
  FCurrentVGear := VGear;
  (*
  dataModality.caption:=ADICOMRec[selwin].modality;
dataSeries.caption:=FloattoStr(ADICOMRec[selwin].seriesno);
dataImageNo.caption:=ADICOMRec[selwin].imageno;{P5}
dataSliceTh.caption:=FloattoStr(ADICOMRec[selwin].slicethickness) + ' mm';
dataContrast.caption:=ADICOMRec[selwin].contrast;
If dataModality.caption = 'MR' then
   begin
   dataProtocol.caption:=ADICOMRec[selwin].protocol;
   end;
  *)

  Try
    DataModality.caption := VGear.Dicomdata.Modality;
    DataSeries.caption := FloatTostr(VGear.Dicomdata.Seriesno);
    DataImageNo.caption := VGear.Dicomdata.Imageno;
    DataSliceTh.caption := FloatTostr(VGear.Dicomdata.SliceThickness) + ' mm';
    DataContrast.caption := VGear.Dicomdata.Contrast;
    If DataModality.caption = 'MR' Then
    Begin
      DataProtocol.caption := VGear.Dicomdata.Protocol;
    End
    Else
    Begin
      DataProtocol.caption := ''; // JMW - not sure why this is only populated for MR images, but that is how it was in the old Rad Viewer
    End;
  Except
    On e: Exception Do
    Begin
      // log exception?
    End;
  End;

  Showmodal();
End;

End.
