import { Injectable } from '@angular/core';

import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';

import { map, tap } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment.prod';
// import { Respuesta } from '../interfaces/interfaces';
import { UsuariotokenModel } from '../models/usuariotoken.models';
import { UsuarioModel } from '../models/usuario.models';

const apiUlr = environment.apiUlr;
@Injectable({
  providedIn: 'root'
})
export class AuthService {

  // private url = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty';

  userToken: string = '';

  constructor(private http: HttpClient) {
    this.leerToken();
  }



  logout() {
    localStorage.removeItem('parmtoken');
    localStorage.removeItem('parmexpira');
    localStorage.removeItem('parmid');
    localStorage.removeItem('parmnombreusuario');
    localStorage.removeItem('parmidoficina');
    localStorage.removeItem('parmnombresucursal');
    localStorage.removeItem('parmidcierrecaja');
    localStorage.setItem('ppagina', '0');
  }

  login(usuario: UsuariotokenModel) {

    const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
    let body = new HttpParams();
    body = body.set('nombreusuario', usuario.plogin);
    body = body.set('clave', usuario.ppassword);
    return this.http.post(apiUlr + 'ValidaUser', body)
      .pipe(
        map((resp: any) => {
          if (resp['info'] != null) {
            if (resp['mesaje'] == 'OK') {
              usuario.pid = resp['info'].item.idusuario;
              usuario.token = resp['info'].item.llave;
              usuario.idubicacion  = resp['info'].item.idsucursal;
              this.guardarToken(usuario);
              return resp['info'].item;
            } else {
              console.log('FAILD');
              return null;
            }
          } else {
            console.log('error coneccion');
            return null;
          }

        })
      );

  }

  private guardarToken(usuario: UsuariotokenModel) {

    let hoy = new Date();

    console.log(usuario.plogin);
    hoy.setSeconds(3600);
    localStorage.setItem('parmid', usuario.pid);
    localStorage.setItem('parmnombreusuario', usuario.plogin);
    localStorage.setItem('parmtoken', usuario.token);
    localStorage.setItem('parmexpira', hoy.getTime().toString());
    localStorage.setItem('parmidrolusuario', usuario.idrolusuario.toString());
    localStorage.setItem('parmidoficina', usuario.idubicacion);


  }

  leerToken() {

    if (localStorage.getItem('token')) {
      this.userToken = localStorage.getItem('token') || '';
    } else {
      this.userToken = '';
    }

    return this.userToken;

  }

  estaAutenticado() {
    const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
    let body = new HttpParams();
    body = body.set('idusuario', localStorage.getItem('parmid') || '');
    body = body.set('llave', localStorage.getItem('parmtoken') || '');
    return this.http.post(apiUlr + 'selSistema', body).pipe(
      map((resp: any) => {
        if (resp['info'] != null) {
          if (resp['mesaje'] == 'Lista de Sistemas') {
            return resp['mesaje'];
          } else {
            console.log('FAILD');
            return null;
          }
        } else {
          console.log('error coneccion');
          return null;
        }

      })
    );
  }

  Cambiarpassword(usuario: UsuarioModel) {
    const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
    let body = new HttpParams();
    body = body.set('idusuario', localStorage.getItem('parmid') || '');
    body = body.set('llave', localStorage.getItem('parmtoken') || '');
    //parametros
    body = body.set('pidusuario', usuario.idusuario.toString()); body = body.set('pidpersona', usuario.idpersona.toString()); body = body.set('pnombreusuario', usuario.nombreusuario.toString()); body = body.set('pclave', usuario.clave.toString()); body = body.set('psalt', usuario.salt.toString()); body = body.set('ppin', usuario.pin.toString()); body = body.set('pidestadousuario', usuario.idestadousuario.toString()); body = body.set('pidtipousuario', usuario.idtipousuario.toString()); body = body.set('pestilo', usuario.estilo.toString()); body = body.set('pidsucursal', usuario.idsucursal.toString()); body = body.set('pidrol', usuario.idrol.toString()); console.log('llamar el post');
    //realizar consulta
    return this.http.post(apiUlr + 'Cambiarpassword', body)
      .pipe(map((resp: any) => {
        if (resp['info'] != null) {
          if (resp['mesaje'] != null) {
            return resp;
          }
          else {
            console.log('FAILD');
            return null;
          }
        }
        else {
          console.log('error coneccion');
          return null;
        }
      }));
  }

  Creapassword(usuario: UsuarioModel) {
    const myheader = new HttpHeaders().set('Content-Type', 'application/form-data')
    let body = new HttpParams();
    body = body.set('idusuario', localStorage.getItem('parmid') || '');
    body = body.set('llave', localStorage.getItem('parmtoken') || '');
    //parametros
    body = body.set('pidusuario', usuario.idusuario.toString()); body = body.set('pidpersona', usuario.idpersona.toString()); body = body.set('pnombreusuario', usuario.nombreusuario.toString()); body = body.set('pclave', usuario.clave.toString()); body = body.set('psalt', usuario.salt.toString()); body = body.set('ppin', usuario.pin.toString()); body = body.set('pidestadousuario', usuario.idestadousuario.toString()); body = body.set('pidtipousuario', usuario.idtipousuario.toString()); body = body.set('pestilo', usuario.estilo.toString()); body = body.set('pidsucursal', usuario.idsucursal.toString()); body = body.set('pidrol', usuario.idrol.toString());//realizar consulta
    return this.http.post(apiUlr + 'Creapassword', body)
      .pipe(map((resp: any) => {
        if (resp['info'] != null) {
          if (resp['mesaje'] != null) {
            return resp;
          }
          else {
            console.log('FAILD');
            return null;
          }
        }
        else {
          console.log('error coneccion');
          return null;
        }
      }));
  }
}
