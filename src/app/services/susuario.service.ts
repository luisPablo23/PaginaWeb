import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { map, tap } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { ProcedureParam } from '../models/usuariotoken.models';
import { UsuarioModel } from '../models/usuario.models';
import { environment } from '../../environments/environment';
import { DatePipe } from '@angular/common';
import { Router }from '@angular/router';
const apiUlr = environment.apiUlr;
@Injectable({  providedIn: 'root'})
export class SusuarioService {
constructor(private http: HttpClient,public datepipe: DatePipe,private router: Router) { }
//usuario: usuarioModel;
//select
selusuario(procedureParam: ProcedureParam) {
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
return this.http.post(apiUlr + 'selusuario', body)
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
//termina selusuario
//create
addusuario(usuario: UsuarioModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidusuario', usuario.idusuario.toString());body = body.set('pidpersona', usuario.idpersona.toString());body = body.set('pnombreusuario', usuario.nombreusuario.toString());body = body.set('pclave', usuario.clave.toString());body = body.set('psalt', usuario.salt.toString());body = body.set('ppin', usuario.pin.toString());body = body.set('pidestadousuario', usuario.idestadousuario.toString());body = body.set('pidtipousuario', usuario.idtipousuario.toString());body = body.set('pestilo', usuario.estilo.toString());body = body.set('pidsucursal', usuario.idsucursal.toString());body = body.set('pidrol', usuario.idrol.toString());//realizar consulta
return this.http.post(apiUlr + 'addusuario', body)
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
getusuario(usuario: UsuarioModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidusuario', usuario.idusuario.toString());body = body.set('pidpersona', usuario.idpersona.toString());body = body.set('pnombreusuario', usuario.nombreusuario.toString());body = body.set('pclave', usuario.clave.toString());body = body.set('psalt', usuario.salt.toString());body = body.set('ppin', usuario.pin.toString());body = body.set('pidestadousuario', usuario.idestadousuario.toString());body = body.set('pidtipousuario', usuario.idtipousuario.toString());body = body.set('pestilo', usuario.estilo.toString());body = body.set('pidsucursal', usuario.idsucursal.toString());body = body.set('pidrol', usuario.idrol.toString());//realizar consulta
return this.http.post(apiUlr + 'getusuario', body)
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
updusuario(usuario: UsuarioModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidusuario', usuario.idusuario.toString());body = body.set('pidpersona', usuario.idpersona.toString());body = body.set('pnombreusuario', usuario.nombreusuario.toString());body = body.set('pclave', usuario.clave.toString());body = body.set('psalt', usuario.salt.toString());body = body.set('ppin', usuario.pin.toString());body = body.set('pidestadousuario', usuario.idestadousuario.toString());body = body.set('pidtipousuario', usuario.idtipousuario.toString());body = body.set('pestilo', usuario.estilo.toString());body = body.set('pidsucursal', usuario.idsucursal.toString());body = body.set('pidrol', usuario.idrol.toString());//realizar consulta
return this.http.post(apiUlr + 'updusuario', body)
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
papusuario(usuario: UsuarioModel,tipo:string,procedure:string) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
body = body.set('tipo', tipo);
body = body.set('procedure', procedure);
//parametros
body = body.set('pidusuario', usuario.idusuario.toString());body = body.set('pidpersona', usuario.idpersona.toString());body = body.set('pnombreusuario', usuario.nombreusuario.toString());body = body.set('pclave', usuario.clave.toString());body = body.set('psalt', usuario.salt.toString());body = body.set('ppin', usuario.pin.toString());body = body.set('pidestadousuario', usuario.idestadousuario.toString());body = body.set('pidtipousuario', usuario.idtipousuario.toString());body = body.set('pestilo', usuario.estilo.toString());body = body.set('pidsucursal', usuario.idsucursal.toString());body = body.set('pidrol', usuario.idrol.toString());//realizar consulta
return this.http.post(apiUlr + 'papusuario', body)
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
