(* GPL > 3.0
Copyright (C) 1986-2009 eIrOcA Elio & Enrico Croce, Simona Burzio

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
(* TabaC - Gestione Tabacchi
 * Ultima modifica: 06 nov 1999
 *)
unit FPrinterSetup;

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  {$IFDEF WIN32} ComCtrls, {$ENDIF}
  Printers, Dialogs, DB, DBTables, Buttons, TabNotBk, Mask, JvExMask, JvSpin;

type
  TfmPrinterSetup = class(TForm)
    BitBtn1: TBitBtn;
    btOk: TBitBtn;
    sdPrinter: TPrinterSetupDialog;
    GroupBox7: TGroupBox;
    Label16: TLabel;
    iRigheRep: TJvSpinEdit;
    GroupBox6: TGroupBox;
    Label5: TLabel;
    Label4: TLabel;
    sbSetting: TSpeedButton;
    Label7: TLabel;
    eFontSize: TJvSpinEdit;
    cbFonts: TComboBox;
    cbPrinter: TComboBox;
    Label1: TLabel;
    iOffTop: TJvSpinEdit;
    Label2: TLabel;
    iOffLeft: TJvSpinEdit;
    Label3: TLabel;
    iOffRight: TJvSpinEdit;
    Label6: TLabel;
    iOffBottom: TJvSpinEdit;
    aa: TPrintDialog;
    procedure FormShow(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure cbPrinterChange(Sender: TObject);
    procedure cbFontsChange(Sender: TObject);
    procedure sbSettingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function PrinterSetup: TModalResult;

implementation

{$R *.DFM}

uses
  Costanti, SysUtils, uOpzioni;

function PrinterSetup: TModalResult;
var
  fmPrinterSetup: TfmPrinterSetup;
begin
  fmPrinterSetup:= nil;
  try
    fmPrinterSetup:= TfmPrinterSetup.Create(nil);
    Result:= fmPrinterSetup.ShowModal;
  finally
    fmPrinterSetup.Free;
  end;
end;

procedure TfmPrinterSetup.FormShow(Sender: TObject);
begin
  cbPrinter.Clear;
  cbPrinter.Items.AddStrings(Printer.Printers);
  cbPrinter.ItemIndex:= Opzioni.PrinterIndex;
  cbPrinterChange(nil);
  cbFonts.Text:= Opzioni.PrinterFontName;
  eFontSize.Value:= Opzioni.PrinterFontSize;
  iRigheRep.Value:= Opzioni.RighePag;
  iOffTop.Value:= Opzioni.PrinterOffsetTop;
  iOffBottom.Value:= Opzioni.PrinterOffsetBottom;
  iOffRight.Value:= Opzioni.PrinterOffsetRight;
  iOffLeft.Value:= Opzioni.PrinterOffsetLeft;
end;

procedure TfmPrinterSetup.btOkClick(Sender: TObject);
begin
  Opzioni.PrinterIndex:= cbPrinter.ItemIndex;
  Opzioni.PrinterFontName:= cbFonts.Text;
  Opzioni.PrinterFontSize:= eFontSize.AsInteger;
  Opzioni.RighePag:= iRigheRep.AsInteger;
  Opzioni.PrinterOffsetTop:= iOffTop.AsInteger;
  Opzioni.PrinterOffsetBottom:= iOffBottom.AsInteger;
  Opzioni.PrinterOffsetRight:= iOffRight.AsInteger;
  Opzioni.PrinterOffsetLeft:= iOffLeft.AsInteger;
end;

procedure TfmPrinterSetup.cbPrinterChange(Sender: TObject);
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

procedure TfmPrinterSetup.cbFontsChange(Sender: TObject);
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

procedure TfmPrinterSetup.sbSettingClick(Sender: TObject);
begin
  sdPrinter.Execute;
end;

end.

