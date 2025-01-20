import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router, Route } from '@angular/router';
import { NgForm } from '@angular/forms';
import { Observable } from 'rxjs';

import { SusuarioService } from '../../../services/susuario.service';
import { UsuarioModel } from '../../../models/usuario.models';

import Swal from 'sweetalert2';
import { ProcedureParam } from '../../../models/usuariotoken.models';

@Component({
  selector: 'app-usuario',
  templateUrl: './usuario.component.html',
  styleUrls: ['./usuario.component.scss']
})
export class UsuarioComponent implements OnInit {

  usuarios: any[] = [];
  estadolista='1';
  cargando = false;

  constructor(private router: ActivatedRoute,private routera: Router, private usuarioService: SusuarioService) { }
  procedureParam: ProcedureParam = new ProcedureParam();
  ngOnInit(): void {
    // if(parseInt(localStorage.getItem('parmidrolusuario') ||'0') >2)
    // {
    //   this.routera.navigateByUrl('/inicio');
    // }
    this.estadolista='1';
    this.buscar();
  }
  change(e: any) {

    this.estadolista = e.target.value.toString();
    this.buscar();
  }
  buscar()
  {
    this.cargando = true;
    // this.procedureParam.pCampo0 = 'Nidoficina';
    // this.procedureParam.pValor0 = localStorage.getItem('parmidoficina') || '0';

    this.usuarioService.selusuario(this.procedureParam)
      .subscribe( resp => {
        this.usuarios = resp['info'].item;

        this.cargando = false;
      });
  }

}
