// *****************************************************************************
// *
// *   Date created : 04-12-2012
// *
// *   Author       : Erwin van den Bosch (PA7N)
// *
// *   Mail         : erwin@pa7n.nl
// *
// *   WWW          : http://www.pa7n.nl
// *
// *   © 2012 Erwin van den Bosch (PA7N)
// *
// *****************************************************************************

unit frmmain;

interface

uses
  // Delphi
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SyncObjs, Themes, ExtCtrls,
  // 3rd party
  uCiaComport;

const
  VNA_PROCESSDATA = WM_USER + 1;

type
  TPanelPlus = class(TPanel)
  private
    { Private declarations }
    FOnPaint : TNotifyEvent;
  protected
    { Protected declarations }
  public
    { Public declarations }
    property Canvas;
    Procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    Property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

  TVNAEntry = class(TObject)
  private
    { Private declarations }
    FADCMagnitude   : integer;
    FADCAngle       : integer;
    FFrequency      : extended;
    FMagnitude      : extended;
    FAngle          : extended;
    FSWR            : extended;
    FReturnLoss     : extended;
    FXs             : extended;
    FRs             : extended;
    FZ              : extended;
    FL              : extended;
    FC              : extended;
    FQ              : extended;
  public
     { Published declarations }
    property ADCMagnitude   : integer    read FADCMagnitude    write FADCMagnitude;
    property ADCAngle       : integer    read FADCAngle        write FADCAngle;
    property Magnitude      : extended   read FMagnitude       write FMagnitude;
    property Angle          : extended   read FAngle           write FAngle;
    property ReturnLoss     : extended   read FReturnLoss      write FReturnLoss;
    property SWR            : extended   read FSWR             write FSWR;
    property Frequency      : extended   read FFrequency       write FFrequency;
    property Xs             : extended   read FXs              write FXs;
    property Rs             : extended   read FRs              write FRs;
    property Z              : extended   read FZ               write FZ;
    property L              : extended   read FL               write FL;
    property C              : extended   read FC               write FC;
    property Q              : extended   read FQ               write FQ;
  end;

  TVNAList = class(TList)
  private
    { Private declarations }
  protected
    { Protected declarations }
    function  Get(Index: integer): TVNAEntry;
    procedure Put(Index: integer; Item: TVNAEntry);
  public
    { Public declarations }
    constructor Create;
    destructor Destroy ; override;
    function  Add(Item: TVNAEntry): integer;
    function  CreateAndAdd: TVNAEntry;
    procedure ClearAndFree;
    property  Items[Index: integer]: TVNAEntry read Get write Put; default;
  end;

  TMainForm = class;
  TComThread = class(TThread)
  private
    ComPort : TCiaComPort;
    processing : boolean;
    procedure ComPortDataAvailable(Sender: TObject);
  public
    ownerForm  : TMainForm;
    Fstart     : integer;
    Fend       : integer;
    Fsteps     : integer;
    FCom       : integer;
    FDDSstep   : extended;
    procedure Execute; override;
  end;

  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    lowswr_F: TLabel;
    marker1_F: TLabel;
    marker2_F: TLabel;
    lowswr_SWR: TLabel;
    marker1_SWR: TLabel;
    marker2_SWR: TLabel;
    lowswr_RL: TLabel;
    marker1_RL: TLabel;
    marker2_RL: TLabel;
    lowswr_Phase: TLabel;
    marker1_Phase: TLabel;
    marker2_Phase: TLabel;
    lowswr_Z: TLabel;
    marker1_Z: TLabel;
    marker2_Z: TLabel;
    lowswr_Rs: TLabel;
    lowswr_Xs: TLabel;
    marker1_Rs: TLabel;
    marker1_Xs: TLabel;
    marker2_Rs: TLabel;
    marker2_Xs: TLabel;
    GroupBox3: TGroupBox;
    cbSWR: TCheckBox;
    cbRL: TCheckBox;
    cbPhase: TCheckBox;
    cbZ: TCheckBox;
    Label11: TLabel;
    btnStart: TButton;
    cbComPort: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    eSteps: TEdit;
    Label14: TLabel;
    eCalRL: TEdit;
    Label15: TLabel;
    cbXs: TCheckBox;
    cbRs: TCheckBox;
    btnZoom: TButton;
    eDDSFreq: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    lowswr_L: TLabel;
    marker1_L: TLabel;
    marker2_L: TLabel;
    Label19: TLabel;
    lowswr_C: TLabel;
    marker1_C: TLabel;
    marker2_C: TLabel;
    Label23: TLabel;
    lowswr_Q: TLabel;
    marker1_Q: TLabel;
    marker2_Q: TLabel;
    GroupBox4: TGroupBox;
    rbCalcL: TRadioButton;
    rbCalcC: TRadioButton;
    eCorL: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    lblCalcCorLfreq: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    lblResultCalcLorC: TLabel;
    Label27: TLabel;
    eFstart: TEdit;
    Label26: TLabel;
    eFend: TEdit;
    Label28: TLabel;
    procedure btnStartClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PanelResize(Sender: TObject);
    procedure PanelPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure panelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure eFstartExit(Sender: TObject);
    procedure eFendExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure eCalRLExit(Sender: TObject);
    procedure eCalRLKeyPress(Sender: TObject; var Key: Char);
    procedure cbPlotClick(Sender: TObject);
    procedure eStepsExit(Sender: TObject);
    procedure btnZoomClick(Sender: TObject);
    procedure eDDSFreqExit(Sender: TObject);
    procedure eDDSFreqKeyPress(Sender: TObject; var Key: Char);
    procedure eCorLKeyPress(Sender: TObject; var Key: Char);
    procedure eCorLExit(Sender: TObject);
    procedure rbCalcLClick(Sender: TObject);
    procedure eFstartEndKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    panel            : TPanelPlus;
    FVNAList         : TVNAList;
    Fstart           : integer;
    Fend             : integer;
    Fsteps           : integer;
    FDDSstep         : extended;
    FUIstart         : integer;
    FUIend           : integer;
    FUIsteps         : integer;
    FUIDDSF          : integer;
    FUIDDSstep       : extended;
    FTopBorder       : integer;
    FBottomBorder    : integer;
    FLeftBorder      : integer;
    FRightBorder     : integer;
    FClientWidth     : integer;
    FClientHeight    : integer;
    marker1x         : integer;
    marker2x         : integer;
    markerLowSWRx    : integer;
    comThread        : TComThread;
    workbuf          : pointer;
    cs               : TCriticalSection;
    FPaintBitmap     : TBitmap;
    FBackgroundColor : TColor;
    FSWRColor        : TColor;
    FRLColor         : TColor;
    FPhaseColor      : TColor;
    FZColor          : TColor;
    FXsColor         : TColor;
    FRsColor         : TColor;
    FDataAvailable   : boolean;
    FCalRL           : Extended;
    FCalcCorL        : Extended;
    marker1xFreq     : Extended;
    marker2xFreq     : Extended;
    FADCtoAngle      : Extended;
    procedure ProcessData( const buf: pointer );
    procedure CheckingNewScanParameters;
    procedure EventProcessData(var msg: TMessage); message VNA_PROCESSDATA;
    procedure PaintScale;
    procedure InternalPaint;
    procedure InternalProcessData;
    procedure OpenComPort;
    procedure CloseComPort;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses math, registry, procs32;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  panel := TPanelPlus.Create(self);
  panel.Parent := Self;
  panel.Anchors := [akLeft,akTop,akRight,akBottom];
  panel.BevelOuter := bvNone;
  panel.Cursor := crCross;
  panel.ParentBackground := False;
  panel.Top := 39;
  panel.Left := 8;
  panel.Width := 1168;
  panel.Height := 550;
  panel.OnMouseDown := panelMouseDown;
  panel.OnPaint := PanelPaint;
  panel.OnResize := PanelResize;

  DecimalSeparator  := '.';
  FDataAvailable   := FALSE;
  FCalRL           := -0.7;
  FCalcCorL        := 100;
  FBackgroundColor := RGB(0,0,56);
  FSWRColor        := RGB(224,48,48);
  FRLColor         := RGB(96,96,255);
  FPhaseColor      := $00CB00E1;
  FZColor          := $0000CACA;
  FXsColor         := clSilver;
  FRsColor         := $000080FF;
  FUIstart         := 100;
  FUIend           := 30000;
  FUIsteps         := 500;
  FUIDDSF          := 400000000;
  FUIDDSstep       := 4294967296000 / FUIDDSF;
  FStart           := FUIstart;
  FEnd             := FUIend;
  FSteps           := FUIsteps;
  FDDSstep         := FUIDDSstep;
  FADCtoAngle      := 180 / 1024;
  FTopBorder       := 40;
  FBottomBorder    := 40;
  FLeftBorder      := 90;
  FRightBorder     := 90;
  FClientWidth     := panel.Width  - FLeftBorder - FRightBorder;
  FClientHeight    := panel.Height - FTopBorder  - FBottomBorder;
  marker1x         := -1;
  marker1xFreq     := 0;
  marker2x         := -1;
  marker2xFreq     := 0;
  markerLowSWRx    := -1;
  comThread        := nil;
  FVNAList         := TVNAList.Create;
  cs               := TCriticalSection.Create;
  GetMem(workbuf, 16000);
  FillMemory(workbuf, 16000, 0);
  FPaintBitmap := Tbitmap.Create;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  reg: TRegistry;
  strList : TStringList;
  i : integer;
  Pname, comStr: string;
begin
  Height := Round(Screen.Height * 0.9);
  Width  := Round(Screen.Width * 0.9);

  eFstart.Text := FloatToStr(FUIstart / 1000);
  eFend.Text   := FloatToStr(FUIend / 1000);

  reg     := TRegistry.Create;
  strList := TStringList.Create;

  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKeyReadOnly('\HARDWARE\DEVICEMAP\SERIALCOMM');
  reg.GetValueNames(strList);
  Pname := '';
  for i := 0 to strList.Count - 1 do begin
    comStr := reg.ReadString(strList[i]);
    cbComPort.AddItem( comStr, Pointer(StrToInt(Copy(comStr, 4, Length(comStr)-3))) );
    if Pos('VCP', strList[i]) > 0 then
      Pname := reg.ReadString( strList[i] );
  end;
  cbComPort.Sorted := TRUE;

  strList.Free;
  reg.free;
  if Pname = '' then begin
    cbComPort.ItemIndex := 0;
  end
  else begin
    cbComPort.ItemIndex := cbComPort.items.IndexOf(Pname);
  end;

  InternalProcessData;
end;

procedure TMainForm.OpenComPort;
begin
  if comThread = nil then begin
    comThread := TComThread.Create(TRUE);
    comThread.FreeOnTerminate := FALSE;
    comThread.ownerForm := Self;
    comThread.Fstart := FUIstart;
    comThread.Fend   := FUIend;
    comThread.Fsteps := FUIsteps;
    comThread.FCom   := Integer(cbComPort.Items.Objects[cbComPort.ItemIndex]);
    comThread.Resume;
  end;
end;

procedure TMainForm.btnZoomClick(Sender: TObject);
begin
  if (marker1x > -1) and (marker2x > -1) then begin
    If marker1x <= marker2x then begin
      FUIstart := round( marker1xFreq * 1000 );
      FUIend   := round( marker2xFreq * 1000 );
    end
    else begin
      FUIstart := round( marker2xFreq * 1000 );
      FUIend   := round( marker1xFreq * 1000 );
    end;
    eFstart.Text := FloatToStr(FUIstart / 1000);
    eFend.Text   := FloatToStr(FUIend / 1000);
    marker1x     := -1;
    marker1xFreq := 0;
    marker2x     := -1;
    marker2xFreq := 0;
  end;
end;

procedure TMainForm.cbPlotClick(Sender: TObject);
begin
  InternalProcessData;
end;

procedure TMainForm.CheckingNewScanParameters;
begin
  cs.Enter;
  comThread.Fstart   := FUIstart;
  comThread.Fend     := FUIend;
  comThread.Fsteps   := FUIsteps;
  comThread.FDDSstep := FUIDDSstep;
  cs.Leave;
end;

procedure TMainForm.CloseComPort;
begin
  if comThread <> nil then begin
    comThread.Terminate;
    comThread.WaitFor;
    comThread.Free;
    comThread := nil;
  end;
end;

procedure TMainForm.btnStartClick(Sender: TObject);
begin
  if comThread = nil then begin
    btnStart.Caption := 'Stop';
    OpenComPort;
  end
  else begin
    btnStart.Caption := 'Start';
    CloseComPort;
  end;
  cbComPort.Enabled := comThread = nil;
  btnZoom.Enabled := comThread <> nil;
end;

procedure TMainForm.eCalRLExit(Sender: TObject);
begin
  try
    FCalRL := StrToFloat(eCalRL.Text);
  except
    FCalRL := 0;
  end;
end;

procedure TMainForm.eCalRLKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in [#1..#31, '0'..'9', '.', ',', '-']) then begin
    Key := #0;
    Exit;
  end;
  if Key = ',' then begin
    Key := '.';
  end;
end;

procedure TMainForm.eCorLExit(Sender: TObject);
begin
  try
    FCalcCorL := StrToFloat(eCorL.Text);
  except
    FCalcCorL := 0;
  end;
end;

procedure TMainForm.eCorLKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in [#1..#31, '0'..'9', '.', ',']) then begin
    Key := #0;
    Exit;
  end;
  if Key = ',' then begin
    Key := '.';
  end;
end;

procedure TMainForm.eDDSFreqExit(Sender: TObject);
var
  fs: integer;
begin
  try
    Fs := StrToInt(eDDSFreq.Text);
  except
    Fs := 0;
  end;
  if (Fs < 1) or (Fs > 500000000) then begin
    MessageDlg('DDS frequency must be between 1 and 500000000 Hz.', mtError, [mbOK], 0);
    eDDSFreq.Text := IntToStr(FUIDDSF);
    eDDSFreq.SetFocus;
    Exit;
  end;
  FUIDDSF    := Fs;
  FUIDDSstep := 4294967296000 / FUIDDSF;
end;

procedure TMainForm.eDDSFreqKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in [#1..#31, '0'..'9']) then begin
    Key := #0;
    Exit;
  end;
end;

procedure TMainForm.eFendExit(Sender: TObject);
var
  f: integer;
begin
  try
    f := Round(StrToFloat(eFend.Text) * 1000);
  except
    f := 0;
  end;

  if f < 0 then begin
    MessageDlg('Frequency can not be lower than 0 MHz.', mtError, [mbOK], 0);
    eFend.Text := FloatToStr(FUIend / 1000);
    eFend.SetFocus;
    Exit;
  end;

  if f > 180000 then begin
    MessageDlg('Frequency can not be higher than 180 MHz.', mtError, [mbOK], 0);
    eFend.Text := FloatToStr(FUIend / 1000);
    eFend.SetFocus;
    Exit;
  end;

  FUIend := f;
end;

procedure TMainForm.eFstartExit(Sender: TObject);
var
  f: integer;
begin
  try
    f := Round(StrToFloat(eFstart.Text) * 1000);
  except
    f := 0;
  end;

  if f < 0 then begin
    MessageDlg('Frequency can not be lower than 0 MHz.', mtError, [mbOK], 0);
    eFstart.Text := FloatToStr(FUIstart / 1000);
    eFstart.SetFocus;
    Exit;
  end;

  if f > 180000 then begin
    MessageDlg('Frequency can not be higher than 180 MHz.', mtError, [mbOK], 0);
    eFstart.Text := FloatToStr(FUIstart / 1000);
    eFstart.SetFocus;
    Exit;
  end;

  FUIstart := f;
end;

procedure TMainForm.eFstartEndKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9', DecimalSeparator]) and (Key >= #32)) or
                     ((Key = DecimalSeparator) and (Pos(DecimalSeparator, Text) > 0))
  then begin
    Key := #0;
  end;
end;

procedure TMainForm.eStepsExit(Sender: TObject);
var
  fs: integer;
begin
  try
    Fs := StrToInt(eSteps.Text);
  except
    Fs := 0;
  end;
  if (Fs < 10) or (Fs > 4000) then begin
    MessageDlg('Steps must be between 10 and 4000.', mtError, [mbOK], 0);
    eSteps.Text := IntToStr(FUISteps);
    eSteps.SetFocus;
    Exit;
  end;
  FUIsteps := Fs;
end;

procedure TMainForm.EventProcessData(var msg: TMessage);
begin
  FDataAvailable := TRUE;
  InternalProcessData;
end;

procedure TMainForm.PanelPaint(Sender: TObject);
begin
  InternalPaint;
end;

procedure TMainForm.PanelResize(Sender: TObject);
begin
  InternalProcessData;
end;

procedure TMainForm.InternalPaint;
var
  FFinalBitmap  : TBitmap;
begin
  FFinalBitmap := TBitmap.Create;
  FFinalBitmap.PixelFormat := pf24bit;
  FFinalBitmap.Width := panel.Width;
  FFinalBitmap.Height := panel.Height;
  FFinalBitmap.Canvas.Draw(0, 0, FPaintBitmap);
  if FDataAvailable then begin
    with FFinalBitmap.Canvas do begin
      Brush.Color := FBackgroundColor;
      Pen.Color := clBlue;
      Pen.Style := psDash;
      Font.Name  := 'Arial';
      Font.Color := clBlue;
      Font.Size  := 10;
      SetBkMode(Handle, 0);
      if (marker1x > 0) and (marker1x < Fsteps) then begin
        MoveTo( FLeftBorder + round(marker1x * (FClientWidth/Fsteps)), FTopBorder);
        LineTo( FLeftBorder + round(marker1x * (FClientWidth/Fsteps)), FPaintBitmap.Height - FBottomBorder);
        TextOut( FLeftBorder + round(marker1x * (FClientWidth/Fsteps)) - 5, FPaintBitmap.Height - FBottomBorder, 'm1');
      end;
      if (marker2x > 0) and (marker2x < Fsteps) then begin
        MoveTo( FLeftBorder + round(marker2x * (FClientWidth/Fsteps)), FTopBorder);
        LineTo( FLeftBorder + round(marker2x * (FClientWidth/Fsteps)), FPaintBitmap.Height - FBottomBorder);
        TextOut( FLeftBorder + round(marker2x * (FClientWidth/Fsteps)) - 5, FPaintBitmap.Height - FBottomBorder, 'm2');
      end;
      if (markerLowSWRx > 0) and (markerLowSWRx < Fsteps) then begin
        Pen.Color := clLime;
        MoveTo( FLeftBorder + round(markerLowSWRx * (FClientWidth/Fsteps)), FTopBorder);
        LineTo( FLeftBorder + round(markerLowSWRx * (FClientWidth/Fsteps)), FPaintBitmap.Height - FBottomBorder);
      end;
    end;
  end;

  panel.Canvas.Draw(0, 0, FFinalBitmap);
  FFinalBitmap.Free;

  Update;
end;

procedure TMainForm.InternalProcessData;
var
  i, y, offset     : integer;
  lowSWR,f,g,rr,ss,calcLC : extended;
  abyte            : Byte;
  VNAEntry         : TVNAEntry;
begin
  FClientWidth  := panel.Width  - FLeftBorder - FRightBorder;
  FClientHeight := panel.Height - FTopBorder  - FBottomBorder;

  FPaintBitmap.PixelFormat := pf24bit;
  FPaintBitmap.Width       := panel.Width;
  FPaintBitmap.Height      := panel.Height;

  PaintScale;

  if FDataAvailable then begin
    lowSWR := 99999;
    FVNAList.ClearAndFree;
    for i := 0 to Fsteps-1 do begin
      VNAEntry := FVNAList.CreateAndAdd;
      VNAEntry.Frequency := Fstart/1000 + ((Fend-Fstart)/(Fsteps*1000)) * i;

      if (marker1xFreq >= Fstart/1000) and (marker1xFreq <= Fend/1000) then
        marker1x := round( (marker1xFreq - Fstart/1000) / ((Fend-Fstart)/(Fsteps*1000)) )
      else
      begin
        marker1x := -1;
        marker1xFreq := 0;
      end;

      if (marker2xFreq >= Fstart/1000) and (marker2xFreq <= Fend/1000) then
        marker2x := round( (marker2xFreq - Fstart/1000) / ((Fend-Fstart)/(Fsteps*1000)) )
      else
      begin
        marker2x := -1;
        marker2xFreq := 0;
      end;

      offset := i*4;

      abyte := pbyte( (integer(workbuf)+offset) )^;
      case pbyte( (integer(workbuf)+offset + 1) )^ of
        1: VNAEntry.ADCAngle := abyte + 256;
        2: VNAEntry.ADCAngle := abyte + 512;
        3: VNAEntry.ADCAngle := abyte + 768;
      else
        VNAEntry.ADCAngle := abyte;
      end;

      abyte := pbyte( (integer(workbuf)+offset + 2) )^;
      case pbyte( (integer(workbuf)+offset + 3) )^ of
        1: VNAEntry.ADCMagnitude := abyte + 256;
        2: VNAEntry.ADCMagnitude := abyte + 512;
        3: VNAEntry.ADCMagnitude := abyte + 768;
      else
        VNAEntry.ADCMagnitude := abyte;
      end;

      VNAEntry.ReturnLoss := ((VNAEntry.ADCMagnitude * (60/1024)) - 20) + FCalRL;
      VNAEntry.Magnitude := 1 / (Power( 10, (VNAEntry.ReturnLoss / 20) ));
      VNAEntry.Angle := VNAEntry.ADCAngle * FADCtoAngle;

      f  := Cos(VNAEntry.Angle / (180 / PI) );
      g  := Sin(VNAEntry.Angle / (180 / PI) );
      rr := f * VNAEntry.Magnitude;
      ss := g * VNAEntry.Magnitude;

      VNAEntry.Xs  := Abs(((2 * ss) / (((1 - rr)*(1 - rr)) + (ss * ss))) * 50);
      VNAEntry.Rs  := Abs(((1 - (rr*rr) - (ss*ss)) / (((1 - rr)*(1 - rr)) + (ss*ss))) * 50);
      VNAEntry.SWR := abs( (1 + VNAEntry.Magnitude) / (1 - VNAEntry.Magnitude) );
      VNAEntry.Z   := Sqrt(VNAEntry.Rs*VNAEntry.Rs + VNAEntry.Xs*VNAEntry.Xs);
      if VNAEntry.Rs > 0 then
        VNAEntry.Q   := Abs(VNAEntry.Xs / VNAEntry.Rs)
      else
        VNAEntry.Q   := 9999;

      VNAEntry.L := VNAEntry.Xs / (2*PI*VNAEntry.Frequency);
      VNAEntry.C := 1 / (2*PI*VNAEntry.Frequency*VNAEntry.Xs) * 1E6;

      if VNAEntry.SWR <= lowSWR then begin
        lowSWR := VNAEntry.SWR;
        markerLowSWRx := i;
      end;

    end;

    if cbSWR.Checked then begin
      FPaintBitmap.Canvas.Pen.Color := FSWRColor;
      for i := 0 to Fsteps-1 do begin
        VNAEntry := FVNAList[i];
        y := Round(math.Log10(VNAEntry.SWR) * FClientHeight );
        if y > FClientHeight then y := FClientHeight;

        if i=0 then
          FPaintBitmap.Canvas.MoveTo(FLeftBorder + 1, panel.Height-y-FBottomBorder)
        else
          FPaintBitmap.Canvas.LineTo(FLeftBorder + 1 + round(i * (FClientWidth/Fsteps)), panel.Height-y-FBottomBorder);
      end;
    end;

    if cbRL.Checked then begin
      FPaintBitmap.Canvas.Pen.Color := FRLColor;
      for i := 0 to Fsteps-1 do begin
        VNAEntry := FVNAList[i];
        y := Round(VNAEntry.ReturnLoss * (FClientHeight/30) );
        if y > FClientHeight then y := FClientHeight;

        if i=0 then
          FPaintBitmap.Canvas.MoveTo(FLeftBorder + 1, FTopBorder + y)
        else
          FPaintBitmap.Canvas.LineTo(FLeftBorder + 1 + round(i * (FClientWidth/Fsteps)), FTopBorder + y);
      end;
    end;

    if cbPhase.Checked then begin
      FPaintBitmap.Canvas.Pen.Color := FPhaseColor;
      for i := 0 to Fsteps-1 do begin
        VNAEntry := FVNAList[i];
        y := Round(VNAEntry.Angle * (FClientHeight/180) );
        if y > FClientHeight then y := FClientHeight;

        if i=0 then
          FPaintBitmap.Canvas.MoveTo(FLeftBorder + 1, FTopBorder + y)
        else
          FPaintBitmap.Canvas.LineTo(FLeftBorder + 1 + round(i * (FClientWidth/Fsteps)), FTopBorder + y);
      end;
    end;

    if cbZ.Checked then begin
      FPaintBitmap.Canvas.Pen.Color := FZColor;
      for i := 0 to Fsteps-1 do begin
        VNAEntry := FVNAList[i];
        y := Round(VNAEntry.Z * (FClientHeight/400) );
        if y > FClientHeight then y := FClientHeight;

        if i=0 then
          FPaintBitmap.Canvas.MoveTo(FLeftBorder + 1, FTopBorder + y)
        else
          FPaintBitmap.Canvas.LineTo(FLeftBorder + 1 + round(i * (FClientWidth/Fsteps)), FTopBorder + y);
      end;
    end;

    if cbXs.Checked then begin
      FPaintBitmap.Canvas.Pen.Color := FXsColor;
      for i := 0 to Fsteps-1 do begin
        VNAEntry := FVNAList[i];
        y := Round(VNAEntry.Xs * (FClientHeight/400) );
        if y > FClientHeight then y := FClientHeight;

        if i=0 then
          FPaintBitmap.Canvas.MoveTo(FLeftBorder + 1, FTopBorder + y)
        else
          FPaintBitmap.Canvas.LineTo(FLeftBorder + 1 + round(i * (FClientWidth/Fsteps)), FTopBorder + y);
      end;
    end;

    if cbRs.Checked then begin
      FPaintBitmap.Canvas.Pen.Color := FRsColor;
      for i := 0 to Fsteps-1 do begin
        VNAEntry := FVNAList[i];
        y := Round(VNAEntry.Rs * (FClientHeight/400) );
        if y > FClientHeight then y := FClientHeight;

        if i=0 then
          FPaintBitmap.Canvas.MoveTo(FLeftBorder + 1, FTopBorder + y)
        else
          FPaintBitmap.Canvas.LineTo(FLeftBorder + 1 + round(i * (FClientWidth/Fsteps)), FTopBorder + y);
      end;
    end;

    lowswr_F.Caption     := Format('%0.3f', [FVNAList[markerLowSWRx].Frequency]);
    lowswr_SWR.Caption   := Format('%0.2f', [FVNAList[markerLowSWRx].SWR]);
    lowswr_RL.Caption    := Format('%0.1f', [FVNAList[markerLowSWRx].ReturnLoss]);
    lowswr_Phase.Caption := Format('%0.1f', [FVNAList[markerLowSWRx].Angle]);
    lowswr_Z.Caption     := Format('%0.2f', [FVNAList[markerLowSWRx].Z]);
    lowswr_Rs.Caption    := Format('%0.2f', [FVNAList[markerLowSWRx].Rs]);
    lowswr_Xs.Caption    := Format('%0.2f', [FVNAList[markerLowSWRx].Xs]);
    lowswr_Q.Caption     := Format('%0.1f', [FVNAList[markerLowSWRx].Q]);
    lowswr_L.Caption     := Format('%0.1f', [FVNAList[markerLowSWRx].L]);
    lowswr_C.Caption     := Format('%0.1f', [FVNAList[markerLowSWRx].C]);

    lblCalcCorLfreq.Caption     := Format('%0.3f', [marker1xFreq]);
    if (FCalcCorL>0) and (marker1xFreq>0) then begin
      if rbCalcL.Checked then
        calcLC := sqr(1/(2*PI*marker1xFreq*1e3))/(FCalcCorL*1e-12)
      else
        calcLC := (sqr(1/(2*PI*marker1xFreq*1e6))/(FCalcCorL*1e-6))*1e12;

      if calcLC >= 1000 then
        lblResultCalcLorC.Caption   := Format('%0.1f', [ calcLC ])
      else
      if calcLC >= 10 then
        lblResultCalcLorC.Caption   := Format('%0.2f', [ calcLC ])
      else
        lblResultCalcLorC.Caption   := Format('%0.3f', [ calcLC ]);
    end
    else
      lblResultCalcLorC.Caption   := '';
      
    if marker1x >= 0 then begin
      marker1_F.Caption     := Format('%0.3f', [FVNAList[marker1x].Frequency]);
      marker1_SWR.Caption   := Format('%0.2f', [FVNAList[marker1x].SWR]);
      marker1_RL.Caption    := Format('%0.1f', [FVNAList[marker1x].ReturnLoss]);
      marker1_Phase.Caption := Format('%0.1f', [FVNAList[marker1x].Angle]);
      marker1_Z.Caption     := Format('%0.2f', [FVNAList[marker1x].Z]);
      marker1_Rs.Caption    := Format('%0.2f', [FVNAList[marker1x].Rs]);
      marker1_Xs.Caption    := Format('%0.2f', [FVNAList[marker1x].Xs]);
      marker1_Q.Caption     := Format('%0.1f', [FVNAList[marker1x].Q]);
      marker1_L.Caption     := Format('%0.1f', [FVNAList[marker1x].L]);
      marker1_C.Caption     := Format('%0.1f', [FVNAList[marker1x].C]);
    end
    else begin
      marker1_F.Caption     := '';
      marker1_SWR.Caption   := '';
      marker1_RL.Caption    := '';
      marker1_Phase.Caption := '';
      marker1_Z.Caption     := '';
      marker1_Rs.Caption    := '';
      marker1_Xs.Caption    := '';
      marker1_Q.Caption     := '';
      marker1_L.Caption     := '';
      marker1_C.Caption     := '';
    end;

    if marker2x >= 0 then begin
      marker2_F.Caption     := Format('%0.3f', [FVNAList[marker2x].Frequency]);
      marker2_SWR.Caption   := Format('%0.2f', [FVNAList[marker2x].SWR]);
      marker2_RL.Caption    := Format('%0.1f', [FVNAList[marker2x].ReturnLoss]);
      marker2_Phase.Caption := Format('%0.1f', [FVNAList[marker2x].Angle]);
      marker2_Z.Caption     := Format('%0.2f', [FVNAList[marker2x].Z]);
      marker2_Rs.Caption    := Format('%0.2f', [FVNAList[marker2x].Rs]);
      marker2_Xs.Caption    := Format('%0.2f', [FVNAList[marker2x].Xs]);
      marker2_Q.Caption     := Format('%0.1f', [FVNAList[marker2x].Q]);
      marker2_L.Caption     := Format('%0.1f', [FVNAList[marker2x].L]);
      marker2_C.Caption     := Format('%0.1f', [FVNAList[marker2x].C]);
    end
    else begin
      marker2_F.Caption     := '';
      marker2_SWR.Caption   := '';
      marker2_RL.Caption    := '';
      marker2_Phase.Caption := '';
      marker2_Z.Caption     := '';
      marker2_Rs.Caption    := '';
      marker2_Xs.Caption    := '';
      marker2_Q.Caption     := '';
      marker2_L.Caption     := '';
    end;

  end;

  InternalPaint;
end;

procedure TMainForm.PaintScale;
var
  i : integer;

  procedure DrawSWRlogScale( aValue: Extended; aText: string; DrawALine: boolean );
  var y : integer;
      r : TRect;
  begin
    with FPaintBitmap.Canvas do begin
      Pen.Color := FSWRColor;
      y := Round(math.Log10(aValue) * (FPaintBitmap.Height - FBottomBorder- FTopBorder) );
      MoveTo(FLeftBorder - 10, FPaintBitmap.Height - FBottomBorder - y);
      LineTo(FLeftBorder, FPaintBitmap.Height - FBottomBorder - y);

      if DrawALine then begin
        Pen.Color := clMaroon;
        Pen.Style := psDot;
        MoveTo(FLeftBorder + 2, FPaintBitmap.Height - FBottomBorder - y);
        LineTo(FPaintBitmap.Width - FRightBorder, FPaintBitmap.Height - FBottomBorder - y);
        Pen.Style := psSolid;
      end;

      r :=  Rect(FLeftBorder - 40,
                 FPaintBitmap.Height - FBottomBorder - y - (TextHeight(aText) div 2),
                 FLeftBorder - 15,
                 FPaintBitmap.Height - FBottomBorder - y + (TextHeight(aText) div 2)
                );
      DrawText(Handle, PChar(aText), -1, R, DT_RIGHT or DT_SINGLELINE or DT_VCENTER);
    end;
  end;

  procedure DrawRLscale( y: integer; aText: string);
  var
    r : TRect;
  begin
    with FPaintBitmap.Canvas do begin
      MoveTo(FLeftBorder - 45, y);
      LineTo(FLeftBorder - 35, y);

      r :=  Rect(0,
                 y - (TextHeight(aText) div 2),
                 FLeftBorder - 50,
                 y + (TextHeight(aText) div 2)
                );
      DrawText(Handle, PChar(aText), -1, R, DT_RIGHT or DT_SINGLELINE or DT_VCENTER);
    end;
  end;

  procedure DrawPhaseScale( y: integer; aText: string; DrawALine: boolean);
  var
    r : TRect;
  begin
    with FPaintBitmap.Canvas do begin
      Pen.Color := FPhaseColor;
      MoveTo( FPaintBitmap.Width - FRightBorder + 1, y);
      LineTo( FPaintBitmap.Width - FRightBorder + 11, y);

      if DrawALine then begin
        Pen.Color := $007A0088;
        Pen.Style := psDot;
        MoveTo(FLeftBorder + 2, y);
        LineTo(FPaintBitmap.Width - FRightBorder, y);
        Pen.Style := psSolid;
      end;

      r :=  Rect(FPaintBitmap.Width - FRightBorder + 10,
                 y - (TextHeight(aText) div 2),
                 FPaintBitmap.Width - FRightBorder + 40,
                 y + (TextHeight(aText) div 2)
                );
      DrawText(Handle, PChar(aText), -1, R, DT_RIGHT or DT_SINGLELINE or DT_VCENTER);
    end;
  end;

  procedure DrawZXRscale( y: integer; aText: string; DrawALine: boolean);
  var
    r : TRect;
  begin
    with FPaintBitmap.Canvas do begin
      Pen.Color := FZColor;
      MoveTo(FPaintBitmap.Width - FRightBorder + 50, y);
      LineTo(FPaintBitmap.Width - FRightBorder + 61, y);

      if DrawALine then begin
        Pen.Color := $00007A7D;
        Pen.Style := psDot;
        MoveTo(FLeftBorder + 2, y);
        LineTo(FPaintBitmap.Width - FRightBorder, y);
        Pen.Style := psSolid;
      end;

      r :=  Rect(FPaintBitmap.Width - FRightBorder + 60,
                 y - (TextHeight(aText) div 2),
                 FPaintBitmap.Width - FRightBorder + 85,
                 y + (TextHeight(aText) div 2)
                );
      DrawText(Handle, PChar(aText), -1, R, DT_RIGHT or DT_SINGLELINE or DT_VCENTER);
    end;
  end;


begin
  with FPaintBitmap.Canvas do begin
    Font.Name  := 'Arial';
    Font.Color := FSWRColor;
    Font.Size  := 9;
    SetBkMode(handle, 0);

    Brush.Color := FBackgroundColor;
    Pen.Color   := FBackgroundColor;
    FillRect(Rect(0, 0, panel.Width, panel.Height));

    Pen.Color := clGreen;
    MoveTo(FLeftBorder, FPaintBitmap.Height - FBottomBorder );
    LineTo(FPaintBitmap.Width - FRightBorder, FPaintBitmap.Height - FBottomBorder);

    MoveTo(FLeftBorder, FPaintBitmap.Height - FBottomBorder);
    LineTo(FLeftBorder, FTopBorder - 5);

    MoveTo(FPaintBitmap.Width - FRightBorder, FPaintBitmap.Height - FBottomBorder);
    LineTo(FPaintBitmap.Width - FRightBorder, FTopBorder - 5 );

    Font.Style := [fsBold];
    TextOut( FLeftBorder - 30, FTopBorder - 25, 'SWR');
    Font.Style := [];
    DrawSWRlogScale( 1,   '1',   FALSE);
    DrawSWRlogScale( 1.5, '1.5', TRUE);
    DrawSWRlogScale( 2,   '2',   TRUE);
    DrawSWRlogScale( 2.5, '2.5', FALSE);
    DrawSWRlogScale( 3,   '3',   TRUE);
    DrawSWRlogScale( 4,   '4',   FALSE);
    DrawSWRlogScale( 5,   '5',   FALSE);
    DrawSWRlogScale( 6,   '6',   FALSE);
    DrawSWRlogScale( 7,   '7',   FALSE);
    DrawSWRlogScale( 8,   '8',   FALSE);
    DrawSWRlogScale( 9,   '9',   FALSE);
    DrawSWRlogScale(10,   '10',  FALSE);

    Font.Color := FRLColor;
    Font.Style := [fsBold];
    TextOut( FLeftBorder - 75, FTopBorder - 25, 'R.L.');
    Font.Style := [];
    Pen.Color := FRLColor;
    MoveTo( FLeftBorder - 45, FTopBorder);
    LineTo( FLeftBorder - 45, FPaintBitmap.Height - FBottomBorder);
    DrawRLscale( FTopBorder, '0 db');
    DrawRLscale( FTopBorder + (FClientHeight div 3), '10 db');
    DrawRLscale( FTopBorder + 2 * (FClientHeight div 3), '20 db');
    DrawRLscale( FPaintBitmap.Height - FBottomBorder, '30 db');

    Font.Color := FPhaseColor;
    Font.Style := [fsBold];
    TextOut( FPaintBitmap.Width - FRightBorder + 5, FTopBorder - 25, 'Phase');
    Font.Style := [];
    Pen.Color := FPhaseColor;

    DrawPhaseScale(FTopBorder, '0°', TRUE);
    DrawPhaseScale(FTopBorder + (FClientHeight div 4), '45°', TRUE);
    DrawPhaseScale(FTopBorder + 2 * (FClientHeight div 4), '90°', TRUE);
    DrawPhaseScale(FTopBorder + 3 * (FClientHeight div 4), '135°', TRUE);
    DrawPhaseScale(FPaintBitmap.Height - FBottomBorder, '180°', FALSE);

    Font.Color := FZColor;
    Font.Style := [fsBold];
    TextOut( FPaintBitmap.Width - FRightBorder + 50, FTopBorder - 25, 'Z-X-R');
    Font.Style := [];
    Pen.Color := FZColor;
    MoveTo( FPaintBitmap.Width - FRightBorder + 60, FTopBorder);
    LineTo( FPaintBitmap.Width - FRightBorder + 60, FPaintBitmap.Height - FBottomBorder);
    DrawZXRscale(FTopBorder, '0', FALSE);
    DrawZXRscale(FTopBorder + (FClientHeight div 8), '50', TRUE);
    for i := 2 to 7 do begin
      DrawZXRscale(FTopBorder + (FClientHeight div 8)*i, IntToStr(i*50), FALSE);
    end;
    DrawZXRscale(FPaintBitmap.Height - FBottomBorder, '400', FALSE);
  end;
end;

procedure TMainForm.panelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FDataAvailable then begin

    if Button = mbLeft then begin
      if (X >= FLeftBorder) and (X <= FLeftBorder + FClientWidth) then begin
        marker1x := round((x - FLeftBorder) / (FClientWidth/Fsteps));
        if marker1x > Fsteps - 1 then marker1x := FSteps - 1;
        marker1xFreq := FVNAList[marker1x].Frequency;
      end
      else begin
        marker1x     := -1;
        marker1xFreq :=  0;
      end;
    end;
    if Button = mbRight then begin
      if (X >= FLeftBorder) and (X <= FLeftBorder + FClientWidth) then begin
        marker2x := round((x - FLeftBorder) / (FClientWidth/Fsteps));
        if marker2x > Fsteps - 1 then marker2x := FSteps - 1;
        marker2xFreq := FVNAList[marker2x].Frequency;
      end
      else begin
        marker2x     := -1;
        marker2xFreq :=  0;
      end;
    end;

    InternalProcessData;

  end;
end;

procedure TMainForm.ProcessData( const buf: pointer );
begin
  cs.Enter;
  Fstart := comThread.Fstart;
  Fend   := comThread.Fend;
  Fsteps := comThread.Fsteps;
  FDDSstep := comThread.FDDSstep;
  CopyMemory(workbuf, buf, Fsteps*4);
  cs.Leave;

  Postmessage( Handle, VNA_PROCESSDATA, 0, 0 );
end;

procedure TMainForm.rbCalcLClick(Sender: TObject);
begin
  if rbCalcL.Checked then begin
    Label20.Caption := 'C';
    Label21.Caption := 'pF';
    Label25.Caption := 'L';
    Label27.Caption := 'uH';
  end
  else begin
    Label20.Caption := 'L';
    Label21.Caption := 'uH';
    Label25.Caption := 'C';
    Label27.Caption := 'pF';
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CloseComPort;
  CanClose := TRUE;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  cs.Free;
  FreeMem(workbuf);
  FPaintBitmap.free;
  FVNAList.Free;
  panel.Free;
end;


{ TComThread }

procedure TComThread.ComPortDataAvailable(Sender: TObject);
begin
  // placeholder
end;

procedure TComThread.Execute;
var
  fout, stepsize: int64;
  buf : Pointer;
begin
  ComPort := TCiaComPort.Create(nil);
  GetMem(buf, 16000);
  ComPort.Port := FCom;
  ComPort.Baudrate := 115200;
  ComPort.ByteSize := 8;
  ComPort.StopBits := sbOne;
  ComPort.Parity   := ptNone;
  ComPort.FlowCtrl.XonXoff := False;
  ComPort.OnDataAvailable  := ComPortDataAvailable;
  ComPort.RxBuffer := 16384;
  ComPort.Open := TRUE;
  ComPort.PurgeTx;
  Sleep(100);
  ComPort.PurgeRx;

   processing := FALSE;
   while not Terminated do begin
     if not processing then begin
       processing := TRUE;
       Sleep(200);
       ownerForm.CheckingNewScanParameters;
       fout := Round( Fstart * FDDSstep );
       stepsize := Round(((Fend - Fstart) * FDDSstep ) / Fsteps);
       ComPort.SendStr('0'+#13);
       ComPort.SendStr(IntToStr(fout)+#13);
       ComPort.SendStr(IntToStr(FSteps)+#13);
       ComPort.SendStr(IntToStr(stepsize)+#13);
     end;

     sleep(50);
     //DebugConsoleMsg(floatToStr(FDDSstep));
     if (not terminated) and (ComPort.RxCount >= cardinal(Fsteps*4)) then begin
       ComPort.Receive(buf, Fsteps*4);
       ownerForm.ProcessData( buf );
       processing := FALSE;
     end;

   end;
  ComPort.Open := FALSE;
  FreeMem(buf);
  ComPort.Free;
end;

{ TVNAList }

function TVNAList.Add(Item: TVNAEntry): integer;
begin
  result := inherited Add( pointer(Item) );
end;

procedure TVNAList.ClearAndFree;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do begin
    Items[ i ].Free;
    Delete( i );
  end;
end;

constructor TVNAList.Create;
begin
  inherited;
  // future use?
end;

function TVNAList.CreateAndAdd: TVNAEntry;
begin
  result := TVNAEntry.Create;
  // default values here
  Add( result );
end;

destructor TVNAList.Destroy;
var
  i: integer;
begin
  try
    for i := Count - 1 downto 0 do begin
      Items[ i ].Free;
      Delete( i );
    end;
  finally
    inherited Destroy ;
  end;
end;

function TVNAList.Get(Index: integer): TVNAEntry;
begin
  result := TVNAEntry(inherited Get(Index) );
end;

procedure TVNAList.Put(Index: integer; Item: TVNAEntry);
begin
  inherited Put( Index, pointer(Item) );
end;

{ TPanelPlus }

constructor TPanelPlus.Create(AOwner: TComponent);
begin
  inherited;
  // Als we dit niet doen dan word de achtergrond doorzichtig en valt er niets
  // meer te kleuren. En dat wil je meestal met een TPanel.
  if ThemeServices.ThemesEnabled then
  begin
    ControlStyle := ControlStyle - [csParentBackground];
  end;
end;

procedure TPanelPlus.Paint;
begin
  inherited;
  if Assigned( FOnPaint ) then FOnPaint( self );
end;

end.
