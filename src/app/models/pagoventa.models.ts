export class PagoventaModel
{idpagoventa : number;
idventa : number;
idingresoegreso : number;
fecha:Date = new Date();
descripcion : string;
monto : decimal(10,0);
idtipopago : number;
idcotizacionmoneda : number;
idusuario : number;
idoficina : number;
constructor() {
this.idpagoventa = 0;
this.idventa = 0;
this.idingresoegreso = 0;
this.descripcion = '';
this.monto = decimal(10,0);
this.idtipopago = 0;
this.idcotizacionmoneda = 0;
this.idusuario = 0;
this.idoficina = 0;
}}