export class CierrecajaModel
{idcierrecaja : number;
idoficina : number;
idusuario : number;
montoinicio : decimal(10,0);
montofinal : decimal(10,0);
idusuariocierre : number;
idestadocierrecaja : smallint(6);
fechainicio:Date = new Date();
fechafinal:Date = new Date();
constructor() {
this.idcierrecaja = 0;
this.idoficina = 0;
this.idusuario = 0;
this.montoinicio = decimal(10,0);
this.montofinal = decimal(10,0);
this.idusuariocierre = 0;
this.idestadocierrecaja = smallint(6);
}}