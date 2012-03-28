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
 * Ultima modifica: 26 ott 1999
 *)
unit FStatCalc;

interface

uses
  WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Dialogs,
  DTabaC, 
  DBTables, DB, StdCtrls, Controls, Gauges, Buttons;

type
  TfmStatCalc = class(TForm)
    OKBtn: TBitBtn;
    btCancel: TBitBtn;
    GroupBox1: TGroupBox;
    gProgBar: TGauge;
    Label1: TLabel;
    meMsg: TMemo;
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaATTV: TBooleanField;
    tbMTaba: TTable;
    tbTabaMULI: TSmallintField;
    tbTabaDESC: TStringField;
    tbMTabaCODI: TSmallintField;
    tbMTabaMEDA: TFloatField;
    tbMTabaMAXA: TFloatField;
    tbMTabaMED5: TFloatField;
    tbMTabaMAX5: TFloatField;
    tbMTabaMED0: TFloatField;
    tbMTabaMAX0: TFloatField;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure StatCalc;

implementation

{$R *.DFM}

uses
  eLibCore;

procedure StatCalc;
var
  fmStatCalc: TfmStatCalc;
begin
  fmStatCalc:= nil;
  try
    fmStatCalc:= TfmStatCalc.Create(nil);
    fmStatCalc.ShowModal;
  finally
    fmStatCalc.Free;
  end;
end;

procedure TfmStatCalc.FormShow(Sender: TObject);
begin
  meMsg.Clear;
  gProgBar.Progress:= 0;
  gProgBar.MinValue:= 0;
end;

procedure TfmStatCalc.OKBtnClick(Sender: TObject);
var
  i, j, Num: integer;
  NumX : array[1..3] of longint;
  SumX : array[1..3] of real;
  MaxX : array[1..3] of real;
  CodI : integer;
  FstD1,FstD2,FstD3: integer;
  LstD : integer;
  DataI, DataF: TDateTime;
  Giac, Cons: longint;
  VSR: TVendSearchRec;
  GSR: TGiacSearchRec;
begin
  btCancel.Enabled:= false;
  try
    tbTaba.Open;
    tbMTaba.EmptyTable;
    tbMTaba.Open;
    dmTaba.LoadDate([dtPrez, dtGiac, dtCari, dtOrdi, dtPatO, dtPatC]);
    Num:= tbTaba.RecordCount;
    gProgBar.MaxValue:= Num;
    tbTaba.First;
    LstD := dmTaba.DateList[dtGiac].Count-1;
    FstD1:= dmTaba.DateList[dtGiac].Count-53; if FstD1 < 0 then FstD1:= 0;
    FstD2:= dmTaba.DateList[dtGiac].Count-10; if FstD2 < 0 then FstD2:= 0;
    FstD3:= dmTaba.DateList[dtGiac].Count-5;  if FstD3 < 0 then FstD3:= 0;
    for i:= 1 to Num do begin
      Application.ProcessMessages;
      gProgBar.Progress:= i-1;
      for j:= 1 to 3 do begin
        NumX[j]:= 0;
        SumX[j]:= 0;
        MaxX[j]:= 0;
      end;
      CodI:= tbTabaCodI.Value;
      if tbTabaAttv.Value then begin
        for j:= FstD1+1 to LstD do begin
          DataI:= (dmTaba.DateList[dtGiac].Objects[j-1] as DTabaC.TDate).Data;
          DataF:= (dmTaba.DateList[dtGiac].Objects[j  ] as DTabaC.TDate).Data;
          VSR:= dmTaba.FindVendite(DataI, DataF);
          Cons:= dmTaba.CalcVendite(VSR, CodI);
          if Cons < 0 then begin
            meMsg.Lines.Add(DateUtil.myDateToStr(DataI)+'-'+DateUtil.myDateToStr(DataF)+' '+tbTabaDesc.Value+'='+IntToStr(Cons));
          end;
          VSR.Free;
          GSR:= dmTaba.FindGiacenza(DataF, true);
          Giac:= dmTaba.GetGiacenza(GSR, CodI);
          GSR.Free;
          if (Giac > 0) then begin
            NumX[1]:= NumX[1] + 1;
            if j >= FstD2 then begin
              NumX[2]:= NumX[2] + 1;
            end;
            if j >= FstD3 then begin
              NumX[3]:= NumX[3] + 1;
            end;
          end;
          if (Cons <> 0) then begin
            SumX[1]:= SumX[1] + Cons;
            if j >= FstD2 then begin
              SumX[2]:= SumX[2] + Cons;
            end;
            if j >= FstD3 then begin
              SumX[3]:= SumX[3] + Cons;
            end;
            if j >= FstD3 then begin
              if Cons > MaxX[3] then MaxX[3]:= Cons;
            end
            else if j >= FstD2 then begin
              if Cons > MaxX[2] then MaxX[2]:= Cons;
            end
            else if Cons > MaxX[1] then MaxX[1]:= Cons;
          end;
        end;
        if (NumX[1] > 0) and (NumX[1] < 10) then begin
          NumX[1]:= 10;
          NumX[2]:=  9;
          IF NumX[3] < 4 then NumX[2]:= 4;
        end;
        if (NumX[2] > 0) and (NumX[2] < 9) then NumX[2]:= NumX[2] + 1;
        if (NumX[3] > 0) and (NumX[3] < 4) then NumX[3]:= NumX[3] + 1;
        for j:= 1 to 3 do begin
          if NumX[j] > 0 then SumX[j]:= SumX[j] / NumX[j]
          else SumX[j]:= 0;
          MaxX[j]:= MaxX[j] - tbTabaMulI.Value + 1;
          if MaxX[j] < SumX[j] then MaxX[j]:= int(SumX[j]+0.99);
        end;
      end;
      meMsg.Lines.Add(Format('%4d %-30s %3d %9.3f %9.3f',
        [CodI, tbTabaDesc.Value,NumX[1], SumX[1], MaxX[1]]));
      for j:= 1 to 3 do begin
        if SumX[j]<0 then SumX[j]:= 0;
        if MaxX[j]<0 then MaxX[j]:= 0;
      end;
      tbMTaba.Append;
      tbMTabaCodI.Value:= CodI;
      tbMTabaMedA.Value:= SumX[1];
      tbMTabaMed0.Value:= SumX[2];
      tbMTabaMed5.Value:= SumX[3];
      tbMTabaMaxA.Value:= MaxX[1];
      tbMTabaMax0.Value:= MaxX[2];
      tbMTabaMax5.Value:= MaxX[3];
      tbMTaba.Post;
      tbTaba.Next;
    end;
    gProgBar.Progress:= Num;
  finally
    tbTaba.Close;
    tbMTaba.Close;
  end;
  btCancel.Enabled:= true;
  btCancel.Caption:= '&Ok';
end;

end.

