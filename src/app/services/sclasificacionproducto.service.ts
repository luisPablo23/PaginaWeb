import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { map, tap } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { ProcedureParam } from '../models/usuariotoken.models';
import { ClasificacionproductoModel } from '../models/clasificacionproducto.models';
import { environment } from '../../environments/environment';
import { DatePipe } from '@angular/common';
const apiUlr = environment.apiUlr;
const apiid = environment.apiid;
const apillave = environment.apillave;
@Injectable({  providedIn: 'root'})
export class SclasificacionproductoService {
constructor(private http: HttpClient,public datepipe: DatePipe) { }
clasificacionproducto: ClasificacionproductoModel= new ClasificacionproductoModel;
//select
selclasificacionproducto(procedureParam: ProcedureParam) {
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
return this.http.post(apiUlr + 'selclasificacionproducto', body)
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
//termina selClasificacionproducto
//create
addclasificacionproducto(clasificacionproducto: ClasificacionproductoModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidclasificacionproducto', clasificacionproducto.idclasificacionproducto.toString());body = body.set('pnombreclasificacionproducto', clasificacionproducto.nombreclasificacionproducto.toString());body = body.set('pdescripcion', clasificacionproducto.descripcion.toString());body = body.set('pidclasificacionproductopadre', clasificacionproducto.idclasificacionproductopadre.toString());body = body.set('pprimario', clasificacionproducto.primario.toString());body = body.set('pidtipoclasificacionproducto', clasificacionproducto.idtipoclasificacionproducto.toString());//realizar consulta
return this.http.post(apiUlr + 'addClasificacionproducto', body)
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
getclasificacionproducto(clasificacionproducto: ClasificacionproductoModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidclasificacionproducto', clasificacionproducto.idclasificacionproducto.toString());body = body.set('pnombreclasificacionproducto', clasificacionproducto.nombreclasificacionproducto.toString());body = body.set('pdescripcion', clasificacionproducto.descripcion.toString());body = body.set('pidclasificacionproductopadre', clasificacionproducto.idclasificacionproductopadre.toString());body = body.set('pprimario', clasificacionproducto.primario.toString());body = body.set('pidtipoclasificacionproducto', clasificacionproducto.idtipoclasificacionproducto.toString());//realizar consulta
return this.http.post(apiUlr + 'getClasificacionproducto', body)
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
updclasificacionproducto(clasificacionproducto: ClasificacionproductoModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidclasificacionproducto', clasificacionproducto.idclasificacionproducto.toString());body = body.set('pnombreclasificacionproducto', clasificacionproducto.nombreclasificacionproducto.toString());body = body.set('pdescripcion', clasificacionproducto.descripcion.toString());body = body.set('pidclasificacionproductopadre', clasificacionproducto.idclasificacionproductopadre.toString());body = body.set('pprimario', clasificacionproducto.primario.toString());body = body.set('pidtipoclasificacionproducto', clasificacionproducto.idtipoclasificacionproducto.toString());//realizar consulta
return this.http.post(apiUlr + 'updClasificacionproducto', body)
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
papclasificacionproducto(clasificacionproducto: ClasificacionproductoModel,tipo:string,procedure:string) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
body = body.set('tipo', tipo);
body = body.set('procedure', procedure);
//parametros
body = body.set('pidclasificacionproducto', clasificacionproducto.idclasificacionproducto.toString());body = body.set('pnombreclasificacionproducto', clasificacionproducto.nombreclasificacionproducto.toString());body = body.set('pdescripcion', clasificacionproducto.descripcion.toString());body = body.set('pidclasificacionproductopadre', clasificacionproducto.idclasificacionproductopadre.toString());body = body.set('pprimario', clasificacionproducto.primario.toString());body = body.set('pidtipoclasificacionproducto', clasificacionproducto.idtipoclasificacionproducto.toString());//realizar consulta
return this.http.post(apiUlr + 'papClasificacionproducto', body)
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
