import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { map, tap } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { ProcedureParam } from '../models/usuariotoken.models';
import { RolusuarioModel } from '../models/rolusuario.models';
import { environment } from '../../environments/environment';
import { DatePipe } from '@angular/common';
import { Router }from '@angular/router';
const apiUlr = environment.apiUlr;
@Injectable({  providedIn: 'root'})
export class SrolusuarioService {
constructor(private http: HttpClient,public datepipe: DatePipe,private router: Router) { }
//rolusuario: rolusuarioModel;
//select
selrolusuario(procedureParam: ProcedureParam) {
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
return this.http.post(apiUlr + 'selrolusuario', body)
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
//termina selrolusuario
//create
addrolusuario(rolusuario: RolusuarioModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidrolusuario', rolusuario.idrolusuario.toString());body = body.set('pidrol', rolusuario.idrol.toString());body = body.set('pidusuario', rolusuario.idusuario.toString());body = body.set('pidestadorolusuario', rolusuario.idestadorolusuario.toString());body = body.set('pidubicacion', rolusuario.idubicacion.toString());body = body.set('pidtiporolusuario', rolusuario.idtiporolusuario.toString());body = body.set('pidusuariocreacion', rolusuario.idusuariocreacion.toString());body = body.set('pfechabaja', this.datepipe.transform(rolusuario.fechabaja, 'yyyy-MM-dd HH:mm:ss')||'');//realizar consulta
return this.http.post(apiUlr + 'addrolusuario', body)
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
getrolusuario(rolusuario: RolusuarioModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidrolusuario', rolusuario.idrolusuario.toString());body = body.set('pidrol', rolusuario.idrol.toString());body = body.set('pidusuario', rolusuario.idusuario.toString());body = body.set('pidestadorolusuario', rolusuario.idestadorolusuario.toString());body = body.set('pidubicacion', rolusuario.idubicacion.toString());body = body.set('pidtiporolusuario', rolusuario.idtiporolusuario.toString());body = body.set('pidusuariocreacion', rolusuario.idusuariocreacion.toString());body = body.set('pfechabaja', this.datepipe.transform(rolusuario.fechabaja, 'yyyy-MM-dd HH:mm:ss')||'');//realizar consulta
return this.http.post(apiUlr + 'getrolusuario', body)
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
updrolusuario(rolusuario: RolusuarioModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidrolusuario', rolusuario.idrolusuario.toString());body = body.set('pidrol', rolusuario.idrol.toString());body = body.set('pidusuario', rolusuario.idusuario.toString());body = body.set('pidestadorolusuario', rolusuario.idestadorolusuario.toString());body = body.set('pidubicacion', rolusuario.idubicacion.toString());body = body.set('pidtiporolusuario', rolusuario.idtiporolusuario.toString());body = body.set('pidusuariocreacion', rolusuario.idusuariocreacion.toString());body = body.set('pfechabaja', this.datepipe.transform(rolusuario.fechabaja, 'yyyy-MM-dd HH:mm:ss')||'');//realizar consulta
return this.http.post(apiUlr + 'updrolusuario', body)
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
paprolusuario(rolusuario: RolusuarioModel,tipo:string,procedure:string) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
body = body.set('tipo', tipo);
body = body.set('procedure', procedure);
//parametros
body = body.set('pidrolusuario', rolusuario.idrolusuario.toString());body = body.set('pidrol', rolusuario.idrol.toString());body = body.set('pidusuario', rolusuario.idusuario.toString());body = body.set('pidestadorolusuario', rolusuario.idestadorolusuario.toString());body = body.set('pidubicacion', rolusuario.idubicacion.toString());body = body.set('pidtiporolusuario', rolusuario.idtiporolusuario.toString());body = body.set('pidusuariocreacion', rolusuario.idusuariocreacion.toString());body = body.set('pfechabaja', this.datepipe.transform(rolusuario.fechabaja, 'yyyy-MM-dd HH:mm:ss')||'');//realizar consulta
return this.http.post(apiUlr + 'paprolusuario', body)
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
