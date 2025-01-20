import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router, Route } from '@angular/router';
import { NgForm } from '@angular/forms';
import { Observable } from 'rxjs';

import { SmarcaService } from '../../services/smarca.service';
import { MarcaModel } from '../../models/marca.models';

import Swal from 'sweetalert2';
import { ProcedureParam } from '../../models/usuariotoken.models';

@Component({
  selector: 'app-marca',
  templateUrl: './marca.component.html',
  styleUrls: ['./marca.component.scss']
})
export class MarcaComponent implements OnInit {

  marcas: any[] = [];
  estadolista='1';
  cargando = false;

  constructor(private router: ActivatedRoute,private routera: Router, private marcaService: SmarcaService) { }
  procedureParam: ProcedureParam = new ProcedureParam();
  ngOnInit(): void {
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
    this.marcaService.selmarca(this.procedureParam)
      .subscribe( resp => {
        this.marcas = resp;
        this.cargando = false;
      });
  }

}
