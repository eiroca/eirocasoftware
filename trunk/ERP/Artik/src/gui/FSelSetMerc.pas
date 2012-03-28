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
unit FSelSetMerc;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  uCodici, DArtik,
  Forms, Dialogs, StdCtrls, Buttons, Grids, Outline;

type
  TfmSelSetMer = class(TForm)
    lbSetMer: TLabel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    lbCodAlf: TLabel;
    olSettori: TOutline;
    procedure FormShow(Sender: TObject);
    procedure olSettoriClick(Sender: TObject);
    procedure olSettoriEnter(Sender: TObject);
    procedure olSettoriKeyPress(Sender: TObject; var Key: Char);
    procedure olSettoriDblClick(Sender: TObject);
  private
    { Private declarations }
    Schema: TSchemaCodici;
    CodAlf: string;
    Leaf: boolean;
  public
    { Public declarations }
    procedure GetSelected;
    procedure ShowInfo(SetMer: TSettoreMerc);
  end;

function SelectSetMer(var CodAlf: string; Leaf: boolean): boolean;  

implementation

{$R *.DFM}

uses
  eLibCore;

function SelectSetMer(var CodAlf: string; Leaf: boolean): boolean;
var
  fmSelSetMer: TfmSelSetMer;
begin
  fmSelSetMer:= TfmSelSetMer.Create(nil);
  try
    fmSelSetMer.CodAlf:= CodAlf;
    fmSelSetMer.Leaf  := Leaf;
    Result:= fmSelSetMer.ShowModal=mrOk;
    if Result then begin
      CodAlf:= fmSelSetMer.CodAlf;
    end;
  finally
    fmSelSetMer.Free;
  end;
end;

procedure TfmSelSetMer.FormShow(Sender: TObject);
begin
  Schema:= TSchemaCodici.Create(olSettori);
  Schema.LoadData;
  Schema.Expand(CodAlf);
  GetSelected;
end;

procedure TfmSelSetMer.GetSelected;
var
  CurSet: TSettoreMerc;
begin
  CurSet:= Schema.GetSelected;
  ShowInfo(CurSet);
  if CurSet <> nil then begin
    CodAlf:= CurSet.CodAlf;
  end;
  btOk.Enabled:= (CurSet<>nil) and (not Leaf or CurSet.IsLeaf);
end;

procedure TfmSelSetMer.ShowInfo(SetMer: TSettoreMerc);
begin
  if SetMer = nil then begin
    lbCodAlf.Caption:= '<none>';
    lbSetMer.Caption:= '<< none >>';
  end
  else begin
    lbCodAlf.Caption:= SetMer.CodAlf;
    lbSetMer.Caption:= ISettoriMerc.Desc(SetMer.CodAlf);
  end;
end;

procedure TfmSelSetMer.olSettoriClick(Sender: TObject);
begin
  GetSelected;
end;

procedure TfmSelSetMer.olSettoriEnter(Sender: TObject);
begin
  Schema.ResetSearch;
end;

procedure TfmSelSetMer.olSettoriKeyPress(Sender: TObject; var Key: Char);
begin
  if Schema.ProcessKey(Key) then Key:= #0;
end;

procedure TfmSelSetMer.olSettoriDblClick(Sender: TObject);
begin
  if btOk.Enabled then btOk.Click;
end;

end.

