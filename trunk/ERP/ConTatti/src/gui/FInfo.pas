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
unit FInfo;

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  {$IFDEF WIN32} ComCtrls, {$ENDIF}
  Printers, Dialogs, DB, DBTables, Buttons, TabNotBk, Mask, JvExMask, JvSpin,
  JvExControls, JvDBLookup;

type
  TfmInfo = class(TForm)
    BitBtn1: TBitBtn;
    btOk: TBitBtn;
    sdPrinter: TPrinterSetupDialog;
    tbContat: TTable;
    dsContat: TDataSource;
    tbContatCodCon: TIntegerField;         
    tbContatTipo: TIntegerField;
    tbContatNome_Tit: TStringField;
    tbContatNome_Main: TStringField;
    tbContatNome_Suf: TStringField;
    tbContatClasse: TStringField;
    tbContatSettore: TStringField;
    tbContatNote: TMemoField;
    tbInfo: TTabbedNotebook;
    Label1: TLabel;
    iDefaultDB: TEdit;
    GroupBox1: TGroupBox;
    cbSelfPref: TCheckBox;
    cbIntPref: TCheckBox;
    Indirizzi: TGroupBox;
    rbIndMode1: TRadioButton;
    rbIndMode2: TRadioButton;
    iRigheInd: TJvSpinEdit;
    tbTelef: TTable;
    tbTelefCodTel: TIntegerField;
    tbTelefCodCon: TIntegerField;
    tbTelefTipo: TIntegerField;
    tbTelefTel_Pre1: TStringField;
    tbTelefTel_Pre2: TStringField;
    tbTelefTelefono: TStringField;
    tbTelefNote: TStringField;
    GroupBox2: TGroupBox;
    cbAutoInsertDataImpo: TCheckBox;
    iDataImpoNota: TEdit;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    lcYourSelf: TJvDBLookupCombo;
    Label3: TLabel;
    iDefPrefix2: TEdit;
    iDefPrefix1: TEdit;
    Label6: TLabel;
    cbPostEdit: TCheckBox;
    cbPostInsert: TCheckBox;
    cbAutoInsertTelef: TCheckBox;
    cbAutoInsertIndir: TCheckBox;
    GroupBox5: TGroupBox;
    cbShowPre2: TCheckBox;
    cbShowTito: TCheckBox;
    tbContatNome_Pre1: TStringField;
    tbContatNome_Pre2: TStringField;
    Label2: TLabel;
    GroupBox6: TGroupBox;
    eFontSize: TJvSpinEdit;
    cbFonts: TComboBox;
    Label5: TLabel;
    Label4: TLabel;
    cbPrinter: TComboBox;
    SpeedButton1: TSpeedButton;
    Label7: TLabel;
    GroupBox7: TGroupBox;
    iRigheRep: TJvSpinEdit;
    Label16: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure cbPrinterChange(Sender: TObject);
    procedure cbFontsChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lcYourSelfCloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function SetupInfo: TModalResult;

implementation

{$R *.DFM}

uses
  Costanti, ContComm, eLibCore, SysUtils, uOpzioni;

function SetupInfo: TModalResult;
var
  fmInfo: TfmInfo;
begin
  fmInfo:= nil;
  try
    fmInfo:= TfmInfo.Create(nil);
    Result:= fmInfo.ShowModal;
  finally
    fmInfo.Free;
  end;
end;

procedure TfmInfo.FormShow(Sender: TObject);
begin
  tbInfo.PageIndex:= 0;
  tbContat.Open;
  tbTelef.Open;
  cbPrinter.Clear;
  cbPrinter.Items.AddStrings(Printer.Printers);
  cbPrinter.ItemIndex:= Opzioni.PrinterIndex;
  cbPrinterChange(nil);
  cbFonts.Text:= Opzioni.PrinterFontName;
  eFontSize.Value:= Opzioni.PrinterFontSize;
  iDefaultDB.Text:= Opzioni.DefaultDB;
  if Opzioni.YourSelf > 0 then lcYourSelf.Value:= IntToStr(Opzioni.YourSelf)
  else lcYourSelf.Value:= '';
  cbIntPref.Checked:= Opzioni.IntPref;
  cbSelfPref.Checked:= Opzioni.SelfPref;
  iDefPrefix1.Text:= Opzioni.DefPrefix1;
  iDefPrefix2.Text:= Opzioni.DefPrefix2;
  if Opzioni.RigheInd = 0 then begin
    rbIndMode1.Checked:= true;
    iRigheInd.Value:= defRigheInd;
  end
  else begin
    rbIndMode2.Checked:= true;
    iRigheInd.Value:= Opzioni.RigheInd;
  end;
  iRigheRep.Value:= Opzioni.RigheRep;
  cbAutoInsertDataImpo.Checked:= Opzioni.AutoInsertDataImpo;
  cbAutoInsertTelef.Checked:= Opzioni.AutoInsertTelef;
  cbAutoInsertIndir.Checked:= Opzioni.AutoInsertIndir;
  cbPostEdit.Checked:= Opzioni.PostEdit;
  cbPostInsert.Checked:= Opzioni.PostInsert;
  iDataImpoNota.Text:= Opzioni.InsertDataImpoNota;
  cbShowTito.Checked:= Opzioni.ShowTito;
  cbShowPre2.Checked:= Opzioni.ShowPre2;
end;

procedure TfmInfo.btOkClick(Sender: TObject);
begin
  Opzioni.DefaultDB:= iDefaultDB.Text;
  Opzioni.PrinterIndex:= cbPrinter.ItemIndex;
  Opzioni.PrinterFontName:= cbFonts.Text;
  Opzioni.PrinterFontSize:= trunc(eFontSize.Value);
  Opzioni.IntPref:= cbIntPref.Checked;
  Opzioni.SelfPref:= cbSelfPref.Checked;
  Opzioni.YourSelf:= Parser.IVal(lcYourSelf.Value);
  Opzioni.DefPrefix1:= Trim(iDefPrefix1.Text);
  Opzioni.DefPrefix2:= Trim(iDefPrefix2.Text);
  if rbIndMode1.Checked then begin
    Opzioni.RigheInd:= 0;
  end
  else begin
    Opzioni.RigheInd:= trunc(iRigheInd.Value);
  end;
  Opzioni.RigheRep:= trunc(iRigheRep.Value);
  Opzioni.AutoInsertDataImpo:= cbAutoInsertDataImpo.Checked;
  Opzioni.AutoInsertTelef:= cbAutoInsertTelef.Checked;
  Opzioni.AutoInsertIndir:= cbAutoInsertIndir.Checked;
  Opzioni.PostEdit:= cbPostEdit.Checked;
  Opzioni.PostInsert:= cbPostInsert.Checked;
  Opzioni.ShowTito:= cbShowTito.Checked;
  Opzioni.ShowPre2:= cbShowPre2.Checked;
  Opzioni.InsertDataImpoNota:= iDataImpoNota.Text;
end;

procedure TfmInfo.cbPrinterChange(Sender: TObject);
var
  OldFont: string;
begin
  OldFont:= cbFonts.Text;
  cbFonts.Clear;
  if cbPrinter.ItemIndex <> -1 then begin
    try
      Printer.PrinterIndex:= cbPrinter.ItemIndex;
      cbFonts.Items.AddStrings(Printer.Fonts);
      cbFonts.Text:= OldFont;
    finally
    end;
  end;
end;

procedure TfmInfo.cbFontsChange(Sender: TObject);
var
  F: TFont;
begin
  F:= TFont.Create;
  F.Name:= cbFonts.Name;
  if eFontSize.Value <> 0 then begin
    eFontSize.Value:= F.Size;
  end;
  F.Free;
end;

procedure TfmInfo.SpeedButton1Click(Sender: TObject);
begin
  sdPrinter.Execute;
end;

procedure TfmInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tbContat.Close;
end;

procedure TfmInfo.lcYourSelfCloseUp(Sender: TObject);
begin
  if tbContat.Locate('CodCon', lcYourSelf.Value, []) then begin
    tbTelef.First;
    if not tbTelef.EOF then begin
      iDefPrefix1.Text:= tbTelefTel_Pre1.Value;
      iDefPrefix2.Text:= tbTelefTel_Pre2.Value;
    end;
  end;
end;

end.

