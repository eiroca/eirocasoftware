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
unit FEditConConti;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Mask, ExtCtrls, Grids, DBGrids, ComCtrls,
  RgNav, RgNavDB;

type
  TfmEditConConti = class(TForm)
    pcConConti: TPageControl;
    tsDettaglio: TTabSheet;
    tsElenco: TTabSheet;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditCodCon: TDBEdit;
    EditAlias: TDBEdit;
    EditDesc: TDBEdit;
    CheckBoxGruppo: TDBCheckBox;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    RGNavigator1: TRGNavigator;
    Label7: TLabel;
    DBMemo1: TDBMemo;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

function EditConti: TModalResult;

implementation

{$R *.DFM}

uses
  DEditConConti;

function EditConti: TModalResult;
var
  fmEditConConti: TfmEditConConti;
begin
  fmEditConConti:= nil;
  try
    fmEditConConti:= TfmEditConConti.Create(nil);
    Result:= fmEditConConti.ShowModal;
  finally
    fmEditConConti.Free;
  end;
end;

procedure TfmEditConConti.FormCreate(Sender: TObject);
begin
  pcConConti.ActivePage:= tsDettaglio;
end;

end.

