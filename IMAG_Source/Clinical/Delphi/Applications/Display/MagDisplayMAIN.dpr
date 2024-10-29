Program MagDisplayMAIN;
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



uses
  Forms,
  ActiveX,
  cMag4VGear in '..\Shared\cMag4VGear.pas' {Mag4VGear: TFrame},
  cMag4VGearManager in '..\Shared\cMag4VGearManager.pas',
  cmag4viewer in '..\Shared\cmag4viewer.pas' {Mag4Viewer: TFrame},
  cMagBrokerKeepAlive in '..\Shared\cMagBrokerKeepAlive.pas',
  cMagCCOWManager in '..\Shared\cMagCCOWManager.pas',
  cMagDBBroker in '..\Shared\cMagDBBroker.pas',
  cMagDBDemo in '..\Shared\cMagDBDemo.pas',
  cMagDBDemoUtils in '..\Shared\cMagDBDemoUtils.pas',
  cMagDBMVista in '..\Shared\cMagDBMVista.pas',
  cMagDBSysUtils in '..\Shared\cMagDBSysUtils.pas',
  cMagIGManager in '..\Shared\cMagIGManager.pas',
  cMagImageAccessLogManager in '..\Shared\cMagImageAccessLogManager.pas',
  cMagImageList in '..\Shared\cMagImageList.pas',
  cMagImageListManager in '..\Shared\cMagImageListManager.pas',
  cMagImageUtility in '..\Shared\cMagImageUtility.pas',
  cMagImport in '..\Shared\cMagImport.pas',
  cMagKeepAliveThread in '..\Shared\cMagKeepAliveThread.pas',
  cMagListView in '..\Shared\cMagListView.pas',
  cMagMenu in '..\Shared\cMagMenu.pas',
  cmagObserverLabel in '..\Shared\cmagObserverLabel.pas',
  cMagPat in '..\Shared\cMagPat.pas',
  cMagPatPhoto in '..\Shared\cMagPatPhoto.pas' {MagPatPhoto: TFrame},
  cMagPublishSubscribe in '..\Shared\cMagPublishSubscribe.pas',
  cMagRemoteDummyBroker in '..\Shared\cMagRemoteDummyBroker.pas',
  cMagRemoteWSBrokerFactory in '..\Shared\cMagRemoteWSBrokerFactory.pas',
  cMagSecurity in '..\Shared\cMagSecurity.pas',
  cMagStackViewer in '..\Shared\cMagStackViewer.pas' {Mag4StackViewer: TFrame},
  cMagTreeView in '..\Shared\cMagTreeView.pas',
  cMagUtils in '..\Shared\cMagUtils.pas',
  cMagUtilsDB in '..\Shared\cMagUtilsDB.pas',
  cMagViewerTB8 in '..\Shared\cMagViewerTB8.pas' {magViewerTB8: TFrame},
  cMagVUtils in '..\Shared\cMagVUtils.pas',
  dmSingle in '..\Shared\dmSingle.pas' {DMod: TDataModule},
  fMagAbout in '..\Shared\fMagAbout.pas' {frmAbout},
  cmagListViewColumnSelect in '..\Shared\cmagListViewColumnSelect.pas' {frmColumnSelect},
  fMagCopyAgreement in '..\Shared\fMagCopyAgreement.pas' {frmCopyAgreement},
  fmagDateRange in '..\Shared\fmagDateRange.pas' {frmDateRange},
  fmagGetEsigDialog in '..\Shared\fmagGetEsigDialog.pas' {frmGetEsigDialog},
  fMagIG14PanWindow in '..\Shared\fMagIG14PanWindow.pas' {frmIG14PanWindow},
  FMagImage in '..\Shared\FMagImage.pas' {MagImage: TFrame},
  fMagPatAccess in '..\Shared\fMagPatAccess.pas' {frmPatAccess},
  fMagRIVUserConfig in '..\Shared\fMagRIVUserConfig.pas' {frmMagRIVUserConfig},
  cmagTreeViewEdit in '..\Shared\cmagTreeViewEdit.pas' {frmTreeViewEdit},
  fmagVideoPlayer in '..\Shared\fmagVideoPlayer.pas' {frmVideoPlayer},
  fmagVistaLookup in '..\Shared\fmagVistaLookup.pas' {MagLookup},
  fmagWebHelp in '..\Shared\fmagWebHelp.pas' {frmWebHelp},
  fmagWebHelpMapping in '..\Shared\fmagWebHelpMapping.pas' {frmWebHelpMapping},
  ImagingExchangeSiteService in '..\Shared\ImagingExchangeSiteService.pas',
  IMagInterfaces in '..\Shared\IMagInterfaces.pas',
  iMagRemoteBrokerInterface in '..\Shared\iMagRemoteBrokerInterface.pas',
  iMagViewer in '..\Shared\iMagViewer.pas',
  MagCacheImage in '..\Shared\MagCacheImage.pas',
  MagCacheManager in '..\Shared\MagCacheManager.pas',
  MagFileVersion in '..\Shared\MagFileVersion.pas',
  cMagPatLookup in '..\Shared\cMagPatLookup.pas' {maggplkf},
  Maggrpcu in '..\Shared\Maggrpcu.pas' {maggrpcf},
  Magguini in '..\Shared\Magguini.pas',
  Maggut1 in '..\Shared\Maggut1.pas',
  MagImageManager in '..\Shared\MagImageManager.pas',
  MagPositions in '..\Shared\MagPositions.pas',
  MagPrevInstance in '..\Shared\MagPrevInstance.pas',
  MagRemoteBroker in '..\Shared\MagRemoteBroker.pas',
  MagRemoteBrokerManager in '..\Shared\MagRemoteBrokerManager.pas',
  MagRemoteInterface in '..\Shared\MagRemoteInterface.pas',
  MagRemoteToolbar in '..\Shared\MagRemoteToolbar.pas' {fMagRemoteToolbar: TFrame},
  magResources in '..\Shared\magResources.pas',
  cmag4viewerOptions in '..\Shared\cmag4viewerOptions.pas' {Mag4ViewerOptions},
  MagSyncCPRSu in '..\Shared\MagSyncCPRSu.pas' {MagSyncCPRSf},
  MagTimeout in '..\Shared\MagTimeout.pas' {MagTimeoutform},
  MagWrksmemou in '..\Shared\MagWrksmemou.pas' {MagWrksMemo},
  uMagClasses in '..\Shared\uMagClasses.pas',
  uMagCRC32 in '..\Shared\uMagCRC32.PAS',
  uMagDefinitions in '..\Shared\uMagDefinitions.pas',
  uMagKeyMgr in '..\Shared\uMagKeyMgr.pas',
  umagutils8 in '..\Shared\umagutils8.pas',
  fMag4VGear14 in '..\Shared\fMag4VGear14.pas' {Mag4VGear14: TFrame},
  fMagAnnot in '..\Shared\fMagAnnot.pas' {MagAnnot},
  imagingClinicalDisplaySOAP_v7 in '..\Shared\imagingClinicalDisplaySOAP_v7.pas',
  cMagRemoteWSBroker_v7 in '..\Shared\cMagRemoteWSBroker_v7.pas',
  uMagAnnotRADConverters in '..\Shared\uMagAnnotRADConverters.pas',
  fMagAnnotationMarkProperty in '..\Shared\fMagAnnotationMarkProperty.pas' {frmMagAnnotationMarkProperty},
  fMagAnnotationOptionsX in '..\Shared\fMagAnnotationOptionsX.pas' {frmAnnotOptionsX},
  uMagAnnotDisplayRAD in '..\Shared\uMagAnnotDisplayRAD.pas',
  cMagViewerRadTB2 in '..\Shared\cMagViewerRadTB2.pas' {magViewerRadTB2: TFrame},
  ImagDMinterface in '..\Shared\ImagDMinterface.pas',
  cEKGOverlay in 'cEKGOverlay.pas',
  cEvtScroll in 'cEvtScroll.pas',
  cLoadTestThread in 'cLoadTestThread.pas',
  cMuseTest in 'cMuseTest.pas',
  dMuseConnection in 'dMuseConnection.pas',
  fEKGDisplay in 'fEKGDisplay.pas' {EKGDisplayForm},
  fEKGDisplayOptions in 'fEKGDisplayOptions.pas' {EKGDisplayOptionsForm},
  fmagAbsResize in 'fmagAbsResize.pas' {frmAbsResize},
  fmagAbstracts in 'fmagAbstracts.pas' {frmMagAbstracts},
  fMagCineView in 'fMagCineView.pas' {frmCineView},
  fMagCTConfigure in 'fMagCTConfigure.pas' {frmCTConfigure},
  fmagDeleteImage in 'fmagDeleteImage.pas' {frmDeleteImage},
  fmagDialogSaveAs in 'fmagDialogSaveAs.pas' {frmDialogSaveAs},
  fmagDialogSelection in 'fmagDialogSelection.pas' {frmDialogSelection},
  fMagDICOMDir in 'fMagDICOMDir.pas' {frmDICOMDir},
  fmagDicomTxtFile in 'fmagDicomTxtFile.pas' {frmDicomTxtfile},
  fmagFilterSaveAs in 'fmagFilterSaveAs.pas' {frmFilterSaveAs},
  fMagFMSetSelect in 'fMagFMSetSelect.pas' {frmFMSetSelect},
  fmagFocus in 'fmagFocus.pas' {frmFocus},
  fmagGenOverlay in 'fmagGenOverlay.pas' {frmGenOverlay},
  fmagGroupAbs in 'fmagGroupAbs.pas' {frmGroupAbs},
  fmagIconLegend in 'fmagIconLegend.pas' {frmIconLegend},
  fmagImageInfo in 'fmagImageInfo.pas' {frmMagImageInfo},
  fmagImageInfoSys in 'fmagImageInfoSys.pas' {frmMagImageInfoSys},
  fmagImageList in 'fmagImageList.pas' {frmImageList},
  fmagindexedit in 'fmagindexedit.pas' {frmIndexEdit},
  fmagLegalNotice in 'fmagLegalNotice.pas' {frmMagLegalNotice},
  fmagListFilter in 'fmagListFilter.pas' {frmListFilter},
  fMagLoadingImageMessage in 'fMagLoadingImageMessage.pas' {frmLoadingImageMessage},
  fMagLog in 'fMagLog.pas' {frmLog},
  fmagMain in 'fmagMain.pas' {frmMain},
  fmagPatPhotoOnly in 'fmagPatPhotoOnly.pas' {frmPatPhotoOnly},
  fMagRadImageInfo in 'fMagRadImageInfo.pas' {frmRadImageInfo},
  fMagRadiologyImageInfo in 'fMagRadiologyImageInfo.pas' {frmRadiologyImageInfo},
  fmagRadViewer in 'fmagRadViewer.pas' {frmRadViewer},
  fmagReasonSelect in 'fmagReasonSelect.pas' {frmReasonSelect},
  fMagReleaseOfInfoPrint in 'fMagReleaseOfInfoPrint.pas' {frmReleaseOfInfoPrint},
  fMagReportMgr in 'fMagReportMgr.pas' {frmMagReportMgr},
  fmagSaveImageAs in 'fmagSaveImageAs.pas' {frmSaveImageAs},
  fMagURLMemoryMapViewer in 'fMagURLMemoryMapViewer.pas' {frmURLMemoryMapViewer},
  fmagUserPref in 'fmagUserPref.pas' {frmUserPref},
  fmagVerify in 'fmagVerify.pas' {frmVerify},
  fmagVerifyStats in 'fmagVerifyStats.pas' {frmVerifyStats},
  fraindexfields in 'fraindexfields.pas' {frameIndexFields: TFrame},
  fraMagImageInfo in 'fraMagImageInfo.pas' {fraImageInfo: TFrame},
  Maggrptu in 'Maggrptu.pas' {maggrptf},
  MAGGUT9 in 'MAGGUT9.pas',
  MagRadListWinu in 'MagRadListWinu.pas' {radlistwin},
  MagTIUWinu in 'MagTIUWinu.pas' {MagTIUWinf},
  MagUtilFormu in 'MagUtilFormu.pas' {MagUtilformf},
  MuseDeclarations in 'MuseDeclarations.pas',
  TemplateToText in 'TemplateToText.pas' {templateTEXT},
  uMagAppMgr in 'uMagAppMgr.pas',
  uMagDisplayMgr in 'uMagDisplayMgr.pas',
  uMagDisplayUtils in 'uMagDisplayUtils.pas',
  uMagFltMgr in 'uMagFltMgr.pas',
  umagutils8B in 'umagutils8B.pas',
  cMagAnnotXMLControlsDisplay in '..\Shared\cMagAnnotXMLControlsDisplay.pas',
  cMag4ViewerEventScrollBox in '..\Shared\cMag4ViewerEventScrollBox.pas',
  cmag4ViewerImageProxy in '..\Shared\cmag4ViewerImageProxy.pas',
  FormTemplate in 'FormTemplate.pas' {formTemplate1},
  cMagDisplayMsg in 'cMagDisplayMsg.pas',
  fMagReleaseOfInfoStatuses in 'fMagReleaseOfInfoStatuses.pas' {frm_ROI_Statuses},
  MagROIRestUtility in 'MagROIRestUtility.pas',
  fMagIG14DICOMHeader in '..\Shared\fMagIG14DICOMHeader.pas' {frmIG14DICOMHeader},
  fMagReleaseOfInfoSaveJob in 'fMagReleaseOfInfoSaveJob.pas' {frm_ROI_SaveJob},
  uMagRadHeaderLoader in 'uMagRadHeaderLoader.pas',
  uMagTextFileLoader in '..\Shared\uMagTextFileLoader.pas',
  fMagRadScoutViewer in 'fMagRadScoutViewer.pas' {frmScoutViewer},
  cMagLine in '..\Shared\cMagLine.pas',
  fmagRadHeaderProgress in 'fmagRadHeaderProgress.pas' {frmRadHeaderProgress},
  iMagDicomHeaderLoader in 'iMagDicomHeaderLoader.pas',
  cMagIGDicomHeaderLoader in 'cMagIGDicomHeaderLoader.pas',
  IMagPanWindow in '..\Shared\IMagPanWindow.pas',
  fmagFullResSpecial in 'fmagFullResSpecial.pas' {frmFullResSpecial},
  fmagFullRes in 'fmagFullRes.pas' {frmFullRes};

{$R *.RES}

Begin
  CoInitialize(Nil);
  Application.Title := 'VistA Imaging Display';
  Application.HelpFile := 'MAGIMAGING.HLP';
  Application.CreateForm(TFrmmain, Frmmain);
  Application.CreateForm(TDmod, Dmod);
  Application.CreateForm(Tmaggrptf, maggrptf);
  Application.CreateForm(TtemplateTEXT, templateTEXT);
  Application.CreateForm(TMagSyncCPRSf, MagSyncCPRSf);
  Application.CreateForm(TMagTimeoutform, MagTimeoutform);
  Application.CreateForm(TFrmMagRIVUserConfig, FrmMagRIVUserConfig);
  Application.CreateForm(TMagLookup, MagLookup);
  Application.CreateForm(TFrmWebHelpMapping, FrmWebHelpMapping);
  Application.CreateForm(TFrmWebHelp, FrmWebHelp);
  Application.CreateForm(TfrmIconLegend, frmIconLegend);
  Application.CreateForm(TfrmFocus, frmFocus);
  Application.CreateForm(TMagTIUWinf, MagTIUWinf);
  Application.CreateForm(TFrmUserPref, FrmUserPref);
  Application.CreateForm(TMagUtilformf, MagUtilformf);
  Application.Run;
End.
