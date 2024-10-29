{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: December, 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Base interface for viewer components used by the toolbar.

        ;; +--------------------------------------------------------------------+
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
        ;; +--------------------------------------------------------------------+
}
Unit IMagViewer;

Interface

Uses
  cMag4Vgear,
  UMagClasses,
  UMagClassesAnnot,
  UMagDefinitions
  ;

Type
  TMagViewerStyles = (MagvsVirtual, MagvsStaticPage, MagvsDynamic, MagvsLayout);

Type
  TMagViewerPatientIDMismatchEvent = Procedure(Sender: Tobject; MagVGear: TMag4VGear) Of Object;

Type
  IMag4Viewer = Interface(IInterface)

    Function GetCurrentImage(): TMag4VGear;
    Procedure AutoWinLevel();
    Procedure MousePan();
    Procedure WinLevValue(WinValue, LevelValue: Integer);
    Procedure SetApplyToAll(Value: Boolean);
    Function GetApplyToAll(): Boolean;

    Procedure Fit1to1();
    Procedure FitToHeight();
    Procedure FitToWindow();
    Procedure Inverse();
    Procedure FitToWidth();
    Procedure Rotate(Deg: Integer);
    Procedure MouseMagnify();
    Procedure MouseZoomRect();
    Function GetPanWindow(): Boolean;
    Procedure SetPanWindow(Value: Boolean);
    Procedure SetPanWindowWithActivateOption(Value: Boolean; Activate: Boolean);
    Procedure TileAll();
    Procedure FlipVert();
    Procedure FlipHoriz();
    Function GetViewerStyle(): TMagViewerStyles;
    Procedure SetViewerStyle(Const Value: TMagViewerStyles);
    Procedure EditViewerSettings();
    Procedure RemoveFromList();
    Procedure ClearViewer();
    Procedure ToggleSelected();
    Procedure ZoomValue(Zoom: Integer);
    Procedure BrightnessValue(Value: Integer);
    Procedure ContrastValue(Value: Integer);
    Procedure ImagePrint();
    Procedure ImageCopy();
    Procedure ImageReport();
    Function GetImagePage(): Integer;
    Procedure SetImagePage(Const Value: Integer);
    Procedure SetImagePageUseApplyToAll(Const Value: Integer);
    Procedure PageFirstImage();
    Procedure PagePrevImage();
    Procedure PageNextImage();
    Procedure PageLastImage();
    Procedure ResetImages(ApplyToAll: Boolean = False); // resets the image (all if apply to all selected)
    Procedure SetMaximizeImage(Value: Boolean);
    Function GetMaximizeImage(): Boolean;
    Procedure SetRowColCount(r, c: Integer; ImageToDisplayIndex: Integer = -1);

    Procedure SetLockSize(Value: Boolean);
    Function GetLockSize(): Boolean;
    Function GetClearBeforeAdd(): Boolean;
    Procedure SetClearBeforeAdd(Value: Boolean);

    Procedure MouseReSet();
    Procedure PageFirstViewer(SetSelected: Boolean = True);
    Procedure PageNextViewer(SetSelected: Boolean = True);
    Procedure PagePrevViewer(SetSelected: Boolean = True);
    Procedure PageLastViewer(SetSelected: Boolean = True);
    Procedure SetMaxCount(Value: Integer);
    Function GetMaxCount(): Integer;
    Procedure ReAlignImages(Ignmax: Boolean = False; Ignlocksize: Boolean = False; ImageToDisplayIndex: Integer = -1);

    Procedure ReFreshImages();
    Procedure ViewFullResImage();
    Function GetCurrentImageIndex(): Integer;

    Procedure ApplyImageState(State: TMagImageState; ApplyAll: Boolean = False);
    Procedure DisplayDICOMHeader();
    Procedure StopScrolling();

    Procedure SetShowPixelValues(Value: Boolean);
    Function GetShowPixelValues(): Boolean;

    Function GetHistogramWindowLevel(): Boolean;
    Procedure SetHistogramWindowLevel(Value: Boolean);

    Function GetShowLabels(): Boolean;
    Procedure SetShowLabels(Value: Boolean);

    Function GetCurrentTool(): TMagImageMouse;
    Procedure SetCurrentTool(Value: TMagImageMouse);

    Procedure Annotations();
    Procedure Measurements();
    Procedure Protractor();
    Procedure AnnotationPointer();

    Procedure ApplyViewerState(Viewer: IMag4Viewer); //jw 11/16/07

    Procedure SetAnnotationStyle(AnnotationStyle: TMagAnnotationStyle);

  // JMW 8/11/08 procedures for 508 compliant events

    Procedure ScrollCornerTL();
    Procedure ScrollCornerTR();
    Procedure ScrollCornerBL();
    Procedure ScrollCornerBR();
    Procedure ScrollLeft();
    Procedure ScrollRight();
    Procedure ScrollUp();
    Procedure ScrollDown();

  // JMW 4/6/09 P93 - add options for changing mouse zoom shape
    Procedure SetMouseZoomShape(Value: TMagMouseZoomShape);
    Function getMouseZoomShape(): TMagMouseZoomShape;

    Property ApplyToAll: Boolean Read GetApplyToAll Write SetApplyToAll;
    Property PanWindow: Boolean Read GetPanWindow Write SetPanWindow;
    Property ViewerStyle: TMagViewerStyles Read GetViewerStyle Write SetViewerStyle;
    Property ImagePage: Integer Read GetImagePage Write SetImagePage;
    Property MaximizeImage: Boolean Read GetMaximizeImage Write SetMaximizeImage;
    Property LockSize: Boolean Read GetLockSize Write SetLockSize;
    Property ClearBeforeAddDrop: Boolean Read GetClearBeforeAdd Write SetClearBeforeAdd;
    Property MaxCount: Integer Read GetMaxCount Write SetMaxCount;

    Property ShowPixelValues: Boolean Read GetShowPixelValues Write SetShowPixelValues;
    Property HistogramWindowLevel: Boolean Read GetHistogramWindowLevel Write SetHistogramWindowLevel;
    Property ShowLabels: Boolean Read GetShowLabels Write SetShowLabels;

  End;

Implementation

End.
