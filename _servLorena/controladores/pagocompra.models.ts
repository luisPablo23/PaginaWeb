export class PagocompraModel
{idpagocompra : number;
idcompra : number;
idingresoegreso : number;
fecha : Date = new Date();
descripcion : string;
monto : number;
idtipopago : number;
idcotizacionmoneda : number;
idusuario : number;
idoficina : number;
constructor() {
this.idpagocompra = 0;
this.idcompra = 0;
this.idingresoegreso = 0;
this.fecha =  new Date();
this.descripcion = '';
this.monto = 0;
this.idtipopago = 0;
this.idcotizacionmoneda = 0;
this.idusuario = 0;
this.idoficina = 0;
}}