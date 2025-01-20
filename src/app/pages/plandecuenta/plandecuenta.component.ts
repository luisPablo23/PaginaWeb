import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router, Route } from '@angular/router';
import { NgForm } from '@angular/forms';
import { Observable } from 'rxjs';

import { SplandecuentaService } from '../../services/splandecuenta.service';
import { PlandecuentaModel } from '../../models/plandecuenta.models';

import Swal from 'sweetalert2';
import { ProcedureParam } from '../../models/usuariotoken.models';
import { SparametrotipoService } from 'src/app/services/sparametrotipo.service';

@Component({
  selector: 'app-plandecuenta',
  templateUrl: './plandecuenta.component.html',
  styleUrls: ['./plandecuenta.component.scss']
})
export class PlandecuentaComponent implements OnInit {

  plandecuentas: any[] = [];
  plandecuenta: PlandecuentaModel = new PlandecuentaModel();
  parametrotipolista: any[] = [];

  cargando = false;

  constructor(private router: ActivatedRoute, private routera: Router, private plandecuentaService: SplandecuentaService
    , private parametrotipoService: SparametrotipoService) { }
  procedureParam: ProcedureParam = new ProcedureParam();
  ngOnInit(): void {
    this.procedureParam.inicia();
    this.procedureParam.pCampo0 = 'NNombrecampo';
    this.procedureParam.pValor0 = 'idtipoplandecuenta';
    this.parametrotipoService.selparametrotipo(this.procedureParam)
      .subscribe(resp => {
        this.parametrotipolista = resp['info'].item;
        this.plandecuenta.idtipoplandecuenta=1;
        this.buscar();
      });
  }
  change(e: any) {

    this.plandecuenta.idtipoplandecuenta = e.target.value.toString();
    this.buscar();
  }
  buscar() {
    this.cargando = true;

    this.procedureParam.inicia();
    this.procedureParam.pCampo0 = 'Nidtipoplandecuenta';
    this.procedureParam.pValor0 = this.plandecuenta.idtipoplandecuenta.toString();
    this.plandecuentaService.selplandecuenta(this.procedureParam)
      .subscribe(resp => {
        this.plandecuentas = resp;

        this.cargando = false;

      });
  }

}
