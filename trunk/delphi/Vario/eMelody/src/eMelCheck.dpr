(* GPL > 3.0
Copyright (C) 2001-2009 eIrOcA Enrico Croce & Simona Burzio

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
program eMelCheck;

{$APPTYPE CONSOLE}

uses
  uMelody in 'lib\uMelody.pas';

{$R *.res}

procedure Main;
var
  Path, Mask: string;
begin
  if ParamCount>=1 then Mask:= ParamStr(1) else Mask:= '*.mel';
  if ParamCount>=2 then Path:= ParamStr(2) else Path:= '';
  if (Mask='-?') or (Mask='?') or (Mask='-h') or (Mask='/?') then begin
    writeln(ParamStr(0),' [mask [path]]');
  end
  else begin
    CorrectMel(path, mask);
  end;
end;

begin
  Main;
end.
