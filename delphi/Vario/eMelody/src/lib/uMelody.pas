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
unit uMelody;

interface

uses
  SysUtils, Classes;

type
  TNota = class
    public
     nota  : char;
     modif : char;
     ottava: char;
     durata: char;
    public
     constructor Create;
     destructor Destroy; override;
  end;

const
  MOT_RINGHEADER = 'L35&';

type
  EParseError = class(Exception)
  end;

  TMotorolaRingingTone = class
    private
     tempo: integer;
     note : TList;
    public
     checkCheckSum: boolean;
    public
     constructor Create;
     destructor Destroy; override;
    public
     procedure Clear;
     function  decodeSMS(const aSMS: string): boolean;
     function  encodeSMS: string;
  end;

procedure CorrectMel(const path, Mask: string);

implementation

uses
  eLibCore;

constructor TNota.Create;
begin
  nota  := 'C';
  modif := #0;
  ottava:= #0;
  durata:= '1';
end;

destructor TNota.Destroy;
begin
end;

constructor TMotorolaRingingTone.Create;
begin
  Note:= TList.Create;
  tempo:= 2;
  checkCheckSum:= true;
end;

destructor TMotorolaRingingTone.Destroy;
begin
  Clear;
  Note.Free;
end;

procedure TMotorolaRingingTone.Clear;
var
  i: integer;
begin
  for i:= Note.Count-1 downto 0 do begin
    TObject(Note[i]).Free;
  end;
  Note.Clear;
end;

function TMotorolaRingingTone.decodeSMS(const aSMS: string): boolean;
var
  ch: char;
  checkSumCalc, checkSumOrig: byte;
  ps: integer;
  endSep: integer;
  no: char;
  sh: char;
  mo: char;
  te: char;
  nota: TNota;
  b1, b2: byte;
begin
  Clear;
  Tempo:= 2;
  Result:= false;
  if (length(aSMS) <= 10) then raise EParseError.Create('String too short');
  if (copy(aSMS, 1, 4) <> MOT_RINGHEADER) then raise EParseError.Create('Bad Header');
  if (aSMS[6]) <> ' ' then raise EParseError.Create('Invalid Format at char 6');
  ch:= aSMS[5];
  if not (ch in ['1'..'4']) then EParseError.Create('Bad Tempo value');
  tempo:= ord(ch) - ord('0');
  endSep:= pos('&&', aSMS);
  if (checkCheckSum) then begin
    checkSumCalc:= 0;
    for ps:= 7 to endSep-1 do begin
      ch:= aSMS[ps];
      checkSumCalc:= checkSumCalc xor byte(ch);
    end;
    b1:= byte(aSMS[endSep+2]) - $30;
    b2:= byte(aSMS[endSep+3]) - $30;
    checkSumOrig:= b2 + b1 * 16;
    if (checkSumOrig <> checkSumCalc) then raise EParseError.Create('Invalid checkSum');
  end;
  if (endSep=-1) then raise EParseError.Create('End Marker Missing');
  if (length(aSMS) < endSep+2) then raise EParseError.Create('String too short');
  ps:= 7;
  while (ps<endSep) do begin
    no:= UpCase(aSMS[ps]);
    te:= aSMS[ps+1];
    sh:= #0;
    mo:= #0;
    if not (te in ['1'..'6']) then begin
      sh:= te;
      te:= aSMS[ps+2];
      if not (te in ['1'..'6']) then begin
        mo:= te;
        te:= aSMS[ps+3];
      end;
    end;
    if not (no in ['A'..'G', 'R']) then raise EParseError.Create('Invalid note in '+IntToStr(ps));
    if not (te in ['1'..'6'])then raise EParseError.Create('Invalid note in '+IntToStr(ps));
    if (sh in ['+','-']) then begin
      if mo <> #0 then raise EParseError.Create('Invalid note in '+IntToStr(ps));
      mo:= sh;
      sh:= #0;
    end;
    if not (sh in ['#', #0])then raise EParseError.Create('Invalid note in '+IntToStr(ps));
    if not (mo in ['+', '-', #0])then raise EParseError.Create('Invalid note in '+IntToStr(ps));
    nota:= TNota.Create;
    nota.nota:= no;
    nota.modif:= sh;
    nota.ottava:= mo;
    nota.durata:= te;
    note.Add(nota);
  end;
end;

function TMotorolaRingingTone.encodeSMS: string;
begin
end;

procedure CorrectMel(const path, Mask: string);
var
  files: TFiles;
  count, Pos: integer;
  FE: TFileElem;
  fin, fout: TextFile;
  ch: char;
  flag: boolean;
begin
  files:= TFiles.Create;
  try
    writeln('Reading files... '+Mask);
    files.ReadDirectory(Path, Mask, true, true);
    if files.Count = 0 then exit;
    writeln('Checking files...');
    count:= files.Count;
    for pos:= 0 to files.Count-1 do begin
      FE:= files.FileElem[pos];
      write(count,' '#13); dec(count);
      if not RenameFile(FE.Path, FE.Path+'.bak') then begin
        writeln('Failed to make backup file of '+FE.Path);
      end
      else begin
        try
          AssignFile(fin, FE.Path+'.bak');
          AssignFile(fout, FE.Path);
          Reset(fin);
          Rewrite(fout);
          flag:= false;
          while not EOF(fin) do begin
            read(fin, ch);
            if not (ch in [#$0A, #$0D]) then begin
              write(fout, ch);
            end
            else begin
              flag:= true;
            end;
          end;
          close(fin);
          close(fout);
          if not (flag) then begin
            DeleteFile(FE.Path+'.bak');
          end;
        except
          writeln('Failed to check '+FE.Path);
          DeleteFile(FE.Path);
          if not RenameFile(FE.Path+'.bak', FE.Path) then begin
            writeln('Failed to restore file '+FE.Path+'.bak');
          end;
        end
      end;
    end;
  finally
    Files.Free;
    writeln('Done');
  end;
end;

end.

