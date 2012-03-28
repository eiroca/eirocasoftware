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
unit FEditPiaCod;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DArtik, uCodici,
  Forms, Dialogs, Grids, DBGrids, DB, DBTables, Outline, StdCtrls,
  Buttons, ExtCtrls, Menus, Mask, JvExMask, JvSpin;

type
  TfmEditPiaCod = class(TForm)
    olSettori: TOutline;
    Panel1: TPanel;
    Panel2: TPanel;
    lbSetMer: TLabel;
    lbCodAlf: TLabel;
    Label1: TLabel;
    iCodAlf: TEdit;
    Label2: TLabel;
    iSetMer: TEdit;
    Label3: TLabel;
    iPreDes: TEdit;
    Label4: TLabel;
    iRicMin: TJVSpinEdit;
    Label5: TLabel;
    iRicMax: TJvSpinEdit;
    btDefault: TBitBtn;
    btAggiorna: TBitBtn;
    pmAction: TPopupMenu;
    miAdd: TMenuItem;
    miAddChild: TMenuItem;
    N1: TMenuItem;
    miDelete: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure olSettoriClick(Sender: TObject);
    procedure btAggiornaClick(Sender: TObject);
    procedure btDefaultClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure iCodAlfKeyPress(Sender: TObject; var Key: Char);
    procedure olSettoriEnter(Sender: TObject);
    procedure olSettoriKeyPress(Sender: TObject; var Key: Char);
    procedure miDeleteClick(Sender: TObject);
    procedure miAddChildClick(Sender: TObject);
    procedure miAddClick(Sender: TObject);
  private
    { Private declarations }
    Schema : TSchemaCodici;
    procedure GetSelected;
    procedure ShowData(SetMer: TSettoreMerc);
    procedure ShowInfo(SetMer: TSettoreMerc);
    procedure SaveChanges;
    procedure AddNode(const Cod: string);
  public
    { Public declarations }
  end;

procedure EditPiaCod;

implementation

{$R *.DFM}

uses
  eLibCore, FGetUnCod;

function LastLetter(s: string): string;
begin
  if length(s)>0 then Result:= S[length(s)]
  else Result:= '';
end;

procedure EditPiaCod;
var
  fmEditPiaCod: TfmEditPiaCod;
begin
  fmEditPiaCod:= TfmEditPiaCod.Create(nil);
  try
    fmEditPiaCod.ShowModal;
  finally
    fmEditPiaCod.Free;
  end;
end;

procedure TfmEditPiaCod.FormCreate(Sender: TObject);
begin
  iSetMer.MaxLength:= LEN_SETMERC;
  iPreDes.MaxLength:= LEN_PREDESC;
  iCodAlf.MaxLength:= LEN_CODALF;
end;

procedure TfmEditPiaCod.FormShow(Sender: TObject);
begin
  Schema:= TSchemaCodici.Create(olSettori);
  Schema.LoadData;
  GetSelected;
end;

procedure TfmEditPiaCod.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Schema.Free;
end;

procedure TfmEditPiaCod.olSettoriClick(Sender: TObject);
begin
  GetSelected;
end;

procedure TfmEditPiaCod.GetSelected;
var
  CurSet: TSettoreMerc;
begin
  CurSet:= Schema.GetSelected;
  if CurSet <> nil then begin
    ShowInfo(CurSet);
    ShowData(CurSet);
  end;
end;

procedure TfmEditPiaCod.ShowInfo(SetMer: TSettoreMerc);
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

procedure TfmEditPiaCod.ShowData(SetMer: TSettoreMerc);
begin
  if SetMer = nil then begin
    iCodAlf.Text:= ''; iCodAlf.ReadOnly:= true;
    iSetMer.Text:= ''; iSetMer.ReadOnly:= true;
    iPreDes.Text:= ''; iPreDes.ReadOnly:= true;
    iRicMin.Value:= 0; iRicMin.ReadOnly:= true;
    iRicMax.Value:= 0; iRicMax.ReadOnly:= true;
  end
  else begin
    iCodAlf.Text:= SetMer.CodAlf;    iCodAlf.ReadOnly:= true;
    iSetMer.Text:= SetMer.SetMer;    iSetMer.ReadOnly:= false;
    iPreDes.Text:= SetMer.PreDes;    iPreDes.ReadOnly:= false;
    iRicMin.Value:= SetMer.RicMin;   iRicMin.ReadOnly:= false;
    iRicMax.Value:= SetMer.RicMax;   iRicMax.ReadOnly:= false;
  end;
  btAggiorna.Enabled:= (SetMer<>nil);
  btDefault.Enabled := length(SetMer.CodAlf)>1;
  miDelete.Enabled:= SetMer<>nil;
  miAddChild.Enabled:= (SetMer<>nil) and (length(SetMer.CodAlf)<3);
  miAdd.Enabled:= (SetMer<>nil);
end;

procedure TfmEditPiaCod.btAggiornaClick(Sender: TObject);
var
  Parent: TSettoreMerc;
  CurSet: TSettoreMerc;
begin
  CurSet:= Schema.GetSelected;
  if CurSet <> nil then begin
    Parent:= Schema.GetSelectedParent;
    if (Parent=nil)
     or (((Parent.RicMin=0) or (iRicMin.Value >= Parent.RicMin)) and ((Parent.RicMax=0) or (iRicMax.Value <= Parent.RicMax)))
     or (MessageDlg('Sei sicuro dei valori immessi?', mtConfirmation, [mbYes, mbNo], 0)=mrYes) then begin
      CurSet.SetMer:= iSetMer.Text;
      CurSet.PreDes:= iPreDes.Text;
      CurSet.RicMin:= iRicMin.Value;
      CurSet.RicMax:= iRicMax.Value;
    end;
    SaveChanges;
    Schema.UpdateCaption(CurSet, CurSet.CodAlf+' - '+CurSet.SetMer);
  end;
end;

procedure TfmEditPiaCod.btDefaultClick(Sender: TObject);
var
  Parent: TSettoreMerc;
  CurSet: TSettoreMerc;
begin
  CurSet:= Schema.GetSelected;
  if (CurSet<>nil) then begin
    Parent:= Schema.GetSelectedParent;
    if (Parent <> nil) then begin
      CurSet.PreDes:= Parent.PreDes;
      CurSet.RicMin:= Parent.RicMin;
      CurSet.RicMax:= Parent.RicMax;
      SaveChanges;
    end;
  end;
end;

procedure TfmEditPiaCod.SaveChanges;
var
  CurSet: TSettoreMerc;
begin
  CurSet:= Schema.GetSelected;
  if CurSet <> nil then ISettoriMerc.Save(CurSet);
  ShowData(CurSet);
  ShowInfo(CurSet);
end;

procedure TfmEditPiaCod.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmEditPiaCod.iCodAlfKeyPress(Sender: TObject; var Key: Char);
begin
  Key:= Upcase(Key);
end;

procedure TfmEditPiaCod.olSettoriEnter(Sender: TObject);
begin
  Schema.ResetSearch;
end;

procedure TfmEditPiaCod.olSettoriKeyPress(Sender: TObject; var Key: Char);
begin
  if Schema.ProcessKey(Key) then Key:= #0;
end;

procedure TfmEditPiaCod.miDeleteClick(Sender: TObject);
var
  N: longint;
  tmp: string;
  CurSet: TSettoreMerc;
begin
  CurSet:= Schema.GetSelected;
  N:= ISettoriMerc.CountArtic(CurSet.CodAlf);
  if N > 0 then begin
    MessageDlg('Impossibile cancellare in quanto sono presenti degli articoli in questo settore merceologico',
     mtInformation, [mbOk], 0);
    exit;
  end;
  ISettoriMerc.Delete(CurSet.CodAlf);
  tmp:= CurSet.CodAlf;
  Schema.LoadData;
  GetSelected;
  if length(tmp)>1 then begin
    Schema.Expand(Copy(tmp, 1, length(tmp)-1));
  end;
end;

procedure TfmEditPiaCod.miAddChildClick(Sender: TObject);
var
  CurSet: TSettoreMerc;
begin
  CurSet:= Schema.GetSelected;
  AddNode(CurSet.CodAlf);
end;

procedure TfmEditPiaCod.AddNode(const Cod: string);
var
  Code: char;
  tmp: string;
begin
  Code:= #0;
  if GetUnusedCode(Cod, Code) and (Code<>#0) then begin
    tmp:= Cod+Code;
    ISettoriMerc.Crea(tmp);
    Schema.LoadData;
    GetSelected;
    Schema.Expand(tmp);
  end;
end;

procedure TfmEditPiaCod.miAddClick(Sender: TObject);
var
  tmp: string;
  CurSet: TSettoreMerc;
begin
  CurSet:= Schema.GetSelected;
  tmp:= CurSet.CodAlf;
  if length(tmp)>0 then Delete(tmp, length(tmp), 1);
  AddNode(tmp);
end;

end.

