object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'PA7N VNA'
  ClientHeight = 706
  ClientWidth = 1184
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 900
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    1184
    706)
  PixelsPerInch = 96
  TextHeight = 13
  object Label12: TLabel
    Left = 105
    Top = 11
    Width = 41
    Height = 13
    Alignment = taRightJustify
    BiDiMode = bdLeftToRight
    Caption = 'Comport'
    ParentBiDiMode = False
  end
  object Label13: TLabel
    Left = 278
    Top = 11
    Width = 27
    Height = 13
    Alignment = taRightJustify
    Caption = 'Steps'
  end
  object Label14: TLabel
    Left = 400
    Top = 11
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'R.L. Cal'
  end
  object Label15: TLabel
    Left = 501
    Top = 11
    Width = 12
    Height = 13
    Caption = 'dB'
  end
  object Label16: TLabel
    Left = 526
    Top = 11
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'DDS freq.'
  end
  object Label17: TLabel
    Left = 667
    Top = 11
    Width = 16
    Height = 13
    Caption = 'Hz.'
  end
  object GroupBox1: TGroupBox
    Left = 159
    Top = 600
    Width = 534
    Height = 98
    Anchors = [akLeft, akBottom]
    Caption = ' Values '
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 32
      Width = 60
      Height = 13
      Caption = 'Lowest SWR'
    end
    object Label2: TLabel
      Left = 8
      Top = 51
      Width = 42
      Height = 13
      Caption = 'Marker 1'
    end
    object Label3: TLabel
      Left = 8
      Top = 70
      Width = 42
      Height = 13
      Caption = 'Marker 2'
    end
    object Label4: TLabel
      Left = 83
      Top = 13
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Caption = 'Frequency'
    end
    object Label5: TLabel
      Left = 153
      Top = 13
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = 'SWR'
    end
    object Label6: TLabel
      Left = 286
      Top = 13
      Width = 14
      Height = 13
      Caption = '|Z|'
    end
    object Label7: TLabel
      Left = 196
      Top = 13
      Width = 20
      Height = 13
      Alignment = taRightJustify
      Caption = 'R.L.'
    end
    object Label8: TLabel
      Left = 227
      Top = 13
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Phase'
    end
    object Label9: TLabel
      Left = 332
      Top = 13
      Width = 12
      Height = 13
      Caption = 'Rs'
    end
    object Label10: TLabel
      Left = 369
      Top = 13
      Width = 19
      Height = 13
      Caption = '|Xs|'
    end
    object lowswr_F: TLabel
      Left = 72
      Top = 32
      Width = 62
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_F: TLabel
      Left = 72
      Top = 51
      Width = 62
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_F: TLabel
      Left = 72
      Top = 70
      Width = 62
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object lowswr_SWR: TLabel
      Left = 140
      Top = 32
      Width = 36
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_SWR: TLabel
      Left = 140
      Top = 51
      Width = 36
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_SWR: TLabel
      Left = 140
      Top = 70
      Width = 36
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object lowswr_RL: TLabel
      Left = 182
      Top = 32
      Width = 34
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_RL: TLabel
      Left = 182
      Top = 51
      Width = 34
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_RL: TLabel
      Left = 182
      Top = 70
      Width = 34
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object lowswr_Phase: TLabel
      Left = 222
      Top = 32
      Width = 34
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_Phase: TLabel
      Left = 222
      Top = 51
      Width = 34
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_Phase: TLabel
      Left = 222
      Top = 70
      Width = 34
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object lowswr_Z: TLabel
      Left = 262
      Top = 32
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_Z: TLabel
      Left = 262
      Top = 51
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_Z: TLabel
      Left = 262
      Top = 70
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object lowswr_Rs: TLabel
      Left = 306
      Top = 32
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object lowswr_Xs: TLabel
      Left = 350
      Top = 32
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_Rs: TLabel
      Left = 306
      Top = 51
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_Xs: TLabel
      Left = 350
      Top = 51
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_Rs: TLabel
      Left = 306
      Top = 70
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_Xs: TLabel
      Left = 350
      Top = 70
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object Label18: TLabel
      Left = 394
      Top = 13
      Width = 43
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'L(uH)'
    end
    object lowswr_L: TLabel
      Left = 394
      Top = 32
      Width = 43
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_L: TLabel
      Left = 394
      Top = 51
      Width = 43
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_L: TLabel
      Left = 394
      Top = 70
      Width = 43
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object Label19: TLabel
      Left = 438
      Top = 13
      Width = 43
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'C(pF)'
    end
    object lowswr_C: TLabel
      Left = 438
      Top = 32
      Width = 43
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_C: TLabel
      Left = 438
      Top = 51
      Width = 43
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_C: TLabel
      Left = 438
      Top = 70
      Width = 43
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object Label23: TLabel
      Left = 482
      Top = 13
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Q'
    end
    object lowswr_Q: TLabel
      Left = 482
      Top = 32
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker1_Q: TLabel
      Left = 482
      Top = 51
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object marker2_Q: TLabel
      Left = 482
      Top = 70
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 600
    Width = 145
    Height = 98
    Anchors = [akLeft, akBottom]
    Caption = ' Settings '
    TabOrder = 3
    object Label11: TLabel
      Left = 8
      Top = 17
      Width = 82
      Height = 13
      Caption = 'Frequency range'
    end
    object Label26: TLabel
      Left = 9
      Top = 39
      Width = 34
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Start'
    end
    object Label28: TLabel
      Left = 9
      Top = 66
      Width = 34
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'End'
    end
    object eFstart: TEdit
      Left = 48
      Top = 36
      Width = 90
      Height = 21
      TabOrder = 0
      OnExit = eFstartExit
      OnKeyPress = eFstartEndKeyPress
    end
    object eFend: TEdit
      Left = 48
      Top = 63
      Width = 90
      Height = 21
      TabOrder = 1
      OnExit = eFendExit
      OnKeyPress = eFstartEndKeyPress
    end
  end
  object GroupBox3: TGroupBox
    Left = 699
    Top = 600
    Width = 181
    Height = 98
    Anchors = [akLeft, akBottom]
    Caption = ' Plot '
    TabOrder = 4
    object cbSWR: TCheckBox
      Left = 12
      Top = 16
      Width = 77
      Height = 17
      Caption = 'SWR'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbPlotClick
    end
    object cbRL: TCheckBox
      Left = 12
      Top = 36
      Width = 77
      Height = 17
      Caption = 'Return loss'
      TabOrder = 1
      OnClick = cbPlotClick
    end
    object cbPhase: TCheckBox
      Left = 12
      Top = 56
      Width = 77
      Height = 17
      Caption = 'Phase'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = cbPlotClick
    end
    object cbZ: TCheckBox
      Left = 12
      Top = 76
      Width = 77
      Height = 17
      Caption = 'Z'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = cbPlotClick
    end
    object cbXs: TCheckBox
      Left = 108
      Top = 13
      Width = 41
      Height = 17
      Caption = 'Xs'
      TabOrder = 4
      OnClick = cbPlotClick
    end
    object cbRs: TCheckBox
      Left = 108
      Top = 36
      Width = 41
      Height = 17
      Caption = 'Rs'
      TabOrder = 5
      OnClick = cbPlotClick
    end
  end
  object btnStart: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = btnStartClick
  end
  object cbComPort: TComboBox
    Left = 152
    Top = 8
    Width = 89
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object eSteps: TEdit
    Left = 311
    Top = 8
    Width = 61
    Height = 21
    Hint = 'Steps between 10 and 4000'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Text = '500'
    OnExit = eStepsExit
    OnKeyPress = eDDSFreqKeyPress
  end
  object eCalRL: TEdit
    Left = 444
    Top = 8
    Width = 51
    Height = 21
    TabOrder = 6
    Text = '-0.7'
    OnExit = eCalRLExit
    OnKeyPress = eCalRLKeyPress
  end
  object btnZoom: TButton
    Left = 709
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Zoom'
    Enabled = False
    TabOrder = 7
    OnClick = btnZoomClick
  end
  object eDDSFreq: TEdit
    Left = 579
    Top = 8
    Width = 82
    Height = 21
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Text = '400000000'
    OnExit = eDDSFreqExit
    OnKeyPress = eDDSFreqKeyPress
  end
  object GroupBox4: TGroupBox
    Left = 882
    Top = 600
    Width = 185
    Height = 98
    Anchors = [akLeft, akBottom]
    Caption = 'Calculate L or C'
    TabOrder = 9
    object Label20: TLabel
      Left = 12
      Top = 38
      Width = 13
      Height = 13
      AutoSize = False
      Caption = 'C'
    end
    object Label21: TLabel
      Left = 95
      Top = 38
      Width = 22
      Height = 13
      AutoSize = False
      Caption = 'pF'
    end
    object lblCalcCorLfreq: TLabel
      Left = 31
      Top = 57
      Width = 62
      Height = 13
      AutoSize = False
    end
    object Label22: TLabel
      Left = 12
      Top = 57
      Width = 13
      Height = 13
      AutoSize = False
      Caption = 'f'
    end
    object Label24: TLabel
      Left = 95
      Top = 57
      Width = 30
      Height = 13
      AutoSize = False
      Caption = 'MHz.'
    end
    object Label25: TLabel
      Left = 12
      Top = 76
      Width = 13
      Height = 13
      AutoSize = False
      Caption = 'L'
    end
    object lblResultCalcLorC: TLabel
      Left = 31
      Top = 76
      Width = 62
      Height = 13
      AutoSize = False
    end
    object Label27: TLabel
      Left = 95
      Top = 76
      Width = 30
      Height = 13
      AutoSize = False
      Caption = 'uH'
    end
    object rbCalcL: TRadioButton
      Left = 8
      Top = 16
      Width = 77
      Height = 17
      Caption = 'Calculate L'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbCalcLClick
    end
    object rbCalcC: TRadioButton
      Left = 91
      Top = 16
      Width = 77
      Height = 17
      Caption = 'Calculate C'
      TabOrder = 1
      OnClick = rbCalcLClick
    end
    object eCorL: TEdit
      Left = 31
      Top = 35
      Width = 58
      Height = 21
      TabOrder = 2
      Text = '100'
      OnExit = eCorLExit
      OnKeyPress = eCorLKeyPress
    end
  end
end
