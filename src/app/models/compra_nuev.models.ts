export class Compra_NuevModel
{idcompra : number;
numerocompra : number;
nombrecompra : string;
titulo : string;
idusuario : number;
idproveedor : number;
fechacompra:Date = new Date();
tipocompra : number;
idoficina : number;
subtotal : decimal(10,0);
descuento : decimal(10,0);
total : decimal(10,0);
idmoneda : number;
descripcion : string;
idestadocompra : number;
pagado : decimal(10,0);
cambio : decimal(10,0);
idusuarioresponsable : number;
idaperturacierrecaja : number;
constructor() {
this.idcompra = 0;
this.numerocompra = 0;
this.nombrecompra = '';
this.titulo = '';
this.idusuario = 0;
this.idproveedor = 0;
this.tipocompra = 0;
this.idoficina = 0;
this.subtotal = decimal(10,0);
this.descuento = decimal(10,0);
this.total = decimal(10,0);
this.idmoneda = 0;
this.descripcion = '';
this.idestadocompra = 0;
this.pagado = decimal(10,0);
this.cambio = decimal(10,0);
this.idusuarioresponsable = 0;
this.idaperturacierrecaja = 0;
}}