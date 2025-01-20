export class CotizaciondetalleModel
{idcotizaciondetalle : number;
idcotizacion : number;
nombrecotizaciondetalle : string;
idproducto : number;
cantidad : decimal(10,0);
preciounitario : decimal(10,0);
precioventa : decimal(10,0);
subtotal : decimal(10,0);
fechaini:Date = new Date();
fechafin:Date = new Date();
idestadocotizaciondetalle : number;
idcompradetalle : number;
constructor() {
this.idcotizaciondetalle = 0;
this.idcotizacion = 0;
this.nombrecotizaciondetalle = '';
this.idproducto = 0;
this.cantidad = decimal(10,0);
this.preciounitario = decimal(10,0);
this.precioventa = decimal(10,0);
this.subtotal = decimal(10,0);
this.idestadocotizaciondetalle = 0;
this.idcompradetalle = 0;
}}