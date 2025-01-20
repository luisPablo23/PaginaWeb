import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { NgForm } from '@angular/forms';
import { Observable } from 'rxjs';

import { UsuarioModel } from '../../../models/usuario.models';
import { SusuarioService } from '../../../services/susuario.service';

import Swal from 'sweetalert2';

import { ProcedureParam } from '../../../models/usuariotoken.models';
import { SrolService } from '../../../services/srol.service';
import { RolModel } from '../../../models/rol.models';
import { SpersonaService } from '../../..//services/spersona.service';
import { PersonaModel } from '../../..//models/persona.models';
import { AuthService } from 'src/app/services/auth.service';
import { RolusuarioModel } from 'src/app/models/rolusuario.models';
import { SrolusuarioService } from 'src/app/services/srolusuario.service';

@Component({
  selector: 'app-usuariogestion',
  templateUrl: './usuariogestion.component.html',
  styleUrls: ['./usuariogestion.component.scss'],
})
export class UsuariogestionComponent implements OnInit {
  usuario: UsuarioModel = new UsuarioModel();
  persona: PersonaModel = new PersonaModel();
  pass1 = '';
  pass2 = '';
  soloroles = '0';

  constructor(
    private router: ActivatedRoute,
    private routera: Router,
    private susuarioService: SusuarioService,
    private personaService: SpersonaService,
    private auth: AuthService,
    private rolusuarioService: SrolusuarioService,
    private rolService: SrolService //, private spersonaService: SpersonaService //, private srolService: SrolService //, private srolusuarioService: SrolusuarioService
  ) { }
  procedureParam: ProcedureParam = new ProcedureParam();
  rolusuario: any[] = [];
  cargando = false;
  ngOnInit() {

    const id = this.router.snapshot.paramMap.get('id') || '0';
    this.soloroles = this.router.snapshot.paramMap.get('soloroles') || '0';
    this.usuario.idusuario = parseInt(id);
    this.persona.fechanacimiento = new Date();
    if (id !== '0') {
      this.susuarioService.getusuario(this.usuario).subscribe((resp: any) => {
        this.usuario = resp['info'].item[0];

        this.persona.idpersona = this.usuario.idpersona;
        this.personaService.getpersona(this.persona).subscribe((resp: any) => {
          this.persona = resp['info'].item[0];
          this.cargarolusuario();
          this.cargando = false;
        });
      });
    } else {

    }
  }
  cargarolusuario() {
    this.procedureParam.pCampo0 = 'Nidusuario';
    this.procedureParam.pValor0 = this.usuario.idusuario.toString();
    this.rolusuarioService.selrolusuario(this.procedureParam)
      .subscribe(resp => {
        console.log('task:1');
        console.log(resp['info'].item);
        this.rolusuario = resp['info'].item;

      });
  }
  guardar(form: NgForm) {
    if (form.invalid) {
      Swal.fire({
        allowOutsideClick: false,
        title: this.usuario.idusuario,
        text: 'Complete el formulario',
      });
      return;
    }
    if (this.pass1 !== this.pass2) {
      Swal.fire({
        allowOutsideClick: false,
        title: this.usuario.idusuario,
        text: 'contraseña invalida',
      });
      return;
    }
    Swal.fire({
      allowOutsideClick: false,
      title: 'Espere',
      text: 'Guardando información...',
    });
    Swal.showLoading();

    let peticion: Observable<any>;
    this.usuario.clave = this.pass1;
    this.usuario.idsucursal = parseInt(
      localStorage.getItem('parmidoficina') || '0'
    );
    this.usuario.idtipousuario = 1;


    // this.usuario.idubicacion = Number(this.pidubicacion);
    this.persona.idtipopersona = 1;
    if (this.usuario.idusuario > 0) {
      this.auth.Cambiarpassword(this.usuario).subscribe((resp) => {
        this.personaService.updpersona(this.persona).subscribe((resp) => {
          Swal.fire({
            allowOutsideClick: false,
            title: this.usuario.idusuario,
            text: 'Se actualizó correctamente',
          });
        });
      });
    } else {
      this.persona.fechanacimiento = new Date();
      this.personaService.addpersona(this.persona).subscribe((resp) => {
        this.usuario.idpersona = resp['info'].item[0].idpersona;
        this.auth.Creapassword(this.usuario).subscribe((resp) => {

          Swal.fire({
            allowOutsideClick: false,
            title: this.usuario.idusuario,
            text: 'Se creo correctamente',
          });
          this.routera.navigateByUrl('/usuario');

        });
      });
    }
  }
  // changeidrol(e: any) {
  //   this.usuario.idrol = e.target.value.toString();

  // }
  changeidestadousuario(e: any) {
    this.usuario.idestadousuario = e.target.value.toString();
  }
  //  changeidestado(e: any) {
  //    this.usuario.id = e.target.value.toString();
  //  }
}
