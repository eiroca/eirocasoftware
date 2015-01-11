(* GPL > 3.0
Copyright (C) 1996-2009 eIrOcA Enrico Croce & Simona Burzio

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
unit FMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  eLibCore, uBioritmi,
  StdCtrls, Buttons, eGauge, ComCtrls, Mask,
  JvComponentBase, JvFormPlacement, JvExMask, JvToolEdit, JvExControls, JvSpin,
  JvAppStorage, JvAppIniStorage;

type
  TfmMain = class(TForm)
    gbLui: TGroupBox;
    iData1: TJvDateEdit;
    iOggi: TJvDateEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    tbEmotivo1: TTrackBar;
    tbFisico1: TTrackBar;
    tbIntellettivo1: TTrackBar;
    Label2: TLabel;
    RxSpinButton1: TJvSpinButton;
    GroupBox1: TGroupBox;
    iData2: TJvDateEdit;
    Label6: TLabel;
    tbEmotivo2: TTrackBar;
    tbFisico2: TTrackBar;
    tbIntellettivo2: TTrackBar;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    GroupBox2: TGroupBox;
    egAffinita: TeGauge;
    lbAff1: TLabel;
    lbLui: TLabel;
    lbLei: TLabel;
    lbAff2: TLabel;
    fsMain: TJvFormStorage;
    Label10: TLabel;
    lbLuiG: TLabel;
    lbLeiG: TLabel;
    Label11: TLabel;
    BitBtn1: TBitBtn;
    apStorage: TJvAppIniFileStorage;
    procedure FormCreate(Sender: TObject);
    procedure iOggiChange(Sender: TObject);
    procedure RxSpinButton1BottomClick(Sender: TObject);
    procedure RxSpinButton1TopClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    Lui, Lei: TBioritmo;
    procedure CalcBioritmi;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

uses
  eLibVCL;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  DateUtil.SetLongYear;
  apStorage.FileName:= ChangeFileExt(ParamStr(0), '.INI');
  Lui:= TBioritmo.Create;
  Lei:= TBioritmo.Create;
  iOggi.Date:= Date;
end;

procedure TfmMain.iOggiChange(Sender: TObject);
begin
  CalcBioritmi;
end;

procedure TfmMain.CalcBioritmi;
var
  Oggi: TDateTime;
  DataLui: TDateTime;
  DataLei: TDateTime;
  procedure NoLui;
  begin
    tbEmotivo1.Position:= 0;
    tbFisico1.Position:= 0;
    tbIntellettivo1.Position:= 0;
    lbLui.Caption:= '';
    lbLuiG.Caption:= '';
  end;
  procedure NoLei;
  begin
    tbEmotivo2.Position:= 0;
    tbFisico2.Position:= 0;
    tbIntellettivo2.Position:= 0;
    lbLei.Caption:= '';
    lbLeiG.Caption:= '';
  end;
  procedure NoAff;
  begin
    egAffinita.Value:= 0;
    lbAff1.Caption:= 'N.D.';
    lbAff2.Caption:= '';
  end;
var
  val: integer;
begin
  Oggi:= iOggi.Date;
  DataLui:= iData1.Date;
  DataLei:= iData2.Date;
  if (Oggi<>0) then begin
    if (DataLui<>0) then begin
      Lui.DataNascita:= DataLui;
      Lui.DataBioritmo:= Oggi;
      tbEmotivo1.Position:= round(Lui.Emotivo*100);
      tbFisico1.Position:= round(Lui.Fisico*100);
      tbIntellettivo1.Position:= round(Lui.Intellettivo*100);
      lbLui.Caption:= Format('%d giorni a %s', [trunc(abs(Oggi-DataLui)), FormatDateTime('dddd d, mmm yyyy',Oggi)]);
      lbLuiG.Caption:= FormatDateTime('dddd', DataLui);
    end
    else begin
      NoLui;
    end;
    if (DataLei<>0) then begin
      Lei.DataNascita:= DataLei;
      Lei.DataBioritmo:= Oggi;
      tbEmotivo2.Position:= round(Lei.Emotivo*100);
      tbFisico2.Position:= round(Lei.Fisico*100);
      tbIntellettivo2.Position:= round(Lei.Intellettivo*100);
      lbLei.Caption:= Format('%d giorni a %s', [trunc(abs(Oggi-DataLei)), FormatDateTime('dddd d, mmm yyyy',Oggi)]);
      lbLeiG.Caption:= FormatDateTime('dddd', DataLei);
    end
    else begin
      NoLei;
    end;
    if (DataLui<>0) and (DataLei<>0) then begin
      val:= round(Lui.calcAffinita(Lei.DataNascita)*(egAffinita.Max-egAffinita.Min));
      if (val<egAffinita.Min) then val:= egAffinita.Min
      else if (val>egAffinita.Max) then val:= egAffinita.Max;
      egAffinita.Value:= val;
      val:= round(Lui.calcAffinita(Lei.DataNascita)*100);
      lbAff1.Caption:= Format('%d%%',[val]);
      if (val <= 35) then lbAff2.Caption:= 'cattiva'
      else if (val <= 45) then lbAff2.Caption:= 'scarsa'
      else if (val <= 55) then lbAff2.Caption:= 'media'
      else if (val <= 65) then lbAff2.Caption:= 'buona'
      else                     lbAff2.Caption:= 'ottima';
    end
    else begin
      NoAff;
    end;
  end
  else begin
    NoLui;
    NoLei;
    NoAff;
  end;
end;

procedure TfmMain.RxSpinButton1BottomClick(Sender: TObject);
begin
  iOggi.Date:= iOggi.Date-1;
end;

procedure TfmMain.RxSpinButton1TopClick(Sender: TObject);
begin
  iOggi.Date:= iOggi.Date+1;
end;

procedure TfmMain.BitBtn1Click(Sender: TObject);
begin
  AboutGPL(Application.Title);
end;

end.

