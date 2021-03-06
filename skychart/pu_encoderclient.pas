unit pu_encoderclient;

{$MODE Delphi}

{****************************************************************
Copyright (C) 2000 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
****************************************************************}

{------------- interface for ouranos like system. ----------------------------

PJ Pallez Nov 1999
Patrick Chevalley Aug 2000, 2011

will work with all systems using same protocol
(Ouranos, NGC MAX,MicroGuider,..)

-------------------------------------------------------------------------------}

interface

uses u_help, u_translation, UScaleDPI,
  Messages, SysUtils, Classes, Graphics, Controls, u_constant,
  Forms, Dialogs, u_projection, u_util,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls, EnhEdits;

type
  Tpop_encoder = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    LabelAlpha: TLabel;
    LabelDelta: TLabel;
    pos_x: TEdit;
    pos_y: TEdit;
    GroupBox1: TGroupBox;
    SpeedButton4: TSpeedButton;
    Label1: TLabel;
    list_init: TListView;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    cbo_type: TComboBox;
    led: TEdit;
    res_x: TEdit;
    res_y: TEdit;
    GroupBox3: TGroupBox;
    led1: TEdit;
    SpeedButton1: TSpeedButton;
    SaveButton1: TButton;
    az_x: TEdit;
    alt_y: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    TabSheet3: TTabSheet;
    GroupBox4: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    PortSpeedbox: TComboBox;
    cbo_port: TComboBox;
    Paritybox: TComboBox;
    DatabitBox: TComboBox;
    StopbitBox: TComboBox;
    Label13: TLabel;
    TimeOutBox: TComboBox;
    Mounttype: TRadioGroup;
    Button2: TButton;
    ReadIntBox: TComboBox;
    Label14: TLabel;
    GroupBox5: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    lat: TEdit;
    long: TEdit;
    Panel2: TPanel;
    Label17: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton5: TSpeedButton;
    PopupMenu1: TPopupMenu;
    Delete1: TMenuItem;
    Timer1: TTimer;
    Panel3: TPanel;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    IntTimeOutBox: TComboBox;
    Label21: TLabel;
    StatusBar1: TStatusBar;
    GroupBox7: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Z1T: TFloatEdit;
    Z2T: TFloatEdit;
    Z3T: TFloatEdit;
    init90: TSpeedButton;
    status: TSpeedButton;
    InitType: TRadioGroup;
    CheckBox3: TCheckBox;
    SpeedButton6: TSpeedButton;
    CheckBox4: TCheckBox;
    {Ouranos compatible IO}
    procedure query_encoder;
    {Utility and form functions}
    procedure formcreate(Sender: TObject);
    procedure kill(Sender: TObject; var CanClose: boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure setresClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    function str2ra(s: string): double;
    function str2dec(s: string): double;
    procedure Encoder_Error;
    procedure statusClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SaveButton1Click(Sender: TObject);
    procedure ReadIntBoxChange(Sender: TObject);
    procedure latChange(Sender: TObject);
    procedure longChange(Sender: TObject);
    procedure MounttypeClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure list_initMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Delete1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure init90Click(Sender: TObject);
    procedure InitTypeClick(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);

  private
    { Private declarations }
    FConfig: string;
    procedure InitObject(Source: string; alpha, delta: double);
    procedure SetRes;
    procedure Clear_Init_List;
    procedure AffMsg(msgtxt: string);
    procedure GetSideralTime;
    procedure ComputeCoord(p1, p2: PInit_object; x, y: integer;
      var alpha, delta: double);
    procedure GetCoordinates;
    procedure ShowCoordinates;
    procedure QueryStatus;

  public
    { Public declarations }
    csc: Tconf_skychart;
    X_List, Y_List, Istatus: integer;
    theta0, phi0: double;
    g_ok: boolean;
    wait_create: boolean;
    first_show: boolean;
    Init90Y: integer;
    procedure SetLang;
    function ReadConfig(ConfigPath: shortstring): boolean;
    procedure SetRefreshRate(rate: integer);
    procedure ScopeShow;
    procedure ScopeShowModal(var ok: boolean);
    procedure ScopeConnect(var ok: boolean);
    procedure ScopeDisconnect(var ok: boolean);
    procedure ScopeGetInfo(var Name: shortstring; var QueryOK, SyncOK, GotoOK: boolean;
      var refreshrate: integer);
    procedure ScopeSetObs(la, lo: double);
    procedure ScopeAlign(Source: string; ra, Dec: double);
    procedure ScopeGetRaDec(var ar, de: double; var ok: boolean);
    procedure ScopeGetAltAz(var alt, az: double; var ok: boolean);
    procedure ScopeGoto(ar, de: double; var ok: boolean);
    procedure ScopeReset;
    function ScopeInitialized: boolean;
    function ScopeConnected: boolean;
    procedure ScopeClose;
    procedure ScopeGetEqSys(var EqSys: double);
    procedure ScopeReadConfig(ConfigPath: shortstring);
  end;


implementation

{$R *.lfm}
uses
  cu_encoderprotocol,
  cu_serial,
  cu_taki;

procedure Tpop_encoder.SetRefreshRate(rate: integer);
begin
  Timer1.Interval := rate;
  ReadIntBox.Text := IntToStr(rate);
end;

procedure Tpop_encoder.ScopeConnect(var ok: boolean);
begin
  SetRes;
  ok := (led.color = clLime);
end;

procedure Tpop_encoder.ScopeDisconnect(var ok: boolean);
begin
  timer1.Enabled := False;
  ok := Encoder_Close;
  if ok then
  begin
    led.color := clRed;
    led1.color := clRed;
  end;
  Clear_Init_List;
  pos_x.Text := '';
  pos_y.Text := '';
  az_x.Text := '';
  alt_y.Text := '';
  Alpha_Inversion := False;
  Delta_Inversion := False;
  Init90Y := 999999;
  init90.font.color := clWindowText;
end;

procedure Tpop_encoder.ScopeClose;
begin
  Release;
end;

function Tpop_encoder.ScopeConnected: boolean;
begin
  while wait_create do
    Application.ProcessMessages;
  Result := (led.color = clLime);
end;

function Tpop_encoder.ScopeInitialized: boolean;
begin
  while wait_create do
    Application.ProcessMessages;
  Result := (init_objects.Count >= 2);
end;

procedure Tpop_encoder.ScopeAlign(Source: string; ra, Dec: double);
begin
  InitObject(copy(Source, 1, 9), 15 * ra, Dec);
end;

procedure Tpop_encoder.ScopeShowModal(var ok: boolean);
begin
  showmodal;
  ok := (modalresult = mrOk);
end;

procedure Tpop_encoder.ScopeShow;
begin
  while wait_create do
    Application.ProcessMessages;
  Show;
  PageControl1.ActivePageIndex := 0;
  PageControl1.Invalidate;
end;

procedure Tpop_encoder.ScopeGetRaDec(var ar, de: double; var ok: boolean);
begin
  if (init_objects.Count >= 2) then
  begin
    ar := curdeg_x / 15;
    de := curdeg_y;
    ok := True;
  end
  else
  begin
    ar := 0;
    de := 0;
    ok := False;
  end;
end;

procedure Tpop_encoder.ScopeGetAltAz(var alt, az: double; var ok: boolean);
begin
  if (init_objects.Count >= 2) then
  begin
    alt := cur_alt;
    az := cur_az;
    ok := True;
  end
  else
  begin
    alt := 0;
    az := 0;
    ok := False;
  end;
end;

procedure Tpop_encoder.ScopeGetInfo(var Name: shortstring;
  var QueryOK, SyncOK, GotoOK: boolean; var refreshrate: integer);
begin
  while wait_create do
    Application.ProcessMessages;
  Name := cbo_type.Text;
  QueryOK := True;
  SyncOK := True;
  GotoOK := False;
  refreshrate := Timer1.Interval;
end;

procedure Tpop_encoder.ScopeReset;
begin
  Clear_Init_List;
end;

procedure Tpop_encoder.ScopeSetObs(la, lo: double);
begin
  lat.Text := floattostr(la);
  long.Text := floattostr(lo);
  latitude := la;
  longitude := lo;
end;

procedure Tpop_encoder.ScopeGoto(ar, de: double; var ok: boolean);
begin
  ok := False;
end;

procedure Tpop_encoder.ScopeGetEqSys(var EqSys: double);
begin
  // always current date
  EqSys := 0;
end;

procedure Tpop_encoder.ScopeReadConfig(ConfigPath: shortstring);
begin
  ReadConfig(ConfigPath);
end;

{-------------------------------------------------------------------------------

                                  Coordinates functions

--------------------------------------------------------------------------------}

procedure Tpop_encoder.GetSideralTime;
var
  y, m, d: word;
  jd0, ut: double;
  n: TDateTime;
begin
  n := csc.tz.NowUTC;
  decodedate(n, y, m, d);
  ut := frac(n) * 24;
  jd0 := jd(y, m, d, 0);
  Sideral_Time := SidTim(jd0, ut, csc.ObsLongitude, csc.eqeq);   // in radian
end;

procedure Tpop_encoder.ComputeCoord(p1, p2: PInit_object; x, y: integer;
  var alpha, delta: double);
var
  theta, phi, tim, tim0, tim1, tim2: double;
begin
  if p2.time > p1.time then
  begin
    tim0 := p1.time;
    tim1 := 0;
    tim2 := (p2.time - p1.time) * 1440;
  end
  else
  begin
    tim0 := p2.time;
    tim1 := (p1.time - p2.time) * 1440;
    tim2 := 0;
  end;

  cu_taki.Reset(Z1T.Value, Z2T.Value, Z3T.Value);
  if Delta_Inversion then
    theta := theta0 - p1.theta
  else
    theta := p1.theta - theta0;
  if Alpha_Inversion then
    phi := phi0 - p1.phi
  else
    phi := p1.phi - phi0;
  cu_taki.AddStar(p1.alpha, p1.delta, tim1, phi, theta);
  if Delta_Inversion then
    theta := theta0 - p2.theta
  else
    theta := p2.theta - theta0;
  if Alpha_Inversion then
    phi := phi0 - p2.phi
  else
    phi := p2.phi - phi0;
  cu_taki.AddStar(p2.alpha, p2.delta, tim2, phi, theta);

  theta := y * scaling_y + 180;
  phi := x * scaling_x + 180;
  tim := (now - tim0) * 1440;
  if Delta_Inversion then
    theta := theta0 - theta
  else
    theta := theta - theta0;
  if Alpha_Inversion then
    phi := phi0 - phi
  else
    phi := phi - phi0;
  cu_taki.Tel2Equ(phi, theta, tim, alpha, delta);
end;

procedure Tpop_encoder.GetCoordinates;
var
  j, n, m, py: integer;
  p1, p2: PInit_object;
  pos: Tpoint;
  alpha, delta, dista, disti, d: double;
  msg: string;
begin
  try
    if init_objects.Count < 2 then
    begin
      AffMsg(rsTWOStarsMust);
      exit;
    end;
    if not Encoder_query(curstep_x, curstep_y, msg) then
    begin
      AffMsg(msg);
      Encoder_Error;
      exit;
    end;
    { approx. coordinates using last init. star}
    ComputeCoord(Last_p1, Last_p2, curstep_x, curstep_y, alpha, delta);
    { search nearest and farest init star }
    n := init_objects.Count - 1;
    m := 0;
    dista := High(integer);
    disti := 0;
    for j := 0 to init_objects.Count - 1 do
    begin
      p1 := init_objects[j];
      d := rad2deg * angulardistance(deg2rad * alpha, deg2rad * delta, deg2rad *
        p1.alpha, deg2rad * p1.delta);
      if d < dista then
      begin
        n := j;
        dista := d;
      end;
      if d > disti then
      begin
        m := j;
        disti := d;
      end;
      list_init.Items.Item[j].SubItems.Strings[3] := '   ';
    end;
    if n > m then
    begin   // respect time order
      j := m;
      m := n;
      n := j;
    end;
    { mark used star in list }
    list_init.Items.Item[n].SubItems.Strings[3] := ' * ';
    list_init.Items.Item[m].SubItems.Strings[3] := ' * ';
    pos := list_init.Items.Item[n].Position;
    py := pos.y;
    pos := list_init.TopItem.Position;
    py := py - pos.y;
    //list_init.Scroll(0,py); // lazarus

    {compute instrumental coordinates}
    p1 := init_objects[n];
    p2 := init_objects[m];
    Last_p1 := p1;
    Last_p2 := p2;
    ComputeCoord(p1, p2, curstep_x, curstep_y, curdeg_x, curdeg_y);
    {convert to alt-az pos}
    GetSideralTime;
    Eq2Hz(sideral_time - deg2rad * curdeg_x, deg2rad * curdeg_y, cur_az, cur_alt, csc);
    cur_az := rmod(rad2deg * cur_az + 180, 360);
    cur_alt := rad2deg * cur_alt;
    { clean RA }
    curdeg_x := rmod(curdeg_x + 720, 360);
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) +
        ' Coord : S1:' + IntToStr(n) + ' S2:' + IntToStr(m) +
        ' X:' + IntToStr(curstep_x) + ' Y:' + IntToStr(curstep_y) + ' T:' + floattostr(now) +
        ' RA:' + floattostr(curdeg_x) + ' DEC:' + floattostr(curdeg_y) +
        ' AZ:' + floattostr(cur_az) + ' ALT:' + floattostr(cur_alt));
  except
    curdeg_x := 0;
    curdeg_y := 0;
    cur_az := 0;
    cur_alt := 0;
  end;
end;

{-------------------------------------------------------------------------------

                                  Utility functions

--------------------------------------------------------------------------------}

procedure Tpop_encoder.Encoder_Error;
begin
  Inc(num_error);
  if num_error > max_error then
    ScopeDisconnect(g_OK);
end;

function Tpop_encoder.str2ra(s: string): double;
var
  h, m, ss: integer;
begin
  h := StrToInt(copy(s, 19, 2));
  m := StrToInt(copy(s, 22, 2));
  ss := StrToInt(copy(s, 25, 1)); // tenth of minute
  Result := 15 * ((h) + (m / 60) + (ss / 600));
end;

function Tpop_encoder.str2dec(s: string): double;
var
  sgn, d, m: integer;
begin
  d := StrToInt(copy(s, 27, 3));
  if d < 0 then
    sgn := -1
  else
    sgn := 1;
  m := StrToInt(copy(s, 31, 2));
  Result := sgn * (abs(d) + (m / 60));
end;

procedure Tpop_encoder.Clear_Init_List;
begin
  initialised := False;
  list_init.items.Clear;
  init_objects.Clear;
end;


{-------------------------------------------------------------------------------

                                  Form functions

--------------------------------------------------------------------------------}

procedure Tpop_encoder.SetLang;
begin
  Caption := rsObsolete + ': ' + rsEncoders;
  TabSheet1.Caption := rsCoordinates;
  Label11.Caption := rsAzimuth;
  Label12.Caption := rsAltitude;
  CheckBox2.Caption := rsDeviceStatus;
  Label18.Caption := rsXErrors;
  Label19.Caption := rsYErrors;
  Label20.Caption := rsBattery;
  status.Caption := rsStatus;
  SpeedButton4.Caption := rsClear;
  Label1.Caption := rsObjectsUsedF;
  SpeedButton1.Caption := rsConnect;
  SpeedButton5.Caption := rsDisconnect;
  SpeedButton2.Caption := rsHide;
  SpeedButton6.Caption := rsHelp;
  TabSheet2.Caption := rsEncoderConfi;
  GroupBox2.Caption := rsEncoderConfi;
  Label2.Caption := rsType2;
  Label3.Caption := rsStepsAlpha;
  Label4.Caption := rsStepsDelta;
  Label14.Caption := rsReadInterval;
  Label6.Caption := rsConnected;
  Mounttype.Caption := rsMountType;
  Mounttype.Items[0] := rsEquatorial;
  Mounttype.Items[1] := rsAltAz;
  InitType.Caption := rsEncoderIniti;
  GroupBox7.Caption := rsMountFabrica;
  GroupBox5.Caption := rsObservatory;
  Label15.Caption := rsLatitude;
  Label16.Caption := rsLongitude;
  CheckBox3.Caption := rsRecordProtoc;
  CheckBox4.Caption := rsFormAlwaysVi;
  SaveButton1.Caption := rsSaveSetting;
  TabSheet3.Caption := rsPortConfigur;
  GroupBox4.Caption := rsPortConfigur;
  Label5.Caption := rsSerialPort;
  Label7.Caption := rsSpeed;
  Label9.Caption := rsDataBits;
  Label8.Caption := rsParity;
  Label10.Caption := rsStopBits;
  Label13.Caption := rsTimeoutMs;
  Label21.Caption := rsIntervalTime;
  Button2.Caption := rsSaveSetting;

  SetHelp(self, hlpEncoder);
end;

procedure Tpop_encoder.AffMsg(msgtxt: string);
begin
  if msgtxt <> '' then
  begin
    Istatus := 10000 div Timer1.Interval;
    Beep;
  end;
  statusbar1.SimpleText := msgtxt;
  statusbar1.Refresh;
end;

procedure Tpop_encoder.formcreate(Sender: TObject);
begin
  ScaleDPI(Self);
  wait_create := True;
  first_show := True;
  Init90Y := 999999;
  init_objects := TList.Create;
  wait_create := False;
end;

function Tpop_encoder.ReadConfig(ConfigPath: shortstring): boolean;
var
  ini: tinifile;
  newcolumn: tlistcolumn;
  nom: string;
begin
  Result := DirectoryExists(ConfigPath);
  if Result then
    FConfig := slash(ConfigPath) + 'scope.ini'
  else
    FConfig := slash(extractfilepath(ParamStr(0))) + 'scope.ini';
  ini := tinifile.Create(FConfig);
  res_x.Text := ini.readstring('encoders', 'res_x', '2000');
  res_y.Text := ini.readstring('encoders', 'res_y', '2000');
  nom := ini.readstring('encoders', 'name', 'Ouranos');
  cbo_type.Text := nom;
  ReadIntBox.Text := ini.readstring('encoders', 'read_interval', '1000');
  cbo_port.Text := ini.readstring('encoders', 'comport', DefaultSerialPort);
  PortSpeedbox.Text := ini.readstring('encoders', 'baud', '9600');
  DatabitBox.Text := ini.readstring('encoders', 'databits', '8');
  Paritybox.Text := ini.readstring('encoders', 'parity', 'N');
  StopbitBox.Text := ini.readstring('encoders', 'stopbits', '1');
  TimeOutBox.Text := ini.readstring('encoders', 'timeout', '1000');
  IntTimeOutBox.Text := ini.readstring('encoders', 'inttimeout', '400');
  lat.Text := ini.readstring('observatory', 'latitude', '0');
  long.Text := ini.readstring('observatory', 'longitude', '0');
  MountType.ItemIndex := ini.ReadInteger('encoders', 'mount', 0);
  InitType.ItemIndex := ini.ReadInteger('encoders', 'initpos', 1);
  Z1T.Text := ini.Readstring('encoders', 'mount_Z1', '0');
  Z2T.Text := ini.Readstring('encoders', 'mount_Z2', '0');
  Z3T.Text := ini.Readstring('encoders', 'mount_Z3', '0');
  Checkbox4.Checked := ini.ReadBool('encoders', 'AlwaysVisible', True);
  ini.Free;
  with list_init do
  begin
    newcolumn := columns.add;
    newcolumn.Caption := rsName;
    newcolumn.Width := 70;
    newcolumn := columns.add;
    newcolumn.Caption := 'Alpha';
    newcolumn.Width := 60;
    newcolumn := columns.add;
    newcolumn.Caption := 'Delta';
    newcolumn.Width := 60;
    newcolumn := columns.add;
    newcolumn.Caption := rsTime;
    newcolumn.Width := 40;
    newcolumn := columns.add;
    newcolumn.Caption := rsSel;
    newcolumn.Width := 30;
  end;
  Timer1.Interval := strtointdef(ReadIntBox.Text, 1000);
  ReadIntBox.Text := IntToStr(Timer1.Interval);
  First_Show := False;
end;


procedure Tpop_encoder.kill(Sender: TObject; var CanClose: boolean);
begin
  if port_opened then
  begin
    canclose := False;
    hide;
  end;
end;


procedure Tpop_encoder.Timer1Timer(Sender: TObject);
begin
  if port_opened and resolution_sent then
    query_encoder;
end;



procedure Tpop_encoder.SpeedButton1Click(Sender: TObject);
begin
  query_encoder;
end;


procedure Tpop_encoder.statusClick(Sender: TObject);
{gives the status of the system}
var
  s1, s2, s3, s4, s5: string;
  a: double;
  b: integer;
begin
  Affmsg('');
  if port_opened then
    s1 := rsConnected
  else
    s1 := rsDiconnected;
  if resolution_sent then
    s2 := Format(rsResolutionXY, [IntToStr(reso_x), IntToStr(reso_y)])
  else
    s2 := '';
  if alpha_inversion then
    s4 := rsInversionAlp
  else
    s4 := '';
  if delta_inversion then
    s4 := Format(rsInversionDel, [s4]);
  if init90y = 999999 then
    s5 := rsVerticalAxis2
  else
    s5 := Format(rsVerticalAxis, [IntToStr(init90y)]);
  if initialised then
  begin
    a := last_init_alpha - trunc(last_init_alpha);
    b := trunc(last_init_alpha / 15);
    s3 := Format(rsInitialisedA, [last_init, #13#10, #13#10,
      last_init_target, artostr(b + a), detostr(last_init_delta)]);
  end
  else
  begin
    s3 := rsNotInitialis;
  end;
  if checkbox4.Checked then
    formstyle := fsNormal;
  messagedlg(rsSytemStatus + #13#10#13#10 + cbo_port.Text + s1 +
    #13#10 + s2 + #13#10 + s3 + #13#10 + s4 + #13#10 + s5 + #13#10, mtInformation, [mbOK], 0);
  if checkbox4.Checked then
    formstyle := fsStayOnTop;
end;

procedure Tpop_encoder.ShowCoordinates;
var
  msg: string;
begin
  if (init_objects.Count >= 2) then
  begin
    GetCoordinates;
    pos_x.Text := armtostr(Curdeg_x / 15);
    pos_y.Text := demtostr(Curdeg_y);
    az_x.Text := demtostr(Cur_az);
    alt_y.Text := demtostr(Cur_alt);
    if Cur_alt < 0 then
      alt_y.Color := clRed
    else
      alt_y.Color := clWindow;
  end
  else if MountType.ItemIndex = 0 then
  begin
    if not Encoder_query(curstep_x, curstep_y, msg) then
    begin
      AffMsg(msg);
      Encoder_Error;
      exit;
    end;
    pos_x.Text := IntToStr(curstep_x);
    pos_y.Text := IntToStr(curstep_y);
    az_x.Text := '';
    alt_y.Text := '';
  end
  else
  begin
    if not Encoder_query(curstep_x, curstep_y, msg) then
    begin
      AffMsg(msg);
      Encoder_Error;
      exit;
    end;
    pos_x.Text := '';
    pos_y.Text := '';
    az_x.Text := IntToStr(curstep_x);
    alt_y.Text := IntToStr(curstep_y);
  end;
end;

procedure Tpop_encoder.SpeedButton4Click(Sender: TObject);
begin
  Affmsg('');
  Clear_Init_List;
  Alpha_Inversion := False;
  Delta_Inversion := False;
end;

procedure Tpop_encoder.setresClick(Sender: TObject);
begin
  SetRes;
  Alpha_Inversion := False;
  Delta_Inversion := False;
end;

procedure Tpop_encoder.SetRes;
var
  i, x, y: integer;
  msg: string;
begin
  Affmsg('');
  {Connect and Sets the Resolution.}
  led.color := clRed;
  led.refresh;
  led1.color := clRed;
  led1.refresh;
  timer1.Enabled := False;
  Clear_Init_List;
  Init90Y := 999999;
  init90.font.color := clWindowText;
  if debug then
  begin
    writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) +
      ' ObsLat:' + floattostr(csc.ObsLatitude) + ' ObsLong:' +
      floattostr(csc.ObsLongitude));
    writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) +
      ' ResolX:' + res_x.Text + ' ResolY:' + res_y.Text +
      ' Z1:' + z1t.Text + ' Z2:' + z2t.Text + ' Z3:' + z3t.Text);
  end;
  try
    if Encoder_Open(trim(cbo_type.Text), trim(cbo_port.Text), PortSpeedbox.Text,
      Paritybox.Text, DatabitBox.Text, StopbitBox.Text, TimeOutBox.Text, IntTimeOutBox.Text) and
      Encoder_Query(x, y, msg) then
    begin
      reso_x := StrToInt(res_x.Text);
      reso_y := StrToInt(res_y.Text);
      i := 0;
      repeat
        Encoder_Set_Resolution(reso_x, reso_y);
        Encoder_Init(reso_x div 2, reso_y div 2);
        Encoder_Query(x, y, msg);
        Inc(i);
        sleep(100);
      until ((x = 0) and (y = 0)) or (i > 3);
      //   Encoder_Set_Init_Flag;
      {Calculate how much an encoder step means in degrees}
      scaling_x := 360 / reso_x;
      scaling_y := 360 / reso_y;
      resolution_sent := True;
      led.color := clLime;
      led1.color := clLime;
      timer1.Enabled := True;
    end
    else
    begin
      AffMsg(msg);
      Encoder_Close;
      Affmsg(Format(rsErrorOpening2, [cbo_type.Text, cbo_port.Text]));
    end;
  finally

  end;
end;

procedure Tpop_encoder.InitObject(Source: string; alpha, delta: double);
{Add a point to the initialisation list.}
var
  p, q: Pinit_object;
  listitem: tlistitem;
  s1, s2: integer;
  a1, d1: double;
  inittime: Tdatetime;
  msg: string;
begin
  {Check if Resolution has been set}
  if port_opened and resolution_sent then
  begin
    {Check if scope level is set}
    if Init90Y = 999999 then
    begin
      Affmsg(rsPleaseInitTh);
      exit;
    end;
    ;
    {be sure we have the current steps}
    if not timer1.Enabled then
      if not Encoder_query(curstep_x, curstep_y, msg) then
      begin
        AffMsg(msg);
        Encoder_Error;
        exit;
      end;
    {be sure first two initialisation are valid}
    if init_objects.Count = 1 then
    begin
      q := init_objects[0];
      if (abs(q.steps_x - curstep_x) < 5) or (abs(q.steps_y - curstep_y) < 5) then
      begin
        Affmsg(rsPleaseMoveTh);
        exit;
      end;
    end;
    {... store information in global vars and Tlist}
    inittime := now;
    last_init := datetimetostr(inittime);
    last_init_target := Source;
    last_init_alpha := alpha;
    last_init_delta := delta;
    new(p);
    with list_init do
    begin
      listitem := items.add;
      listitem.Caption := Source;
      listitem.subitems.add(copy(armtostr(alpha / 15), 2, 99));
      listitem.subitems.add(demtostr(delta));
      listitem.subitems.add(formatdatetime('hh:nn', inittime));
      listitem.subitems.add('   ');
      {stores the pointer in new column item}
      listitem.Data := p;
    end;
    { store information }
    p.Name := Source;
    p.alpha := alpha;
    p.delta := delta;
    p.time := inittime;
    p.steps_x := curstep_x;
    p.steps_y := curstep_y;
    p.error := 0;
    p.theta := p.steps_y * scaling_y + 180;
    p.phi := p.steps_x * scaling_x + 180;
    GetSideralTime;
    Eq2Hz(sideral_time - deg2rad * p.alpha, deg2rad * p.delta, a1, d1, csc);
    p.az := 360 - rmod(rad2deg * a1 + 180, 360);
    p.alt := rad2deg * d1;

    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) +
        ' Align : ' + IntToStr(init_objects.Count) + ' ' + p.Name +
        ' RA:' + floattostr(p.alpha) + ' DEC:' + floattostr(p.delta) + ' T:' + floattostr(p.time) +
        ' X: ' + IntToStr(p.steps_x) + ' Y: ' + IntToStr(p.steps_y) +
        ' TH:' + floattostr(p.theta) + ' PHI:' + floattostr(p.phi) +
        ' AZ:' + floattostr(p.az) + ' ALT:' + floattostr(p.alt));

    if init_objects.Count = 1 then
    begin    // set axis direction
      q := init_objects[0];
      // Find any encoder inversion
      case MountType.ItemIndex of
        0:
        begin   //  Equatorial mount
          s1 := trunc(sgn(q.alpha - p.alpha));
          s2 := trunc(sgn(q.phi - p.phi));
          if s1 = s2 then
            Alpha_Inversion := False
          else
            Alpha_Inversion := True;
          if abs(q.phi - p.phi) > 180 then
            Alpha_Inversion := not Alpha_Inversion;
          if abs(q.alpha - p.alpha) > 180 then
            Alpha_Inversion := not Alpha_Inversion;
          s1 := trunc(sgn(q.delta - p.delta));
          s2 := trunc(sgn(q.theta - p.theta));
          if s1 = s2 then
            Delta_Inversion := False
          else
            Delta_Inversion := True;
          if abs(q.theta - p.theta) > 180 then
            Delta_Inversion := not Delta_Inversion;
          if Delta_Inversion then
            theta0 := (Init90Y * scaling_y + 180) + 90 * inittype.ItemIndex
          else
            theta0 := (Init90Y * scaling_y + 180) - 90 * inittype.ItemIndex;
          if Alpha_Inversion then
            phi0 := p.phi + p.alpha
          else
            phi0 := p.phi - p.alpha;
          if debug then
          begin
            writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) +
              ' Equatorial mount' + ' INITPOS:' + IntToStr(
              init90y) + ' INIT :' + IntToStr(inittype.ItemIndex) +
              ' TH0:' + floattostr(theta0) + ' PHI0:' + floattostr(phi0));
            if Delta_Inversion then
              writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Delta_Inversion : True')
            else
              writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Delta_Inversion : False');
            if Alpha_Inversion then
              writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Alpha_Inversion : True')
            else
              writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Alpha_Inversion : False');
          end;
        end;
        1:
        begin   // AltAZ mount
          s1 := trunc(sgn(q.az - p.az));
          s2 := trunc(sgn(q.phi - p.phi));
          if s1 = s2 then
            Alpha_Inversion := False
          else
            Alpha_Inversion := True;
          if abs(q.phi - p.phi) > 180 then
            Alpha_Inversion := not Alpha_Inversion;
          if abs(q.az - p.az) > 180 then
            Alpha_Inversion := not Alpha_Inversion;
          s1 := trunc(sgn(q.alt - p.alt));
          s2 := trunc(sgn(q.theta - p.theta));
          if s1 = s2 then
            Delta_Inversion := False
          else
            Delta_Inversion := True;
          if abs(q.theta - p.theta) > 180 then
            Delta_Inversion := not Delta_Inversion;
          if Delta_Inversion then
            theta0 := (Init90Y * scaling_y + 180) + 90 * inittype.ItemIndex
          else
            theta0 := (Init90Y * scaling_y + 180) - 90 * inittype.ItemIndex;
          if Alpha_Inversion then
            phi0 := p.phi + p.az
          else
            phi0 := p.phi - p.az;
          if debug then
          begin
            writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' AltAZ mount' +
              ' INITPOS:' + IntToStr(init90y) + ' INIT :' +
              IntToStr(inittype.ItemIndex) + ' TH0:' +
              floattostr(theta0) + ' PHI0:' + floattostr(phi0));
            if Delta_Inversion then
              writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Delta_Inversion : True')
            else
              writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Delta_Inversion : False');
            if Alpha_Inversion then
              writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Alpha_Inversion : True')
            else
              writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Alpha_Inversion : False');
          end;
        end;
      end;
    end;
    {store the checked data}
    init_objects.Add(p);
    if init_objects.Count = 1 then
      Last_p1 := p;
    if init_objects.Count = 2 then
      Last_p2 := p;
  end
  else
  begin
    Affmsg(rsTheInterface);
  end;
end;


procedure Tpop_encoder.QueryStatus;
var
  ex, ey: integer;
  batteryOK: boolean;
begin
  if GetDeviceStatus(ex, ey, batteryOK) then
  begin
    edit1.Text := IntToStr(ex);
    edit2.Text := IntToStr(ey);
    if batteryOK then
      edit3.color := clLime
    else
      edit3.color := clRed;
    Panel3.refresh;
  end;
end;

procedure Tpop_encoder.query_encoder;
{Just sends a 'Q' to the encoder interface.}
begin
  if not port_opened or not resolution_sent then
  begin
    led.color := clred;
    led1.color := clred;
    exit;
  end
  else
  begin
    if statusbar1.SimpleText <> '' then
    begin
      if Istatus <= 0 then
        Affmsg('')
      else
        Dec(Istatus);
    end;
    ShowCoordinates;
    if CheckBox2.Checked then
      QueryStatus;
  end;
end;

procedure Tpop_encoder.SaveButton1Click(Sender: TObject);
var
  ini: tinifile;
begin
  ini := tinifile.Create(FConfig);
  ini.writestring('encoders', 'res_x', res_x.Text);
  ini.writestring('encoders', 'res_y', res_y.Text);
  ini.writestring('encoders', 'name', cbo_type.Text);
  ini.writestring('encoders', 'read_interval', ReadIntBox.Text);
  ini.writeinteger('encoders', 'mount', MountType.ItemIndex);
  ini.writeinteger('encoders', 'initpos', InitType.ItemIndex);
  ini.writestring('encoders', 'mount_Z1', Z1T.Text);
  ini.writestring('encoders', 'mount_Z2', Z2T.Text);
  ini.writestring('encoders', 'mount_Z3', Z3T.Text);
  ini.writestring('encoders', 'comport', cbo_port.Text);
  ini.writestring('encoders', 'baud', PortSpeedbox.Text);
  ini.writestring('encoders', 'databits', DatabitBox.Text);
  ini.writestring('encoders', 'parity', Paritybox.Text);
  ini.writestring('encoders', 'stopbits', StopbitBox.Text);
  ini.writestring('encoders', 'timeout', TimeOutBox.Text);
  ini.writestring('encoders', 'inttimeout', IntTimeOutBox.Text);
  ini.writebool('encoders', 'AlwaysVisible', checkbox4.Checked);
  ini.writestring('observatory', 'latitude', lat.Text);
  ini.writestring('observatory', 'longitude', long.Text);
  ini.Free;
end;

procedure Tpop_encoder.ReadIntBoxChange(Sender: TObject);
begin
  Timer1.Interval := strtointdef(ReadIntBox.Text, 1000);
end;

procedure Tpop_encoder.latChange(Sender: TObject);
var
  x: double;
  i: integer;
begin
  val(lat.Text, x, i);
  if i = 0 then
    latitude := x;
end;

procedure Tpop_encoder.longChange(Sender: TObject);
var
  x: double;
  i: integer;
begin
  val(long.Text, x, i);
  if i = 0 then
    longitude := x;
end;

procedure Tpop_encoder.MounttypeClick(Sender: TObject);
begin
  Clear_Init_List;
end;

procedure Tpop_encoder.SpeedButton5Click(Sender: TObject);
var
  ok: boolean;
begin
  Affmsg('');
  ScopeDisconnect(ok);
end;

procedure Tpop_encoder.SpeedButton2Click(Sender: TObject);
begin
  Hide;
end;

procedure Tpop_encoder.list_initMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  ht: THitTests;
begin
  if (button = mbRight) then
  begin
    ht := list_init.GetHitTestInfoAt(X, Y);
    if ht = [htOnLabel] then
    begin
      X_List := X;
      Y_List := Y;
      popupmenu1.popup(mouse.cursorpos.x, mouse.cursorpos.y);
    end;
  end;
end;

procedure Tpop_encoder.Delete1Click(Sender: TObject);
var
  lin: TlistItem;
  i: integer;
begin
  lin := list_init.GetItemAt(X_List, Y_List);
  if lin <> nil then
  begin
    i := lin.Index;
    init_objects.Delete(i);
    lin.Delete;
  end;
end;

procedure Tpop_encoder.FormShow(Sender: TObject);
begin
  InitTypeClick(Sender);
  GetSerialPorts(cbo_port);
end;

procedure Tpop_encoder.init90Click(Sender: TObject);
var
  msg: string;
begin
  if led1.color = clLime then
  begin
    {be sure we have the current steps}
    if not timer1.Enabled then
      if not Encoder_query(curstep_x, curstep_y, msg) then
      begin
        AffMsg(msg);
        Encoder_Error;
        exit;
      end;
    Init90Y := curstep_y;
    init90.Font.Color := clGreen;
  end;
end;

procedure Tpop_encoder.InitTypeClick(Sender: TObject);
begin
  case inittype.ItemIndex of
    0: Init90.Caption := Format(rsInit, ['0°']);
    1: Init90.Caption := Format(rsInit, ['90°']);
  end;
end;

procedure Tpop_encoder.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked then
  begin
    Initserialdebug('encoder_trace.txt');
    debug := True;
  end
  else
  begin
    CloseSerialDebug;
  end;
end;

procedure Tpop_encoder.SpeedButton6Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tpop_encoder.CheckBox4Click(Sender: TObject);
begin
  if first_show then
    exit;
  if checkbox4.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

end.
