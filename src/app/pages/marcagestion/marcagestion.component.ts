import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { NgForm } from '@angular/forms';
import { Observable } from 'rxjs';

import { MarcaModel } from '../../models/marca.models';
import { SmarcaService } from '../../services/smarca.service';

import Swal from 'sweetalert2';

import { ProcedureParam } from '../../models/usuariotoken.models';


@Component({
  selector: 'app-marcagestion',
  templateUrl: './marcagestion.component.html',
  styleUrls: ['./marcagestion.component.scss'],
})
export class MarcagestionComponent implements OnInit {
  marca: MarcaModel = new MarcaModel();

  pidmarca = '1';

  constructor(
    private router: ActivatedRoute,
    private routera: Router,
    private smarcaService: SmarcaService,
    private marcaService: SmarcaService //, private spersonaService: SpersonaService //, private srolService: SrolService //, private srolmarcaService: SrolmarcaService
  ) {}
  procedureParam: ProcedureParam = new ProcedureParam();
  marcalista: MarcaModel[] = [];
  ngOnInit() {

    const id = this.router.snapshot.paramMap.get('id') || '0';
    this.marca.idmarca = parseInt(id);

    if (id !== '0') {
      this.smarcaService.getmarca(this.marca).subscribe((resp: any) => {
        this.marca = resp[0];
        this.cargamarca();
      });
    } else {
      this.cargamarca();
    }
  }
  cargamarca() {
    // this.procedureParam.inicia();
    // this.marcaService
    //   .selmarca(this.procedureParam)
    //   .subscribe((resp: any) => {
    //     this.marcalista = resp['info'].item;
    //   });
  }
  guardar(form: NgForm) {
    if (form.invalid) {
      console.log('Formulario no válido');
      return;
    }

    Swal.fire({
      allowOutsideClick: false,
      title: 'Espere',
      text: 'Guardando información...',
    });
    Swal.showLoading();
    //this.marca.idusuarioactualiza=parseInt( localStorage.getItem('parmid') ||'0');
    if (this.marca.idmarca > 0) {
      this.smarcaService.updmarca(this.marca).subscribe((resp) => {
        Swal.fire({
          allowOutsideClick: false,
          title: this.marca.idmarca,
          text: 'Se actualizó correctamente',
        });
        this.routera.navigateByUrl('/marca');
      });

    } else {
      this.smarcaService.addmarca(this.marca).subscribe((resp) => {
        Swal.fire({
          allowOutsideClick: false,
          title: this.marca.idmarca,
          text: 'Se creo correctamente',
        });
        this.routera.navigateByUrl('/marca');
      });

    }
  }

  changeidmarca(e: any) {
    this.marca.idmarca = e.target.value.toString();
  }
}
