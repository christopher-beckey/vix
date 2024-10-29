inherited magViewerRadTB: TmagViewerRadTB
  inherited tbarViewer: TToolBar
    inherited tbProtractor: TToolButton
      Hint = 'Use Angle Tool'
    end
    inherited tbRulerPointer: TToolButton
      Hint = 'Use Ruler/Angle Tool Pointer'
    end
    inherited pnlWinLev: TPanel
      Width = 328
      inherited lblLev: TLabel
        Left = 175
      end
      inherited lblWinValue: TLabel
        Width = 49
      end
      inherited lblLevValue: TLabel
        Left = 200
        Width = 41
      end
      inherited tbicWin: TTrackBar
        Left = 74
      end
      inherited tbicLev: TTrackBar
        Left = 234
      end
    end
    inherited picZoom: TPanel
      Width = 165
      inherited tbicZoom: TTrackBar
        Width = 110
        PageSize = 3
      end
    end
    inherited btnPageFirst: TToolButton
      Left = 165
    end
    inherited tbtnPagePrev: TToolButton
      Left = 198
    end
    inherited tbtnPageNext: TToolButton
      Left = 231
    end
    inherited tbtnPageLast: TToolButton
      Left = 264
    end
  end
end
