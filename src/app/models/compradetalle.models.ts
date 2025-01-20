export class CompradetalleModel
{idcompradetalle : number;
idcompra : number;
nombrecompradetalle : string;
idproducto : number;
cantidad : decimal(10,0);
preciounitario : decimal(10,0);
precioventa : decimal(10,0);
subtotal : decimal(10,0);
fechaini:Date = new Date();
fechafin:Date = new Date();
idestadocompradetalle : number;
constructor() {
this.idcompradetalle = 0;
this.idcompra = 0;
this.nombrecompradetalle = '';
this.idproducto = 0;
this.cantidad = decimal(10,0);
this.preciounitario = decimal(10,0);
this.precioventa = decimal(10,0);
this.subtotal = decimal(10,0);
this.idestadocompradetalle = 0;
}}