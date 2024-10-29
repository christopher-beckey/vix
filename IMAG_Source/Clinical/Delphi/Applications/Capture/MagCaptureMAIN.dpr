Program MagCaptureMAIN;
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

uses
  Forms,
  ActiveX,
  Maggut1 in '..\shared\Maggut1.pas',
  MagExeWait in '..\shared\MagExeWait.pas',
  MagTimeout in '..\shared\MagTimeout.pas' {MagTimeoutform},
  MagSyncCPRSu in '..\shared\MagSyncCPRSu.pas' {MagSyncCPRSf},
  fmagVistALookup in '..\shared\fmagVistALookup.pas' {MagLookup},
  fmagVideoPlayer in '..\shared\fmagVideoPlayer.pas' {frmVideoPlayer},
  MagPrevInstance in '..\shared\MagPrevInstance.pas',
  cMagVutils in '..\shared\cMagVutils.pas',
  cmagLabelNoClear in '..\shared\cmagLabelNoClear.pas',
  cMagDBBroker in '..\shared\cMagDBBroker.pas',
  Maggrpcu in '..\shared\Maggrpcu.pas' {maggrpcf},
  MaggMsgu in '..\shared\MaggMsgu.pas' {MaggMsgf},
  MagPositions in '..\shared\MagPositions.pas',
  cMagMenu in '..\shared\cMagMenu.pas',
  cMagPat in '..\shared\cMagPat.pas',
  Magguini in '..\shared\Magguini.pas',
  uMagDefinitions in '..\shared\uMagDefinitions.pas',
  cMagDBMVista in '..\shared\cMagDBMVista.pas',
  MagFileVersion in '..\shared\MagFileVersion.pas',
  fMagAbout in '..\shared\fMagAbout.pas' {frmAbout},
  cMagLVutils in '..\shared\cMagLVutils.pas',
  MagWrksmemou in '..\shared\MagWrksmemou.pas' {MagWrksMemo},
  cMagListView in '..\shared\cMagListView.pas',
  uMagClasses in '..\shared\uMagClasses.pas',
  uMagKeyMgr in '..\shared\uMagKeyMgr.pas',
  fmagEsigDialog in '..\shared\fmagEsigDialog.pas' {frmEsigDialog},
  cMagDBDemo in '..\shared\cMagDBDemo.pas',
  cMagSecurity in '..\shared\cMagSecurity.pas',
  fmagDateRange in '..\shared\fmagDateRange.pas' {frmDateRange},
  fmagPasswordDlg in '..\shared\fmagPasswordDlg.pas' {frmPasswordDlg},
  fmagWebHelp in '..\shared\fmagWebHelp.pas' {frmWebHelp},
  fmagWebHelpMapping in '..\shared\fmagWebHelpMapping.pas' {frmWebHelpMapping},
  MAGWKCNF in '..\Shared\MAGWKCNF.PAS' {MagWrksf},
  cMagIGManager in '..\Shared\cMagIGManager.pas',
  fMagAnnotationOptionsX in '..\Shared\fMagAnnotationOptionsX.pas' {frmAnnotOptionsX},
  fMagAnnotationMarkProperty in '..\Shared\fMagAnnotationMarkProperty.pas' {frmMagAnnotationMarkProperty},
  ImagDMinterface in '..\Shared\ImagDMinterface.pas',
  dmSingle in '..\Shared\dmSingle.pas' {DMod: TDataModule},
  cMagCapClinMgr in 'cMagCapClinMgr.pas',
  fEdtLVlink in 'fEdtLVlink.pas' {fEdtLV},
  fmagCapBatchAdv in 'fmagCapBatchAdv.pas' {frmCapBatchAdv},
  fmagCapBatchImageDesc in 'fmagCapBatchImageDesc.pas' {frmCapBatchImageDesc},
  fmagCapBatchOptions in 'fmagCapBatchOptions.pas' {frmCapBatchOptions},
  fmagCapConfig in 'fmagCapConfig.pas' {frmCapConfig},
  fmagCapDragTab in 'fmagCapDragTab.pas' {frmCapDragTab},
  fmagCapGrpComplete in 'fmagCapGrpComplete.PAS' {frmCapGrpComplete},
  fmagCapIconLegend in 'fmagCapIconLegend.pas' {frmCapIconLegend},
  fmagCapInfoWindow in 'fmagCapInfoWindow.pas' {frmCapInfoWindow},
  fmagCapMain in 'fmagCapMain.PAS' {frmCapMain},
  fmagCapPatConsultList in 'fmagCapPatConsultList.pas' {frmCapPatConsultList},
  fmagCapSaveConfig in 'fmagCapSaveConfig.pas' {frmCapSaveConfig},
  fmagCapSettings in 'fmagCapSettings.pas' {frmCapSettings},
  fmagCapTabOrder in 'fmagCapTabOrder.pas' {frmCapTabOrder},
  fmagCapTIU in 'fmagCapTIU.pas' {frmCapTIU},
  fmagCapTIUoptions in 'fmagCapTIUoptions.pas' {frmCapTIUOptions},
  fmagCapUtilForm in 'fmagCapUtilForm.pas' {frmCapUtilForm},
  fmagConfigList in 'fmagConfigList.pas' {frmConfigList},
  FmagDateTimeDialog in 'FmagDateTimeDialog.pas' {frmDateTimeDialog},
  fMagDicomEntry in 'fMagDicomEntry.pas' {frmDICOMEntry},
  fmagDirectoryDialog in 'fmagDirectoryDialog.pas' {frmDirectoryDialog},
  fmagDoNotClear in 'fmagDoNotClear.pas' {frmDoNotClear},
  fMagPatVisits in 'fMagPatVisits.pas' {PatVisitsform},
  fmagTESTDicomData in 'fmagTESTDicomData.pas' {frmTESTDicomData},
  fmagVideoOptions in 'fmagVideoOptions.pas' {frmVideoOptions},
  MagBatchCapUtil in 'MagBatchCapUtil.pas',
  MagBatchImageDesc in 'MagBatchImageDesc.pas' {MagBatchImageDescform},
  MagBroker in 'MagBroker.pas',
  magClinProcf in 'magClinProcf.pas' {magClinProc},
  MagFloatConfigu in 'MagFloatConfigu.pas' {MagFloatConfig},
  Magglabu in 'Magglabu.pas' {magglabf},
  Maggmcu in 'Maggmcu.pas' {MAGGMCF},
  Maggridu in 'Maggridu.pas' {maggridf},
  Maggsuru in 'Maggsuru.pas' {maggsur},
  MagLastImages in 'MagLastImages.pas' {MagLastImagesForm},
  MagSelectImportDiru in 'MagSelectImportDiru.pas' {MagSelectImportDirf},
  MagTestDicomNumbers in 'MagTestDicomNumbers.pas' {DicomNumbers},
  magTRConsultf in 'magTRConsultf.pas' {magTRConsult},
  uMagAppMgrCap in 'uMagAppMgrCap.pas',
  uMagCapUtil in 'uMagCapUtil.pas',
  uMAGDicomFunctions in 'uMAGDicomFunctions.pas',
  uMAGDicomObj in 'uMAGDicomObj.pas',
  uMagDICOMUtils in 'uMagDICOMUtils.pas',
  uMagGearUtils in 'uMagGearUtils.pas',
  cMagCapMsg in 'cMagCapMsg.pas',
  cMagTwain in 'cMagTwain.pas',
  FMagImage in '..\Shared\FMagImage.pas' {MagImage: TFrame},
  uMagTIUutil in '..\Shared\uMagTIUutil.pas',
  IMagInterfaces in '..\Shared\IMagInterfaces.pas',
  cMagPublishSubscribe in '..\Shared\cMagPublishSubscribe.pas',
  MagProgress in '..\SysTools\MagProgress.pas' {MagProgressForm},
  MagSessionInfo in '..\SysTools\MagSessionInfo.pas' {MagSessionInfoform},
  MagWrksListView in '..\SysTools\MagWrksListView.pas' {MagWrksListForm},
  uMagCapDef in 'uMagCapDef.pas';

{$R *.RES}

Begin
  //memchk;
  CoInitialize(Nil);
  Application.Title := 'VistA Imaging Capture';
  Application.HelpFile := '';
  Application.CreateForm(TFrmcapmain, Frmcapmain);
  Application.CreateForm(TMagLastImagesForm, MagLastImagesForm);
  Application.CreateForm(TMagLookup, MagLookup);
  Application.CreateForm(TMaggrpcf, Maggrpcf);
  Application.CreateForm(TfrmWebHelp, frmWebHelp);
  Application.CreateForm(TfrmWebHelpMapping, frmWebHelpMapping);
  Application.CreateForm(TfrmCapInfoWindow, frmCapInfoWindow);
  Application.CreateForm(TMagWrksf, MagWrksf);
  Application.CreateForm(TFrmConfigList, FrmConfigList);
  Application.CreateForm(TFrmCapBatchAdv, FrmCapBatchAdv);
  Application.CreateForm(TFrmCapBatchImageDesc, FrmCapBatchImageDesc);
  Application.CreateForm(TFrmCapBatchOptions, FrmCapBatchOptions);
  Application.CreateForm(TFrmCapConfig, FrmCapConfig);
  Application.CreateForm(TFrmCapDragTab, FrmCapDragTab);
  Application.CreateForm(TFrmCapIconLegend, FrmCapIconLegend);
  Application.CreateForm(TFrmCapSaveConfig, FrmCapSaveConfig);
  Application.CreateForm(TFrmCapSettings, FrmCapSettings);
  Application.CreateForm(TFrmCapTabOrder, FrmCapTabOrder);
  Application.CreateForm(TFrmCapTIUOptions, FrmCapTIUOptions);
  Application.CreateForm(TfrmCapPatConsultList, frmCapPatConsultList);
  Application.CreateForm(TMagClinProc, MagClinProc);
  Application.CreateForm(TFEdtLV, FEdtLV);
  Application.CreateForm(TFrmDateTimeDialog, FrmDateTimeDialog);
  Application.CreateForm(TFrmDirectoryDialog, FrmDirectoryDialog);
  Application.CreateForm(TFrmDoNotClear, FrmDoNotClear);
  Application.CreateForm(TMaggsur, Maggsur);
  Application.CreateForm(TMagglabf, Magglabf);
  Application.CreateForm(TMaggridf, Maggridf);
  Application.CreateForm(TMAGGMCF, MAGGMCF);
  Application.CreateForm(TMagFloatConfig, MagFloatConfig);
  Application.CreateForm(TPatVisitsform, PatVisitsform);
  Application.CreateForm(TfrmCapUtilForm, frmCapUtilForm);
  Application.CreateForm(TDMod, DMod);
  Application.CreateForm(TMagProgressForm, MagProgressForm);
  Application.CreateForm(TMagSessionInfoform, MagSessionInfoform);
  Application.CreateForm(TMagWrksListForm, MagWrksListForm);
  Application.Run;
End.
