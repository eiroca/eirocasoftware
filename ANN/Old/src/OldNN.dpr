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
program OldNN;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Neuronal in 'kohonen\Neuronal.pas',
  Kohonen in 'kohonen\Kohonen.pas',
  Test1 in 'mlp\Test1.pas',
  NN in 'mlp\NN.pas',
  MemAssoc in 'MemAssoc\MemAssoc.pas';

begin
  Test1.Main;
  MemAssoc.Main;
  Kohonen.Main;
  Neuronal.Main;
  readln;
end.

