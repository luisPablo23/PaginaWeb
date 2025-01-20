export class PersonaModel
{idpersona : number;
idtipopersona : number;
nombre : string;
paterno : string;
materno : string;
direccion : string;
celular : string;
celularcontacto : string;
fechanacimiento : Date = new Date();
idtiposexo : number;
observaciones : string;
nrodocumento : string;
idtipodocumento : number;
nit : string;
constructor() {
this.idpersona = 0;
this.idtipopersona = 0;
this.nombre = '';
this.paterno = '';
this.materno = '';
this.direccion = '';
this.celular = '';
this.celularcontacto = '';
this.fechanacimiento =  new Date();
this.idtiposexo = 0;
this.observaciones = '';
this.nrodocumento = '';
this.idtipodocumento = 0;
this.nit = '';
}}