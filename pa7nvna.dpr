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

program pa7nvna;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFNDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frmmain in 'frmmain.pas' {MainForm},
  uCiaComPort in 'uCiaComPort.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'PA7N miniVNA';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
