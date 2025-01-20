export class UsuarioModel
{idusuario : number;
idpersona : number;
nombreusuario : string;
clave : string;
salt : string;
pin : number;
idestadousuario : number;
idtipousuario : number;
estilo : string;
idsucursal : number;
idrol : number;
constructor() {
this.idusuario = 0;
this.idpersona = 0;
this.nombreusuario = '';
this.clave = '';
this.salt = '';
this.pin = 0;
this.idestadousuario = 0;
this.idtipousuario = 0;
this.estilo = '';
this.idsucursal = 0;
this.idrol = 0;
}}
