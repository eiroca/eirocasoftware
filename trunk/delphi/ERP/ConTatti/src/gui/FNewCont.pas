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
unit FNewCont;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DBTables, DB;

type
  TfmNewCont = class(TForm)
    Label1: TLabel;
    iNome: TEdit;
    iNotaNome: TEdit;
    Label2: TLabel;
    iTelef1: TEdit;
    iNotaTelef1: TEdit;
    Label3: TLabel;       
    iTelef2: TEdit;
    iNotaTelef2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    iIndir1: TEdit;
    iNotaIndir1: TEdit;
    Label6: TLabel;
    iIndir2: TEdit;
    iNotaIndir2: TEdit;
    btCancel: TBitBtn;
    btOk: TBitBtn;
    btEdit: TBitBtn;
    btHelp: TBitBtn;
    Label7: TLabel;
    tbIndir: TTable;
    tbTelef: TTable;
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
    tbTelefCodTel: TIntegerField;
    tbTelefCodCon: TIntegerField;
    tbTelefTipo: TIntegerField;
    tbTelefTel_Pre1: TStringField;
    tbTelefTel_Pre2: TStringField;
    tbTelefTelefono: TStringField;
    tbTelefNote: TStringField;
    tbIndirCodInd: TIntegerField;
    tbIndirCodCon: TIntegerField;
    tbIndirTipo: TIntegerField;
    tbIndirIndirizzo: TMemoField;
    tbIndirNote: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure iNomeExit(Sender: TObject);
    procedure iTelef1Exit(Sender: TObject);
    procedure iIndir2Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    DefNam: string;
    DefTel: string;
    DefInd: string;
    function PostData: longint;
  public
    { Public declarations }
  end;

function NewContatto: TModalResult;

implementation

{$R *.DFM}

uses
  DContat, uOpzioni, ContComm, eLibCore, FContat;

procedure TfmNewCont.FormCreate(Sender: TObject);
begin
  DefNam:= iNome.Text;
  DefTel:= iTelef1.Text;
  DefInd:= iIndir1.Text;
end;

function TfmNewCont.PostData: longint;
var
  Nome: string;
  flg: boolean;
  NomeMain: string;
  NomePre: string;
  Tel1, Tel2: string;
  Ind1, Ind2: string;
  Pre1, Pre2, Num: string;
  S: TStrings;
begin
  Result:= 0;
  S:= nil;
  try
    if lowercase(iNome.Text) = lowercase(DefNam) then Nome:= ''
    else Nome:= Trim(iNome.Text);
    Flg:= SplitName(Nome, NomeMain, NomePre);
    if not flg or (NomeMain='') then begin
      MessageDlg('E'' obbligatorio inserire il cognome (o la ragione sociale) del contatto!', mtInformation, [mbOk], 0);
      ActiveControl:= iNome;
      exit;
    end;
    if lowercase(iTelef1.Text) = lowercase(DefTel) then Tel1:= ''
    else Tel1:= Trim(iTelef1.Text);
    if lowercase(iTelef2.Text) = lowercase(DefTel) then Tel2:= ''
    else Tel2:= Trim(iTelef2.Text);
    if lowercase(iIndir1.Text) = lowercase(DefInd) then Ind1:= ''
    else Ind1:= Trim(iIndir1.Text);
    if lowercase(iIndir2.Text) = lowercase(DefInd) then Ind2:= ''
    else Ind2:= Trim(iIndir2.Text);
    if (Tel1 <> '') and (not SplitTel(Tel1, Pre1, Pre2, Num) or (Num='')) then begin
      MessageDlg('Il numero "'+Tel1+'" non rappresenta un numero di telefono valido', mtInformation, [mbOk], 0);
      ActiveControl:= iTelef1;
      exit;
    end;
    if (Tel2 <> '') and (not SplitTel(Tel2, Pre1, Pre2, Num) or (Num='')) then begin
      MessageDlg('Il numero "'+Tel2+'" non rappresenta un numero di telefono valido', mtInformation, [mbOk], 0);
      ActiveControl:= iTelef2;
      Abort;
    end;
    S:= TStringList.Create;
    if (Ind1 <> '') and (not SplitInd(Ind1, S) or (S.Count=0)) then begin
      MessageDlg('Il numero "'+Ind1+'" non rappresenta un indirizzo valido', mtInformation, [mbOk], 0);
      ActiveControl:= iIndir1;
      S.Free;
      exit;
    end;
    if (Ind2 <> '') and (not SplitInd(Ind2, S) or (S.Count=0)) then begin
      MessageDlg('Il numero "'+Ind2+'" non rappresenta un indirizzo valido', mtInformation, [mbOk], 0);
      ActiveControl:= iIndir2;
      S.Free;
      exit;
    end;
    S.Clear;
    S.Add(trim(iNotaNome.Text));
    tbContat.Active:= true;
    tbIndir.Active:= true;
    tbTelef.Active:= true;
    try
      tbContat.Append;
      tbContatNome_Pre1.Value:= NomePre;
      tbContatNome_Main.Value:= NomeMain;
      tbContatNote.Assign(S);
      tbContat.Post;
      Result:= tbContatCodCon.Value;
    except
      tbContat.Cancel;
      Result:= 0;
    end;
    if Result > 0 then begin
      if Tel1 <> '' then begin
        SplitTel(Tel1, Pre1, Pre2, Num);
        if Pre1 = '' then Pre1:= Opzioni.DefPrefix1;
        if Pre2 = '' then Pre2:= Opzioni.DefPrefix2;
        try
          tbTelef.Append;
          tbTelefCodCon.Value:= Result;
          tbTelefTel_Pre1.Value:= Pre1;
          tbTelefTel_Pre2.Value:= Pre2;
          tbTelefTelefono.Value:= Num;
          tbTelefNote.Value:= Trim(iNotaTelef1.Text);
          tbTelef.Post;
        except
          tbTelef.Cancel;
        end;
      end;
      if Tel2 <> '' then begin
        SplitTel(Tel2, Pre1, Pre2, Num);
        if Pre1 = '' then Pre1:= Opzioni.DefPrefix1;
        if Pre2 = '' then Pre2:= Opzioni.DefPrefix2;
        try
          tbTelef.Append;
          tbTelefCodCon.Value:= Result;
          tbTelefTel_Pre1.Value:= Pre1;
          tbTelefTel_Pre2.Value:= Pre2;
          tbTelefTelefono.Value:= Num;
          tbTelefNote.Value:= Trim(iNotaTelef2.Text);
          tbTelef.Post;
        except
          tbTelef.Cancel;
        end;
      end;
      if Ind1 <> '' then begin
        SplitInd(Ind1, S);
        try
          tbIndir.Append;
          tbIndirCodCon.Value:= Result;
          tbIndirIndirizzo.Assign(S);
          tbIndirNote.Value:= Trim(iNotaIndir1.Text);
          tbIndir.Post;
        except
          tbIndir.Cancel;
        end;
      end;
      if Ind2 <> '' then begin
        SplitInd(Ind2, S);
        try
          tbIndir.Append;
          tbIndirCodCon.Value:= Result;
          tbIndirIndirizzo.Assign(S);
          tbIndirNote.Value:= Trim(iNotaIndir2.Text);
          tbIndir.Post;
        except
          tbIndir.Cancel;
        end;
      end;
    end;
  finally
    S.Free;
    tbContat.Active:= false;
    tbIndir.Active:= false;
    tbTelef.Active:= false;
  end;
end;

procedure TfmNewCont.btOkClick(Sender: TObject);
begin
  ActiveControl:= nil;
  if PostData>0 then ModalResult:= mrOk;
end;

procedure TfmNewCont.btEditClick(Sender: TObject);
var
  CodCon: longint;
begin
  ActiveControl:= nil;
  CodCon:= PostData;
  if CodCon > 0 then begin
    ShowContatto(CodCon);
    dmContatti.Notify(Self, CC_SELECTCON, TObject(CodCon));
    ModalResult:= mrOk;
  end;
end;

procedure TfmNewCont.iNomeExit(Sender: TObject);
var
  Nome: string;
  NomeMain: string;
  NomePre: string;
  Flg: boolean;
begin
  if lowercase(iNome.Text) = lowercase(DefNam) then Nome:= ''
  else Nome:= Trim(iNome.Text);
  Flg:= SplitName(Nome, NomeMain, NomePre);
  if Flg then begin
    if (NomePre <> '') and (NomeMain<>'') then begin
      NomeMain:= NomeMain+', '+NomePre;
    end;
    iNome.Text:= NomeMain;
  end;
end;

procedure TfmNewCont.iTelef1Exit(Sender: TObject);
var
  Flg: boolean;
  tmp: string;
  PRe1, PRe2, Num: string;
  e: TEdit;
begin
  e:= Sender as TEdit;
  if lowercase(e.Text) = lowercase(DefTel) then tmp:= ''
  else tmp:= Trim(e.Text);
  flg:= SplitTel(tmp, pre1, pre2, num);
  if Flg then begin
    if Num <> '' then begin
      if Pre1 = '' then Pre1:= Opzioni.DefPrefix1;
      if Pre2 = '' then Pre2:= Opzioni.DefPrefix2;
      Num:= '+'+Pre1+' '+Pre2+' '+Num;
    end;
    e.Text:= Num;
  end;
end;

procedure TfmNewCont.iIndir2Exit(Sender: TObject);
var
  Flg: boolean;
  S: TStrings;
  tmp: string;
  e: TEdit;
  i: integer;
begin
  e:= Sender as TEdit;
  if lowercase(e.Text) = lowercase(DefInd) then tmp:= ''
  else tmp:= Trim(e.Text);
  S:= nil;
  try
    S:= TStringList.Create;
    flg:= SplitInd(tmp, S);
    tmp:= '';
    if flg then begin
      for i:= 0 to S.Count-1 do begin
        if tmp <> '' then tmp:= tmp + ' - ';
        tmp:= tmp + S.Strings[i];
      end;
    end;
    e.Text:= tmp;
  except
    S.Free;
  end;
end;

procedure TfmNewCont.FormShow(Sender: TObject);
begin
  iNotaNome.Text:= '';
  iNotaTelef1.Text:= '';
  iNotaTelef2.Text:= '';
  iNotaIndir1.Text:= '';
  iNotaIndir2.Text:= '';
  iNome.Text:= DefNam;
  iTelef1.Text:= DefTel;
  iTelef2.Text:= DefTel;
  iIndir1.Text:= DefInd;
  iIndir2.Text:= DefInd;
end;

function NewContatto: TModalResult;
var
  fmNewCont: TfmNewCont;
begin
  fmNewCont:= nil;
  try
    fmNewCont:= TfmNewCont.Create(nil);
    Result:= fmNewCont.ShowModal;
  finally
    fmNewCont.Free;
  end;
end;

end.

