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
unit FSplash;

interface

uses
  Forms, Classes, Controls, ExtCtrls, StdCtrls, Graphics, LabelEffect,
  JvExControls, JvLabel;

type
  TfmSplash = class(TForm)
    Panel1: TPanel;
    LabelEffect1: TJvLabel;
    Image1: TImage;
    LabelEffect3: TJvLabel;
    procedure FormDeactivate(Sender: TObject);
  end;

implementation

{$R *.DFM}

var
  fmSplash: TfmSplash;

procedure TfmSplash.FormDeactivate(Sender: TObject);
begin
  Screen.Cursor:= crDefault;
  fmSplash.Free
end;

begin
  Screen.Cursor:= crHourGlass;
  fmSplash:= TfmSplash.Create(nil);
  fmSplash.Show;
  fmSplash.Update
end.

