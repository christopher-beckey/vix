Unit IMagImage;

Interface

Uses
  Graphics,
  UMagDefinitions,
  Windows
  ;

Type
  MagImage = Interface(IDispatch)

//    constructor Create(AOwner : TComponent);
    Procedure LoadImage(Filename: String);
    Procedure ClearImage();
    Procedure SetZoomWindow(Value: Boolean);
    Procedure SetPanWindow(Value: Boolean);
    Procedure PanWindowSettings(h, w, x, y: Integer);

    Function GetPage: Integer;
    Function GetPageCount: Integer;
    Procedure SetPage(Const Value: Integer);
    Procedure SetPageCount(Const Value: Integer);
    Procedure DeSkewImage;

    Procedure WinLevValue(WinValue, LevValue: Integer);
    Procedure SmoothImage;
    Procedure RefreshImage;
    Procedure ReDrawImage;
    Procedure ResetImage;
    Procedure FitToWidth;
    Procedure FitToHeight;
    Procedure FitToWindow;
    Procedure Fit1to1;
    Procedure FlipVert;
    Procedure FlipHoriz;
    Procedure Rotate(Deg: Integer);
    Procedure Inverse;
    Procedure DeSkewAndSmooth;
    Procedure MouseMagnify;
    Procedure MousePan;
    Procedure MouseZoomRect;
    Procedure MouseReSet;
    Procedure ZoomValue(Value: Integer);
    Procedure ContrastValue(Value: Integer);
    Procedure BrightnessValue(Value: Integer);
    Function GetBitsPerPixel(): Integer;
    Function GetWidth(): Integer;
    Procedure SetUpdateGUI(Value: Boolean);
    Procedure SetSettingMode(Mode: Integer);
    Procedure SetSettingValue(Value: Integer);
    Procedure SetPrintSize(Value: Integer);
    Procedure PrintImage(Handle: HDC);
    Procedure CopyToClipboard();

    Function GetMouseAction(): TMagImageMouse;
    Function ZoomLevel(): Integer;

    Function GetBrightnessPassed(): Integer;
    Procedure SetBrightnessValue(Value: Integer);

    Function GetContrastPassed(): Integer;
    Procedure SetContrastValue(Value: Integer);

    Function GetZoomValue(): Integer;
    Procedure SetZoomValue(Value: Integer);

    Function GetUpdatePageView(): Boolean;

    Procedure SetUpdatePageView(Value: Boolean);

    Property Brightness: Integer Read GetBrightnessPassed Write SetBrightnessValue;
    Property Contrast: Integer Read GetContrastPassed Write SetContrastValue;
    Property ImageZoomValue: Integer Read GetZoomValue Write SetZoomValue;
    Property MouseAction: TMagImageMouse Read GetMouseAction;
    Property UpdatePageViewEnabled: Boolean Read GetUpdatePageView Write SetUpdatePageView;

    Procedure SetBackgroundColor(Color: TColor);

  End;

Implementation

End.
