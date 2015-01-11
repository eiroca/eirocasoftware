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
unit FStat;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, Grids, ExtCtrls,
  eBDEXTab, JvComponentBase, JvFormPlacement;

type
  TfmStatistiche = class(TForm)
    Panel1: TPanel;
    ctContat: TcwXTab;
    cbRow: TComboBox;
    cbCol: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;     
    tbContat: TTable;
    tbContatCodCon: TIntegerField;
    tbContatTipo: TIntegerField;
    tbContatNome_Tit: TStringField;
    tbContatNome_Pre1: TStringField;
    tbContatNome_Pre2: TStringField;
    tbContatNome_Main: TStringField;
    tbContatNome_Suf: TStringField;
    tbContatClasse: TStringField;
    tbContatSettore: TStringField;
    tbContatNote: TMemoField;
    fsStat: TJvFormStorage;
    sdExport: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure Statistiche;

implementation

{$R *.DFM}

uses
  eLibCore, uOpzioni;

procedure Statistiche;
var
  fmStatistiche: TfmStatistiche;
begin
  fmStatistiche:= nil;
  try
    fmStatistiche:= TfmStatistiche.Create(nil);
    fmStatistiche.ShowModal;
  finally
    fmStatistiche.Free;
  end;
end;

procedure TfmStatistiche.FormCreate(Sender: TObject);
  procedure Setup(cb: TcomboBox);
  begin
    cb.Items.BeginUpdate;
    cb.Clear;
    cb.Items.AddObject('Denominazione', tbContatNome_Main);
    cb.Items.AddObject('Nome', tbContatNome_Pre1);
    cb.Items.AddObject('Secondi nomi', tbContatNome_Pre2);
    cb.Items.AddObject('Titolo', tbContatNome_Tit);
    cb.Items.AddObject('Classe', tbContatClasse);
    cb.Items.AddObject('Settore', tbContatSettore);
    cb.Items.EndUpdate;
  end;
begin
  Setup(cbRow);
  Setup(cbCol); 
  cbRow.ItemIndex:= cbRow.Items.IndexOf('Classe');
  cbCol.ItemIndex:= cbCol.Items.IndexOf('Settore');
end;

procedure TfmStatistiche.FormShow(Sender: TObject);
begin
  tbContat.Open;
  ctContat.Execute;
end;

procedure TfmStatistiche.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbContat.Close;
end;

procedure TfmStatistiche.BitBtn1Click(Sender: TObject);
  function GetName(cb: TcomboBox): string;
  begin
    Result:= TField(cb.Items.Objects[cb.ItemIndex]).FieldName;
  end;
begin
  ctContat.CrossTab.RowField:= GetName(cbRow);
  ctContat.CrossTab.ColumnField:= GetName(cbCol);
  ctContat.Execute;
end;

procedure TfmStatistiche.BitBtn2Click(Sender: TObject);
var
  fn: TFileName;
  ext: string;
  TT: TTableType;
begin
 if sdExport.Execute then begin
   fn:= sdExport.FileName;
   TT:= ttASCII;
   ext:= UpperCase(ExtractFileExt(fn));
   if ext = '.DB' then TT:= ttParadox
   else if ext = '.DBF' then TT:= ttDBase;
   ctContat.SaveXTab(fn, TT);
 end;
end;

end.

