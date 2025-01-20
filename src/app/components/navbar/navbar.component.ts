import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrl: './navbar.component.css'
})
export class NavbarComponent implements OnInit {

  constructor() { }
  usuario: String = "Usuario:";
  nombreoficina: String = "Usuario:";
  ngOnInit(): void {
    this.usuario=localStorage.getItem('parmnombreusuario') ||'N';
    this.nombreoficina='oficina:'+localStorage.getItem('parmidoficina') ||'N';
  }

}
