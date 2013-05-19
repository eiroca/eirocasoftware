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
unit FPrezziSel;

interface

uses
  WinProcs, WinTypes, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DTabaC, StdCtrls, Buttons, Mask, DBCtrls, ExtCtrls;

type
  TfmPrezziSelect = class(TForm)
    CurDate: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    btOk: TBitBtn;
    cbListDate: TComboBox;
    btCancel: TBitBtn;
    btHelp: TBitBtn;
    Bevel1: TBevel;
    procedure btOkClick(Sender: TObject);
    procedure cbListDateChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure PrezziSelect;

implementation

{$R *.DFM}

uses
  eLibCore;

procedure PrezziSelect;
var
  fmPrezziSelect: TfmPrezziSelect;
begin
  fmPrezziSelect:= nil;
  try
    fmPrezziSelect:= TfmPrezziSelect.Create(nil);
    fmPrezziSelect.ShowModal;
  finally
    fmPrezziSelect.Free;
  end;
end;

procedure TfmPrezziSelect.btOkClick(Sender: TObject);
begin
  if CurDate.Text <> '' then begin
    dmTaba.DataPrezzi:= StrToDate(CurDate.Text);
  end;
  Close;
end;

procedure TfmPrezziSelect.cbListDateChange(Sender: TObject);
begin
  with cbListDate do begin
    CurDate.Text:= Items[ItemIndex];
  end;
end;

procedure TfmPrezziSelect.FormShow(Sender: TObject);
var
  Data: TDateTime;
  i, ps: integer;
begin
  cbListDate.Items.Clear;
  cbListDate.Items.BeginUpdate;
  dmTaba.LoadDate([dtPrez]);
  ps:= -1;
  with dmTaba do begin
    for i:= 0 to DateList[dtPrez].Count-1 do begin
      Data:= TDate(DateList[dtPrez].Objects[i]).Data;
      if DataPrezzi = Data then ps:= i;
      cbListDate.Items.Add(DateUtil.myDateToStr(Data));
    end;
  end;
  cbListDate.Items.EndUpdate;
  cbListDate.ItemIndex:= ps;
  cbListDate.OnChange(nil);
end;

end.

