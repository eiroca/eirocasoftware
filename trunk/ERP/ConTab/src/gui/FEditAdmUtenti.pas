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
unit FEditAdmUtenti;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Mask, ExtCtrls, Grids, DBGrids, ComCtrls,
  RgNav, RgNavDB;

type
  TfmEditAdmUtenti = class(TForm)
    pcConConti: TPageControl;
    tsDettaglio: TTabSheet;
    tsElenco: TTabSheet;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditCodCon: TDBEdit;
    EditDesc: TDBEdit;
    CheckBoxGruppo: TDBCheckBox;
    RGNavigator1: TRGNavigator;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

function EditUtenti: TModalResult;

implementation

{$R *.DFM}

uses
  DEditAdmUtenti;

function EditUtenti: TModalResult;
var
  fmEditAdmUtenti: TfmEditAdmUtenti;
begin
  fmEditAdmUtenti:= nil;
  try
    fmEditAdmUtenti:= TfmEditAdmUtenti.Create(nil);
    Result:= fmEditAdmUtenti.ShowModal;
  finally
    fmEditAdmUtenti.Free;
  end;
end;

procedure TfmEditAdmUtenti.FormCreate(Sender: TObject);
begin
  pcConConti.ActivePage:= tsDettaglio;
end;


end.

