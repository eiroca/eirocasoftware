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
unit FContat;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DContat,                                    
JvDBCombobox, JvDBGrid,
  Menus, DBTables, DB, StdCtrls, Buttons, Grids, DBGrids, DBCtrls, Mask, RgNav,
  RgNavDB, ExtCtrls, Tabs, eDB, JvBDEFilter, JvComponentBase, JvFormPlacement,
  JvExMask, JvToolEdit, JvDBControls, JvExControls, JvDBLookup, JvExDBGrids,
  JvExStdCtrls, JvCombobox, JvSpeedButton;

{ IFDEF FREEONCLOSE}  

const
  pgAzienda = 7;

type
  TfmContatti = class(TForm)
    tsContatti: TTabSet;
    nbContatti: TNotebook;
    tbContat: TTable;
    tbContatCodCon: TIntegerField;
    tbContatTipo: TIntegerField;
    tbContatNome_Tit: TStringField;
    tbContatNome_Main: TStringField;
    tbContatNome_Suf: TStringField;
    tbContatClasse: TStringField;
    tbContatSettore: TStringField;
    tbContatNote: TMemoField;
    tbContatNome: TStringField;
    dsContat: TDataSource;
    tbAziende: TTable;
    tbAziendeCodInt: TIntegerField;
    tbAziendeCodCon: TIntegerField;
    tbAziendeCodFis: TStringField;
    tbAziendeParIVA: TStringField;
    tbAziendeNome: TMemoField;
    tbAziendeNote: TMemoField;
    tbAziendeFirstContact: TDateField;
    tbAziendeTipo: TIntegerField;
    tbAziendeCodAux: TIntegerField;
    dsAziende: TDataSource;
    tbIndir: TTable;
    tbIndirCodInd: TIntegerField;
    tbIndirCodCon: TIntegerField;
    tbIndirTipo: TIntegerField;
    tbIndirIndirizzo: TMemoField;
    tbIndirNote: TStringField;
    dsIndir: TDataSource;
    tbConnessi: TTable;
    dsConnessi: TDataSource;
    tbTelef: TTable;
    tbTelefCodTel: TIntegerField;
    tbTelefCodCon: TIntegerField;
    tbTelefTipo: TIntegerField;
    tbTelefTel_Pre1: TStringField;
    tbTelefTel_Pre2: TStringField;
    tbTelefTelefono: TStringField;
    tbTelefNote: TStringField;
    dsTelef: TDataSource;
    tbContatti2: TTable;
    tbContatti2CodCon: TIntegerField;
    tbContatti2Tipo: TIntegerField;
    tbContatti2Nome_Tit: TStringField;
    tbContatti2Nome_Main: TStringField;
    tbContatti2Nome_Suf: TStringField;
    tbContatti2Classe: TStringField;
    tbContatti2Settore: TStringField;
    tbContatti2Note: TMemoField;
    tbContatti2Nome: TStringField;
    dsContatti2: TDataSource;
    tbRefer: TTable;
    tbReferProg: TIntegerField;
    tbReferCodCon: TIntegerField;
    tbReferCodRef: TIntegerField;
    tbReferRefer: TStringField;
    tbReferNote: TStringField;
    dsRefer: TDataSource;
    tbDateImpo: TTable;
    tbDateImpoProg: TIntegerField;
    tbDateImpoCodCon: TIntegerField;
    tbDateImpoTipo: TIntegerField;
    tbDateImpoData: TDateField;
    tbDateImpoNota: TStringField;
    dsDateImpo: TDataSource;
    pnContat: TPanel;
    sbContat: TScrollBox;
    Label1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    pnContPers: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    DBEdit3: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    EditSettore: TDBEdit;
    DBMemo2: TDBMemo;
    DBEdit2: TDBEdit;
    cbTipoCont: TJvDBComboBox;
    pnContAzie: TPanel;
    lbNome_Suf: TLabel;
    lbNome_Main: TLabel;
    iNome_Suf: TDBComboBox;
    iNome_Main: TDBEdit;
    pnIndir: TPanel;
    ScrollBox1: TScrollBox;
    txIndir: TDBText;
    lbIndir: TLabel;
    pnTelef: TPanel;
    lbTelef: TLabel;
    txTelef: TDBText;
    DBGrid2: TJvDBGrid;
    pnDateImpo: TPanel;
    lbDateImpo: TLabel;
    txDateImpo: TDBText;
    DBGrid3: TJvDBGrid;
    pnAziend: TPanel;
    ScrollBox3: TScrollBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    DBEdit5: TDBEdit;
    DBMemo4: TDBMemo;
    DBDateEdit2: TJvDBDateEdit;
    DBEdit6: TDBEdit;
    DBMemo5: TDBMemo;
    DBEdit7: TDBEdit;
    RxDBComboBox3: TJvDBComboBox;
    pnComunic: TPanel;
    DBGrid1: TJvDBGrid;
    pnRefer: TPanel;
    lbRefer: TLabel;
    txRefer: TDBText;
    txComun: TDBText;
    lbComun: TLabel;
    txAziend: TDBText;
    lbAziend: TLabel;
    tbIndirIndir: TStringField;
    tbIndir2: TTable;
    tbIndir2CodInd: TIntegerField;
    tbIndir2CodCon: TIntegerField;
    tbIndir2Tipo: TIntegerField;
    tbIndir2Indirizzo: TMemoField;
    tbIndir2Note: TStringField;
    BitBtn1: TBitBtn;
    lcNewRef: TJvDBLookupCombo;
    fpContat: TJvFormPlacement;
    Label2: TLabel;
    DBGrid4: TJvDBGrid;
    DBMemo1: TDBMemo;
    Label15: TLabel;
    Label16: TLabel;
    cbTipoIndir: TJvDBComboBox;
    Label14: TLabel;
    DBEdit1: TDBEdit;
    pnIndiTrad: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    pnIndiElet: TPanel;
    Label6: TLabel;
    Panel1: TPanel;
    RxDBComboBox1: TJvDBComboBox;
    Label26: TLabel;
    Label27: TLabel;
    DBEdit10: TDBEdit;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    iPre1: TDBEdit;
    iPre2: TDBEdit;
    iNum: TDBEdit;
    Label31: TLabel;
    tbTelefTelef: TStringField;
    tbTelefTelefTipo: TStringField;
    Panel2: TPanel;
    Label32: TLabel;
    DBGrid5: TJvDBGrid;
    tbReferDi: TTable;
    tbReferDiRefer: TStringField;
    tbReferDiNote: TStringField;
    dsReferDi: TDataSource;
    tbReferDiProg: TIntegerField;
    tbReferDiCodCon: TIntegerField;
    tbReferDiCodRef: TIntegerField;
    tbContatti2Nome_Pre1: TStringField;
    tbContatti2Nome_Pre2: TStringField;
    tbContatNome_Pre1: TStringField;
    tbContatNome_Pre2: TStringField;
    Label33: TLabel;
    DBEdit14: TDBEdit;
    pnGruppi: TPanel;
    Label34: TLabel;
    txGruppi: TDBText;
    dgGruppi: TJvDBGrid;
    tbGruppi: TTable;
    dsGruppi: TDataSource;
    tbInGruppo: TTable;
    tbInGruppoProg: TIntegerField;
    tbInGruppoCodCon: TIntegerField;
    tbInGruppoCodGrp: TIntegerField;
    tbGruppiCodGrp: TIntegerField;
    tbGruppiIn: TStringField;
    dsInGruppo: TDataSource;
    tbGruppiDesc: TStringField;
    flInGruppo: TJvDBFilter;
    tbNickName: TTable;
    tbNickNameProg: TIntegerField;
    tbNickNameCodCon: TIntegerField;
    dgNickName: TJvDBGrid;
    dsNickName: TDataSource;
    Label36: TLabel;
    btConnect: TBitBtn;
    DBConnection: TDBConnectionLink;
    DBMessage: TDBMessageLink;
    RxSpeedButton1: TJvSpeedButton;
    pmNickName: TPopupMenu;
    miNickAdd: TMenuItem;
    miNickDel: TMenuItem;
    miNickEdit: TMenuItem;
    NavContatti: TRGNavigator;
    NavAzienda: TRGNavigator;
    NavConnessi: TRGNavigator;
    NavDateImpo: TRGNavigator;
    NavGruppi: TRGNavigator;
    NavIndir: TRGNavigator;
    NavTelef: TRGNavigator;
    NavRefer: TRGNavigator;
    tbNickNameNickName: TStringField;
    tbConnessiCodCos: TIntegerField;
    tbConnessiCodCon: TIntegerField;
    tbConnessiTipo: TIntegerField;
    tbConnessiData: TDateTimeField;
    tbConnessiContenuto: TStringField;
    tbConnessiNote: TMemoField;
    tbConnessiURL: TStringField;
    tbConnessiTipoDesc: TStringField;
    odURL: TOpenDialog;
    sbConnessi: TScrollBox;
    Label7: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label35: TLabel;
    Label37: TLabel;
    DBEdit4: TDBEdit;
    DBMemo3: TDBMemo;
    DBDateEdit1: TJvDBDateEdit;
    RxDBGrid2: TJvDBGrid;
    cbTipoConn: TJvDBComboBox;
    pnURL: TPanel;
    btOpenURL: TJvSpeedButton;
    btPreview: TJvSpeedButton;
    lbURL: TLabel;
    btLocate: TJvSpeedButton;
    iURL: TDBEdit;
    Label38: TLabel;
    cbOrder: TComboBox;
    procedure tsContattiChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbReferCalcFields(DataSet: TDataset);
    procedure tbContatCalcFields(DataSet: TDataset);
    procedure tbContatti2CalcFields(DataSet: TDataset);
    procedure tbReferBeforeInsert(DataSet: TDataset);
    procedure dsContatDataChange(Sender: TObject; Field: TField);
    procedure tbIndirCalcFields(DataSet: TDataset);
    procedure BitBtn1Click(Sender: TObject);
    procedure tsContattiDrawTab(Sender: TObject; TabCanvas: TCanvas;
      R: TRect; Index: Integer; Selected: Boolean);
    procedure cbTipoContChange(Sender: TObject);
    procedure tbContatBeforeDelete(DataSet: TDataset);
    procedure dsIndirDataChange(Sender: TObject; Field: TField);
    procedure tbTelefCalcFields(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);
    procedure tbReferDiCalcFields(DataSet: TDataset);
    procedure FormDeactivate(Sender: TObject);
    procedure tbContatAfterPost(DataSet: TDataset);
    procedure FormResize(Sender: TObject);
    procedure tbGruppiCalcFields(DataSet: TDataset);
    function flInGruppoFiltering(Sender: TObject;
      DataSet: TDataset): Boolean;
    procedure dgGruppiDblClick(Sender: TObject);
    procedure dgGruppiKeyPress(Sender: TObject; var Key: Char);
    procedure tbGruppiBeforeDelete(DataSet: TDataset);
    procedure tbGruppiBeforeInsert(DataSet: TDataset);
    procedure FormDestroy(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure DBGrid4GetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure DBGrid4DblClick(Sender: TObject);
    procedure DBConnectionEvent(Sender: TeDataBase; Connect: Boolean);
    procedure DBMessageMessage(Sender: TObject; Cmd: Integer;
      Data: TObject);
    procedure miNickAddClick(Sender: TObject);
    procedure miNickDelClick(Sender: TObject);
    procedure miNickEditClick(Sender: TObject);
    procedure iNumExit(Sender: TObject);
    procedure tbConnessiCalcFields(DataSet: TDataset);
    procedure btLocateClick(Sender: TObject);
    procedure cbTipoConnChange(Sender: TObject);
    procedure dsConnessiDataChange(Sender: TObject; Field: TField);
    procedure btOpenURLClick(Sender: TObject);
    procedure btPreviewClick(Sender: TObject);
    procedure cbTipoIndirChange(Sender: TObject);
    procedure iURLChange(Sender: TObject);
    procedure cbOrderChange(Sender: TObject);
    procedure tbContatBeforePost(DataSet: TDataSet);
    procedure dgNickNameEnter(Sender: TObject);
  private
    { Private declarations }
    InsertRef: boolean;
    NeedDataImpo: boolean;
    OldWidth: integer;
    OldHeight: integer;
    CurCodCon: integer;
    Posting: boolean;
    procedure Post(ds: TDataSource);
    procedure TipoConnChanged(NewTipo: integer);
    procedure TipoContChanged(NewTipo: integer);
    procedure TipoIndiChanged(NewTipo: integer);
    procedure MakeDataImpo;
    procedure SetGruppo(CodGrp: integer; Sel: boolean);
    procedure OpenTables;
    procedure CloseTables;
    function  Select(CodCon: longint): boolean;
  public
    { Public declarations }
  end;

procedure ShowContatto(CodCon: longint);

implementation

{$R *.DFM}

uses
  uOpzioni, eLibCore, ContComm, eLibDB, FPreview, eLibSystem;

var
  fmContatti: TfmContatti;

procedure PrepareFormEditContatti;
var
  OldCursor: integer;
begin
  if fmContatti = nil then begin
    OldCursor:= Screen.Cursor;
    try         
      Screen.Cursor:= crHourGlass;
      Application.CreateForm(TfmContatti, fmContatti);
    finally
      Screen.Cursor:= OldCursor;
    end;
  end;
end;

procedure ShowContatto(CodCon: longint);
begin
  PrepareFormEditContatti;
  if CodCon > 0 then begin
    fmContatti.Show;
    fmContatti.Select(CodCon);
  end;
end;

function TfmContatti.Select(CodCon: longint): boolean;
begin
  Result:= tbContat.Locate('CodCon', CodCon, []);
end;

procedure TfmContatti.tsContattiChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  if (NewTab = pgAzienda) then begin
    AllowChange:= (tbContatTipo.Value=ctConAzienda);
  end;
  if AllowChange then begin
    case nbContatti.PageIndex of
      0: begin Post(dsContat); Post(dsNickName); end;
      1: Post(dsIndir);
      2: Post(dsTelef);
      3: Post(dsDateImpo);
      4: Post(dsRefer);
      5: begin
        Post(dsConnessi);
      end;
      6: ;
      7: Post(dsAziende);
    end;
    nbContatti.PageIndex:= NewTab;
    case NewTab of
      1: if Opzioni.AutoInsertIndir and tbIndir.EOF then tbIndir.Insert;
      2: if Opzioni.AutoInsertTelef and tbTelef.EOF then tbTelef.Insert;
      5: begin
      end;
    end;
  end;
end;

procedure TfmContatti.FormCreate(Sender: TObject);
begin
  Posting:= false;
  OldWidth:= Width;
  OldHeight:= Height;
  pnContAzie.BevelInner:= bvNone; pnContAzie.BevelOuter:= bvNone;
  pnContPers.BevelInner:= bvNone; pnContPers.BevelOuter:= bvNone;
  pnIndiTrad.BevelInner:= bvNone; pnIndiTrad.BevelOuter:= bvNone;
  pnIndiElet.BevelInner:= bvNone; pnIndiElet.BevelOuter:= bvNone;
  pnURL.BevelInner:= bvNone;      pnURL.BevelOuter:= bvNone;
  InsertRef:= false;
  DBConnection.DataBase:= dmContatti.DB;
  DBMessage.DataBase:= dmContatti.DB;
  sbConnessi.Hint:= '';
  cbOrder.ItemIndex:= 1;
  cbOrderChange(nil);
end;

procedure TfmContatti.FormShow(Sender: TObject);
begin
  btConnect.Enabled:= true;
  tsContatti.TabIndex := 0;
  nbContatti.PageIndex:= 0;
  OpenTables;
  DBConnection.Active:= true;
  DBMessage.Active:= true;
end;

procedure TfmContatti.OpenTables;
begin
  tbInGruppo.Active:= true;
  tbGruppi.Active:= true;  (* vanno prima di tbContat in quanto sono legati tramite filtro e non Master/Detail *)
  flInGruppo.Active:= true;
  tbContatti2.Active:= true;
  tbIndir2.Active:= true;
  tbIndir.Active:= true;
  tbTelef.Active:= true;
  tbRefer.Active:= true;
  tbReferDi.Active:= true;
  tbConnessi.Active:= true;
  tbAziende.Active:= true;
  tbDateImpo.Active:= true;
  tbNickName.Active:= true;
  tbContat.Active:= true;
end;

procedure TfmContatti.CloseTables;
begin
  tbContat.Active:= false;
  tbIndir.Active:= false;
  tbIndir2.Active:= false;
  tbTelef.Active:= false;
  tbConnessi.Active:= false;
  tbAziende.Active:= false;
  tbContatti2.Active:= false;
  tbRefer.Active:= false;
  tbReferDi.Active:= false;
  tbDateImpo.Active:= false;
  tbGruppi.Active:= false;
  tbInGruppo.Active:= false;
  tbNickName.Active:= false;
  flInGruppo.Active:= false;
end;

procedure TfmContatti.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DBConnection.Active:= false;
  DBMessage.Active:= false;
  CloseTables;
  {$IFDEF FREEONCLOSE}
  Action:= caFree;
  {$ENDIF}
end;

procedure TfmContatti.tbReferCalcFields(DataSet: TDataset);
begin
  tbContatti2.Locate('CodCon', DataSet.FieldByName('CodRef').AsInteger, []);
  tbReferNote.Value:= tbContatti2Settore.Value;
  tbReferRefer.Value:= _DecodeNome(tbContatti2);
end;

procedure TfmContatti.tbReferBeforeInsert(DataSet: TDataset);
begin
  if not InsertRef then Abort;
end;

procedure TfmContatti.tbContatCalcFields(DataSet: TDataset);
begin
  tbContatNome.Value:= _DecodeNome(tbContat);
end;

procedure TfmContatti.tbContatti2CalcFields(DataSet: TDataset);
begin
  tbContatti2Nome.Value:= _DecodeNome(tbContatti2);
end;

procedure TfmContatti.TipoConnChanged(NewTipo: integer);
begin
  case NewTipo of
    ctCnnFile: begin
      lbURL.Caption:= 'File';
      pnURL.Visible:= true;
      btLocate.Enabled:= true;
      btPreview.Enabled:= tbConnessiURl.Value <> '';
      btOpenURL.Enabled:= true;
    end;
    ctCnnURL: begin
      lbURL.Caption:= 'URL';
      pnURL.Visible:= true;
      btLocate.Enabled:= false;
      btPreview.Enabled:= false;
      btOpenURL.Enabled:= true;
    end;
    else begin
      pnURL.Visible:= false;
    end;
  end;
end;

procedure TfmContatti.TipoContChanged(NewTipo: integer);
begin
  case NewTipo of
    ctConAzienda: begin
      pnContPers.Visible:= false;
      pnContAzie.Visible:= true;
    end;
    else begin (* ctPersona *)
      pnContAzie.Visible:= false;
      pnContPers.Visible:= true;
    end;
  end;
end;

procedure TfmContatti.TipoIndiChanged(NewTipo: integer);
begin
  case NewTipo of
    ctIndTradiz: begin
      pnIndiElet.Visible:= false;
      pnIndiTrad.Visible:= true;
    end;
    else begin (* elettronico *)
      pnIndiTrad.Visible:= false;
      pnIndiElet.Visible:= true;
    end;
  end;
end;

procedure TfmContatti.dsContatDataChange(Sender: TObject; Field: TField);
begin
  if (Field=nil) or (Field=tbContatTipo) then begin
    TipoContChanged(tbContatTipo.Value);
    tsContatti.Invalidate;
  end;
  if (Field=nil) or (Field=tbContatCodCon) then begin
    CurCodCon:= tbContatCodCon.Value;
    tbInGruppo.Refresh;
    tbGruppi.Refresh;
  end;
end;

procedure TfmContatti.tbIndirCalcFields(DataSet: TDataset);
begin
  if tbIndir2.FindKey([DataSet.FieldByName('CodInd').AsInteger]) then begin
    tbIndirIndir.Value:= _DecodeIndirizzo(tbIndir2);
  end;
end;

procedure TfmContatti.BitBtn1Click(Sender: TObject);
var
  CodRef: longint;
begin
  CodRef:= Parser.IVal(lcNewRef.Value);
  if CodRef > 0 then begin
    InsertRef:= true;
    tbRefer.Append;
    tbReferCodCon.Value:= tbContatCodCon.Value;
    tbReferCodRef.Value:= CodRef;
    tbRefer.Post;
    InsertRef:= false;
  end;
  lcNewRef.Value:= '';
end;

procedure TfmContatti.tsContattiDrawTab(Sender: TObject;
  TabCanvas: TCanvas; R: TRect; Index: Integer; Selected: Boolean);
begin
  if Index = pgAzienda then begin
    if (tbContatTipo.Value=ctConAzienda) then begin
      TabCanvas.Font.Color:= clBtnText;
    end
    else begin
      TabCanvas.Font.Color:= clBtnFace;
    end;
  end
  else begin
    TabCanvas.Font.Color:= clBtnText;
  end;
//  DrawTab(Sender as TTabSet, TabCanvas, R, Index, Selected);
end;

procedure TfmContatti.cbTipoContChange(Sender: TObject);
begin
  TipoContChanged(cbTipoCont.ItemIndex);
end;

procedure TfmContatti.tbContatBeforeDelete(DataSet: TDataset);
  procedure Cancella(tb: TTable);
  begin
    tb.First;
    while not tb.EOF do begin
      tb.Delete;
    end;
  end;
begin
  if MessageDlg('La cancellazione del contatto comporta anche la cancellazione degli indirizzi, telefoni, ... connessi. '+
      'Sei sicuro di volere proseguire?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    Cancella(tbIndir);
    Cancella(tbTelef);
    Cancella(tbConnessi);
    Cancella(tbRefer);
    Cancella(tbDateImpo);
    Cancella(tbAziende);
    Cancella(tbNickName);
    Cancella(tbInGruppo);
  end
  else Abort;
end;

procedure TfmContatti.dsIndirDataChange(Sender: TObject; Field: TField);
begin
  if (Field=nil) or (Field=tbIndirTipo) then begin
    TipoIndiChanged(tbIndirTipo.Value);
    tsContatti.Invalidate;
  end;
end;

procedure TfmContatti.tbTelefCalcFields(DataSet: TDataset);
var
  Tipo: integer;
begin
  tbTelefTelef.Value:= _DecodeTelefono(DataSet);
  Tipo:= DataSet.FieldByName('Tipo').AsInteger;
  if (Tipo>=ctTelPrimo) and (Tipo<=ctTelUltimo) then begin
    tbTelefTelefTipo.Value:= TeleDesc[Tipo];
  end
  else begin
    tbTelefTelefTipo.Value:= '';
  end;
end;

procedure TfmContatti.FormActivate(Sender: TObject);
begin
  WindowState:= wsNormal;
  tbContatti2.Refresh;
  tbContat.Refresh;
  tbIndir2.Refresh;
  tbIndir.Refresh;
  tbTelef.Refresh;
  tbRefer.Refresh;
  tbReferDi.Refresh;
  tbConnessi.Refresh;
  tbAziende.Refresh;
  tbDateImpo.Refresh;
  tbInGruppo.Refresh;
  tbGruppi.Refresh;  (* deve seguire tbInGruppo.Refresh x essere sincronizzati con il filtro *)
  tbNickName.Refresh;
end;

procedure TfmContatti.tbReferDiCalcFields(DataSet: TDataset);
begin
  tbContatti2.Locate('CodCon', DataSet.FieldByName('CodCon').AsInteger, []);
  tbReferDiNote.Value:= tbContatti2Settore.Value;
  tbReferDiRefer.Value:= _DecodeNome(tbContatti2);
end;

procedure TfmContatti.Post(ds: TDataSource);
  procedure PostIt(ADS: TDataSource);
  begin
    if ADS.DataSet <> nil then begin
           if (ADS.DataSet.State = dsEdit) and (Opzioni.PostEdit) then ADS.DataSet.Post
      else if (ADS.DataSet.State = dsInsert) and (Opzioni.PostInsert) then ADS.DataSet.Post
      else if (ADS.DataSet.State in [dsEdit, dsInsert]) then ADS.DataSet.Cancel;
    end;
  end;
var
  i: integer;
begin
  if Assigned(DS) then PostIt(DS)
  else begin
    for i:= 0 to ComponentCount-1 do begin
      if Components[i] is TDataSource then begin
        ds:= TDataSource(Components[i]);
        PostIt(ds);
      end;
    end;
  end;
end;

procedure TfmContatti.FormDeactivate(Sender: TObject);
begin
  Post(nil);
end;

procedure TfmContatti.MakeDataImpo;
begin
  tbDateImpo.Append;
  tbDateImpoCodCon.Value:= tbContatCodCon.Value;
  tbDateImpoData.Value:= Date;
  tbDateImpoNota.Value:= Opzioni.InsertDataImpoNota;
  tbDateImpo.Post;
end;

procedure TfmContatti.tbContatAfterPost(DataSet: TDataset);
begin
  if NeedDataImpo then MakeDataImpo;
end;

procedure TfmContatti.FormResize(Sender: TObject);
begin
  if WindowState = wsNormal then begin
    Width := OldWidth;
    Height:= OldHeight;
  end;
end;

procedure TfmContatti.tbGruppiCalcFields(DataSet: TDataset);
begin
  if tbInGruppo.Locate('CodGrp', DataSet.FieldByName('CodGrp').AsInteger, []) then begin
    tbGruppiIn.Value:= 'X';
  end
  else begin
    tbGruppiIn.Value:= '';
  end;
end;

function TfmContatti.flInGruppoFiltering(Sender: TObject;
  DataSet: TDataset): Boolean;
begin
  Result:= DataSet.FieldByName('CodCon').AsInteger = CurCodCon;
end;

procedure TfmContatti.dgGruppiDblClick(Sender: TObject);
begin
  SetGruppo(tbGruppiCodGrp.Value, tbGruppiIn.Value = '');
end;

procedure TfmContatti.SetGruppo(CodGrp: integer; Sel: boolean);
begin
  if CodGrp <= 0 then exit;
  if Sel then begin
    if not tbInGruppo.Locate('CodGrp', CodGrp, []) then begin
      tbInGruppo.Append;
      tbInGruppoCodGrp.Value:= CodGrp;
      tbInGruppoCodCon.Value:= CurCodCon;
      tbInGruppo.Post;
      tbGruppi.Refresh;
    end;
  end
  else begin
    if tbInGruppo.Locate('CodGrp', CodGrp, []) then begin
      tbInGruppo.Delete;
      tbGruppi.Refresh;
    end;
  end;
end;

procedure TfmContatti.dgGruppiKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    ' ': SetGruppo(tbGruppiCodGrp.Value, tbGruppiIn.Value = '');
    #13: SetGruppo(tbGruppiCodGrp.Value, true);
    #8 : SetGruppo(tbGruppiCodGrp.Value, false);
  end;
end;

procedure TfmContatti.tbGruppiBeforeDelete(DataSet: TDataset);
begin
  Abort;
end;

procedure TfmContatti.tbGruppiBeforeInsert(DataSet: TDataset);
begin
  Abort;
end;

procedure TfmContatti.FormDestroy(Sender: TObject);
begin
  {$IFDEF FREEONCLOSE}
  fmContatti:= nil;
  {$ENDIF}
end;

procedure TfmContatti.btConnectClick(Sender: TObject);
begin
  dmContatti.OpenIndir(tbIndirCodCon.Value, tbIndirTipo.Value, tbIndirIndir.Value);
end;

procedure TfmContatti.DBGrid4GetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if Field = tbIndirIndir then begin
    if tbIndirTipo.Value = AK_ELETTRONICO then begin
      if not Highlight then AFont.Color:= clHighlight;
    end;
  end;
end;

procedure TfmContatti.DBGrid4DblClick(Sender: TObject);
begin
  dmContatti.OpenIndir(tbIndirCodCon.Value, tbIndirTipo.Value, tbIndirIndir.Value);
end;

procedure TfmContatti.DBConnectionEvent(Sender: TeDataBase; Connect: Boolean);
begin
  if Connect then begin
    OpenTables;
  end
  else begin
    CloseTables;
  end;
end;

procedure TfmContatti.DBMessageMessage(Sender: TObject; Cmd: Integer;
  Data: TObject);
begin
  case Cmd of
    CC_SELECTCON: if Sender <> Self then Select(longint(Data));
  end;
end;

procedure TfmContatti.miNickAddClick(Sender: TObject);
begin
  dsNickName.DataSet.Append;
end;

procedure TfmContatti.miNickDelClick(Sender: TObject);
begin
  try
    dsNickName.DataSet.Delete;
  except
  end;
end;

procedure TfmContatti.miNickEditClick(Sender: TObject);
begin
  try
    dsNickName.DataSet.Edit;
  except
  end;
end;

procedure TfmContatti.iNumExit(Sender: TObject);
var
  tmp, Pre1, Pre2, Num: string;
  flg: boolean;
begin
  tmp:= Trim(iNum.Text);
  flg:= SplitTel(tmp, pre1, pre2, num);
  if Flg then begin
    flg:= false;
    if (pre1 <> '') then begin
      DBUtil._SetEdit(tbTelef);
      tbTelefTel_Pre1.Value:= pre1;
      flg:= true;
    end;
    if (pre2 <> '') then begin
      DBUtil._SetEdit(tbTelef);
      tbTelefTel_Pre2.Value:= pre2;
      flg:= true;
    end;
    if flg then begin
      DBUtil._SetEdit(tbTelef);
      tbTelefTelefono.Value:= Num;
    end;
  end;
end;

procedure TfmContatti.tbConnessiCalcFields(DataSet: TDataset);
var
  tmp: string;
  Tipo: integer;
begin
  Tipo:= DataSet.FieldByName('Tipo').AsInteger;
  if (Tipo>=ctCnnPrimo) and (Tipo<=ctCnnUltimo) then begin
    tmp:= ConnDesc[Tipo];
  end
  else tmp:= '';
  DataSet.FieldByName('TipoDesc').AsString:= tmp;
end;

procedure TfmContatti.btLocateClick(Sender: TObject);
begin
  odURL.InitialDir:= ExtractFilePath(tbConnessiURL.Value);
  if odURL.Execute then begin
    DBUtil.SetEdit(dsConnessi);
    tbConnessiURL.Value:= odURL.FileName;
  end;
end;

procedure TfmContatti.cbTipoConnChange(Sender: TObject);
begin
  TipoConnChanged(cbTipoConn.ItemIndex);
end;

procedure TfmContatti.dsConnessiDataChange(Sender: TObject; Field: TField);
begin
  if (Field=nil) or (Field=tbConnessiTipo) then begin
    TipoConnChanged(tbConnessiTipo.Value);
  end;
end;

procedure TfmContatti.btOpenURLClick(Sender: TObject);
begin
  Execute('open', tbConnessiURL.Value, '');
end;

procedure TfmContatti.btPreviewClick(Sender: TObject);
begin
  Preview(tbConnessiURL.Value);
end;

procedure TfmContatti.cbTipoIndirChange(Sender: TObject);
begin
  TipoIndiChanged(cbTipoIndir.ItemIndex);
end;

procedure TfmContatti.iURLChange(Sender: TObject);
var
  flg: boolean;
begin
  flg:= iURL.Text <> '';
  if flg <> btPreview.Enabled then btPreview.Enabled := flg;
end;

procedure TfmContatti.cbOrderChange(Sender: TObject);
begin
  case cbOrder.ItemIndex of
    1: tbContat.IndexName:= 'IdxNome';
    2: tbContat.IndexName:= 'IdxSettore';
    3: tbContat.IndexName:= 'IdxClasse';
    else tbContat.IndexName:= '';
  end;
  if tbContat.Active then tbContat.Refresh;
end;

procedure TfmContatti.tbContatBeforePost(DataSet: TDataSet);
begin
  NeedDataImpo:= (DataSet.state = dsInsert) and Opzioni.AutoInsertDataImpo;
end;

procedure TfmContatti.dgNickNameEnter(Sender: TObject);
begin
  DBUtil._PostMaster(tbContat);
end;

initialization
  fmContatti:= nil;
end.

