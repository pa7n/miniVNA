unit uCiaComport;

{  Author: Mestdagh Wilfried
   Web:    http://www.mestdagh.biz
   eMail:  wilfried@mestdagh.biz

   If you try this component then please drop me a email with your comments. Any
   comment is welcome, also negative. Please goto my web to download the latest
   version.

   Properties
      Port
         Commnumber of the port (starts at 1)

      Baudrate
         You have to fill in a valid baudreate

      ByteSize
         Default 8 bit. Note that there can be illegal combinations between
         StopBits and ByteSize.

      Parity
         TParity enumerated value

      StopBits
         TStopbits enumerated value. Note that there can be illegal combinations
         between StopBits and ByteSize.

      FlowCtrl
         Set all possible flow controls. Note that there can be illegal
         combinations. See DCB in windows API help for more information.

      RxBuffer
      TxBuffer
         Size of both rx and tx queue used by windows

      LineMode
         If set then the component will fire OnDataAvailable only when the
         LineEnd characters are received

      LineEnd
         string to indicate the end of line.

      Open
         Open or close the port

      RxCount
         Available characters in buffer, only valid if called from within
         OnDataAvailable

   Events
      OnDataAvailable
         Fired when characters are received by the component
      OnDataSent
         Fired when the tx queue is emply. If you have to send a large amount
         of data then this is the place to send next chunck

   Methods
      procedure PurgeRx;
         Purge Rx buffer

      procedure PurgeTx;
         Purge Tx buffer and stops transmitting immediatly

      function  Send(Buffer: Pointer; Len: integer): cardinal;
         Put Buffer in the txqueue, returns char's writed

      procedure SendStr(const Tx: string);
         Call's Send. Use this one if you realy wants to use strings

      function  Receive(Buffer: Pointer; Len: integer): cardinal;
         Only to be called in OnDataAvailable. You have to read all available
         characters (call RxCount to know how much there is in buffer).

      function  ReceiveStr: string;
         Call's Receive. Use this if you really wants to use strings

      function  GetFreeOutBuf: integer;
         Returns free space in Tx buffer.

      procedure GetAvailablePorts(PortList: TStrings);
         Returns all available ports on the machine

      CommFunction(Value: DWord);
         Possible values are:
         CLRDTR	Clears the DTR (data-terminal-ready) signal.
         CLRRTS	Clears the RTS (request-to-send) signal.
         SETDTR	Sends the DTR (data-terminal-ready) signal.
         SETRTS	Sends the RTS (request-to-send) signal.
         SETXOFF	Causes transmission to act as if XOFF has been received.
         SETXON	Causes transmission to act as if XON has been received.
         SETBREAK	Suspends transmission and places the line in a break state.
         CLRBREAK	Restores transmission and places the line in a nonbreak.
         Note that some combinations are illegal. For example toggle the
         hardware lines when hardware handshaking is set.

   Version information:
      1.00 18 Nov 2001
         - First version (only tested on W2K, service pack 2)
      1.01 20 Nov 2001
         - Propery editor for LineEnd
      1.02 24 Nov 2001
         - Added logic in Receive in case someone does not want to receive
           all available bytes.
         - If OnDataAvailable has no handler then we receive and trow away.
         - LineMode and LineEnd
      1.03 3 Mar 2002
         - Added GetFreeOutBuf wich returns free space in output buffer
         - Made changing port settings possible when port is already open
         - Added software and hardware handshaking
      1.04 4 Mar 2002
         - Corrected wrong calculation from XonLimit and XoffLimit
         - Added TxContinueXoff property in FlowCtrl.
      1.05 16 Mar 2002
         - Added GetAvailablePorts(PortList: TStrings), suggested by Wilson Lima
           [wsl@dglnet.com.br]
         - Added property ByteSize
         - Added CommFunction(Value: DWord).
         - Added PurgeRx to clear the Rx buffer and PurgeTx wich clears the Tx
           buffers and stop transmitting immediatly.
         - Corrected closing when there is still data in buffer (could be if
           LineMode is set) then OnDataAvailable will fire before closing.
         - Corrected if setting LineMode to False and there is still data in
           buffer then OnDataAvailable will fire immediatly.
      1.06 24 Apr 2002
         - Ported to Delphi 6 by moving the property editor to a separate file
           uCiaComportE.pas and adding conditional compilation. See notes in
           uCiaComportE.pas on what to do for Delphi6.
      1.07 15 May 2002
         - There was a bug when closing the port in Delphi 6. Serge Wagener
           [serge@wagener-consulting.lu] found offending line. Ivan Turcan
           [iturcan@drake.sk] proposed a bug fix for it. Problem was because
           the thread was created with FreeOnTerminate to True and with Delphi 6
           the thread seems to be destroyed while the WaitFor was still looping.
      1.08 1 Jul 2002
         - Added global function CiaEnumPorts.
         - Corrected spelling error in property Version (it was Verstion) found.
           Thanks to Dirk Claesen [dirk.claesen@pandora.be]. Note that you will
           have a 'property not found' error for this one, but just ignore it.
         - Bug fix in LineEnd when the byte before the first byte in LineEnd was
           exacly that same byte (eg: #13#13#10 and LineEnd #13#10). In that
           case OnDataAvailable was not fired. Fixed with a windowing function.

   Todo
      - Making partial receive possible when LineMode is set to True.
      - Implementing port events CTS, DSR, RLSD, RING, BREAK, ERR
      - Adding more exception handling
      - Make it thread safe, creating a hidden window and use SendMessage to it
        instead of using the Synchronize method
      - Check DCB on illegal values, eg: XonOff together with Hardware
        handshaking
}

interface

uses
   Windows, Classes, SysUtils;

const
   CIA_COMMVERSION = '1.08';

type
  TCiaComPort = class;
  TStopBits = (sbOne, sbOne_5, sbTwo);
  TParity = (ptNone, ptOdd, ptEven, ptMark, ptSpace);
  ECiaComPort = class(Exception);

  TCiaCommBuffer = class
  private
    FRcvd: PChar;             // pointer to buffer
    FRcvdSize: cardinal;      // size of buffer
    FReadPtr: integer;
    FWritePtr: integer;
    FLineEndPtr: Integer;
  public
    destructor Destroy; override;
    procedure Grow(Len: cardinal);
  end;

  TCiaCommThread = class(TThread)
  private
    FCiaComPort: TCiaComPort;
    FEventMask: cardinal;
    FRxCount: cardinal;
    FRcvBuffer: TCiaCommBuffer;  // if LineMode then we receive in our own buffer
    procedure PortEvent;
    procedure InternalReceive;
    function  CheckLineEnd(P: Pchar): boolean;
  public
    ComHandle: THandle;
    CloseEvent: THandle;
    procedure Execute; override;
  end;

  TDtrControl = (dtrDisable, dtrEnable, dtrHandshake);
  TRtsControl = (rtsDisable, rtsEnable, rtsHandshake, rtsToggle);
  TFlowCtrl = class(TPersistent)
  private
    FFlags: LongInt;
    FComPort: TCiaComPort;
    FRxDtrControl: TDtrControl;
    FRxRtsControl: TRtsControl;
    FRxDsrSensivity: boolean;
    FTxContinueXoff: boolean;
    FTxCtsFlow: boolean;
    FTxDsrFlow: boolean;
    FXonOff: boolean;
    constructor Create(Port: TCiaComPort);
    procedure SetRxDtrControl(Value: TDtrControl);
    procedure SetRxRtsControl(Value: TRtsControl);
    procedure SetRxDsrSensivity(Value: boolean);
    procedure SetTxContinueXoff(Value: boolean);
    procedure SetTxCtsFlow(Value: boolean);
    procedure SetTxDsrFlow(Value: boolean);
    procedure SetXonOff(Value: boolean);
    procedure ChangeCommState;
  published
    property RxDsrSensivity: boolean read FRxDsrSensivity write SetRxDsrSensivity;
    property RxDtrControl: TDtrControl read FRxDtrControl write SetRxDtrControl;
    property RxRtsControl: TRtsControl read FRxRtsControl write SetRxRtsControl;
    property TxContinueXoff: boolean read FTxContinueXoff write SetTxContinueXoff;
    property TxCtsFlow: boolean read FTxCtsFlow write SetTxCtsFlow;
    property TxDsrFlow: boolean read FTxDsrFlow write SetTxDsrFlow;
    property XonXoff: boolean read FXonOff write SetXOnOff;
  end;

  TCiaComPort = class(TComponent)
  private
    FFlowCtrl: TFlowCtrl;
    FLineMode: boolean;
    FLineEnd: string;
    FBaudrate: integer;
    FByteSize: byte;
    FStopbits: TStopBits;
    FParity: TParity;
    FVersion: string;
    FOpen: boolean;
    FPort: integer;
    FRxBuffer: cardinal;
    FXOffLimit: dword;
    FXOnLimit: dword;
    FTxBuffer: cardinal;
    FCommThread: TCiaCommThread;
    FOnDataAvailable: TNotifyEvent;
    FOnDataSent: TNotifyEvent;
    function  GetRxCount: cardinal;
    procedure OpenPort;
    procedure ClosePort;
    procedure SetOpen(Value: boolean);
    procedure SetVersion(Value: string);
    procedure SetBaudRate(Value: integer);
    procedure SetParity(Value: TParity);
    procedure SetStopBits(Value: TStopBits);
    procedure SetRxBuffer(Value: cardinal);
    procedure SetLineMode(Value: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure CommFunction(Value: dword);
    procedure GetAvailablePorts(PortList: TStrings);
    function  GetFreeOutBuf: integer;
    procedure PurgeRx;
    procedure PurgeTx;
    function  Send(Buffer: Pointer; Len: integer): cardinal;
    procedure SendStr(const Tx: string);
    function  Receive(Buffer: Pointer; Len: integer): cardinal;
    function  ReceiveStr: string;
    property Open: boolean read FOpen write SetOpen;
    property RxCount: cardinal read GetRxCount;
  published
    property Baudrate: integer read FBaudrate write SetBaudrate;
    property ByteSize: byte read FByteSize write FByteSize;
    property FlowCtrl: TFlowCtrl read FFlowCtrl write FFlowCtrl;
    property LineEnd: string read FLineEnd write FLineEnd;
    property LineMode: boolean read FLineMode write SetLineMode;
    property Parity: TParity read FParity write SetParity;
    property Port: integer read FPort write FPort;
    property RxBuffer: cardinal read FRxBuffer write SetRxBuffer;
    property StopBits: TStopBits read FStopBits write SetStopBits;
    property TxBuffer: cardinal read FTxBuffer write FTxBuffer;
    property Version: string read FVersion write SetVersion;
    property OnDataAvailable: TNotifyEvent read FOnDataAvailable write FOnDataAvailable;
    property OnDataSent: TNotifyEvent read FOnDataSent write FOnDataSent;
  end;

procedure CiaEnumPorts(PortList: TStrings);

implementation

//------------------------------------------------------------------------------
//---- TCiaCommBuffer ----------------------------------------------------------
//------------------------------------------------------------------------------
destructor TCiaCommBuffer.Destroy;
begin
   if Assigned(FRcvd) then
      FreeMem(FRcvd);
   inherited;
end;

//------------------------------------------------------------------------------
procedure TCiaCommBuffer.Grow(Len: cardinal);
begin
   ReallocMem(FRcvd, FRcvdSize + Len);
   inc(FRcvdSize, Len);
end;

//------------------------------------------------------------------------------
//---- TFlowCtrl ---------------------------------------------------------------
//------------------------------------------------------------------------------
constructor TFlowCtrl.Create(Port: TCiaComPort);
begin
   inherited Create;
   FComPort := Port;
   FRxDtrControl := dtrEnable;
   FRxRtsControl := rtsEnable;
   FFlags := 1 or       // binary mode
             $10 or     // dtrEnable
             $1000;     // rtsEnable
end;

//------------------------------------------------------------------------------
procedure TFlowCtrl.SetRxDsrSensivity(Value: boolean);
begin
   if Value = FRxDsrSensivity then
      Exit;

   FRxDsrSensivity := Value;
   if Value then
      FFlags := FFlags or  $40
   else
      FFlags := FFlags and $FFFFFFBF;

   ChangeCommState;
end;

//------------------------------------------------------------------------------
procedure TFlowCtrl.SetRxDtrControl(Value: TDtrControl);
begin
   if Value = FRxDtrControl then
      Exit;

   FRxDtrControl := Value;
   FFlags := FFlags and $FFFFFFCF;     // reset fDTRControl bits
   case Value of
      dtrDisable:
         ;
      dtrEnable:
         FFlags := FFlags or $10;
      dtrHandshake:
         FFlags := FFlags or $20;
   end;

   ChangeCommState;
end;

//------------------------------------------------------------------------------
procedure TFlowCtrl.SetRxRtsControl(Value: TRtsControl);
begin
   if Value = FRxRtsControl then
      Exit;

   FRxRtsControl := Value;
   FFlags := FFlags and $FFFFCFFF;     // reset fRTSControl bits
   case Value of
      rtsDisable:
         ;
      rtsEnable:
         FFlags := FFlags or $1000;
      rtsHandshake:
         FFlags := FFlags or $2000;
      rtsToggle:
         FFlags := FFlags or $3000;
   end;

   ChangeCommState;
end;

//------------------------------------------------------------------------------
procedure TFlowCtrl.SetTxContinueXoff(Value: boolean);
begin
   if Value = FTxContinueXoff then
      Exit;

   FTxContinueXoff := Value;
   if Value then
      FFlags := FFlags or  $80
   else
      FFlags := FFlags and $FFFFFF7F;

   ChangeCommState;
end;

//------------------------------------------------------------------------------
procedure TFlowCtrl.SetTxCtsFlow(Value: boolean);
begin
   if Value = FTxCtsFlow then
      Exit;

   FTxCtsFlow := Value;
   if Value then
      FFlags := FFlags or  $4
   else
      FFlags := FFlags and $FFFFFFFB;

   ChangeCommState;
end;

//------------------------------------------------------------------------------
procedure TFlowCtrl.SetTxDsrFlow(Value: boolean);
begin
   if Value = FTxDsrFlow then
      Exit;

   FTxDsrFlow := Value;
   if Value then
      FFlags := FFlags or  $8
   else
      FFlags := FFlags and $FFFFFFF7;

   ChangeCommState;
end;

//------------------------------------------------------------------------------
procedure TFlowCtrl.SetXonOff(Value: boolean);
begin
   if Value = FXonOff then
      Exit;

   FXonOff := Value;
   if Value then
      FFlags := FFlags or  $300
   else
      FFlags := FFlags and $FFFFFCFF;

   ChangeCommState;
end;

//------------------------------------------------------------------------------
procedure TFlowCtrl.ChangeCommState;
var
   DCB: TDCB;
begin
   if not FComport.Open then
      Exit;

   GetCommState(FComPort.FCommThread.ComHandle, DCB);
   DCB.Flags := FFlags;
   SetCommState(FComPort.FCommThread.ComHandle, DCB);
end;

//------------------------------------------------------------------------------
//---- TCiaComPort -------------------------------------------------------------
//------------------------------------------------------------------------------
constructor TCiaComPort.Create(AOwner: TComponent);
begin
   inherited;
   FFlowCtrl  := TFlowCtrl.Create(Self);
   FVersion   := CIA_COMMVERSION;
   FLineEnd   := #13#10;
   FRxBuffer  := 8192;
   FTxBuffer  := 8192;
   FXOffLimit := FRxBuffer div 2;
   FXOnLimit  := FRxBuffer div 4 * 3;
   FBaudrate  := 9600;
   FByteSize  := 8;
   FStopBits  := sbOne;
   FParity    := ptNone;
end;

//------------------------------------------------------------------------------
destructor TCiaComPort.Destroy;
begin
   if FOpen then
      ClosePort;
   if Assigned(FFlowCtrl) then
      FFlowCtrl.Destroy;
   inherited;
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.SetVersion(Value: string);
begin
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.SetRxBuffer(Value: cardinal);
var
   DCB: TDCB;
begin
   if Value = FRxBuffer then
      Exit;

   FRxBuffer  := Value;
   FXOffLimit := Value div 4 * 3;
   FXOnLimit  := Value div 2;

   if (csDesigning in ComponentState) or not Open then
      Exit;

   GetCommState(FCommThread.ComHandle, DCB);
   DCB.XoffLim := FXOffLimit;
   DCB.XonLim  := FXOnLimit;
   SetCommState(FCommThread.ComHandle, DCB);
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.SetBaudRate(Value: integer);
var
   DCB: TDCB;
begin
   if Value = FBaudRate then
      Exit;

   FBaudRate := Value;

   if (csDesigning in ComponentState) or not Open then
      Exit;

   GetCommState(FCommThread.ComHandle, DCB);
   DCB.BaudRate := Value;
   SetCommState(FCommThread.ComHandle, DCB);
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.SetParity(Value: TParity);
var
   DCB: TDCB;
begin
   if Value = FParity then
      Exit;

   FParity := Value;

   if (csDesigning in ComponentState) or not Open then
      Exit;

   GetCommState(FCommThread.ComHandle, DCB);
   DCB.Parity := Ord(Value);
   SetCommState(FCommThread.ComHandle, DCB);
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.SetStopBits(Value: TStopBits);
var
   DCB: TDCB;
begin
   if Value = FStopBits then
      Exit;

   FStopBits := Value;

   if (csDesigning in ComponentState) or not Open then
      Exit;

   GetCommState(FCommThread.ComHandle, DCB);
   DCB.StopBits := Ord(Value);
   SetCommState(FCommThread.ComHandle, DCB);
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.SetLineMode(Value: boolean);
begin
   if Value = FLineMode then
      Exit;

   FLineMode := Value;

   if not FLineMode and (FCommThread.FRxCount > 0) then
      FOnDataAvailable(Self);
end;

//------------------------------------------------------------------------------
procedure CiaEnumPorts(PortList: TStrings);
var
   n, MaxPorts: integer;
   Port: THandle;
   PortName: string;
begin
   if Win32PlatForm = VER_PLATFORM_WIN32_NT then
      MaxPorts := 256
   else { if VER_PLATFORM_WIN32_WINDOWS }
      MaxPorts := 9;

   for n := 1 to MaxPorts do
   begin
      PortName := '\\.\COM' + IntToStr(n);
      Port := CreateFile(PChar(PortName), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, 0, 0);

      if (Port <> INVALID_HANDLE_VALUE) or (GetLastError = ERROR_ACCESS_DENIED) then
         PortList.Add(IntToStr(n));

     CloseHandle(Port);
   end;
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.GetAvailablePorts(PortList: TStrings);
begin
   CiaEnumPorts(PortList);
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.CommFunction(Value: dword);
begin
   EscapeCommFunction(FCommThread.ComHandle, Value);
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.OpenPort;
var
   P: string;
   hPort: THandle;
   DCB: TDCB;
begin
   P := '\\.\COM' + IntToStr(FPort);
   hPort := CreateFile(PChar(P), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
   if hPort = INVALID_HANDLE_VALUE then
      raise ECiaComPort.Create('Cannot open port ' + '''' + P + '''');

   GetCommState(hPort, DCB);

   with DCB do begin
      Baudrate := FBaudrate;
      XoffLim  := FXOffLimit;
      XonLim   := FXOnLimit;
      ByteSize := FByteSize;
      Parity   := Ord(FParity);
      StopBits := Ord(FStopBits);
      Flags    := FFlowCtrl.FFlags;
   end;

   SetupComm(hPort, FRxBuffer, FTxBuffer);
   SetCommState(hPort, DCB);
   SetCommMask(hPort, EV_RXCHAR or EV_TXEMPTY);

   FCommThread := TCiaCommThread.Create(True);
   with FCommThread do begin
      FCiaComPort     := Self;
      ComHandle       := hPort;
      //FreeOnTerminate := True;
      FRcvBuffer      := TCiaCommBuffer.Create;
      Resume;
   end;
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.ClosePort;
begin
   if LineMode and (FCommThread.FRxCount > 0) then
      FOnDataAvailable(Self);

   with FCommThread do begin
      SetEvent(CloseEvent);
      FRcvBuffer.Destroy;
      WaitFor;
      //WaitForSingleObject(Handle, Infinite);
      Free;
   end;
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.SetOpen(Value: boolean);
begin
   if Value = FOpen then
      Exit;

   if Value then
      OpenPort
   else
      ClosePort;

   FOpen := Value;
end;

//------------------------------------------------------------------------------
function TCiaComPort.GetFreeOutBuf: integer;
var
   ComStat: TComStat;
   ErrorMask: cardinal;
begin
   ClearCommError(FCommThread.ComHandle, ErrorMask, @ComStat);
   Result := TxBuffer - ComStat.cbOutQue;
end;

//------------------------------------------------------------------------------
function TCiaComPort.Receive(Buffer: Pointer; Len: integer): cardinal;
var
   OverLapped: TOverLapped;
   Buf: TCiaCommBuffer;
begin
   if Len <= 0 then
   begin
      Result := 0;
      Exit;
   end;

   if cardinal(Len) > FCommThread.FRxCount then
      Len := FCommThread.FRxCount;

   if FLineMode then begin
      Buf := FCommThread.FRcvBuffer;
      Move(Buf.FRcvd[Buf.FReadPtr], Buffer^, Len);
      Inc(Buf.FReadPtr, Len);
      if Buf.FReadPtr >= Buf.FWritePtr then begin
         Buf.FReadPtr    := 0;
         Buf.FWritePtr   := 0;
         Buf.FLineEndPtr := 0;
      end;
      Result := Len;
   end
   else begin
      FillChar(OverLapped, SizeOf(OverLapped), 0);
      Readfile(FCommThread.ComHandle, Buffer^, Len, Result, @OverLapped);
   end;

   Dec(FCommThread.FRxCount, Result);
end;

//------------------------------------------------------------------------------
function TCiaComPort.ReceiveStr: string;
begin
   SetLength(Result, RxCount);
   Receive(Pointer(Result), RxCount);
end;

//------------------------------------------------------------------------------
function TCiaComPort.GetRxCount: cardinal;
begin
   Result := FCommThread.FRxCount;
end;

//------------------------------------------------------------------------------
function TCiaComPort.Send(Buffer: Pointer; Len: integer): cardinal;
var
   OverLap: TOverlapped;
begin
   if not FOpen then
      raise ECiaComPort.Create('Port not open');

   FillChar(OverLap, SizeOf(OverLap), 0);
   WriteFile(FCommThread.ComHandle, Buffer^, Len, Result, @OverLap);
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.SendStr(const Tx: string);
begin
   Send(Pointer(Tx), Length(Tx));
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.PurgeRx;
begin
   PurgeComm(FCommThread.ComHandle, PURGE_RXCLEAR or PURGE_RXABORT);
end;

//------------------------------------------------------------------------------
procedure TCiaComPort.PurgeTx;
begin
   PurgeComm(FCommThread.ComHandle, PURGE_TXCLEAR or PURGE_TXABORT);
end;

//------------------------------------------------------------------------------
//---- TCiaCommThread ----------------------------------------------------------
//------------------------------------------------------------------------------
procedure TCiaCommThread.Execute;
var
   WaitHandles: array[0..1] of THandle;
   OverLap: TOverLapped;
   WaitEvent: cardinal;
begin
   FillChar(OverLap, sizeof(OverLapped), 0);
   CloseEvent     := CreateEvent(nil, True, False, nil);
   OverLap.hEvent := CreateEvent(nil, True, True, nil);
   WaitHandles[0] := CloseEvent;
   WaitHandles[1] := OverLap.hEvent;

   while not Terminated do begin
      WaitCommEvent(ComHandle, FEventMask, @OverLap);
      WaitEvent := WaitForMultipleObjects(2, @WaitHandles, False, INFINITE);
      case WaitEvent of
         WAIT_OBJECT_0:
            Terminate;
         WAIT_OBJECT_0 + 1:
            Synchronize(PortEvent);
      end;
   end;

   CloseHandle(OverLap.hEvent);
   CloseHandle(CloseEvent);
   CloseHandle(ComHandle);
end;

//------------------------------------------------------------------------------
function TCiaCommThread.CheckLineEnd(P: Pchar): boolean;
var
   n: integer;
begin
   n := 1;
   while (n <= Length(FCiaComPort.LineEnd)) and (P[n - 1] = FCiaComPort.LineEnd[n]) do
      Inc(n);
   Result := n > Length(FCiaComPort.LineEnd);
end;

//------------------------------------------------------------------------------
procedure TCiaCommThread.InternalReceive;  // synchronized method
var
   OverLapped: TOverLapped;
   Count: Cardinal;
   //j: Integer;
begin
   if FRcvBuffer.FRcvdSize - cardinal(FRcvBuffer.FWritePtr) < FRxCount then
      FRcvBuffer.Grow(FRxCount);

   FillChar(OverLapped, SizeOf(OverLapped), 0);
   Readfile(ComHandle, FRcvBuffer.FRcvd[FRcvBuffer.FWritePtr], FRxCount, Count, @OverLapped);
   Inc(FRcvBuffer.FWritePtr, Count);
   Dec(FRxCount, Count);

   while (FRcvBuffer.FWritePtr - FRcvBuffer.FLineEndPtr) >= Length(FCiaComPort.LineEnd) do
   begin
      if CheckLineEnd(FRcvBuffer.FRcvd + FRcvBuffer.FLineEndPtr) then
      begin
         Inc(FRcvBuffer.FLineEndPtr, Length(FCiaComPort.LineEnd));
         if Assigned(FCiaComPort.FOnDataAvailable) then
         begin
            FRxCount := FRcvBuffer.FLineEndPtr - FRcvBuffer.FReadPtr;
            FCiaComPort.FOnDataAvailable(FCiaComPort);
            if FRcvBuffer.FReadPtr = FRcvBuffer.FWritePtr then
               Exit;
         end;
      end;
      Inc(FRcvBuffer.FLineEndPtr);
   end;

   {while FRcvBuffer.FLineEndPtr < FRcvBuffer.FWritePtr do begin
      j := 1;
      while FRcvBuffer.FRcvd[FRcvBuffer.FLineEndPtr] = FCiaComPort.LineEnd[j] do begin
         Inc(j);
         Inc(FRcvBuffer.FLineEndPtr);
         if (j > Length(FCiaComPort.LineEnd)) and Assigned(FCiaComPort.FOnDataAvailable) then begin
            FRxCount := FRcvBuffer.FLineEndPtr - FRcvBuffer.FReadPtr;
            FCiaComPort.FOnDataAvailable(FCiaComPort);   // found match
            if FRcvBuffer.FReadPtr = FRcvBuffer.FWritePtr then
               Exit;
         end;

         if FRcvBuffer.FLineEndPtr >= FRcvBuffer.FWritePtr then begin
            Dec(FRcvBuffer.FLineEndPtr, j - 1);   // partial match, rewind to match of first char
            Exit;
         end;
      end;
      Inc(FRcvBuffer.FLineEndPtr);
   end; }
end;

//------------------------------------------------------------------------------
procedure TCiaCommThread.PortEvent;    // synchronized method
var
   ComStat: TComStat;
   ErrorMask: cardinal;
   TrashCan: string[255];
begin
   ClearCommError(ComHandle, ErrorMask, @ComStat);

   // we have to check all the events, because more than one can happen the same time
   if (FEventMask and EV_RXCHAR)   > 0 then begin
      FRxCount := ComStat.cbInQue;
      if FRxCount > 0 then
         if not Assigned(FCiaComPort.FOnDataAvailable) then    // nobody wants to receive
            while FRxCount > 0 do
               FCiaComPort.Receive(@TrashCan[1], High(TrashCan))
         else
            if FCiaComPort.LineMode then
               InternalReceive
            else
               FCiaComPort.FOnDataAvailable(FCiaComPort);
   end;

   if ((FEventMask and EV_TXEMPTY) > 0) and Assigned(FCiaComPort.FOnDataSent) then
      FCiaComPort.FOnDataSent(FCiaComPort);

   // Have to add them also in the SetCommMask
   //if (FEventMask and EV_CTS)  > 0 then
   //if (FEventMask and EV_DSR)  > 0 then
   //if (FEventMask and EV_RLSD) > 0 then
   //if (FEventMask and EV_RING) > 0 then
   //if (FEventMask and EV_ERR)  > 0 then
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.
