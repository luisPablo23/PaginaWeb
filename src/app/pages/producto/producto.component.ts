import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router, Route } from '@angular/router';
import { NgForm } from '@angular/forms';
import { Observable } from 'rxjs';

import { SproductoService } from '../../services/sproducto.service';
import { ProductoModel } from '../../models/producto.models';

import Swal from 'sweetalert2';
import { ProcedureParam } from '../../models/usuariotoken.models';

@Component({
  selector: 'app-producto',
  templateUrl: './producto.component.html',
  styleUrl: './producto.component.css'
})
export class ProductoComponent implements OnInit {

  productos: any[] = [];
  estadolista='1';
  cargando = false;

  constructor(private router: ActivatedRoute,private routera: Router, private productoService: SproductoService) { }
  procedureParam: ProcedureParam = new ProcedureParam();
  ngOnInit(): void {
    this.estadolista='1';
    this.buscar();
  }
  change(e: any) {

    this.estadolista = e.target.value.toString();
    this.buscar();
  }
  buscar() {
    this.cargando = true;
    this.productoService.selproducto(this.procedureParam).subscribe(resp => {
      this.productos = resp['info'].item.map((producto: any) => ({
        ...producto,
        imagen: `assets/img/${producto.idproducto}.png` // Ruta de las imágenes "si o si png", el orden sera dependiendo el id del producto
      }));
      this.cargando = false;
    });
  } 
  trackByFn(index: number, item: any): number {
    return item.idproducto; // Usamos el ID del producto como identificador único de cada producto
  } 

}