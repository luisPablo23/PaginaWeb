import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { NgForm } from '@angular/forms';
import { Observable } from 'rxjs';

import { ProductoModel } from '../../models/producto.models';
import { SproductoService } from '../../services/sproducto.service';

import Swal from 'sweetalert2';

import { ProcedureParam } from '../../models/usuariotoken.models';
import { SmarcaService } from 'src/app/services/smarca.service';
import { MarcaModel } from '../../models/marca.models';
import { SclasificacionproductoService } from 'src/app/services/sclasificacionproducto.service';
import { ClasificacionproductoModel } from 'src/app/models/clasificacionproducto.models';

@Component({
  selector: 'app-productogestion',
  templateUrl: './productogestion.component.html',
  styleUrls: ['./productogestion.component.scss'],
})
export class ProductogestionComponent implements OnInit {
  producto: ProductoModel = new ProductoModel();

  pidmarca = '1';

  constructor(
    private router: ActivatedRoute,
    private routera: Router,
    private sproductoService: SproductoService,
    private marcaService: SmarcaService,
    private clasificacionproductoService: SclasificacionproductoService
    //, private spersonaService: SpersonaService //, private srolService: SrolService //, private srolproductoService: SrolproductoService
  ) {}
  procedureParam: ProcedureParam = new ProcedureParam();
  marcalista: MarcaModel[] = [];
  clasificacionproductolista: ClasificacionproductoModel[] = [];
  ngOnInit() {
    
    const id = this.router.snapshot.paramMap.get('id') || '0';
    
    this.producto.idproducto = parseInt(id);
    
    if (id !== '0') {
      
      this.sproductoService.getproducto(this.producto).subscribe((resp: any) => {
        this.producto = resp['info'].item[0];
        this.cargamarca();
     
      });
    } else {
      this.cargamarca();
    }
    
  }
  cargamarca() {
    this.procedureParam.inicia();
    this.marcaService
      .selmarca(this.procedureParam)
      .subscribe((resp: any) => {       
        this.marcalista = resp;
        this.procedureParam.inicia();
        this.clasificacionproductoService.selclasificacionproducto(this.procedureParam)
          .subscribe((resp: any) => {
            this.clasificacionproductolista = resp;
          });
      });
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
    this.producto.idmarca=1;
    this.producto.idusuarioactualiza=parseInt( localStorage.getItem('parmid') ||'0');
    if (this.producto.idproducto > 0) {
      this.sproductoService.updproducto(this.producto).subscribe((resp) => {
        Swal.fire({
          allowOutsideClick: false,
          title: this.producto.idproducto,
          text: 'Se actualizó correctamente',
        });
      });
      this.routera.navigateByUrl('/producto');
    } else {
      this.sproductoService.addproducto(this.producto).subscribe((resp) => {
        Swal.fire({
          allowOutsideClick: false,
          title: this.producto.idproducto,
          text: 'Se creo correctamente',
        });
      });
      this.routera.navigateByUrl('/producto');
    }
  }

  changeidmarca(e: any) {
    this.producto.idmarca = e.target.value.toString();
  }
  changeidclasificacionproducto(e: any) {
    this.producto.idclasificacionproducto = e.target.value.toString();
  }

}
