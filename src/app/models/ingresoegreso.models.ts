export class IngresoegresoModel
{idingresoegreso : number;
descripcion : string;
fechaingresoegreso:Date = new Date();
idplandecuenta : number;
monto : decimal(10,0);
idmoneda : number;
idtipopago : number;
idusuario : number;
idoficina : number;
idcierrecaja : number;
constructor() {
this.idingresoegreso = 0;
this.descripcion = '';
this.idplandecuenta = 0;
this.monto = decimal(10,0);
this.idmoneda = 0;
this.idtipopago = 0;
this.idusuario = 0;
this.idoficina = 0;
this.idcierrecaja = 0;
}}