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
unit FEleDati;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type                                        
  TfmEleDati = class(TForm)
    GroupBox1: TGroupBox;
    cbFlag1: TCheckBox;
    cbFlag2: TCheckBox;
    cbFlag3: TCheckBox;
    cbFlag4: TCheckBox;
    cbFlag6: TCheckBox;
    cbFlag5: TCheckBox;
    cbFlag7: TCheckBox;
    btPrint: TBitBtn;
    btExport: TBitBtn;
    btHelp: TBitBtn;
    btCancel: TBitBtn;
    cbFlag8: TCheckBox;
    btPreview: TBitBtn;
    procedure PrintIt(Sender: TObject);
  private
    { Private declarations }
    Flag: array[1..10] of boolean;
    procedure SetupFlag;
  public
    { Public declarations }
  end;

procedure PrintContatti;

implementation

{$R *.DFM}

uses
  FRepDati;

procedure PrintContatti;
var
  fmEleDati: TfmEleDati;
begin
  fmEleDati:= nil;
  try
    fmEleDati:= TfmEleDati.Create(nil);
    fmEleDati.ShowModal;
  finally
    fmEleDati.Free;
  end;
end;

procedure TfmEleDati.SetupFlag;
begin
  FillChar(Flag, sizeOf(Flag), byte(false));
  Flag[1]:= cbFlag1.Checked;
  Flag[2]:= cbFlag2.Checked;
  Flag[3]:= cbFlag3.Checked;
  Flag[4]:= cbFlag4.Checked;
  Flag[5]:= cbFlag5.Checked;
  Flag[6]:= cbFlag6.Checked;
  Flag[7]:= cbFlag7.Checked;
  Flag[8]:= cbFlag8.Checked;
end;

procedure TfmEleDati.PrintIt(Sender: TObject);
var
  Device: string;
begin
       if Sender = btExport then Device:= 'TextFile'
  else if Sender = btPrint  then Device:= 'Printer'
  else Device:= 'Preview';
  SetupFlag;
  ReportDatiContatto('IdxNome', Flag, Device);
end;

end.

