export class PagocompraModel
{idpagocompra : number;
idcompra : number;
idingresoegreso : number;
fecha:Date = new Date();
descripcion : string;
monto : decimal(10,0);
idtipopago : number;
idcotizacionmoneda : number;
idusuario : number;
idoficina : number;
constructor() {
this.idpagocompra = 0;
this.idcompra = 0;
this.idingresoegreso = 0;
this.descripcion = '';
this.monto = decimal(10,0);
this.idtipopago = 0;
this.idcotizacionmoneda = 0;
this.idusuario = 0;
this.idoficina = 0;
}}