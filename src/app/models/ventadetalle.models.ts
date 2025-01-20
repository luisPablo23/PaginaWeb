export class VentadetalleModel
{idventadetalle : number;
idventa : number;
nombreventadetalle : string;
idproducto : number;
cantidad : decimal(10,0);
preciounitario : decimal(10,0);
subtotal : decimal(10,0);
fechaini:Date = new Date();
fechafin:Date = new Date();
idestadoventadetalle : number;
idcompradetalle : number;
constructor() {
this.idventadetalle = 0;
this.idventa = 0;
this.nombreventadetalle = '';
this.idproducto = 0;
this.cantidad = decimal(10,0);
this.preciounitario = decimal(10,0);
this.subtotal = decimal(10,0);
this.idestadoventadetalle = 0;
this.idcompradetalle = 0;
}}