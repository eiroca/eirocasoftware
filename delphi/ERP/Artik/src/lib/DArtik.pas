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
unit DArtik;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, eDB;

const
  LEN_CODALF   =  3;
  LEN_PREDESC  = 10;
  LEN_SETMERC  = 13;
  LEN_DESCRIZ  = 30;

type
  EArticoli = class(exception)
    public
     CodAlf: string;
     CodNum: integer;
    public
     constructor Create(const aCodAlf: string; const aCodNum: integer);
  end;

type
  (* Definizione settori merceologici *)
  ESettoriMerc = class(exception)
    public
     CodAlf: string;
    public
    constructor Create(const aCodAlf: string);
  end;

  TSettoreEnumProc = procedure (CodAlf: string) of object;

  TSettoreMerc = class
    private
     FCodAlf: string[LEN_CODALF ];
     FSetMer: string[LEN_SETMERC];
     FPreDes: string[LEN_PREDESC];
     FRicMin: double;
     FRicMax: double;
     FChanged: boolean;
     function  GetDesc: string;
     function  GetCodAlf: string;
     function  GetSetMer: string;
     function  GetPreDes: string;
     procedure SetCodAlf(vl: string);
     procedure SetSetMer(const vl: string);
     procedure SetPreDes(const vl: string);
     procedure SetRicMin(vl: double);
     procedure SetRicMax(vl: double);
    public
     function IsLeaf: boolean;
     property CodAlf: string   read GetCodAlf write SetCodAlf;
     property SetMer: string   read GetSetMer write SetSetMer;
     property PreDes: string   read GetPreDes write SetPreDes;
     property RicMin: double   read FRicMin   write SetRicMin;
     property RicMax: double   read FRicMax   write SetRicMax;
     property Desc  : string   read GetDesc;
     property Changed: boolean read FChanged;
    public
     constructor Create;
     destructor  Destroy; override;
  end;

  ISettoriMerc = class
    protected
     class function  Seek(const aCodAlf: string): boolean;
    public
     class function  CountArtic(const aCodAlf: string): longint;
     class function  Valid(const aCodAlf: string): boolean;
     class function  Get(const aCodAlf: string): TSettoreMerc;
     class procedure Load(const aCodAlf: string; SM: TSettoreMerc);
     class procedure Save(SM: TSettoreMerc);
     class function  Desc(const aCodAlf: string): string;
     class function  Simile(const CodAlf1, CodAlf2: string): integer;
     class procedure Delete(const aCodAlf: string);
     class function  Usati(const aCodAlf: string): string;
     class procedure Crea(const aCodAlf: string);
     class procedure EnumSettori(CallBk: TSettoreEnumProc);
  end;

  IArticoli = class
  end;

  TdmArticoli = class(TDataModule)
    DBConnect: TDBConnectionLink;
    tbSettori: TTable;
    tbSettoriCodAlf: TStringField;
    tbSettoriSetMer: TStringField;
    tbSettoriPreDes: TStringField;
    tbSettoriRicMin: TFloatField;
    tbSettoriRicMax: TFloatField;
    qryCountArticoli: TQuery;
    qryCountArticoliResult: TFloatField;
    tbSettoriLst: TTable;
    tbSettoriLstCodAlf: TStringField;
    tbArticoli: TTable;
    tbArticoliCodAlf: TStringField;
    tbArticoliCodNum: TSmallintField;
    tbArticoliDesc: TStringField;
    tbArticoliAttv: TBooleanField;
    tbArticoliCodIVA: TSmallintField;
    tbArticoliCodMis: TSmallintField;
    tbArticoliQta: TFloatField;
    tbArticoliQtaInv: TFloatField;
    tbArticoliQtaDelta: TFloatField;
    tbArticoliQtaAcq: TFloatField;
    tbArticoliQtaOrd: TFloatField;
    tbArticoliQtaVen: TFloatField;
    tbArticoliQtaPre: TFloatField;
    tbArticoliQtaSco: TFloatField;
    tbArticoliPrzLis: TCurrencyField;
    tbArticoliPrzNor: TCurrencyField;
    tbArticoliPrzSpe: TCurrencyField;
    tbArticoliRicNor: TSmallintField;
    tbArticoliRicSpe: TSmallintField;
    tbArticoliPrePriAcq: TCurrencyField;
    tbArticoliPreUltAcq: TCurrencyField;
    tbArticoliDatPriAcq: TDateField;
    tbArticoliDatUltAcq: TDateField;
    tbArticoliCumuloAcq: TFloatField;
    tbArticoliCumuloOrd: TFloatField;
    DB: TeDataBase;
    procedure DBConnectConnect(Sender: TeDataBase; Connect: Boolean);
    procedure dmArticoliCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetCodIVA(CodAlf: string; CodNum: integer): integer;
  end;

var
  dmArticoli: TdmArticoli;

implementation

{$R *.DFM}

uses
  Costanti, UOpzioni, eLibDB, eLibCore;

constructor EArticoli.Create(const aCodAlf: string; const aCodNum: integer);
begin
  CodAlf:= aCodAlf;
  CodNum:= aCodNum;
  inherited CreateFmt('[%s,%d] not found', [aCodAlf, aCodNum]);
end;

constructor ESettoriMerc.Create(const aCodAlf: string);
begin
  CodAlf:= aCodAlf;
  inherited CreateFmt('CodAlf %s not found', [aCodAlf]);
end;

constructor TSettoreMerc.Create;
begin
  FCodAlf:= '';
  FPreDes:= '';
  FSetMer:= '';
  FRicMin:= 0;
  FRicMax:= 0;
  FChanged:= false;
end;

function TSettoreMerc.IsLeaf: boolean;
begin
  Result:= length(CodAlf)=LEN_CODALF;
end;

destructor  TSettoreMerc.Destroy;
begin
  inherited Destroy;
end;

function  TSettoreMerc.GetDesc: string;
begin
  Result:= ISettoriMerc.Desc(CodAlf);
end;

function  TSettoreMerc.GetCodAlf: string;
begin
  Result:= FCodAlf;
end;

function  TSettoreMerc.GetSetMer: string;
begin
  Result:= FSetMer;
end;

function  TSettoreMerc.GetPreDes: string;
begin
  Result:= FPreDes;
end;

procedure TSettoreMerc.SetCodAlf(vl: string);
begin
  if vl <> FCodAlf then begin
    FCodAlf:= vl;
    FChanged:= true;
  end;
end;

procedure TSettoreMerc.SetSetMer(const vl: string);
begin
  if vl <> FSetMer then begin
    FSetMer:= vl;
    FChanged:= true;
  end;
end;

procedure TSettoreMerc.SetPreDes(const vl: string);
begin
  if vl <> FPreDes then begin
    FPreDes:= vl;
    FChanged:= true;
  end;
end;

procedure TSettoreMerc.SetRicMin(vl: double);
begin
  if vl <> FRicMin then begin
    FRicMin:= vl;
    FChanged:= true;
  end;
end;

procedure TSettoreMerc.SetRicMax(vl: double);
begin
  if vl <> FRicMax then begin
    FRicMax:= vl;
    FChanged:= true;
  end;
end;

class function  ISettoriMerc.CountArtic(const aCodAlf: string): longint;
begin
  with dmArticoli do begin
    qryCountArticoli.ParamByName('CodAlf').AsString:= aCodAlf+'%';
    qryCountArticoli.Open;
    Result:= trunc(qryCountArticoliResult.Value);
    qryCountArticoli.Close;
  end;
end;

class function  ISettoriMerc.Seek(const aCodAlf: string): boolean;
begin
  Result:= dmArticoli.tbSettori.FindKey([aCodAlf]);
end;

class function  ISettoriMerc.Valid(const aCodAlf: string): boolean;
begin
  Result:= Seek(aCodAlf);
end;

class function  ISettoriMerc.Get(const aCodAlf: string): TSettoreMerc;
begin
  if Valid(aCodAlf) then begin
    Result:= TSettoreMerc.Create;
    Load(aCodAlf, Result);
  end
  else Result:= nil;
end;

class procedure ISettoriMerc.Load(const aCodAlf: string; SM: TSettoreMerc);
begin
  with dmArticoli do begin
    if Seek(aCodAlf) then begin
      with SM do begin
        CodAlf:= tbSettoriCodAlf.Value;
        SetMer:= tbSettoriSetMer.Value;
        PreDes:= tbSettoriPreDes.Value;
        RicMin:= tbSettoriRicMin.Value;
        RicMax:= tbSettoriRicMax.Value;
        FChanged:= false;
      end;
    end
    else raise ESettoriMerc.CreateFmt('CodAlf %s not found', [aCodAlf]);
  end;
end;

class procedure ISettoriMerc.Save(SM: TSettoreMerc);
begin
  with dmArticoli do begin
    if SM.Changed then begin
      with SM do begin
        if Seek(CodAlf) then tbSettori.Edit
        else begin
          tbSettori.Append;
          tbSettoriCodAlf.Value:= CodAlf;
        end;
        tbSettoriSetMer.Value:= SetMer;
        tbSettoriPreDes.Value:= PreDes;
        tbSettoriRicMin.Value:= RicMin;
        tbSettoriRicMax.Value:= RicMax;
        tbSettori.Post;
        FChanged:= false;
      end;
    end;
  end;
end;

class function  ISettoriMerc.Desc(const aCodAlf: string): string;
var
  i: integer;
begin
  with dmArticoli do begin
    Result:= '';
    for i:= 1 to length(aCodAlf) do begin
      if not Seek(Copy(aCodAlf, 1, i)) then exit;
      if Result <> '' then Result:= Result+' - ';
      Result:= Result+tbSettoriSetMer.Value;
    end;
  end;
end;

class function  ISettoriMerc.Simile(const CodAlf1, CodAlf2: string): integer;
begin
  Result:= 0;
  while (Result<length(CodAlf1)) and (Result < length(CodAlf2)) and (CodAlf1[Result+1] = CodAlf2[Result+1]) do begin
    inc(Result);
  end;
end;

class procedure ISettoriMerc.Delete(const aCodAlf: string);
var
  Len: integer;
  tmp: string;
begin
  with dmArticoli do begin
    Len:= length(aCodAlf);
    if Len=3 then begin
      if Seek(aCodAlf) then tbSettori.Delete;
    end
    else begin
      tbSettori.First;
      while not tbSettori.EOF do begin
        tmp:= tbSettoriCodAlf.Value;
        if (length(tmp)>=Len) and (Copy(tmp, 1, Len) = aCodAlf) then begin
          tbSettori.Delete;
        end
        else begin
          tbSettori.Next;
        end;
      end;
    end;
  end;
end;

class function  ISettoriMerc.Usati(const aCodAlf: string): string;
var
  Len: integer;
  tmp: string;
  ch: char;
begin
  with dmArticoli do begin
    Result:= '';
    Len:= length(aCodAlf);
    tbSettori.First;
    while not tbSettori.EOF do begin
      tmp:= tbSettoriCodAlf.Value;
      if (length(tmp)>Len) and ((Len=0) or (Copy(tmp, 1, Len) = aCodAlf)) then begin
        ch:= tmp[Len+1];
        if Pos(ch, Result) = 0 then Result:= Result + ch;
      end;
      tbSettori.Next;
    end;
  end;
end;

class procedure ISettoriMerc.Crea(const aCodAlf: string);
begin
  with dmArticoli do begin
    tbSettori.Append;
    tbSettoriCodAlf.Value:= aCodAlf;
    tbSettoriSetMer.Value:= 'Settore ' + aCodAlf;
    tbSettori.Post;
  end;
end;

class procedure ISettoriMerc.EnumSettori(CallBk: TSettoreEnumProc);
begin
  with dmArticoli do begin
    tbSettoriLst.First;
    while not tbSettoriLst.EOF do begin
      CallBk(tbSettoriLstCodAlf.Value);
      tbSettoriLst.Next;
    end;
  end;
end;

procedure TdmArticoli.DBConnectConnect(Sender: TeDataBase; Connect: Boolean);
begin
  tbSettori.Active:= Connect;
  tbSettoriLst.Active:= Connect;
  tbArticoli.Active:= Connect;
end;

procedure TdmArticoli.dmArticoliCreate(Sender: TObject);
begin
  Session.AddPassword('Lupin3');
  DBConnect.DataBase:= DB;
  DBConnect.Active:= true;
end;

function TdmArticoli.GetCodIVA(CodAlf: string; CodNum: integer): integer;
begin
  if not tbArticoli.FindKey([CodAlf, CodNum]) then raise EArticoli.Create(CodAlf, CodNum);
  Result:= tbArticoliCodIVA.Value;
end;

end.
