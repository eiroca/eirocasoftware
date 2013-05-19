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
unit FInfo;

interface

uses
  WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Mask, Printers, JvSpin, Dialogs, TabNotBk,
  DB, DBTables, JvCtrls, ComCtrls, JvExMask;

type
  TfmInfo = class(TForm)
    BitBtn1: TBitBtn;
    btOk: TBitBtn;
    sdPrinter: TPrinterSetupDialog;
    nbInfo: TTabbedNotebook;
    Label1: TLabel;
    iDefaultDB: TEdit;
    btSetup: TSpeedButton;
    eFontSize: TJvSpinEdit;
    cbPrinter: TComboBox;
    cbFonts: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure cbPrinterChange(Sender: TObject);
    procedure cbFontsChange(Sender: TObject);
    procedure btSetupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmInfo: TfmInfo;

procedure Settings(Page: integer);

implementation

{$R *.DFM}

uses
  UOpzioni;

procedure TfmInfo.FormShow(Sender: TObject);
begin
  cbPrinter.Clear;
  cbPrinter.Items.AddStrings(Printer.Printers);
  cbPrinter.ItemIndex:= Opzioni.PrinterIndex;
  cbPrinterChange(nil);
  cbFonts.Text:= Opzioni.PrinterFontName;
  eFontSize.Value:= Opzioni.PrinterFontSize;
  iDefaultDB.Text:= Opzioni.DefaultDB;
end;

procedure TfmInfo.btOkClick(Sender: TObject);
begin
  Opzioni.DefaultDB:= iDefaultDB.Text;
  Opzioni.PrinterIndex:= cbPrinter.ItemIndex;
  Opzioni.PrinterFontName:= cbFonts.Text;
  Opzioni.PrinterFontSize:= trunc(eFontSize.Value);
  Opzioni.SaveParam;
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

procedure TfmInfo.btSetupClick(Sender: TObject);
begin
  sdPrinter.Execute;
end;

procedure TfmInfo.FormCreate(Sender: TObject);
begin
  nbInfo.PageIndex:= 0;
end;

procedure Settings(Page: integer);
begin
  if Page < 0 then Page:= 0;
  fmInfo.nbInfo.PageIndex:= Page;
  fmInfo.ShowModal;
end;

end.

