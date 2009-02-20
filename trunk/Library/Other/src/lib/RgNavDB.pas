{*******************************************************}
{                                                       }
{       Intelligent DB Navigator                        }
{                                                       }
{       Copyright (c) 1995,1996 by Rohit Gupta          }
{                                                       }
{*******************************************************}

unit RgNavDB;

{ R-,S-,I-,O-,F-,A+,U+,K+,W-,V+,B-,X+,T-,P+,L+,Y+,D-}

interface

uses Messages, Classes, DB, DBTables, RgUseful, RgNav;

type
  TNavDataLink = class;

{ TRGNavigator }

  TRGNavigator = class (TRGNavigatorX)
  private
    FDataLink: TNavDataLink;
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure GetKeyNames;
    procedure SetKeyCaption (Initialise : Boolean);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
  protected
    IndexList : TStringList;
    KeyNumber : SmallInt;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure BtnClick(Index: TAllNavBtn; CallUserClick : Boolean);  override;
    procedure ActiveChanged; override;   (*PATCH*)
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

{ TNavDataLink }

  TNavDataLink = class(TDataLink)
  private
    FNavigator: TRGNavigator;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
  public
    constructor Create(ANav: TRGNavigator);
    destructor Destroy; override;
    procedure UpdateNavigator;
  end;

procedure Register;

implementation

{ TRGNavigator }

constructor TRGNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IndexList := TStringList.Create;
  FDataLink := TNavDataLink.Create(Self);
end;

destructor TRGNavigator.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  IndexList.Free;
  IndexList := nil;
  inherited Destroy;
end;

procedure TRGNavigator.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = DataSource) then DataSource := nil;
end;

procedure TRGNavigator.WMSize(var Message: TWMSize);
begin
  DLEditing := FDataLink.Editing;
  inherited;
end;

procedure TRGNavigator.BtnClick(Index: TAllNavBtn; CallUserClick : Boolean);
begin
  if (DataSource <> nil) and (DataSource.State <> dsInactive) then begin
    with DataSource.DataSet do begin
      case Index of
        nbPrior  : Prior;
        nbNext   : Next;
        nbFirst  : First;
        nbLast   : Last;
        nbRefresh: Refresh;
        nbKey    : begin
          if KeyNumber < IndexList.Count-1 then inc (KeyNumber)
          else KeyNumber := 0;
          SetKeyCaption (False);
        end;
        else begin
          Inherited BtnClick (Index,FALSE);
          if Confirmed then
            case Index of
              nbInsert : Insert;
              nbDelete : Delete;
              nbEdit   : Edit;
              nbCancel : Cancel;
              nbPost   : Post;
            end;
          end;
      end;
    end;
  end;
  if (not (csDesigning in ComponentState)) and Assigned(FOnNavClick) then FOnNavClick(Self, Index);
end;

procedure TRGNavigator.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if not (csLoading in ComponentState) then begin
    ActiveChanged;
  end;
end;

procedure TRGNavigator.ActiveChanged;
begin
  GetKeyNames;
end;

function TRGNavigator.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TRGNavigator.GetKeyNames;
begin
  if (assigned (FDataLink)) then  { Get Index Names }
    with FDataLink do
      if DataSet is TTable then
        with DataSet as TTable do begin
          IndexList.Clear;
          if Active then GetIndexNames (IndexList);
          SetKeyCaption (True);
        end;
end;

procedure TRGNavigator.SetKeyCaption (Initialise : Boolean);
begin
  with IndexList do begin
    if Initialise then begin
      KeyNumber := Count-1;
      while KeyNumber >= 0 do begin
        if TTable(FDataLink.DataSet).IndexName = Strings[KeyNumber] then exit;
        dec (KeyNumber);
      end;
    end;
    if (Count > 0) and (KeyNumber < Count) and (KeyNumber >= 0) then begin
      Buttons [nbKey].Caption := WordCase (IndexList.Strings[KeyNumber]);
      TTable(FDataLink.DataSet).IndexName := Strings[KeyNumber];
    end;
  end;
end;

procedure TRGNavigator.Loaded;
begin
  inherited Loaded;
  IndexList.Clear;
  if (assigned (FDataLink)) then  { Get Index Names }
    with FDataLink do
      if DataSet is TTable then
        if Active then GetKeyNames;
end;

{ TNavDataLink }

constructor TNavDataLink.Create(ANav: TRGNavigator);
begin
  inherited Create;
  FNavigator := ANav;
end;

destructor TNavDataLink.Destroy;
begin
  FNavigator := nil;
  inherited Destroy;
end;

procedure TNavDataLink.UpdateNavigator;
begin
  if FNavigator <> nil then
    with FNavigator do begin
      DLActive  := Active;
      DLEditing := Editing;
      if DataSet <> nil then DLCanModify := DataSet.CanModify;
    end;
end;

procedure TNavDataLink.EditingChanged;
begin
  UpdateNavigator;
  if FNavigator <> nil then FNavigator.EditingChanged;
end;

procedure TNavDataLink.DataSetChanged;
begin
  UpdateNavigator;
  if FNavigator <> nil then
    with FNavigator, DataSet do begin
      DLBOF := BOF;
      DLEOF := EOF;
    end;
  if FNavigator <> nil then FNavigator.DataChanged;
end;

procedure TNavDataLink.ActiveChanged;
begin
  UpdateNavigator;
  if FNavigator <> nil then FNavigator.ActiveChanged;
end;

procedure Register;
begin
  RegisterComponents('AddOn', [TRGNavigator]);
//  RegisterComponents('AddOn', [TNavDataLink]);
end;

end.
