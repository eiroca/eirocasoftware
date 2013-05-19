(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit FManom;

interface

uses
  WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, IceLock;

type
  TfmManomissione = class(TForm)
    btAbout: TBitBtn;
    btExit: TBitBtn;
    btOk: TBitBtn;
    pnValidate: TPanel;
    ProductName: TLabel;
    tiMinuto: TTimer;
    Label1: TLabel;
    pnKey: TPanel;
    pnWait: TPanel;
    Image1: TImage;
    Label3: TLabel;
    iChckCode: TEdit;
    procedure btAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tiMinutoTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure iChckCodeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    IL: TIceLock;
    Magic: word;
    FMinuti: integer;
    pnWaitMsg: string;
    procedure SetMinuti(aMinuti: integer);
    function CheckOkButton: boolean;
    procedure Enable(pn: Tpanel);
    procedure Disable(pn: Tpanel);
  public
    { Public declarations }
    property Minuti: integer read FMinuti write SetMinuti;
  end;

function SbloccaManomissione(IL: TIceLock; Magic: word; MinTime: integer): boolean;

implementation

{$R *.DFM}

uses
  eLibCore, FAboutBox, FChkUsr, FRegist;

function SbloccaManomissione(IL: TIceLock; Magic: word; MinTime: integer): boolean;
var
  fmManomissione: TfmManomissione;
begin
  fmManomissione:= nil;
  try
    fmManomissione:= TfmManomissione.Create(nil);
    fmManomissione.IL:= IL;
    fmManomissione.Magic:= Magic;
    fmManomissione.Minuti:= MinTime;
    Result:= fmManomissione.ShowModal = mrOk;
  finally
    fmManomissione.Free;
  end;
end;

procedure TfmManomissione.FormCreate(Sender: TObject);
begin
  pnWaitMsg:= pnWait.Caption;
  FMinuti:= -2;
end;

procedure TfmManomissione.btAboutClick(Sender: TObject);
begin
  About(IL, Magic, true);
  if (IL = nil) or (not IL.IsRegistered) then Disable(pnKey)
  else Enable(pnKey);
  CheckOkButton;
end;

procedure TfmManomissione.SetMinuti(aMinuti: integer);
begin
  if aMinuti <> FMinuti then begin
    FMinuti:= aMinuti;
    if aMinuti > 0 then pnWait.Caption:= Format(pnWaitMsg, [aMinuti])
    else pnWait.Caption:= 'Premete il tasto Ok';
  end;
  CheckOkButton;
end;

procedure TfmManomissione.tiMinutoTimer(Sender: TObject);
begin
  if Minuti > 0 then Minuti:= Minuti - 1;
end;

procedure TfmManomissione.Enable(pn: Tpanel);
var
  i: integer;
  C: TControl;
begin
  pn.Enabled:= true;
  pn.Font.Color:= clBtnText;
  for i:= 0 to pn.ControlCount-1 do begin
    C:= pn.Controls[i];
    if C is TEdit then TEdit(C).Color:= clWindow;
  end;
end;

procedure TfmManomissione.Disable(pn: Tpanel);
var
  i: integer;
  C: TControl;
begin
  pn.Enabled:= false;
  pn.Font.Color:= clGrayText;
  for i:= 0 to pn.ControlCount-1 do begin
    C:= pn.Controls[i];
    if C is TEdit  then TEdit(C).Color:= clBtnFace;
  end;
end;

procedure TfmManomissione.FormShow(Sender: TObject);
begin
  btOk.Enabled:= false;
  if Minuti <> 0 then tiMinuto.Enabled:= true;
  iChckCode.Text:= '';
  if (IL = nil) or (not IL.IsRegistered) then Disable(pnKey)
  else Enable(pnKey);
  if Minuti < 0 then begin
    Disable(pnWait);
    pnWait.Caption:= '<< opzione disabilitata >>';
  end
  else Enable(pnWait);
end;

procedure TfmManomissione.btOkClick(Sender: TObject);
begin
  if CheckOkButton then begin
    ModalResult:= mrOk;
  end;
end;

function TfmManomissione.CheckOkButton: boolean;
begin
  if (IL <> nil) and (IL.IsRegistered) and CheckPWDSbloc(Trim(iChckCode.Text)) then Result:= true
  else if (Minuti = 0) then Result:= true
  else Result:= false;
  if Result <> btOk.Enabled then btOk.Enabled:= Result;
end;

procedure TfmManomissione.iChckCodeChange(Sender: TObject);
begin
  CheckOkButton;
end;

procedure TfmManomissione.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tiMinuto.Enabled:= false;
end;

end.

