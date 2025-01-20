import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { map, tap } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { ProcedureParam } from '../models/usuariotoken.models';
import { PlandecuentaModel } from '../models/plandecuenta.models';
import { environment } from '../../environments/environment';
import { DatePipe } from '@angular/common';
const apiUlr = environment.apiUlr;
const apiid = environment.apiid;
const apillave = environment.apillave;
@Injectable({  providedIn: 'root'})
export class SplandecuentaService {
constructor(private http: HttpClient,public datepipe: DatePipe) { }
plandecuenta: PlandecuentaModel= new PlandecuentaModel;
//select
selplandecuenta(procedureParam: ProcedureParam) {
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
return this.http.post(apiUlr + 'selplandecuenta', body)
.pipe(map((resp:any) => {
if (resp['info'] != null) {
if (resp['mesaje'] != null) {
return resp['info'].item;
} else {
console.log('FAILD');
return null;
}
} else {console.log('error coneccion');return null;}
}));
}
//termina selPlandecuenta
//create
addplandecuenta(plandecuenta: PlandecuentaModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidplandecuenta', plandecuenta.idplandecuenta.toString());body = body.set('pdescripcion', plandecuenta.descripcion.toString());body = body.set('pidplandecuentapadre', plandecuenta.idplandecuentapadre.toString());body = body.set('pprimario', plandecuenta.primario.toString());body = body.set('pidtipoplandecuenta', plandecuenta.idtipoplandecuenta.toString());//realizar consulta
return this.http.post(apiUlr + 'addPlandecuenta', body)
.pipe(map((resp:any) => {
if (resp['info'] != null)
{
if (resp['mesaje'] != null)
{
return resp['info'].item;
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
getplandecuenta(plandecuenta: PlandecuentaModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidplandecuenta', plandecuenta.idplandecuenta.toString());body = body.set('pdescripcion', plandecuenta.descripcion.toString());body = body.set('pidplandecuentapadre', plandecuenta.idplandecuentapadre.toString());body = body.set('pprimario', plandecuenta.primario.toString());body = body.set('pidtipoplandecuenta', plandecuenta.idtipoplandecuenta.toString());//realizar consulta
return this.http.post(apiUlr + 'getPlandecuenta', body)
.pipe(map((resp:any) => {
if (resp['info'] != null)
{
if (resp['mesaje'] != null)
{
return resp['info'].item;
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
updplandecuenta(plandecuenta: PlandecuentaModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidplandecuenta', plandecuenta.idplandecuenta.toString());body = body.set('pdescripcion', plandecuenta.descripcion.toString());body = body.set('pidplandecuentapadre', plandecuenta.idplandecuentapadre.toString());body = body.set('pprimario', plandecuenta.primario.toString());body = body.set('pidtipoplandecuenta', plandecuenta.idtipoplandecuenta.toString());//realizar consulta
return this.http.post(apiUlr + 'updPlandecuenta', body)
.pipe(map((resp:any) => {
if (resp['info'] != null)
{
if (resp['mesaje'] != null)
{
return resp['info'].item;
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
papplandecuenta(plandecuenta: PlandecuentaModel,tipo:string,procedure:string) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
body = body.set('tipo', tipo);
body = body.set('procedure', procedure);
//parametros
body = body.set('pidplandecuenta', plandecuenta.idplandecuenta.toString());body = body.set('pdescripcion', plandecuenta.descripcion.toString());body = body.set('pidplandecuentapadre', plandecuenta.idplandecuentapadre.toString());body = body.set('pprimario', plandecuenta.primario.toString());body = body.set('pidtipoplandecuenta', plandecuenta.idtipoplandecuenta.toString());//realizar consulta
return this.http.post(apiUlr + 'papPlandecuenta', body)
.pipe(map((resp:any) => {
if (resp['info'] != null)
{
if (resp['mesaje'] != null)
{
return resp['info'].item;
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
