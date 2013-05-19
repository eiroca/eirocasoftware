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
unit FViewMutuo;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  uMortgage,
  Forms, Dialogs, Grids, JvGrids, JvExGrids;

const
  fmtSoldi = '%10m';

type
  TfmViewMutuo = class(TForm)
    dgDati: TJvDrawGrid;
    procedure FormCreate(Sender: TObject);
    procedure dgDatiDrawCell(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dgDatiShowEditor(Sender: TObject; ACol, ARow: Longint; var AllowEdit: Boolean);
    procedure dgDatiSetEditText(Sender: TObject; ACol, ARow: Longint; const Value: String);
    procedure FormActivate(Sender: TObject);
    procedure dgDatiGetEditText(Sender: TObject; ACol, ARow: Integer; var Value: String);
    procedure dgDatiGetEditAlign(Sender: TObject; ACol, ARow: Integer; var Alignment: TAlignment);
  private
    { Private declarations }
    FMortgage: TMortgage;
    procedure SetMortgage(aMortgage: TMortgage);
  public
    { Public declarations }
    procedure Save(const Path: string);
    property M: TMortgage read  FMortgage write SetMortgage;
  end;

implementation

{$R *.DFM}

uses
  FMain;

procedure TfmViewMutuo.SetMortgage(aMortgage: TMortgage);
begin
  FMortgage:= aMortgage;
  dgDati.RowCount:= M.Periods+1;
  dgDati.Invalidate;
end;

procedure TfmViewMutuo.FormCreate(Sender: TObject);
begin
  dgDati.Align:= alClient;
end;

procedure TfmViewMutuo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fmMain.miMutuiSave.Enabled:= false;
  M.Free;
  Action:= caFree;
end;

procedure TfmViewMutuo.dgDatiDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
  tmp: string;
begin
  if Row = 0 then begin
    case Col of
      0: dgDati.DrawStr(Rect, '# Pag.',      taCenter);
      1: dgDati.DrawStr(Rect, 'Rata annua',  taCenter);
      2: dgDati.DrawStr(Rect, 'Capitale',    taCenter);
      3: dgDati.DrawStr(Rect, 'Interessi',   taCenter);
      4: dgDati.DrawStr(Rect, 'Saldo',       taCenter);
      5: dgDati.DrawStr(Rect, 'Extra pag.',  taCenter);
      6: dgDati.DrawStr(Rect, 'Cumulo cap.', taCenter);
      7: dgDati.DrawStr(Rect, 'Cumulo int.', taCenter);
    end;
  end
  else begin
    if Row <= M.Periods then begin
      with (M.Payments[Row-1]) do begin
        case Col of
          0: dgDati.DrawStr(Rect, IntToStr(Row), taRightJustify);
          1: dgDati.DrawStr(Rect, Format(fmtSoldi, [PayPrincipal+PayInterest]), taRightJustify);
          2: dgDati.DrawStr(Rect, Format(fmtSoldi, [PayPrincipal]), taRightJustify);
          3: dgDati.DrawStr(Rect, Format(fmtSoldi, [PayInterest]), taRightJustify);
          4: dgDati.DrawStr(Rect, Format(fmtSoldi, [Balance]), taRightJustify);
          5: begin
            tmp:= '';
            if ExtraPrincipal > 0 then begin
              tmp:= Format(fmtSoldi, [ExtraPrincipal]);
            end;
            dgDati.DrawStr(Rect, tmp, taRightJustify);
          end;
          6: dgDAti.DrawStr(Rect, Format(fmtSoldi, [CumPrincipal]), taRightJustify);
          7: dgDAti.DrawStr(Rect, Format(fmtSoldi, [CumInterest]), taRightJustify);
        end;
      end;
    end
    else begin
      dgDati.DrawStr(Rect, '', taLeftJustify);
    end;
  end;
end;

procedure TfmViewMutuo.dgDatiShowEditor(Sender: TObject; ACol,
  ARow: Longint; var AllowEdit: Boolean);
begin
  AllowEdit:= (ACol=5) and (ARow>0);
end;

procedure TfmViewMutuo.dgDatiSetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
var
  tmp: double;
begin
  case ACol of
    5: begin
      tmp:= StrToFloatDef(Value, 0);
      if tmp<=0.01 then begin
        M.RemoveExtraPrincipal(ARow);
      end
      else begin
        M.ApplyExtraPrincipal(ARow, tmp);
      end;
      dgDati.Invalidate;
    end;
  end;
end;

procedure TfmViewMutuo.FormActivate(Sender: TObject);
begin
  fmMain.miMutuiSave.Enabled:= true;
end;

procedure TfmViewMutuo.dgDatiGetEditText(Sender: TObject; ACol, ARow: Integer; var Value: String);
begin
  case ACol of
    5: Value:= FloatToStr(M.Payments[ARow-1].ExtraPrincipal);
  end;
end;

procedure TfmViewMutuo.Save(const Path: string);
var
  f: TextFile;
begin
  try
    AssignFile(f, Path);
    Rewrite(f);
    M.Save(f);
    CloseFile(f);
  except
    MessageDlg('Problemi nel salvare i dati', mtError, [mbOk], 0);
  end;
end;

procedure TfmViewMutuo.dgDatiGetEditAlign(Sender: TObject; ACol,
  ARow: Integer; var Alignment: TAlignment);
begin
  Alignment:= taRightJustify;
end;

end.

