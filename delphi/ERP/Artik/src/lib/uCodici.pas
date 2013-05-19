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
unit uCodici;

interface

uses
  Classes, Outline, DB, DBTables, DArtik;

type
  TSchemaCodici = class
    private
     FSearch: string;
     FOutLine: TOutline;
     FSetMer: TList;
     C1: integer;
     C2: integer;
     procedure FreeSetMer;
     function  FindItem(const Cod: string): integer;
     procedure  LoadSettore(aCodAlf: string);
    public
     constructor Create(aOutline: TOutline);
     procedure   LoadData;
     function    GetSelected: TSettoreMerc;
     function    GetSelectedParent: TSettoreMerc;
     procedure   UpdateCaption(SetMerc: TSettoreMerc; const Cap: string);
     function    ProcessKey(Key: char): boolean;
     procedure   ResetSearch;
     procedure   Expand(const Cod: string);
     destructor  Destroy; override;
  end;

implementation

constructor TSchemaCodici.Create(aOutline: TOutline);
begin
  FOutline:= aOutline;
  FSetMer:= TList.Create;
end;

procedure TSchemaCodici.FreeSetMer;
var
  i: integer;
begin
  for i:= FSetMer.Count-1 downto 0 do begin
    TSettoreMerc(FSetMer[i]).Free;
    FSetMer.Delete(i);
  end;
  FSetMer.Pack;
end;

procedure  TSchemaCodici.LoadSettore(aCodAlf: string);
var
  SM: TSettoreMerc;
  tmp: string;
begin
  SM:= ISettoriMerc.Get(aCodAlf);
  FSetMer.Add(SM);
  tmp:= aCodAlf+' - '+SM.SetMer;
  case length(aCodAlf) of
    1: c1:= FOutline.AddObject( 0, tmp, SM);
    2: c2:= FOutline.AddChildObject(c1, tmp, SM);
    3: FOutline.AddChildObject(c2, tmp, SM);
  end;
end;

procedure   TSchemaCodici.LoadData;
begin
  FreeSetMer;
  FOutline.Clear;
  c1:= 0;
  c2:= 0;
  ISettoriMerc.EnumSettori(LoadSettore);
  ResetSearch;
end;

function  TSchemaCodici.GetSelected: TSettoreMerc;
var
  CurPos: integer;
begin
  CurPos:= FOutline.SelectedItem;
  if CurPos = 0 then Result:= nil
  else Result:= TSettoreMerc(FOutline.Items[CurPos].Data);
end;

function  TSchemaCodici.GetSelectedParent: TSettoreMerc;
var
  OLNode: TOutlineNode;
  CurPos: integer;
begin
  Result:= nil;
  CurPos:= FOutline.SelectedItem;
  if CurPos = 0 then Result:= nil;
  OLNode:= FOutline.Items[CurPos].Parent;
  if OLNode <> nil then Result:= TSettoreMerc(OLNode.Data);
end;

procedure   TSchemaCodici.UpdateCaption(SetMerc: TSettoreMerc; const Cap: string);
var
  i: integer;
begin
  for i:= 1 to FOutline.ItemCount do begin
    if FOutline.Items[i].Data=SetMerc then begin
      FOutline.Items[i].Text:= Cap;
      break;
    end;
  end;
end;

function TSchemaCodici.ProcessKey(Key: char): boolean;
var
  ps: integer;
begin
  Result:= false;
  Key:= Upcase(Key);
  ps:= FindItem(FSearch+Key);
  if ps = 0 then begin
    ps:= FindItem(Key);
    if ps= 0 then FSearch:= ''
    else FSearch:= Key;
  end
  else FSearch:= FSearch + Key;
  if ps <> 0 then begin
    Result:= true;
    FOutline.SelectedItem:= ps;
    FOutline.Items[ps].Expand;
  end;
end;

function TSchemaCodici.FindItem(const Cod: string): integer;
var
  i: integer;
begin
  Result:= 0;
  for i:= 1 to FOutline.ItemCount do begin
    if TSettoreMerc(FOutline.Items[i].Data).CodAlf = Cod then begin
      Result:= i;
      break;
    end;
  end;
end;

procedure TSchemaCodici.ResetSearch;
begin
  FSearch:= '';
end;

procedure TSchemaCodici.Expand(const Cod: string);
var
  ps, i: integer;
begin
  ps:= 0;
  for i:= 1 to length(Cod) do begin
    ps:= FindItem(Copy(Cod, 1, i));
    if ps <> 0 then begin
      FOutline.Items[ps].Expand;
    end;
  end;
  if ps <> 0 then FOutline.SelectedItem:= ps;
end;

destructor  TSchemaCodici.Destroy;
begin
  FreeSetMer;
  FSetMer.Free;
end;

end.

