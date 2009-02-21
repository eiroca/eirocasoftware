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
unit FMain;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, Grids,
  DB, DBTables, eDB, rxAppEvent, rxPlacemnt, rxSpeedbar, PrevInstance;

type
  TfmMain = class(TForm)
    mnMain: TMainMenu;
    File1: TMenuItem;
    miExit: TMenuItem;
    miContEdit: TMenuItem;
    N1: TMenuItem;
    miOptsSetup: TMenuItem;
    Visualizza1: TMenuItem;
    fsMain: TFormStorage;
    Aiuto1: TMenuItem;
    miAbout: TMenuItem;
    miOptsPwd: TMenuItem;
    sbMain: TSpeedBar;
    SpeedbarSection1: TSpeedbarSection;
    SpeedItem1: TSpeedItem;
    SpeedItem2: TSpeedItem;
    SpeedbarSection2: TSpeedbarSection;
    SpeedItem3: TSpeedItem;
    SpeedItem4: TSpeedItem;
    miOptsSpdBar: TMenuItem;
    miContEditGrup: TMenuItem;
    SpeedbarSection3: TSpeedbarSection;
    Opzioni1: TMenuItem;
    miInfoTelef: TMenuItem;
    SpeedItem5: TSpeedItem;
    SpeedItem6: TSpeedItem;
    miInfoIndir: TMenuItem;
    SpeedItem7: TSpeedItem;
    N2: TMenuItem;
    miInfoGrup: TMenuItem;
    SpeedItem8: TSpeedItem;
    miInfoStat: TMenuItem;
    SpeedItem9: TSpeedItem;
    AppEvents: TAppEvents;
    miContPack: TMenuItem;
    PrevInst: TMgPrevInstance;
    miNewCont: TMenuItem;
    SpeedItem10: TSpeedItem;
    miInfoNick: TMenuItem;
    SpeedItem11: TSpeedItem;
    miInfoPrint: TMenuItem;
    SpeedItem12: TSpeedItem;
    N3: TMenuItem;
    Aiuto2: TMenuItem;
    procedure miExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miContEditClick(Sender: TObject);
    procedure miOptsSetupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miOptsPwdClick(Sender: TObject);
    procedure fsMainRestorePlacement(Sender: TObject);
    procedure sbMainDblClick(Sender: TObject);
    procedure SpeedItem1Click(Sender: TObject);
    procedure SpeedItem2Click(Sender: TObject);
    procedure miOptsSpdBarClick(Sender: TObject);
    procedure SpeedItem3Click(Sender: TObject);
    procedure SpeedItem4Click(Sender: TObject);
    procedure miContEditGrupClick(Sender: TObject);
    procedure SpeedItem5Click(Sender: TObject);
    procedure miInfoTelefClick(Sender: TObject);
    procedure SpeedItem6Click(Sender: TObject);
    procedure miInfoIndirClick(Sender: TObject);
    procedure SpeedItem7Click(Sender: TObject);
    procedure miInfoGrupClick(Sender: TObject);
    procedure SpeedItem8Click(Sender: TObject);
    procedure miInfoStatClick(Sender: TObject);
    procedure SpeedItem9Click(Sender: TObject);
    procedure miContPackClick(Sender: TObject);
    procedure miNewContClick(Sender: TObject);
    procedure miInfoNickClick(Sender: TObject);
    procedure SpeedItem10Click(Sender: TObject);
    procedure SpeedItem11Click(Sender: TObject);
    procedure miInfoPrintClick(Sender: TObject);
    procedure SpeedItem12Click(Sender: TObject);
    procedure FileDrag1Drop(Sender: TObject);
    procedure Aiuto2Click(Sender: TObject);
  private
    { Private declarations }
  {$IFDEF WIN32}
    procedure AppShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
  {$ELSE}
    procedure AppShowHint(var HintStr: OpenString; var CanShow: Boolean; var HintInfo: THintInfo);
  {$ENDIF}
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

uses
  ContComm, eLib, eLibDB, eLibSystem,
  uOpzioni, DContat,
  FSplash, FInfo, FAboutBox, MakeDB,
  FContat, FChkUsr, FManom, FChgPwd, FEdtGrp, FNewCont,
  FEleTele, FEleIndi, FGruppi, FStat, FDBPack, FElenco, FNickIRC, FEleDati;

procedure TfmMain.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  fsMain.INIFileName:= Opzioni.ProgPath+Opzioni.ProgName+'.INI';
(*
  SetLongYear;
  FourDigitYear:= true;
*)
  AppEvents.OnShowHint:= AppShowHint;
  ShortMonthNames[ 1]:= 'Gen';
  ShortMonthNames[ 2]:= 'Feb';
  ShortMonthNames[ 3]:= 'Mar';
  ShortMonthNames[ 4]:= 'Apr';
  ShortMonthNames[ 5]:= 'Mag';
  ShortMonthNames[ 6]:= 'Giu';
  ShortMonthNames[ 7]:= 'Lug';
  ShortMonthNames[ 8]:= 'Ago';
  ShortMonthNames[ 9]:= 'Set';
  ShortMonthNames[10]:= 'Ott';
  ShortMonthNames[11]:= 'Nov';
  ShortMonthNames[12]:= 'Dic';
end;

procedure TfmMain.miContEditClick(Sender: TObject);
var
  CodCon: longint;
begin
  try
    CodCon:= fmElenco.tbContattiCodCon.Value;
  finally
  end;
  if CodCon <= 0 then CodCon:= -1;
  ShowContatto(CodCon);
end;

procedure TfmMain.miOptsSetupClick(Sender: TObject);
begin
  if SetupInfo = mrOk then begin
    fmElenco.tbContatti.Refresh;
  end;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  Screen.Cursor:= crDefault;
  case dmContatti.CheckProg of
    psManomesso: begin (* manomissione *)
      CloseSplash;
      if not SbloccaManomissione(dmContatti.IceLock, dmContatti.GetMagicKey, 1) then begin
        Application.Terminate;
      end
      else dmContatti.SbloccaProg;
    end;
    psScaduto: begin (* licenza scaduta *)
    end;
    psCondiviso: begin (* lanciato da un altro computer *)
    end;
  end;
  if not Application.Terminated then begin
    case CheckUser(dmContatti.IceLock, dmContatti.GetMagicKey) of
      cuManomesso: begin
        CloseSplash;
        if not SbloccaManomissione(dmContatti.IceLock, dmContatti.GetMagicKey, 1) then begin
          Application.Terminate;
        end
        else dmContatti.SbloccaProg;
      end;
      cuAbort: begin
        CloseSplash;
        Application.Terminate;
      end;
    end;
  end;
  if not Application.Terminated then begin
    CloseSplash;
    try
      if not ConnectDataBase(MakeAllTables, dmContatti.DB, Opzioni.ProgPath+Opzioni.DefaultDB,
         Crypt.SimpleCrypt(dmContatti.DB.Signature, dmContatti.DBSignature), nil) then  begin
        Application.Terminate;
      end
      else begin
      end;
    except
      on EInvalidDataBase do begin
        CloseSplash;
        if not SbloccaManomissione(dmContatti.IceLock, dmContatti.GetMagicKey, 1) then begin
          Application.Terminate;
        end
        else begin
          try
            dmContatti.SbloccaProg;
            if not ConnectDataBase(MakeAllTables, dmContatti.DB, Opzioni.ProgPath+Opzioni.DefaultDB, dmContatti.DBSignature, nil) then Abort;
          except
            Application.TErminate;
          end;
        end;
      end;
      else begin
        MessageDlg('Impossibile accedere o creare il database. Impossibile proseguire.', mtError, [mbOk], 0);
        Application.Terminate;
      end;
    end;
  end;
  if Application.Terminated then begin
    Abort;
  end;
end;

procedure TfmMain.miAboutClick(Sender: TObject);
begin
  About(dmContatti.IceLock, dmContatti.GetMagicKey, true);
end;

procedure TfmMain.miOptsPwdClick(Sender: TObject);
begin
  ChangePasswordDialog(16, true);
end;

procedure TfmMain.fsMainRestorePlacement(Sender: TObject);
begin
  fsMain.INIFileName:= Opzioni.ProgPath+Opzioni.ProgName+'.INI';
end;

procedure TfmMain.sbMainDblClick(Sender: TObject);
begin
  sbMain.Customize(0);
end;

procedure TfmMain.SpeedItem1Click(Sender: TObject);
begin
  miOptsSetup.Click;
end;

procedure TfmMain.SpeedItem2Click(Sender: TObject);
begin
  miOptsPwd.Click;
end;

procedure TfmMain.miOptsSpdBarClick(Sender: TObject);
begin
  sbMain.Customize(0);
end;

procedure TfmMain.SpeedItem3Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.SpeedItem4Click(Sender: TObject);
begin
  miContEdit.Click;
end;

procedure TfmMain.miContEditGrupClick(Sender: TObject);
begin
  EditGruppi;
end;

procedure TfmMain.SpeedItem5Click(Sender: TObject);
begin
  miContEditGrup.Click;
end;

procedure TfmMain.miInfoTelefClick(Sender: TObject);
begin
  ElencoTelefonico(0);
end;

procedure TfmMain.SpeedItem6Click(Sender: TObject);
begin
  miInfoTelef.Click;
end;

procedure TfmMain.miInfoIndirClick(Sender: TObject);
begin
  ElencoIndirizzi(0);
end;

procedure TfmMain.SpeedItem7Click(Sender: TObject);
begin
  miInfoIndir.Click;
end;

procedure TfmMain.miInfoGrupClick(Sender: TObject);
begin
  Gruppi;
end;

procedure TfmMain.SpeedItem8Click(Sender: TObject);
begin
  miInfoGrup.Click;
end;

procedure TfmMain.miInfoStatClick(Sender: TObject);
begin
  Statistiche;
end;

procedure TfmMain.SpeedItem9Click(Sender: TObject);
begin
  miInfoStat.Click;
end;

{$IFDEF WIN32}
procedure TfmMain.AppShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
{$ELSE}
procedure TfmMain.AppShowHint(var HintStr: OpenString; var CanShow: Boolean; var HintInfo: THintInfo);
{$ENDIF}
begin
  with HintInfo do begin
    if HintControl is TCustomGrid then begin
      HintPos:= HintControl.ClientToScreen(CursorPos);
      HintPos.Y:= HintPos.Y+24;
    end;
  end;
end;

procedure TfmMain.miContPackClick(Sender: TObject);
begin
  PackDataBase(MakeAllTables, dmContatti.DB);
end;

procedure TfmMain.miNewContClick(Sender: TObject);
begin
  if NewContatto = mrOk then begin
    fmElenco.tbContatti.Refresh;
  end;
end;

procedure TfmMain.miInfoNickClick(Sender: TObject);
begin
  ShowNick4IRC(0);
end;

procedure TfmMain.SpeedItem10Click(Sender: TObject);
begin
  miNewCont.Click;
end;

procedure TfmMain.SpeedItem11Click(Sender: TObject);
begin
  miInfoNick.Click;
end;

procedure TfmMain.miInfoPrintClick(Sender: TObject);
begin
  PrintContatti;
end;

procedure TfmMain.SpeedItem12Click(Sender: TObject);
begin
  miInfoPrint.Click;
end;

procedure TfmMain.FileDrag1Drop(Sender: TObject);
begin
  MessageDlg('Drop', mtInformation, [mbOk], 0);
end;

procedure TfmMain.Aiuto2Click(Sender: TObject);
var
  HelpPath: string;
begin
  HelpPath:= Opzioni.ProgPath+'help\ConTatti.htm';
  if FileExists(HelpPath) then begin
    Execute('open', HelpPath, '');
  end
  else begin
    MessageDlg('Impossibile trovare il file di help', mtInformation, [mbOk], 0);
  end;
end;

end.

