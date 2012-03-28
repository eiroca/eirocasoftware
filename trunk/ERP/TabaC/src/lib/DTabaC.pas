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
(* TabaC - Gestione Tabacchi
 * Ultima modifica: 06 nov 1999
 *)
unit DTabaC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  eLibMath, eLibCore,
  DBTables, Db, eDB, eReport;

const
  MaxTipi = 1000;

type
  TInfoKind  = (dtPrez, dtGiac, dtCari, dtOrdi, dtPatO, dtPatC);
  TIndexMode = (imCodI, imCodS, imDesc);
  TPredMode  = (pmBest, pmShort, pmMed, pmLong);
  TDateSet  = set of TInfoKind;
  TCurrency = longint;

  TTabaList = class
   private
     FOwnData: boolean;
     FData: TList;
     FCodI: TList;
     function  GetCount: integer;
     function  GetTaba(CodI: longint): TObject;
     procedure SetTaba(CodI: longint; Data: TObject);
   public
     constructor Create(OwnData: boolean);
     destructor  Destroy; override;
     function    GetObjects(i: integer; var CodI: longint; var Obj: TObject): boolean;
     function    IndexOf(CodI: longint): integer;
     procedure   Delete(CodI: integer);
     procedure   Pack;
     property    Count: integer
       read  GetCount;
     property    Taba[CodI: longint]: TObject
       read  GetTaba
       write SetTaba;
  end;

  TDate = class(TObject)
    private
     FDate: TDateTime;
    public
     property Data: TDateTime read FDate write FDate;
     constructor Create(AData: TDateTime);
  end;

  TGiacSearchRec = class
    protected
     FData    : TDateTime;
     FDataPrez: TDateTime;
     FExact   : boolean;
     FPGia    : longint;
    public
     constructor Create;
     property Data: TDateTime
       read FData;
     property DataPrezzi: TDateTime
       read FDataPrez;
     property Exact: boolean
       read FExact;
  end;

  TTablSearchRec = class
    protected
     FDataI: TDateTime;
     FDataF: TDateTime;
     FCod  : TList;
     function GetCount: integer;
     function GetCod(i: integer): longint;
    public
     constructor Create;
     destructor  Destroy; override;
     property DataI: TDateTime
       read FDataI;
     property DataF: TDateTime
       read FDataF;
     property Cod[i: integer]: longint
       read GetCod;
     property Count: integer
       read GetCount;
  end;

  TOrdiSearchRec = class(TTablSearchRec);
  TCariSearchRec = class(TTablSearchRec);
  TPatCSearchRec = class(TTablSearchRec);
  TPatOSearchRec = class(TTablSearchRec);

  TVendSearchRec = class
    protected
     FDataI: TDateTime;
     FDataF: TDateTime;
     GISR: TGiacSearchRec;
     GFSR: TGiacSearchRec;
     Cari: TCariSearchRec;
     PatC: TPatCSearchRec;
    public
     constructor Create;
     destructor  Destroy; override;
     property DataI: TDateTime
       read FDataI;
     property DataF: TDateTime
       read FDataF;
  end;

type
  TdmTaba = class(TDataModule)
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaCODS: TStringField;
    tbTabaTIPO: TSmallintField;
    tbTabaPROD: TSmallintField;
    tbTabaCRIT: TSmallintField;
    tbTabaDESC: TStringField;
    tbTabaATTV: TBooleanField;
    tbTabaMULI: TSmallintField;
    tbTabaQTAS: TSmallintField;
    tbTabaQTAC: TSmallintField;
    tbTabaQTAM: TSmallintField;
    tbTabaDIFR: TSmallintField;
    tbDateGiac: TTable;
    tbDateGiacPGIA: TIntegerField;
    tbDateGiacDATA: TDateField;
    tbDatePrez: TTable;
    tbDatePrezPPRE: TIntegerField;
    tbDatePrezDATA: TDateField;
    tbDatePrezDESC: TStringField;
    tbPrez: TTable;
    tbPrezPPRE: TIntegerField;
    tbPrezCODI: TSmallintField;
    tbPrezPREZ: TCurrencyField;
    tbDateCari: TTable;
    tbDateCariPCAR: TIntegerField;
    tbDateCariDATA: TDateField;
    tbDateCariDATAORDI: TDateField;
    tbDatePatC: TTable;
    tbDatePatCPPCO: TIntegerField;
    tbDatePatCDATA: TDateField;
    tbDatePatCDATAORDI: TDateField;
    tbMedie: TTable;
    tbMedieCODI: TSmallintField;
    tbMedieMEDA: TFloatField;
    tbMedieMAXA: TFloatField;
    tbMedieMED5: TFloatField;
    tbMedieMAX5: TFloatField;
    tbMedieMED0: TFloatField;
    tbMedieMAX0: TFloatField;
    tbCariDate: TTable;
    tbCariDatePCAR: TIntegerField;
    tbCariDateDATA: TDateField;
    tbCariDateDATAORDI: TDateField;
    tbCariDateDATAPREZ: TDateField;
    tbCariDateKGC: TFloatField;
    tbCariDateVAL: TCurrencyField;
    tbCariMov: TTable;
    tbCariMovPCAR: TIntegerField;
    tbCariMovCODI: TSmallintField;
    tbCariMovCARI: TIntegerField;
    tbGiacDate: TTable;
    tbGiacDatePGIA: TIntegerField;
    tbGiacDateDATA: TDateField;
    tbGiacDateDATAPREZ: TDateField;
    tbGiacDateKGC: TFloatField;
    tbGiacDateVAL: TCurrencyField;
    tbGiacMov: TTable;
    tbGiacMovPGIA: TIntegerField;
    tbGiacMovCODI: TSmallintField;
    tbGiacMovGIAC: TIntegerField;
    tbOrdiDate: TTable;
    tbOrdiDatePCAR: TIntegerField;
    tbOrdiDateDATA: TDateField;
    tbOrdiDateDATAORDI: TDateField;
    tbOrdiDateDATAPREZ: TDateField;
    tbOrdiDateKGC: TFloatField;
    tbOrdiDateVAL: TCurrencyField;
    tbOrdiMov: TTable;
    tbOrdiMovPCAR: TIntegerField;
    tbOrdiMovCODI: TSmallintField;
    tbOrdiMovCARI: TIntegerField;
    tbPatOMov: TTable;
    tbPatOMovPPCO: TIntegerField;
    tbPatOMovCODI: TSmallintField;
    tbPatOMovCONS: TIntegerField;
    tbPatODate: TTable;
    tbPatODatePPCO: TIntegerField;
    tbPatODateCODP: TIntegerField;
    tbPatODateDATA: TDateField;
    tbPatODateDATAORDI: TDateField;
    tbPatODateDATAPREZ: TDateField;
    tbPatODateKGC: TFloatField;
    tbPatODateVAL: TCurrencyField;
    tbPatCMov: TTable;
    tbPatCMovPPCO: TIntegerField;
    tbPatCMovCODI: TSmallintField;
    tbPatCMovCONS: TIntegerField;
    tbPatCDate: TTable;
    tbPatCDatePPCO: TIntegerField;
    tbPatCDateCODP: TIntegerField;
    tbPatCDateDATA: TDateField;
    tbPatCDateDATAORDI: TDateField;
    tbPatCDateDATAPREZ: TDateField;
    tbPatCDateKGC: TFloatField;
    tbPatCDateVAL: TCurrencyField;
    tbTipo: TTable;
    tbTipoTIPO: TSmallintField;
    tbTipoDESC: TStringField;
    tbProd: TTable;
    tbProdPROD: TSmallintField;
    tbProdDESC: TStringField;
    tbCrit: TTable;
    tbCritCRIT: TSmallintField;
    tbCritDESC: TStringField;
    sdOutFile: TSaveDialog;
    DB: TeDataBase;
    function DBValidate(const Signature, Magic: String): Boolean;
    procedure DataModule1Create(Sender: TObject);
    procedure DataModule1Destroy(Sender: TObject);
  private
    { Private declarations }
    FNumTab: array [false..true] of integer;
    FData: TDateTime;
    Prezz: array[1..MaxTipi] of longint;
    Valid: array[1..MaxTipi] of boolean;
    function  GetPrezzo(i: integer): longint;
    procedure SetPrezzo(i: integer; vl: longint);
    procedure SetDataPrezzi(AData: TDateTime);
  public
    { Public declarations }
    DateList: array[TInfoKind] of TStringList;
    Index   : array[TIndexMode, false..true] of TIVector;

    property  Prezzo[CodI: integer]: TCurrency read GetPrezzo write SetPrezzo;
    property  DataPrezzi: TDateTime read FData write SetDataPrezzi;
    property  NumTab: integer read FNumTab[false];
    property  NumTabAttv: integer read FNumTab[true];
    procedure LoadDate(what: TDateSet);
    function  FindData(Kind: TInfoKind; dt: TDateTime): integer;
    procedure GetOrder(S: TStrings);
    function  DecodeOrder(Index: integer): string;
    function  EncodeOrder(const Index: string): integer;
    function  ValidCodI(aCodI: integer): boolean;
    procedure LoadPrezzi;
    procedure MakeIndex;
    procedure UpdateTaba;
    procedure UpdatePrezzi;

   protected
    procedure StimaMed(var Med, Max: double; MedA, MaxA, Med0, Max0, Med5, Max5: double);
    procedure SRSetup(SR: TTablSearchRec; DataI, DataF: TDateTime; tbData: TTable;
     fldCodice: TIntegerField; fldData: TDateField; TestNull: boolean; fldTestNull: TField);
    function  SRSumData(SR: TTablSearchRec; CodI: integer; tbMovs: TTable; fldDato: TIntegerField): longint;
    function  SRGetInfo(SR: TTablSearchRec; tbData: TTable; fldKGC: TFloatField; fldVal: TCurrencyField;
     var KgC, Val: double): integer;
   public
    function  FindGiacenza(Data: TDateTime; exact: boolean): TGiacSearchRec;
    function  GetGiacenza (Giac: TGiacSearchRec; CodI: integer): longint;
    function  InfoGiacenza(Giac: TGiacSearchRec; var PreKgC, PreVal, CurKgC, CurVal: double): TDateTime;
    function  InfoGiacenzaExt(Giac: TGiacSearchRec; var PreKgC, PreVal: double; var PreDataPrez: TDateTime; var CurKgC, CurVal: double; var CurDataPrez: TDateTime): TDateTime;

    function  FindCarichi (DataI, DataF: TDateTime): TCariSearchRec;
    function  InfoCarichi (Cari: TCariSearchRec; var KgC, Val: double): integer;
    function  GetCarichi  (Cari: TCariSearchRec; CodI: integer): longint;
    function  FindPatCons (DataI, DataF: TDateTime): TPatCSearchRec;
    function  InfoPatCons (PatC: TPatCSearchRec; var KgC, Val: double): integer;
    function  GetPatCons  (PatC: TPatCSearchRec; CodI: integer): longint;

    function  FindOrdini  (DataI, DataF: TDateTime; DaRice: boolean): TOrdiSearchRec;
    function  InfoOrdini  (Ordi: TOrdiSearchRec; var KgC, Val: double): integer;
    function  GetOrdinato (Ordi: TOrdiSearchRec; CodI: integer): longint;
    function  FindPatOrdi (DataI, DataF: TDateTime; DaCons: boolean): TPatOSearchRec;
    function  InfoPatOrdi (PatO: TPatOSearchRec; var KgC, Val: double): integer;
    function  GetPatOrdi  (PatO: TPatOSearchRec; CodI: integer): longint;

    function  FindVendite (DataI, DataF: TDateTime): TVendSearchRec;
    function  CalcVendite (Vend: TVendSearchRec; CodI: integer): longint;
    function  PrediciVend (CodI: integer; Peri: double; mode: TPredMode): double;
   public
    function  GetLastGiac: TDateTime;
    function  GetStatDate: TDateTime;

   public
    function GetDescProd(Prod: integer): string;
    function GetDescTipo(Tipo: integer): string;
    function GetDescCrit(Crit: integer): string;
   public
    procedure SetupReportDevice(Rep: TeLineReport; Dev: TOutputDevice);

  end;

var
  dmTaba: TdmTaba;

function  LastData(Dt: TStringList): string;

implementation

{$R *.DFM}

uses
  eLibDB, UOpzioni;

function LastData(Dt: TStringList): string;
var
  ps: integer;
begin
  ps:= dt.Count-1;
  if ps <> -1 then begin
    Result:= DateUtil.MyDateToStr(TDate(Dt.Objects[ps]).Data)
  end
  else Result:= '';
end;

constructor TDate.Create(AData: TDateTime);
begin
  Data:= AData;
end;

constructor TTabaList.Create(OwnData: boolean);
begin
  FOwnData:= OwnData;
  FData:= TList.Create;
  FCodI:= TList.Create;
end;

function TTabaList.GetCount: integer;
begin
  Result:= FCodI.Count;
end;

function TTabaList.GetTaba(CodI: longint): TObject;
var
  ps: integer;
begin
  ps:= FCodI.IndexOf(pointer(CodI));
  if ps <> -1 then Result:= FData[ps]
  else Result:= nil;
end;

procedure TTabaList.SetTaba(CodI: longint; Data: TObject);
var
  ps: integer;
begin
  ps:= FCodI.IndexOf(pointer(CodI));
  if ps <> -1 then FData[ps]:= Data
  else begin
    if FCodI.Add(pointer(CodI)) <>
      FData.Add(Data) then raise EInvalidOp.Create(ClassName+' insert error');
  end;
end;

function TTabaList.IndexOf(CodI: longint): integer;
begin
  Result:= FCodI.IndexOf(pointer(CodI));
end;

function TTabaList.GetObjects(i: integer; var CodI: longint; var Obj: TObject): boolean;
begin
  CodI:= longint(FCodI[i]);
  Obj := TObject(FData[i]);
  Result:= (CodI<>0);
  if not Result then Obj:= nil;
end;

procedure TTabaList.Delete(CodI: integer);
var
  ps: integer;
begin
  ps:= FCodI.IndexOf(pointer(CodI));
  if ps <> -1 then begin
    FData.Delete(ps);
    FCodI.Delete(ps);
  end;
end;

procedure TTabaList.Pack;
begin
  FData.Free;
  FCodI.Free;
end;

destructor  TTabaList.Destroy;
var
  i: integer;
begin
  if fOwnData then begin
    for i:= 0 to FData.Count-1 do TObject(FData[i]).Free;
  end;
  FData.Free;
  FCodI.Free;
end;

constructor TGiacSearchRec.Create;
begin
  FData    := NoDate;
  FDataPrez:= NoDate;
  FExact   := false;
  FPGia    := 0;
end;

constructor TVendSearchRec.Create;
begin
  FDataI:= NoDate;
  FDataF:= NoDate;
  GISR:= nil;
  GFSR:= nil;
  Cari:= nil;
  PatC:= nil;
end;

destructor TVendSearchRec.Destroy;
begin
  GISR.Free;
  GFSR.Free;
  Cari.Free;
  PatC.Free;
end;

constructor TTablSearchRec.Create;
begin
  FDataI:= NoDate;
  FDataF:= NoDate;
  FCod  := TList.Create;
end;

function TTablSearchRec.GetCount: integer;
begin
  Result:= FCod.Count;
end;

function TTablSearchRec.GetCod(i: integer): longint;
begin
  Result:= longint(FCod[i]);
end;

destructor  TTablSearchRec.Destroy;
begin
  FCod.Free;
  inherited Destroy;
end;

function TdmTaba.DBValidate(const Signature, Magic: String): Boolean;
begin
  Result:= Crypt.SimpleCrypt(Signature, Signature) = Magic;
end;

procedure TdmTaba.DataModule1Create(Sender: TObject);
var
  i: TInfoKind;
  j: TIndexMode;
  b: boolean;
begin
  Session.AddPassword('Jigen');
  if not ConnectDataBase(DB, Opzioni.BasePath+Opzioni.DefaultDB) then Application.Terminate
  else begin
    tbGiacDate.IndexFieldNames:= 'DATA';
    tbCariDate.IndexFieldNames:= 'DATA';
    tbPatCDate.IndexFieldNames:= 'DATA';
    tbOrdiDate.IndexFieldNames:= 'DATAORDI';
    tbPatODate.IndexFieldNames:= 'DATAORDI';
    tbGiacMov.IndexFieldNames:= 'PGIA;CODI';
    tbCariMov.IndexFieldNames:= 'PCAR;CODI';
    tbPatCMov.IndexFieldNames:= 'PPCO;CODI';
    tbOrdiMov.IndexFieldNames:= 'PCAR;CODI';
    tbPatOMov.IndexFieldNames:= 'PPCO;CODI';

    tbTaba.IndexName:= '';
    tbTaba.Open;
    for i:= low(TInfoKind) to high(TInfoKind) do begin
      DateList[i]:= TStringList.Create;
    end;
    for j:= low(TIndexMode) to high(TIndexMode) do begin
      for b:= false to true do begin
        Index[j, b]:= nil;
      end;
    end;
    LoadPrezzi;
    MakeIndex;
  end;
end;

procedure TdmTaba.DataModule1Destroy(Sender: TObject);
var
  i: TInfoKind;
  j: TIndexMode;
  b: boolean;
begin
  tbTaba.Close;
  for i:= low(TInfoKind) to high(TInfoKind) do begin
    DateList[i]:= TStringList.Create;
  end;
  for j:= low(TIndexMode) to high(TIndexMode) do begin
    for b:= false to true do begin
      Index[j, b]:= nil;
    end;
  end;
end;

function  TdmTaba.GetPrezzo(i: integer): longint;
begin
  if (i>0) and Valid[i] then Result:= Prezz[i]
  else Result:= 0;
end;

procedure TdmTaba.SetPrezzo(i: integer; vl: longint);
begin
 if (i>0) then begin
    Prezz[i]:= vl;
    if vl <> 0 then Valid[i]:= true
    else Valid[i]:= false;
 end;
end;

procedure TdmTaba.SetDataPrezzi(AData: TDateTime);
var
  i: integer;
  PPre: integer;
begin
  for i:= 1 to MaxTipi do begin
    Valid[i]:= false;
  end;
  FData:= int(AData);
  if FData = NoDate then exit;
  tbDatePrez.IndexName:= 'IdxData';
  tbDatePrez.Open;
  if tbDatePrez.FindKey([AData]) then begin
    PPre:= tbDatePrezPPre.Value;
    tbPrez.Open;
    while not tbPrez.EOF do begin
      if tbPrezPPre.Value = PPre then begin
        Prezzo[tbPrezCodI.Value]:= round(tbPrezPrez.Value);
      end;
      tbPrez.Next;
    end;
    tbPrez.Close;
  end;
  tbDatePrez.Close;
end;

procedure TdmTaba.LoadDate(what: TDateSet);
  procedure LoadIt(tb: TTable; str: TStringList; const Index, fldData, fldDesc: string);
    procedure Azzera;
    var
      i: integer;
      O: TObject;
    begin
      for i:= 0 to str.Count-1 do begin
        O:= Str.Objects[i];
        O.Free;
      end;
      Str.Clear;
    end;
    var
      tmp: string;
      F: TField;
  begin
    with tb, str do begin
      IndexName:= Index;
      Open;
      First;
      Azzera;
      tmp:= '';
      while not EOF do begin
        if fldDesc <> '' then tmp:= FieldByName(fldDESC).AsString;
        F:=FieldByName(fldDATA);
        if not F.IsNull then begin
          AddObject(tmp, TDate.Create(FieldByName(fldDATA).AsDateTime));
        end;
        Next;
      end;
      Close;
    end;
  end;
begin
  if dtPrez in What then LoadIt(tbDatePrez, DateList[dtPrez], 'IdxDATA', 'DATA', 'DESC');
  if dtGiac in What then LoadIt(tbDateGiac, DateList[dtGiac], 'IdxDATA', 'DATA', '');
  if dtCari in What then LoadIt(tbDateCari, DateList[dtCari], 'IdxDATA', 'DATA', '');
  if dtOrdi in What then LoadIt(tbDateCari, DateList[dtOrdi], 'IdxDATAORDI', 'DATA', '');
  if dtPatC in What then LoadIt(tbDatePatC, DateList[dtPatC], 'IdxDATA', 'DATA', '');
  if dtPatO in What then LoadIt(tbDatePatC, DateList[dtPatO], 'IdxDATAORDI', 'DATA', '');
end;

function TdmTaba.FindData(Kind: TInfoKind; dt: TDateTime): integer;
var
  i: integer;
begin
  Result:= -1;
  dt:= int(dt);
  for i:= 0 to DateList[Kind].Count-1 do begin
    if int(TDate(DateList[Kind].Objects[i]).Data) = dt then begin
      Result:= i;
      break;
    end;
  end;
end;

procedure TdmTaba.LoadPrezzi;
var
  Pos: integer;
begin
  LoadDate([dtPrez,dtGiac,dtCari,dtOrdi, dtPatC, dtPatO]);
  Pos:= DateList[dtPrez].Count-1;
  if Pos > 0 then DataPrezzi:= TDate(DateList[dtPrez].Objects[Pos]).Data
  else DataPrezzi:= NoDate;
  SetDataPrezzi(DataPrezzi);
end;

procedure TdmTaba.GetOrder(S: TStrings);
begin
  S.BeginUpdate;
  S.Clear;
  S.Add('descrizione');
  S.Add('codice sigaretta');
  S.Add('codice interno');
  S.EndUpdate;
end;

function TdmTaba.DecodeOrder(Index: integer): string;
begin
  case Index of
    1: Result:=  'IdxCodS';
    2: Result:=  '';
    else Result:= 'IdxDesc';
  end;
end;

function TdmTaba.EncodeOrder(const Index: string): integer;
begin
  Result:= -1;
  if Index = '' then Result:= 2
  else if lowercase(Index) = 'idxcods' then Result:= 1
  else if lowercase(Index) = 'idxdesc' then Result:= 0;
end;

function TdmTaba.ValidCodI(aCodI: integer): boolean;
begin
  tbTaba.IndexName:= '';
  Result:= tbTaba.FindKey([aCodI]);
end;

procedure TdmTaba.MakeIndex;
  procedure ReadIndex(const aIndex: string; Attv, Full: TIVector);
  var
    i, N: integer;
  begin
    tbTaba.IndexName:= aIndex;
    tbTaba.First;
    N:= 0;
    i:= 0;
    while not tbTaba.EOF do begin
      inc(i);
      Full[i]:= tbTabaCodI.Value;
      if tbTabaAttv.Value then begin
        inc(n);
        Attv[n]:= tbTabaCodI.Value;
      end;
      tbTaba.Next;
    end;
    FNumTab[false]:= i;
    FNumTab[true] := N;
    for i:= FNumTab[false]+1 to FNumTab[true] do Attv[n]:= 0;
  end;
var
  Siz: integer;
  j: TIndexMode;
  b: boolean;
begin
  Siz:= tbTaba.RecordCount;
  for j:= low(TIndexMode) to high(TIndexMode) do begin
    for b:= false to true do begin
      Index[j, b]:= TIVector.Create(nil);
      Index[j, b].Setup(1, Siz);
    end;
  end;
  ReadIndex('IdxDesc', Index[imDesc, true], Index[imDesc, false]);
  ReadIndex('IdxCodS', Index[imCodS, true], Index[imCodS, false]);
  ReadIndex('',        Index[imCodI, true], Index[imCodI, false]);
end;

procedure TdmTaba.UpdateTaba;
begin
  tbTaba.Active:= true;
  tbTaba.Refresh;
  MakeIndex;
  SetDataPrezzi(DataPrezzi);
end;

procedure TdmTaba.UpdatePrezzi;
begin
  LoadPrezzi;
end;

procedure TdmTaba.StimaMed(var Med, Max: double; MedA, MaxA, Med0, Max0, Med5, Max5: double);
begin
  Med:= -1;
  Max:= -1;
  if (MedA > Med0) and (Med0 > Med5) then Med:= 0.40 * MedA + 0.35 * Med0 + 0.30 * Med5;
  if (MedA > Med0) and (Med0 = Med5) then Med:= 0.40 * MedA + 0.70 * Med0;
  if (MedA > Med0) and (Med0 < Med5) then begin
    Med:= 0.40 * MedA + 0.70 * Med5;
    if (MedA < Med5) then Med:= Med + 0.20 * Med5;
  end;
  if (MedA = Med0) and (Med0 > Med5) then Med:= 0.90 * MedA + 0.20 * Med5;
  if (MedA = Med0) and (Med0 = Med5) then Med:= 1.05 * MedA;
  if (MedA = Med0) and (Med0 < Med5) then Med:= 0.25 * MedA + 0.85 * Med5;
  if (MedA < Med0) and (Med0 > Med5) then begin
    Med:= 0.30 * MedA + 0.45 * Med0 + 0.35 * Med5;
    if MedA < Med5 then Med:= Med + 0.10 * Med5;
  end;
  if (MedA < Med0) and (Med0 = Med5) then Med:= 0.20 * MedA + 0.90 * Med0;
  if (MedA < Med0) and (Med0 < Med5) then Med:= 0.15 * MedA + 0.25 * Med0 + 0.75 * Med5;

  if (MaxA > Max0) and (Max0 > Max5) then Max:= 0.40 * MaxA + 0.35 * Max0 + 0.30 * Max5;
  if (MaxA > Max0) and (Max0 = Max5) then Max:= 0.40 * MaxA + 0.70 * Max0;
  if (MaxA > Max0) and (Max0 < Max5) then begin
    Max:= 0.40 * MaxA + 0.70 * Max5;
    if MaxA < Max5 then Max:= Max + 0.20 * Max5;
  end;
  if (MaxA = Max0) and (Max0 > Max5) then Max:= 0.90 * MaxA + 0.20 * Max5;
  if (MaxA = Max0) and (Max0 = Max5) then Max:= 1.05 * MaxA;
  if (MaxA = Max0) and (Max0 < Max5) then Max:= 0.25 * MaxA + 0.85 * Max5;
  if (MaxA < Max0) and (Max0 > Max5) then begin
    Max:= 0.30 * MaxA + 0.45 * Max0 + 0.35 * Max5;
    if MaxA < Max5 then Max:= Max + 0.10 * Max5;
  end;
  if (MaxA < Max0) and (Max0 = Max5) then Max:= 0.20 * MaxA + 0.90 * Max0;
  if (MaxA < Max0) and (Max0 < Max5) then Max:= 0.15 * MaxA + 0.25 * Max0 + 0.75 * Max5;
  if (Max<0) or (Med<0) then raise EInvalidOperation.CreateFmt('Errere interno media %f, max %f', [Med, Max]);
end;

function TdmTaba.PrediciVend(CodI: integer; Peri: double; mode: TPredMode): double;
var
  Med, Max: double;
begin
  tbMedie.Active:= true;
  Med:= 0;
  Max:= 0;
  if Peri < 1 then Peri:= 1;
  if tbMedie.FindKey([CodI]) then begin
    case mode of
      pmBest: StimaMed(Med, Max, tbMedieMedA.Value, tbMedieMaxA.Value, tbMedieMed0.Value, tbMedieMax0.Value, tbMedieMed5.Value, tbMedieMax5.Value);
      pmLong: begin Med:= tbMedieMedA.Value; Max:= tbMedieMaxA.Value; end;
      pmMed : begin Med:= tbMedieMed0.Value; Max:= tbMedieMax0.Value; end;
      else    begin Med:= tbMedieMed5.Value; Max:= tbMedieMax5.Value; end;
    end;
  end;
  Result:= (Peri-1)*Med+Max;
end;

function TdmTaba.GetStatDate: TDateTime;
var
  hd: THandle;
begin
  try
    hd:= FileOpen(DB.DBPath+'\tabastat.DB', fmOpenRead + fmShareDenyNone);
    Result:= FileDateToDateTime(FileGetDate(hd));
    FileClose(hd);
  except
    Result:= Date;
  end;
end;

function TdmTaba.GetLastGiac: TDateTime;
begin
  tbDateGiac.IndexFieldNames:= 'DATA';
  tbDateGiac.Open;
  tbDateGiac.Last;
  Result:= NoDate;
  if tbDateGiac.EOF then Result:= tbDateGiac.FieldByName('DATA').AsDateTime;
  tbDateGiac.Close;
end;

procedure TdmTaba.SRSetup(SR: TTablSearchRec; DataI, DataF: TDateTime; tbData: TTable;
     fldCodice: TIntegerField; fldData: TDateField; TestNull: boolean; fldTestNull: TField);
var
  Flg: boolean;
begin
  tbData.Active:= true;
  if DataI<>NoDate then tbData.FindNearest([DataI])
  else tbData.First;
  flg:= true;
  while (not tbData.EOF) and ((DataF=NoDate) or (fldData.Value<=DataF)) do begin
    if (not fldData.IsNull) and ((fldTestNull = nil) or (fldTestNull.IsNull = TestNull)) then begin
      if (DataI=NoDate) or (fldData.Value>=DataI) then begin
        SR.FCod.Add(pointer(fldCodice.Value));
        SR.FDataF:= fldData.Value;
        if flg then begin
          SR.FDataI:= fldData.Value;
          flg:= false;
        end;
      end;
    end;
    tbData.Next;
  end;
end;

function TdmTaba.SRSumData(SR: TTablSearchRec; CodI: integer; tbMovs: TTable; fldDato: TIntegerField): longint;
var
  i: integer;
begin
  Result:= 0;
  tbMovs.Active:= true;
  if (SR<>nil) and (SR.FCod.Count>0) then begin
    with SR do begin
      for i:= 0 to FCod.Count-1 do begin
        if tbMovs.FindKey([longint(FCod[i]), CodI]) then begin
          Result:= Result + fldDato.Value;
        end;
      end;
    end;
  end;
end;

function TdmTaba.SRGetInfo(SR: TTablSearchRec; tbData: TTable; fldKGC: TFloatField; fldVal: TCurrencyField;
 var KgC, Val: double): integer;
var
  i: integer;
  OldIndex: string;
begin
  Result:= 0;
  KgC:= 0;
  Val:= 0;
  OldIndex:= tbData.IndexFieldNames;
  tbData.IndexName:= '';
  tbData.Active:= true;
  if (SR<>nil) and (SR.FCod.Count>0) then begin
    with SR do begin
      for i:= 0 to FCod.Count-1 do begin
        if tbData.FindKey([longint(FCod[i])]) then begin
          inc(Result);
          KgC:= KgC + fldKgC.Value;
          Val:= Val + fldVal.Value;
        end;
      end;
    end;
  end;
  tbData.IndexFieldNames:= OldIndex;
end;

function  TdmTaba.FindGiacenza(Data: TDateTime; exact: boolean): TGiacSearchRec;
begin
  Result:= TGiacSearchRec.Create;
  tbGiacDate.Active:= true;
  if Data<>NoDate then tbGiacDate.FindNearest([Data])
  else tbGiacDate.Last;
  if not tbGiacDateData.IsNull then begin
    Result.FData:= tbGiacDateData.Value;
    Result.FPGia:= tbGiacDatePGia.Value;
    Result.FDataPrez:= tbGiacDateDATAPREZ.Value;
  end;
  if Result.FDataPrez = NoDate then begin
    Result.FDataPrez:= DataPrezzi;
  end;
  Result.FExact:= Result.FData = Data;
end;

function  TdmTaba.GetGiacenza(Giac: TGiacSearchRec; CodI: integer): longint;
begin
  Result:= 0;
  tbGiacMov.Active:= true;
  if (Giac<>nil) and (Giac.FPGia<>0) then begin
    if tbGiacMov.FindKey([Giac.FPGia, CodI]) then begin
      Result:= tbGiacMovGiac.Value;
    end;
  end;
end;

function  TdmTaba.InfoGiacenza (Giac: TGiacSearchRec; var PreKgC, PreVal, CurKgC, CurVal: double): TDateTime;
begin
  PreKgC:= 0;
  CurKgC:= 0;
  PreVal:= 0;
  CurVal:= 0;
  Result:= NoDate;
  tbGiacDate.Active:= true;
  if (Giac<>nil) and (Giac.Data<>NoDate) then begin
    if tbGiacDate.FindKey([Giac.Data]) then begin
      CurKgC:= tbGiacDateKGC.Value;
      CurVal:= tbGiacDateVal.Value;
      if not tbGiacDate.BOF then begin
        tbGiacDate.Prior;
        PreKgC:= tbGiacDateKGC.Value;
        PreVal:= tbGiacDateVal.Value;
        Result:= tbGiacDateData.Value;
      end;
    end;
  end;
end;

function  TdmTaba.InfoGiacenzaExt(Giac: TGiacSearchRec; var PreKgC, PreVal: double; var PreDataPrez: TDateTime; var CurKgC, CurVal: double; var CurDataPrez: TDateTime): TDateTime;
begin
  PreKgC:= 0;
  PreVal:= 0;
  PreDataPrez:= NoDate;
  CurKgC:= 0;
  CurVal:= 0;
  CurDataPrez:= NoDate;
  Result:= NoDate;
  tbGiacDate.Active:= true;
  if (Giac<>nil) and (Giac.Data<>NoDate) then begin
    if tbGiacDate.FindKey([Giac.Data]) then begin
      CurKgC:= tbGiacDateKGC.Value;
      CurVal:= tbGiacDateVal.Value;
      CurDataPrez:= tbGiacDateDataPrez.Value;
      if not tbGiacDate.BOF then begin
        tbGiacDate.Prior;
        PreKgC:= tbGiacDateKGC.Value;
        PreVal:= tbGiacDateVal.Value;
        PreDataPrez:= tbGiacDateDataPrez.Value;
        Result:= tbGiacDateData.Value;
      end;
    end;
  end;
end;

function  TdmTaba.FindCarichi(DataI, DataF: TDateTime): TCariSearchRec;
begin
  Result:= TCariSearchRec.Create;
  SRSetup(Result, DataI, DataF, tbCariDate, tbCariDatePCar, tbCariDateData, false, nil);
end;

function  TdmTaba.InfoCarichi(Cari: TCariSearchRec; var KgC, Val: double): integer;
begin
  Result:= SRGetInfo(Cari, tbCariDate, tbCariDateKGC, tbCariDateVal, KgC, Val);
end;

function  TdmTaba.GetCarichi(Cari: TCariSearchRec; CodI: integer): longint;
begin
  Result:= SRSumData(Cari, CodI, tbCariMov, tbCariMovCari);
end;

function  TdmTaba.FindPatCons(DataI, DataF: TDateTime): TPatCSearchRec;
begin
  Result:= TPatCSearchRec.Create;
  SRSetup(Result, DataI, DataF, tbPatCDate, tbPatCDatePPCo, tbPatCDateData, false, nil);
end;

function  TdmTaba.InfoPatCons(PatC: TPatCSearchRec; var KgC, Val: double): integer;
begin
  Result:= SRGetInfo(PatC, tbPatCDate, tbPatCDateKGC, tbPatCDateVal, KgC, Val);
end;

function  TdmTaba.GetPatCons (PatC: TPatCSearchRec; CodI: integer): longint;
begin
  Result:= SRSumData(PatC, CodI, tbPatCMov, tbPatCMovCons);
end;

function  TdmTaba.FindOrdini(DataI, DataF: TDateTime; DaRice: boolean): TOrdiSearchRec;
begin
  Result:= TOrdiSearchRec.Create;
  SRSetup(Result, DataI, DataF, tbOrdiDate, tbOrdiDatePCar, tbOrdiDateDataOrdi, DaRice, tbOrdiDateData);
end;

function  TdmTaba.InfoOrdini(Ordi: TOrdiSearchRec; var KgC, Val: double): integer;
begin
  Result:= SRGetInfo(Ordi, tbOrdiDate, tbOrdiDateKGC, tbOrdiDateVal, KgC, Val);
end;

function  TdmTaba.GetOrdinato(Ordi: TOrdiSearchRec; CodI: integer): longint;
begin
  Result:= SRSumData(Ordi, CodI, tbOrdiMov, tbOrdiMovCari);
end;

function  TdmTaba.FindPatOrdi(DataI, DataF: TDateTime; DaCons: boolean): TPatOSearchRec;
begin
  Result:= TPatOSearchRec.Create;
  SRSetup(Result, DataI, DataF, tbPatODate, tbPatODatePPCo, tbPatODateDataOrdi, DaCons, tbPatODateData);
end;

function  TdmTaba.InfoPatOrdi(PatO: TPatOSearchRec; var KgC, Val: double): integer;
begin
  Result:= SRGetInfo(PatO, tbPatODate, tbPatODateKGC, tbPatODateVal, KgC, Val);
end;

function  TdmTaba.GetPatOrdi (PatO: TPatOSearchRec; CodI: integer): longint;
begin
  Result:= SRSumData(PatO, CodI, tbPatOMov, tbPatOMovCons);
end;

function  TdmTaba.FindVendite(DataI, DataF: TDateTime): TVendSearchRec;
begin
  Result:= TVendSearchRec.Create;
  Result.GISR:= FindGiacenza(DataI, true);
  Result.GFSR:= FindGiacenza(DataF, true);
  Result.FDataI:= Result.GISR.Data;
  Result.FDataF:= Result.GFSR.Data;
  Result.Cari:= FindCarichi(Result.DataI, Result.DataF);
  Result.PatC:= FindPatCons(Result.DataI, Result.DataF);
end;

function TdmTaba.CalcVendite (Vend: TVendSearchRec; CodI: integer): longint;
begin
  with Vend do begin
    Result:=
     (GetGiacenza(GISR, CodI)+GetCarichi(Cari, CodI)) -
     (GetGiacenza(GFSR, CodI)+GetPatCons(PatC, CodI));
  end;
end;

function GetField(tb: TTable; key: integer; fld: string): string;
begin
  tb.Active:= true;
  if (key<>0) and (tb.FindKey([key])) then begin
    Result:= tb.FieldByName(fld).Value;
  end
  else begin
    Result:= '';
  end;
end;

function TdmTaba.GetDescProd(Prod: integer): string;
begin
  Result:= GetField(tbProd, Prod, 'DESC');
end;

function TdmTaba.GetDescTipo(Tipo: integer): string;
begin
  Result:= GetField(tbTipo, Tipo, 'DESC');
end;

function TdmTaba.GetDescCrit(Crit: integer): string;
begin
  Result:= GetField(tbCrit, Crit, 'DESC');
end;

procedure TdmTaba.SetupReportDevice(Rep: TeLineReport; Dev: TOutputDevice);
var
  Prn: TOutputPrinter;
begin
  Dev.Report.PageHeight:= Opzioni.RighePag; (* nessun salto di pagina *)
  if Dev is TOutputTextFile then begin
    if sdOutFile.Execute then begin
      TOutputTextFile(Dev).FileName:= sdOutFile.FileName;
      Dev.Report.PageHeight:= -1; (* nessun salto di pagina *)
    end
    else Abort;
  end
  else if Dev is TOutputPrinter then begin
    Prn:= TOutputPrinter(Dev);
    Prn.PrinterIndex:= Opzioni.PrinterIndex;
    Prn.Font.Name:= Opzioni.PrinterFontName;
    if Opzioni.PrinterFontSize <> 0 then begin
      Prn.Font.Size:= Opzioni.PrinterFontSize;
    end;
    Prn.OffTop:= Opzioni.PrinterOffsetTop;
    Prn.OffBottom:= Opzioni.PrinterOffsetBottom;
    Prn.OffLeft:= Opzioni.PrinterOffsetLeft;
    Prn.OffRight:= Opzioni.PrinterOffsetRight;
  end;
end;

end.

