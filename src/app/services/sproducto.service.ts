import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { map, tap } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { ProcedureParam } from '../models/usuariotoken.models';
import { ProductoModel } from '../models/producto.models';
import { environment } from '../../environments/environment';
import { DatePipe } from '@angular/common';
import { Router }from '@angular/router';
const apiUlr = environment.apiUlr;
@Injectable({  providedIn: 'root'})
export class SproductoService {
constructor(private http: HttpClient,public datepipe: DatePipe,private router: Router) { }
//producto: productoModel;
//select
selproducto(procedureParam: ProcedureParam) {
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
return this.http.post(apiUlr + 'selproducto', body)
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
//termina selproducto
//create
addproducto(producto: ProductoModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidproducto', producto.idproducto.toString());body = body.set('pnombreproducto', producto.nombreproducto.toString());body = body.set('pidclasificacionproducto', producto.idclasificacionproducto.toString());body = body.set('preferencia', producto.referencia.toString());body = body.set('pdescripcion', producto.descripcion.toString());body = body.set('pcolor', producto.color.toString());body = body.set('ptalla', producto.talla.toString());body = body.set('pidmarca', producto.idmarca.toString());body = body.set('pcodigobarra1', producto.codigobarra1.toString());body = body.set('pcodigobarra2', producto.codigobarra2.toString());body = body.set('pidtipounidad', producto.idtipounidad.toString());body = body.set('ptipoproducto', producto.tipoproducto.toString());body = body.set('pventacongarantia', producto.ventacongarantia.toString());body = body.set('pconnumeroserie', producto.connumeroserie.toString());body = body.set('pconrfid', producto.conrfid.toString());body = body.set('pdiasvalides', producto.diasvalides.toString());body = body.set('pmontocompra', producto.montocompra.toString());body = body.set('pmontoventa', producto.montoventa.toString());body = body.set('pmodelo', producto.modelo.toString());body = body.set('pidusuarioactualiza', producto.idusuarioactualiza.toString());//realizar consulta
return this.http.post(apiUlr + 'addproducto', body)
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
getproducto(producto: ProductoModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidproducto', producto.idproducto.toString());body = body.set('pnombreproducto', producto.nombreproducto.toString());body = body.set('pidclasificacionproducto', producto.idclasificacionproducto.toString());body = body.set('preferencia', producto.referencia.toString());body = body.set('pdescripcion', producto.descripcion.toString());body = body.set('pcolor', producto.color.toString());body = body.set('ptalla', producto.talla.toString());body = body.set('pidmarca', producto.idmarca.toString());body = body.set('pcodigobarra1', producto.codigobarra1.toString());body = body.set('pcodigobarra2', producto.codigobarra2.toString());body = body.set('pidtipounidad', producto.idtipounidad.toString());body = body.set('ptipoproducto', producto.tipoproducto.toString());body = body.set('pventacongarantia', producto.ventacongarantia.toString());body = body.set('pconnumeroserie', producto.connumeroserie.toString());body = body.set('pconrfid', producto.conrfid.toString());body = body.set('pdiasvalides', producto.diasvalides.toString());body = body.set('pmontocompra', producto.montocompra.toString());body = body.set('pmontoventa', producto.montoventa.toString());body = body.set('pmodelo', producto.modelo.toString());body = body.set('pidusuarioactualiza', producto.idusuarioactualiza.toString());//realizar consulta
return this.http.post(apiUlr + 'getproducto', body)
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
updproducto(producto: ProductoModel) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
//parametros
body = body.set('pidproducto', producto.idproducto.toString());body = body.set('pnombreproducto', producto.nombreproducto.toString());body = body.set('pidclasificacionproducto', producto.idclasificacionproducto.toString());body = body.set('preferencia', producto.referencia.toString());body = body.set('pdescripcion', producto.descripcion.toString());body = body.set('pcolor', producto.color.toString());body = body.set('ptalla', producto.talla.toString());body = body.set('pidmarca', producto.idmarca.toString());body = body.set('pcodigobarra1', producto.codigobarra1.toString());body = body.set('pcodigobarra2', producto.codigobarra2.toString());body = body.set('pidtipounidad', producto.idtipounidad.toString());body = body.set('ptipoproducto', producto.tipoproducto.toString());body = body.set('pventacongarantia', producto.ventacongarantia.toString());body = body.set('pconnumeroserie', producto.connumeroserie.toString());body = body.set('pconrfid', producto.conrfid.toString());body = body.set('pdiasvalides', producto.diasvalides.toString());body = body.set('pmontocompra', producto.montocompra.toString());body = body.set('pmontoventa', producto.montoventa.toString());body = body.set('pmodelo', producto.modelo.toString());body = body.set('pidusuarioactualiza', producto.idusuarioactualiza.toString());//realizar consulta
return this.http.post(apiUlr + 'updproducto', body)
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
papproducto(producto: ProductoModel,tipo:string,procedure:string) {
const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
let body = new HttpParams();
body = body.set('idusuario', localStorage.getItem('parmid')||'');
body = body.set('llave', localStorage.getItem('parmtoken')||'');
body = body.set('tipo', tipo);
body = body.set('procedure', procedure);
//parametros
body = body.set('pidproducto', producto.idproducto.toString());body = body.set('pnombreproducto', producto.nombreproducto.toString());body = body.set('pidclasificacionproducto', producto.idclasificacionproducto.toString());body = body.set('preferencia', producto.referencia.toString());body = body.set('pdescripcion', producto.descripcion.toString());body = body.set('pcolor', producto.color.toString());body = body.set('ptalla', producto.talla.toString());body = body.set('pidmarca', producto.idmarca.toString());body = body.set('pcodigobarra1', producto.codigobarra1.toString());body = body.set('pcodigobarra2', producto.codigobarra2.toString());body = body.set('pidtipounidad', producto.idtipounidad.toString());body = body.set('ptipoproducto', producto.tipoproducto.toString());body = body.set('pventacongarantia', producto.ventacongarantia.toString());body = body.set('pconnumeroserie', producto.connumeroserie.toString());body = body.set('pconrfid', producto.conrfid.toString());body = body.set('pdiasvalides', producto.diasvalides.toString());body = body.set('pmontocompra', producto.montocompra.toString());body = body.set('pmontoventa', producto.montoventa.toString());body = body.set('pmodelo', producto.modelo.toString());body = body.set('pidusuarioactualiza', producto.idusuarioactualiza.toString());//realizar consulta
return this.http.post(apiUlr + 'papproducto', body)
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
