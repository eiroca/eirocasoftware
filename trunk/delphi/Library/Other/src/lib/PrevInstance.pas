{==============================================================================}
{= PrevInst Unit Version 1.0                                                  =}
{=                                                                            =}
{= The TMgPrevInstance component is a 16/32 bit non-visual component which    =}
{= checks for other instances of the current EXE running. Once a specified    =}
{= number of instances is exceeded, an event id fired and optionally the last =}
{= of the other instances is brought to the front of the windows Z-order.     =}
{=                                                                            =}
{= Copyright © 1997 by Malcolm Groves.                                        =}
{==============================================================================}
{= History                                                                    =}
{=   13/06/96  v1.0 Initial Version                                           =}
{=   20/03/97  v1.1 Fixed up some 16 bit incompatibilities.                   =}
{=                  (Thanks to Joe from Uni. of Vienna for pointing them out) =}
{==============================================================================}
unit PrevInstance;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TmgFoundAction = (mgfaRestoreAndQuit, mgfaRestore, mgfaQuit, mgfaNone);
  TOnAllowedInstancesExceededEvent = procedure(Sender : TObject;
                                               InstanceCount : Integer;
                                               var Action : TmgFoundAction) of Object;
  TMgPrevInstance = class(TComponent)
  private
    { Private declarations }
    FAllowedInstances : integer;
    FFoundAction : TmgFoundAction;
    FOnAllowedInstancesExceeded : TOnAllowedInstancesExceededEvent;
    procedure CheckPrevInstances;
    procedure Loaded; override;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    Property Name;
    Property Tag;
    property AllowedInstances : integer
      read FAllowedInstances
      write FAllowedInstances;
    property FoundAction : TmgFoundAction
      read FFoundAction
      write FFoundAction;
    property OnAllowedInstancesExceeded : TOnAllowedInstancesExceededEvent
      read FOnAllowedInstancesExceeded
      write FOnAllowedInstancesExceeded;
  end;

procedure Register;
function LookAtAllWindows(Handle: HWnd; Temp: Longint): BOOL; {$ifdef WIN32} stdcall {$ELSE} export {$ENDIF};

implementation
var
  MyAppName : Array[0..255] of Char;
  MyClassName : Array[0..255] of Char;
  NumFound  : Integer;
  LastFound : HWnd;
  MyPopup : HWnd;


constructor TMgPrevInstance.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAllowedInstances := 1;
  FFoundAction := mgfaRestoreAndQuit;
end;

destructor TMgPrevInstance.Destroy;
begin
  inherited Destroy;
end;


procedure TMgPrevInstance.Loaded;
begin
  inherited Loaded;	{ always call the inherited method first }
  {if run-time check for previous instances}
  if not (csDesigning in ComponentState) then
    CheckPrevInstances;

end;


function LookAtAllWindows(Handle: HWnd; Temp: Longint): BOOL;
var
  WindowName  : Array[0..255] of Char;
  ClassName : Array[0..255] of Char;
begin
  Result:= true;
  if GetClassName(Handle, ClassName, SizeOf(ClassName)) > 0 then
    if StrComp(ClassName, MyClassName) = 0 then
      if GetWindowText(Handle, WindowName, SizeOf(WindowName)) > 0 then
        if StrComp(WindowName, MyAppName) = 0 then
        begin
          inc(NumFound);
          if Handle <> Application.Handle then
            LastFound := Handle;
        end;
end;


procedure TMgPrevInstance.CheckPrevInstances;
begin
  NumFound := 0;
  LastFound := 0;
  GetWindowText(Application.Handle, MyAppName, SizeOf(MyAppName));
  GetClassName(Application.Handle, MyClassName, SizeOf(MyClassName));
  EnumWindows(@LookAtAllWindows,0);
  if NumFound > AllowedInstances then
  begin
    if Assigned(FOnAllowedInstancesExceeded) then
      FOnAllowedInstancesExceeded(Self, NumFound, FFoundAction);

    if (FFoundAction = mgfaRestore) or (FFoundAction = mgfaRestoreAndQuit) then
    begin
      MyPopup := GetLastActivePopup(LastFound);
      BringWindowToTop(LastFound);
      if IsIconic(MyPopup) then
        ShowWindow(MyPopup, SW_RESTORE)
      else
        BringWindowToTop(MyPopup);
    end;

    if (FFoundAction = mgfaQuit) or (FFoundAction = mgfaRestoreAndQuit) then
      Halt(0);
  end;
end;

procedure Register;
begin
  RegisterComponents('AddOn', [TMgPrevInstance]);
end;

end.
