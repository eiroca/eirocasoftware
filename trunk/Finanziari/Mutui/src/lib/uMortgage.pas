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
unit uMortgage;

interface

uses
  SysUtils, Classes;

type

  EInvalidMortgage = class(Exception);

  { One element in the amort. table. }
  Payment = record
    PayPrincipal  : double;
    PayInterest   : double;
    CumPrincipal  : double;
    CumInterest   : double;
    ExtraPrincipal: double;
    Balance       : double;
  end;

  PaymentTable = array of Payment;

  TMortgage = class
    private
     FPeriods: integer;
     FPeriodsPerYear: double;
     FPrincipal: double;
     FInterest : double;
     procedure AllocPayments;
    protected
     procedure SetPeriods(vl: integer);
     procedure SetPeriodsPerYear(vl: double);
     procedure SetPrincipal(vl: double);
     procedure SetInterest(vl: double);
    public
     { Number of periods in mortgage }
     property Periods: integer read  FPeriods write SetPeriods;
     { Number of periods in a year }
     property PeriodsPerYear: double read  FPeriodsPerYear write SetPeriodsPerYear;
     { Amount of principal }
     property Principal: double read FPrincipal write  SetPrincipal;
     { Percentage of interest per *YEAR*}
     property Interest : double read FInterest write SetInterest;
    public
     { Monthly payment }
     MonthlyPI: double;
     { Array holding payments }
     Payments : PaymentTable;
    public
     constructor Create(StartPrincipal: double; StartInterest: double; StartPeriods: integer; StartPeriodsPerYear: double);
     procedure   Recalc;
     procedure   GetPayment(PaymentNumber: integer; var ThisPayment: Payment);
     procedure   ApplyExtraPrincipal(PaymentNumber: integer; Extra: double);
     procedure   RemoveExtraPrincipal(PaymentNumber: integer);
     procedure   Load(var f: textfile);
     procedure   Save(var f: textfile);
     destructor  Destroy; override;
  end;

implementation

function CalcPayment(Principal, InterestPerPeriod: double; NumberOfPeriods: integer): double;
var
  Factor: double;
begin
  if (InterestPerPeriod>0) then begin
    Factor:= exp(-NumberOfPeriods * ln(1.0 + InterestPerPeriod));
    Result:= Principal * InterestPerPeriod / (1.0 - Factor)
  end
  else begin
    Result:= Principal / NumberOfPeriods;
  end;
end;

procedure TMortgage.SetPeriodsPerYear(vl: double);
begin
  if vl <> FPeriodsPerYear then begin
    FPeriodsPerYear:= vl;
    Recalc;
  end;
end;

procedure TMortgage.SetPrincipal(vl: double);
begin
  if vl <> FPrincipal then begin
    FPrincipal:= vl;
    Recalc;
  end;
end;

procedure TMortgage.SetInterest(vl: double);
begin
  if vl <> FInterest then begin
    FInterest:= vl;
    Recalc;
  end;
end;

procedure TMortgage.AllocPayments;
var
  i: integer;
begin
  SetLength(Payments, Periods);
  for i:= 0 to Periods-1 do Payments[i].ExtraPrincipal:= 0;
end;

procedure TMortgage.SetPeriods(vl: integer);
begin
  if vl <> FPeriods then begin
    FPeriods:= vl;
    AllocPayments;
    Recalc;
  end;
end;

constructor TMortgage.Create(StartPrincipal: double; StartInterest: double;
  StartPeriods: integer; StartPeriodsPerYear: double);
begin
  { Set up all the initial state values: }
  Principal:= StartPrincipal;
  Interest := StartInterest;
  Periods  := StartPeriods;
  PeriodsPerYear:= StartPeriodsPerYear;
  { Calculate the amortization table }
  Recalc;
end;

procedure TMortgage.Save(var f: textfile);
var
  i: integer;
begin
  writeln(f, ClassName);
  writeln(f, Periods);
  writeln(f, PeriodsPerYear);
  writeln(f, Principal);
  writeln(f, Interest);
  writeln(f, MonthlyPI);
  for i:= 0 to Periods-1 do begin
    writeln(f, i);
    with Payments[i] do begin
      writeln(f, PayPrincipal);
      writeln(f, PayInterest);
      writeln(f, CumPrincipal);
      writeln(f, CumInterest);
      writeln(f, ExtraPrincipal);
      writeln(f, Balance);
    end;
  end;
end;

procedure TMortgage.Load(var f: textfile);
const
  ErrMsg = 'Bad Definition';
var
  i: integer;
  stmp: string;
  itmp: integer;
  dtmp: double;
begin
  readln(f, stmp);
  if stmp <> ClassName then raise EInvalidMortgage.Create(ErrMsg);
  readln(f, itmp); Periods:= itmp;
  readln(f, dtmp); PeriodsPerYear:= dtmp;
  readln(f, dtmp); Principal:= dtmp;
  readln(f, dtmp); Interest:= dtmp;
  readln(f, dtmp); MonthlyPI:= dtmp;
  AllocPayments;
  for i:= 0 to Periods-1 do begin
    readln(f, itmp); if itmp <> i then EInvalidMortgage.Create(ErrMSg);
    with Payments[i] do begin
      readln(f, PayPrincipal);
      readln(f, PayInterest);
      readln(f, CumPrincipal);
      readln(f, CumInterest);
      readln(f, ExtraPrincipal);
      readln(f, Balance);
    end;
  end;
end;

{ This method calculates the amortization table for the mortgage. }
{ The table is stored in the array pointed to by Payments.     }
procedure TMortgage.Recalc;
var
  i: integer;
  RemainingPrincipal: double;
  InterestThisPeriod: double;
  InterestPerPeriod: double;
  HypotheticalPrincipal: double;
begin
  if (PeriodsPerYear=0) then exit;
  InterestPerPeriod:= Interest/PeriodsPerYear;
  MonthlyPI:= CalcPayment(Principal, InterestPerPeriod, Periods);
  { Round the monthly to cents: }
  MonthlyPI:= int(MonthlyPI * 100.0 + 0.5) / 100.0;
  { Now generate the amortization table: }
  RemainingPrincipal:= Principal;
  for i:= 0 to Periods-1 do begin
    { Calculate the interest this period and round it to cents:  }
    InterestThisPeriod:= (RemainingPrincipal * InterestPerPeriod);
    if (InterestThisPeriod<0.01) then begin
      InterestThisPeriod:= 0;
    end
    else begin
      InterestThisPeriod:= int(InterestThisPeriod * 100 + 0.5) / 100.0;
    end;
    { Store values into payments array: }
    with Payments[i] do begin
      if RemainingPrincipal = 0 then begin { Loan's been paid off! }
        PayInterest:= 0;
        PayPrincipal:= 0;
        Balance:= 0;
      end
      else begin
        HypotheticalPrincipal:= MonthlyPI - InterestThisPeriod + ExtraPrincipal;
        if HypotheticalPrincipal > RemainingPrincipal then PayPrincipal:= RemainingPrincipal
        else PayPrincipal:= HypotheticalPrincipal;
        PayInterest:= InterestThisPeriod;
        RemainingPrincipal:= RemainingPrincipal - PayPrincipal; { Update running balance }
        Balance:= RemainingPrincipal;
      end;
      { Update the cumulative interest and principal fields: }
      if i = 0 then begin
        CumPrincipal:= PayPrincipal;
        CumInterest:= PayInterest;
      end
      else begin
        CumPrincipal:= Payments[i-1].CumPrincipal + PayPrincipal;
        CumInterest:= Payments[i-1].CumInterest + PayInterest;
      end;
    end;
  end;
end;

procedure TMortgage.GetPayment(PaymentNumber: integer; var ThisPayment: Payment);
begin
  ThisPayment:= Payments[PaymentNumber-1];
end;

procedure TMortgage.ApplyExtraPrincipal(PaymentNumber: integer; Extra: double);
begin
  Payments[PaymentNumber-1].ExtraPrincipal:= Extra;
  Recalc;
end;

procedure TMortgage.RemoveExtraPrincipal(PaymentNumber: integer);
begin
  Payments[PaymentNumber-1].ExtraPrincipal:= 0.0;
  Recalc;
end;

destructor TMortgage.Destroy;
begin
  inherited;
end;

end.

