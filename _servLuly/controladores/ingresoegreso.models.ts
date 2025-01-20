export class IngresoegresoModel
{idingresoegreso : number;
descripcion : string;
fechaingresoegreso : Date = new Date();
idplandecuenta : number;
monto : number;
idmoneda : number;
idtipopago : number;
idusuario : number;
idsucursal : number;
idcierrecaja : number;
constructor() {
this.idingresoegreso = 0;
this.descripcion = '';
this.fechaingresoegreso =  new Date();
this.idplandecuenta = 0;
this.monto = 0;
this.idmoneda = 0;
this.idtipopago = 0;
this.idusuario = 0;
this.idsucursal = 0;
this.idcierrecaja = 0;
}}