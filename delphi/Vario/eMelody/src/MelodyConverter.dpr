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
program MelodyConverter;

{$APPTYPE CONSOLE}

uses
  Forms,
  uMelody in 'lib\uMelody.pas';

{$R *.RES}

var
 mr: TMotorolaRingingTone;
begin
  mr:= TMotorolaRingingTone.Create;
  mr.decodeSMS('L35&3 D#+4C+3D#5F6A6B-3C#2D#-3G-2A4D#+4C+3D#5F6A6B-3C#2D#-3G-2A4D#+4C+3D#5F6A6B-3C#2D#-3G-2A4D#+4C+3D#5F6A6&&5:');
  mr.Free;
end.
