unit lx200_lib;
{
Copyright (C) 2000 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

{------------- interface for LX200 system. ----------------------------
Contribution from :
PJ Pallez Nov 1999
Patrick Chevalley Oct 2000
-------------------------------------------------------------------------------}

interface

Uses Dialogs,SysUtils,Windows,Classes,Forms ;

{basic LX200 functions}
Function LX200_Open(model,commport,baud,parity,data,stop,timeout,inttimeout : string) : boolean;
Function LX200_Close : boolean;
Function LX200_QueryEQ(var RA,DEC : double) : boolean;
Function LX200_QueryAZ(var Az,Al : double) : boolean;
Function LX200_Slew : boolean;
Function LX200_Goto(RA,DEC : double) : boolean;
Function LX200_Sync : boolean;
Function LX200_SyncPos( RA,DEC : double) : boolean;
Function LX200_SetObs( Lat,Long,TZ : double; datenow : Tdatetime) : boolean;
Function LX200_SetSpeed(speed : integer) : boolean;
Function LX200_Move(direction : integer) : boolean;
Function LX200_StopDir(direction : integer) : boolean;
Function LX200_StopMove : boolean;
Procedure LX200_SetFormat(format : integer);
Function LX200_SwitchHighPrecision : string;
Function LX200_QueryHighPrecision : string;
Function LX200_SetFocusSteep(speed:char):boolean;
Function LX200_StartFocus(dir:char):boolean;
Function LX200_StopFocus:boolean;
function LX200_SetTimeDate : boolean;
function LX200_Parkscope : boolean;

Function DEToStr(de: Double; var d,m,s : string) : string;
Function ARToStr(ar: Double; var d,m,s : string) : string;
Function DEmToStr(de: Double; var d,m : string) : string;
Function ARmToStr(ar: Double; var d,m : string) : string;

const ValidPort='COM1 COM2 COM3 COM4 COM5 COM6 COM7 COM8';
      ValidModel :array[1..4] of string=('LX200','AutoStar','Magellan-II','Magellan-I');
      NumModel = 3;
      crlf = chr(13)+chr(10);
var
{system flags and statuses}
  port_opened   : boolean;            // Interface is opened
  initialised:boolean;                // Last Init operation was successful
  LX200_model : string;               // actual model
  LX200_type  : integer = 0;          // kind of protocol to use
  LX200_mode : string;                // alignement mode
  LX200_format : integer;             // 0 : short , 1 : long
  LX200_opened,LX200_UseHPP : boolean;
{Current values}
  curdeg_x,  curdeg_y :double;        // current equatorial position in degrees
  cur_az,  cur_alt :double;           // current alt-az position in degrees
  Sideral_Time : Double;              // Current sideral time
  Longitude : Double;                 // Observatory longitude (Negative East of Greenwich}
  Latitude : Double;                  // Observatory latitude

const north=0; south=1; east=2; west=3;

implementation

Uses Serial;

var
  LX200_port  : THandle;            // COM port file handle


Function PadZeros(x : string ; l :integer) : string;
const zero = '000000000000';
var p : integer;
begin
x:=trim(x);
p:=l-length(x);
result:=copy(zero,1,p)+x;
end;

Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

Function DEToStr(de: Double; var d,m,s : string) : string;
var dd,min1,min,sec: Double;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+'�'+m+chr(39)+s+'"';
end;

Function ARToStr(ar: Double; var d,m,s : string) : string;
var dd,min1,min,sec: Double;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.999 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.95 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(dd:2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+'h'+m+'m'+s+'s';
end;

Function DEmToStr(de: Double; var d,m : string) : string;
var dd,min: Double;
begin
    dd:=Int(de);
    min:=abs(de-dd)*60;
    if min>=59.5 then begin
       dd:=dd+sgn(de);
       min:=0.0;
    end;
    min:=Round(min);
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    result := d+'�'+m+chr(39);
end;

Function ARmToStr(ar: Double; var d,m : string) : string;
var dd,min: Double;
begin
    dd:=Int(ar);
    min:=abs(ar-dd)*60;
    if min>=59.5 then begin
       dd:=dd+sgn(ar);
       min:=0.0;
    end;
//    min:=Round(min);
    str(dd:2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    str(min:4:1,m);
    if length(trim(m))<4 then m:='0'+trim(m);
    result := d+'h'+m+'m';
end;

//  LX-200 uses 9600 N 8 1
Function LX200_Open(model,commport,baud,parity,data,stop,timeout,inttimeout : string) : boolean;
var i,typ,count : integer;
    buf : string;
begin
result:=false;
if (length(CommPort)<>4)or
   (pos(CommPort,ValidPort)=0)
   then begin ShowMessage('Invalid communication port : '+commport); exit; end;
typ:=0;
for i:=1 to NumModel do if (pos(Model,ValidModel[i])>0) then typ:=i;
if typ=0 then begin ShowMessage('Unsupported encoder model : '+model); exit; end;
if port_opened then LX200_Close;
if OpenCom(LX200_port,commport,baud,parity,data,stop,timeout,inttimeout) then begin
   port_opened:=true;
   LX200_model:=model;
   LX200_type:=typ;
   PurgeBuffer(LX200_port);
   // check scope connected
   case LX200_type of
   1..2 : begin  // get DEC (change for FS2 with no ACK nor GC)
         buf:='#:GD#';
         count:=length(buf);
         if WriteCom(LX200_port,buf,count)= false then exit;
         count:=20;
         if ReadCom(LX200_port,buf,count) = false then exit;
         if count<6 then exit;
         buf:='P';
         LX200_mode:=buf;
         LX200_opened:=true;
         result:=true;
         end;
   3..4 : begin  // get date  for Magellan
         buf:='#:GC#';
         count:=length(buf);
         if WriteCom(LX200_port,buf,count)= false then exit;
         count:=9;
         if ReadCom(LX200_port,buf,count) = false then exit;
         if count<9 then exit;
         LX200_mode:='P';
         LX200_opened:=true;
         result:=true;
         end;
   end;
end else begin
   ShowMessage('Port '+commport+' cannot be opened!');
   LX200_opened:=false;
end;
end;

Procedure LX200_SetFormat(format : integer);
var count,f : integer;
    buf : string;
begin
   // Get format
   buf:='#:GD#';
   count:=length(buf);
   if WriteCom(LX200_port,buf,count)= false then exit;
   count:=20;
   if ReadCom(LX200_port,buf,count) = false then exit;
   if length(trim(buf))>7 then f:=1 else f:=0;
   if f<>format then begin
       buf:='#:U#';          // switch format
       count:=length(buf);
       if WriteCom(LX200_port,buf,count)= false then exit;
   end;
   LX200_format:=format;
end;

Function LX200_Close : boolean;
begin
CloseCom(LX200_port);
port_opened:=false;
LX200_opened:=false;
LX200_model:='';
LX200_mode:='';
LX200_type:=0;
result:=true;
end;

Function LX200_QueryEQ(var RA,DEC : double) : boolean;
var buf : string;
    a,b,c : double;
    count,p,i : integer;
begin
result:=false;
case LX200_type of
2 : begin       // Autostar, some model have problem to respond to the double command
buf:='#:GR#';
count:=length(buf);
PurgeBuffer(LX200_port);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=20;
if ReadCom(LX200_port,buf,count) = false then exit;
case LX200_format of
0 : begin
    //1234567890123456
    //+HH:MM.M#
    //03:21.7#
    i:=pos(':',buf);
    val(copy(buf,1,i-1),a,p); if p>0 then exit;
    buf:=copy(buf,i+1,999);
    i:=pos('#',buf);
    val(copy(buf,1,i-1),b,p); if p>0 then exit;
    RA:=15*(a+b/60);
    end;
1 : begin
    //1234567890123456
    //06:07:58#
    i:=pos(':',buf);
    val(copy(buf,1,i-1),a,p); if p>0 then exit;
    buf:=copy(buf,i+1,999);
    i:=pos(':',buf);
    val(copy(buf,1,i-1),b,p); if p>0 then exit;
    buf:=copy(buf,i+1,999);
    i:=pos('#',buf);
    val(copy(buf,1,i-1),c,p); if p>0 then exit;
    RA:=15*(a+b/60+c/3600);
    end;
end;
buf:='#:GD#';
count:=length(buf);
PurgeBuffer(LX200_port);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=20;
if ReadCom(LX200_port,buf,count) = false then exit;
case LX200_format of
0 : begin
    //1234567890123456
    //-DD*MM#
    //+30�02#
    val(copy(buf,2,2),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    DEC:=a+b/60;
    if copy(buf,1,1)='-' then DEC:=-DEC;
    end;
1 : begin
    //1234567890123456
    //+19�46:02d#
    val(copy(buf,2,2),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    val(copy(buf,8,2),c,p); if p>0 then exit;
    DEC:=a+b/60+c/3600;
    if copy(buf,1,1)='-' then DEC:=-DEC;
    end;
end;
    end;
else begin          // LX200, Magellan
buf:='#:GR#:GD#';
count:=length(buf);
PurgeBuffer(LX200_port);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=20;
if ReadCom(LX200_port,buf,count) = false then exit;
case LX200_format of
0 : begin
    //1234567890123456
    //+HH:MM.M#-DD*MM#
    //03:21.7#+30�02#
    i:=pos(':',buf);
    val(copy(buf,1,i-1),a,p); if p>0 then exit;
    buf:=copy(buf,i+1,999);
    i:=pos('#',buf);
    val(copy(buf,1,i-1),b,p); if p>0 then exit;
    RA:=15*(a+b/60);
    buf:=copy(buf,i+1,999);
    val(copy(buf,2,2),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    DEC:=a+b/60;
    if copy(buf,1,1)='-' then DEC:=-DEC;
    end;
1 : begin
    //1234567890123456
    //06:07:58#+19�46:02d#
    i:=pos(':',buf);
    val(copy(buf,1,i-1),a,p); if p>0 then exit;
    buf:=copy(buf,i+1,999);
    i:=pos(':',buf);
    val(copy(buf,1,i-1),b,p); if p>0 then exit;
    buf:=copy(buf,i+1,999);
    i:=pos('#',buf);
    val(copy(buf,1,i-1),c,p); if p>0 then exit;
    RA:=15*(a+b/60+c/3600);
    buf:=copy(buf,i+1,999);
    val(copy(buf,2,2),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    val(copy(buf,8,2),c,p); if p>0 then exit;
    DEC:=a+b/60+c/3600;
    if copy(buf,1,1)='-' then DEC:=-DEC;
    end;
end;
end;
end;
result:=true;
end;

Function LX200_QueryAZ(var Az,Al : double) : boolean;
var buf : string;
    a,b,c : double;
    count,p : integer;
begin
result:=false;
case LX200_type of
2 : begin       // Autostar, some model have problem to respond to the double command
buf:='#:GZ#';
count:=length(buf);
PurgeBuffer(LX200_port);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=20;
if ReadCom(LX200_port,buf,count) = false then exit;
case LX200_format of
0 : begin
    //1234567890123456
    //DDD*MM#
    val(copy(buf,1,3),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    Az:=a+b/60;
    end;
1 : begin
    //1234567890123456789
    //311�52:05#
    val(copy(buf,1,3),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    val(copy(buf,8,2),c,p); if p>0 then exit;
    Az:=a+b/60+c/3600;
    end;
end;
buf:='#:GA#';
count:=length(buf);
PurgeBuffer(LX200_port);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=20;
if ReadCom(LX200_port,buf,count) = false then exit;
case LX200_format of
0 : begin
    //1234567890123456
    //-DD*MM#
    val(copy(buf,2,2),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    Al:=a+b/60;
    if copy(buf,1,1)='-' then Al:=-Al;
    end;
1 : begin
    //1234567890123456789
    //+19�46:10#
    val(copy(buf,2,2),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    val(copy(buf,8,2),c,p); if p>0 then exit;
    Al:=a+b/60+c/3600;
    if copy(buf,1,1)='-' then Al:=-Al;
    end;
end;
    end;
else begin          // LX200, Magellan
buf:='#:GZ#:GA#';
count:=length(buf);
PurgeBuffer(LX200_port);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=20;
if ReadCom(LX200_port,buf,count) = false then exit;
case LX200_format of
0 : begin
    //1234567890123456
    //DDD*MM#-DD*MM#
    val(copy(buf,1,3),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    Az:=a+b/60;
    val(copy(buf,9,2),a,p); if p>0 then exit;
    val(copy(buf,12,2),b,p); if p>0 then exit;
    Al:=a+b/60;
    if copy(buf,8,1)='-' then Al:=-Al;
    end;
1 : begin
    //1234567890123456789
    //311�52:05#+19�46:10#
    val(copy(buf,1,3),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    val(copy(buf,8,2),c,p); if p>0 then exit;
    Az:=a+b/60+c/3600;
    val(copy(buf,12,2),a,p); if p>0 then exit;
    val(copy(buf,15,2),b,p); if p>0 then exit;
    val(copy(buf,18,2),c,p); if p>0 then exit;
    Al:=a+b/60+c/3600;
    if copy(buf,11,1)='-' then Al:=-Al;
    end;
end;
end;
end;
result:=true;
end;

Function LX200_Pos(var RA,DEC : double) : boolean;
var buf,s1,s2,s3 : string;
    count : integer;
begin
result:=false;
RA:=RA/15;
case LX200_type of
2 : begin       // Autostar, some model have problem to respond to the double command
case LX200_format of
0 : begin
    armtostr(ra,s1,s2);
    buf:='#:Sr '+s1+':'+s2+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='0' then exit;
    demtostr(dec,s1,s2);
    buf:='#:Sd '+s1+chr(223)+s2+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='0' then exit;
    end;
1 : begin
    artostr(ra,s1,s2,s3);
    buf:='#:Sr '+s1+':'+s2+':'+s3+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='0' then exit;
    detostr(dec,s1,s2,s3);
    buf:='#:Sd '+s1+chr(223)+s2+':'+s3+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='0' then exit;
    end;
end;
end;
else begin          // LX200, Magellan
case LX200_format of
0 : begin
    armtostr(ra,s1,s2);
    buf:='#:Sr '+s1+':'+s2+'#:Sd ';
    demtostr(dec,s1,s2);
    buf:=buf+s1+chr(223)+s2+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='00' then exit;
    end;
1 : begin
    artostr(ra,s1,s2,s3);
    buf:='#:Sr '+s1+':'+s2+':'+s3+'#:Sd ';
    detostr(dec,s1,s2,s3);
    buf:=buf+s1+chr(223)+s2+':'+s3+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='00' then exit;
    end;
end;
end;
end;
result:=true;
end;

Function LX200_Slew : boolean;
var buf : string;
    count : integer;
begin
result:=false;
PurgeBuffer(LX200_port);
    // slew to current object
    buf:='#:MS#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=50;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if (trim(buf)<>'')and(copy(buf,1,1)='1') then begin
       buf:=copy(buf,2,99);
       showmessage('LX200 say : '+buf);
       exit;
    end;
result:=true;
end;

Function LX200_Goto(RA,DEC : double) : boolean;
begin
result:=false;
// set object position
if not LX200_Pos(RA,DEC) then exit;
// slew to object
if not LX200_Slew then exit;
result:=true;
end;

Function LX200_Sync : boolean;
var buf : string;
    count : integer;
begin
result:=false;
PurgeBuffer(LX200_port);
    buf:='#:CM#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=50;
    if ReadCom(LX200_port,buf,count) = false then exit;
result:=true;
end;

Function LX200_SyncPos( RA,DEC : double) : boolean;
begin
result:=false;
PurgeBuffer(LX200_port);
    // set object position
    if not LX200_Pos(RA,DEC) then exit;
    // sync object
    if not LX200_Sync then exit;
result:=true;
end;

Function LX200_SetObs( Lat,Long,TZ : double; datenow : Tdatetime) : boolean;
begin
result:=true;
end;

Function LX200_SetSpeed(speed : integer) : boolean;
var count : integer;
    buf : string;
begin
result:=false;
PurgeBuffer(LX200_port);
case LX200_type of
1 : begin // LX200
    buf:='#:R';
    case speed of
    0 : buf:=buf+'S#';
    1 : buf:=buf+'M#';
    2 : buf:=buf+'C#';
    3 : buf:=buf+'G#';
    else exit;
    end;
    end;
2 : begin // Autostar
    case speed of
    0 : buf:='#:Sw4#';
    1 : buf:='#:Sw3#';
    2 : buf:='#:Sw2#';
    3 : buf:='#:Sw2#';
    else exit;
    end;
    end;
end;
count:=length(buf);
if WriteCom(LX200_port,buf,count)= false then exit;
result:=true;
end;

Function LX200_Move(direction : integer) : boolean;
var count : integer;
    buf : string;
begin
result:=false;
PurgeBuffer(LX200_port);
    buf:='#:M';
    case direction of
    north : buf:=buf+'n#';
    south : buf:=buf+'s#';
    east  : buf:=buf+'e#';
    west  : buf:=buf+'w#';
    else exit;
    end;
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
result:=true;
end;

Function LX200_StopDir(direction : integer) : boolean;
var count : integer;
    buf : string;
begin
result:=false;
PurgeBuffer(LX200_port);
case LX200_type of
1 : begin // LX200
    buf:='#:Q';
    case direction of
    north : buf:=buf+'n#';
    south : buf:=buf+'s#';
    east  : buf:=buf+'e#';
    west  : buf:=buf+'w#';
    else buf:=buf+'#';
    end;
    end;
2 : begin // Autostar
    buf:='#:Q#';
    end;
end;
count:=length(buf);
if WriteCom(LX200_port,buf,count)= false then exit;
result:=true;
end;

Function LX200_StopMove : boolean;
var count : integer;
    buf : string;
begin
result:=false;
    buf:='#:Q#:Qn#:Qs#:Qe#:Qw#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
result:=true;
end;

Function LX200_QueryHighPrecision : string;
var buf : string;
    i,count : integer;
begin
result:='Error';
PurgeBuffer(LX200_port);
for i:=1 to 2 do begin
    buf:='#:P#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=50;
    if ReadCom(LX200_port,buf,count) = false then exit;
end;
// buf:='HIGH PRECISION  ';
result:=trim(buf);
LX200_UseHPP:=result='HIGH PRECISION';
end;

Function LX200_SwitchHighPrecision : string;
var buf : string;
    count : integer;
begin
result:='Error';
PurgeBuffer(LX200_port);
    buf:='#:P#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=50;
    if ReadCom(LX200_port,buf,count) = false then exit;
result:=trim(buf);
LX200_UseHPP:=result='HIGH PRECISION';
end;

Function LX200_SetFocusSteep(speed:char):boolean;
var count : integer;
    buf : string;
begin
// standard lx200 :      speed = (F,S)
// lx200gps, autostar :  speed = (1,2,3,4)
buf:='#:F'+speed+'#';
count:=length(buf);
result:=WriteCom(LX200_port,buf,count);
end;

Function LX200_StartFocus(dir:char):boolean;
var count : integer;
    buf : string;
begin
// dir = (+,-)
buf:='#:F'+dir+'#';
count:=length(buf);
result:=WriteCom(LX200_port,buf,count);
end;

Function LX200_StopFocus:boolean;
var count : integer;
    buf : string;
begin
buf:='#:FQ#';
count:=length(buf);
result:=WriteCom(LX200_port,buf,count);
end;

function LX200_SetTimeDate : boolean;
var count : integer;
    buf, dt, tm, tz, site, saved, savet : string;
label exit;
begin
  saved := ShortDateFormat;
  savet := ShortTimeFormat;
  try
        result:=false;
        PurgeBuffer(LX200_port);

        //Set Date
        ShortDateFormat := 'mm/dd/yy';
        buf := '#:SC '+DateToStr(Date)+'#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        // read ok response
        count:=1;
        ReadCom(LX200_port,buf,count);
        // read planetary update response
        count:=50;
        ReadCom(LX200_port,buf,count);
        count:=50;
        ReadCom(LX200_port,buf,count);

        //Set Time
        ShortTimeFormat := 'hh:mm:ss';
        buf := '#:SL '+TimeToStr(Time)+'#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count:=1;
        ReadCom(LX200_port,buf,count);

        //Clean buffer
        PurgeBuffer(LX200_port);

        //Get from scope: site, date and time
        buf := '#:GM#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count := 50;
        if ReadCom(LX200_port,site,count) = false then goto exit;
        site := stringreplace(trim(site),'#','',[rfReplaceAll]);

        buf := '#:GC#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count := 10;
        if ReadCom(LX200_port,dt,count) = false then goto exit;
        dt := stringreplace(trim(dt),'#','',[rfReplaceAll]);

        buf := '#:GL#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count := 10;
        if ReadCom(LX200_port,tm,count) = false then goto exit;
        tm := stringreplace(trim(tm),'#','',[rfReplaceAll]);

        buf := '#:GG#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count := 10;
        if ReadCom(LX200_port,tz,count) = false then goto exit;
        tz := stringreplace(trim(tz),'#','',[rfReplaceAll]);

        result := true;
        ShowMessage('Telescope setting is now:'+crlf+'Site: ' + site + crlf+'Date: ' + dt + crlf+'Time: ' + tm +crlf+'Time zone: ' + tz+ '.');
exit:
finally
  ShortDateFormat := saved;
  ShortTimeFormat := savet;
end;
end;

function LX200_Parkscope : boolean;
var buf : string;
    count : integer;
begin
 result := false;
 buf := '#:hP#';
 count:=length(buf);
 if WriteCom(LX200_port,buf,count) = false then exit;
 result := true;
end;

end.
