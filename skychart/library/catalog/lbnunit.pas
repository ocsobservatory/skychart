unit lbnunit;
{
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
}
{$mode objfpc}{$H+}
interface

uses
  skylibcat, sysutils;
type
LBNrec = record ar,de :longint ;
                area : single;
                num,d1,d2,id : word;
                color,bright : byte;
                name : array[1..8] of char;
                end;
Function IsLBNpath(path : string) : Boolean;
procedure SetLBNpath(path : string);
Procedure OpenLBNAll(var ok : boolean);
Procedure OpenLBN(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenLBNwin(var ok : boolean);
Procedure ReadLBN(var lin : LBNrec; var ok : boolean);
procedure CloseLBN ;

var
  LBNpath : string;

implementation

var
   flbn : file of LBNrec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;

Function IsLBNpath(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetLBNpath(path : string);
begin
LBNpath:=noslash(path);
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(flbn);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=LBNpath+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(flbn,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(flbn);
ok:=true ;
end;

Procedure OpenLBNAll(var ok : boolean);
var i:integer;
begin
JDCatalog:=jd2000;
curSM:=1;
nSM:=50;
for i:=1 to nSM do SMlst[i]:=i;
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure OpenLBN(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadLBN(var lin : LBNrec; var ok : boolean);
var sm:integer;
begin
ok:=true;
if eof(flbn) then begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;
if ok then  Read(flbn,lin);
end;

procedure CloseLBN ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenLBNwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.

