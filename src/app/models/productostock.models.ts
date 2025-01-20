export class ProductostockModel
{idproductostock : number;
idproducto : number;
idoficina : number;
cantidad : decimal(10,0);
cantidadminima : decimal(10,0);
cantidadmaxima : decimal(10,0);
preciocompra : decimal(10,0);
precioventa : decimal(10,0);
idusuarioregistra : number;
idcompradetalle : number;
idcompradetalledato : number;
constructor() {
this.idproductostock = 0;
this.idproducto = 0;
this.idoficina = 0;
this.cantidad = decimal(10,0);
this.cantidadminima = decimal(10,0);
this.cantidadmaxima = decimal(10,0);
this.preciocompra = decimal(10,0);
this.precioventa = decimal(10,0);
this.idusuarioregistra = 0;
this.idcompradetalle = 0;
this.idcompradetalledato = 0;
}}