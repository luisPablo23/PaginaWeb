import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { map, tap } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { ProcedureParam } from '../models/usuariotoken.models';
import { PersonaModel } from '../models/persona.models';
import { environment } from '../../environments/environment';
import { DatePipe } from '@angular/common';
import { Router }from '@angular/router';
const apiUlr = environment.apiUlr;
@Injectable({  providedIn: 'root'})
export class SpersonaService {
constructor(private http: HttpClient,public datepipe: DatePipe,private router: Router) { }
//persona: personaModel;
//select
selpersona(procedureParam: ProcedureParam) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pCampo0', procedureParam.pCampo0);
body = body.set('pValor0', procedureParam.pValor0);
body = body.set('pCampo1', procedureParam.pCampo1);
body = body.set('pValor1', procedureParam.pValor1);
body = body.set('pCampo2', procedureParam.pCampo2);
body = body.set('pValor2', procedureParam.pValor2);
body = body.set('pCampo3', procedureParam.pCampo3);
body = body.set('pValor3', procedureParam.pValor3);
body = body.set('pCampo4', procedureParam.pCampo4);
body = body.set('pValor4', procedureParam.pValor4);
body = body.set('pCampo5', procedureParam.pCampo5);
body = body.set('pValor5', procedureParam.pValor5);
body = body.set('pCampo6', procedureParam.pCampo6);
body = body.set('pValor6', procedureParam.pValor6);
body = body.set('pCampo7', procedureParam.pCampo7);
body = body.set('pValor7', procedureParam.pValor7);
//realizar consulta
return this.http.post(apiUlr + 'selpersona', body)
.pipe(map((resp:any) => {
if (resp['info'] != null) {
if (resp['mesaje'] != null) {
if (resp['mesaje'] == '201')
this.router.navigateByUrl('/login');
else
return resp;
} else {
console.log('FAILD');
return null;
}
} else {console.log('error coneccion');return null;}
}));
}
//termina selpersona
//create
addpersona(persona: PersonaModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidpersona', persona.idpersona.toString());body = body.set('pidtipopersona', persona.idtipopersona.toString());body = body.set('pnombre', persona.nombre.toString());body = body.set('ppaterno', persona.paterno.toString());body = body.set('pmaterno', persona.materno.toString());body = body.set('pdireccion', persona.direccion.toString());body = body.set('pcelular', persona.celular.toString());body = body.set('pcelularcontacto', persona.celularcontacto.toString());body = body.set('pfechanacimiento', this.datepipe.transform(persona.fechanacimiento, 'yyyy-MM-dd HH:mm:ss')||'');body = body.set('pidtiposexo', persona.idtiposexo.toString());body = body.set('pobservaciones', persona.observaciones.toString());body = body.set('pnrodocumento', persona.nrodocumento.toString());body = body.set('pidtipodocumento', persona.idtipodocumento.toString());body = body.set('pnit', persona.nit.toString());//realizar consulta
return this.http.post(apiUlr + 'addpersona', body)
.pipe(map((resp:any) => {
if (resp['info'] != null)
{
if (resp['mesaje'] != null)
{
if (resp['mesaje'] == '201')
this.router.navigateByUrl('/login');
else
return resp;
}
else
{
console.log('FAILD');
return null;
}
}
else
{
console.log('error coneccion');
return null;
}
}));
}
//termina create
//read
getpersona(persona: PersonaModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidpersona', persona.idpersona.toString());body = body.set('pidtipopersona', persona.idtipopersona.toString());body = body.set('pnombre', persona.nombre.toString());body = body.set('ppaterno', persona.paterno.toString());body = body.set('pmaterno', persona.materno.toString());body = body.set('pdireccion', persona.direccion.toString());body = body.set('pcelular', persona.celular.toString());body = body.set('pcelularcontacto', persona.celularcontacto.toString());body = body.set('pfechanacimiento', this.datepipe.transform(persona.fechanacimiento, 'yyyy-MM-dd HH:mm:ss')||'');body = body.set('pidtiposexo', persona.idtiposexo.toString());body = body.set('pobservaciones', persona.observaciones.toString());body = body.set('pnrodocumento', persona.nrodocumento.toString());body = body.set('pidtipodocumento', persona.idtipodocumento.toString());body = body.set('pnit', persona.nit.toString());//realizar consulta
return this.http.post(apiUlr + 'getpersona', body)
.pipe(map((resp:any) => {
if (resp['info'] != null)
{
if (resp['mesaje'] != null)
{
if (resp['mesaje'] == '201')
this.router.navigateByUrl('/login');
else
return resp;
}
else
{
console.log('FAILD');
return null;
}
}
else
{
console.log('error coneccion');
return null;
}
}));
}
//termina read
//update
updpersona(persona: PersonaModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidpersona', persona.idpersona.toString());body = body.set('pidtipopersona', persona.idtipopersona.toString());body = body.set('pnombre', persona.nombre.toString());body = body.set('ppaterno', persona.paterno.toString());body = body.set('pmaterno', persona.materno.toString());body = body.set('pdireccion', persona.direccion.toString());body = body.set('pcelular', persona.celular.toString());body = body.set('pcelularcontacto', persona.celularcontacto.toString());body = body.set('pfechanacimiento', this.datepipe.transform(persona.fechanacimiento, 'yyyy-MM-dd HH:mm:ss')||'');body = body.set('pidtiposexo', persona.idtiposexo.toString());body = body.set('pobservaciones', persona.observaciones.toString());body = body.set('pnrodocumento', persona.nrodocumento.toString());body = body.set('pidtipodocumento', persona.idtipodocumento.toString());body = body.set('pnit', persona.nit.toString());//realizar consulta
return this.http.post(apiUlr + 'updpersona', body)
.pipe(map((resp:any) => {
if (resp['info'] != null)
{
if (resp['mesaje'] != null)
{
if (resp['mesaje'] == '201')
this.router.navigateByUrl('/login');
else
return resp;
}
else
{
console.log('FAILD');
return null;
}
}
else
{
console.log('error coneccion');
return null;
}
}));
}
//termina update
//personalizado
pappersona(persona: PersonaModel,tipo:string,procedure:string) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
body = body.set('tipo', tipo);
body = body.set('procedure', procedure);
//parametros
body = body.set('pidpersona', persona.idpersona.toString());body = body.set('pidtipopersona', persona.idtipopersona.toString());body = body.set('pnombre', persona.nombre.toString());body = body.set('ppaterno', persona.paterno.toString());body = body.set('pmaterno', persona.materno.toString());body = body.set('pdireccion', persona.direccion.toString());body = body.set('pcelular', persona.celular.toString());body = body.set('pcelularcontacto', persona.celularcontacto.toString());body = body.set('pfechanacimiento', this.datepipe.transform(persona.fechanacimiento, 'yyyy-MM-dd HH:mm:ss')||'');body = body.set('pidtiposexo', persona.idtiposexo.toString());body = body.set('pobservaciones', persona.observaciones.toString());body = body.set('pnrodocumento', persona.nrodocumento.toString());body = body.set('pidtipodocumento', persona.idtipodocumento.toString());body = body.set('pnit', persona.nit.toString());//realizar consulta
return this.http.post(apiUlr + 'pappersona', body)
.pipe(map((resp:any) => {
if (resp['info'] != null)
{
if (resp['mesaje'] != null)
{
if (resp['mesaje'] == '201')
this.router.navigateByUrl('/login');
else
return resp;
}
else
{
console.log('FAILD');
return null;
}
}
else
{
console.log('error coneccion');
return null;
}
}));
}
//termina personalizado
}
