import { Component, OnInit } from '@angular/core';

import { FormBuilder, FormGroup, NgForm, Validators } from '@angular/forms';
import { FormControl } from '@angular/forms';
import { Router } from '@angular/router';
import { UsuariotokenModel,ProcedureParam } from '../../models/usuariotoken.models';


import { AuthService } from '../../services/auth.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  loginForm = this.fb.group({
    usuario: ['', [Validators.required]],
    clave: ['', [Validators.required, Validators.minLength(6)]],
  });
  usuario: UsuariotokenModel = new UsuariotokenModel();
  procedureParam: ProcedureParam = new ProcedureParam();
  recordarme = false;
  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private router: Router
  ) {

  }

  ngOnInit(): void {}

  onClicklogin(form: NgForm) {
    if (form.invalid) {
      return;
    }
    Swal.fire({
      allowOutsideClick: false,
      title: 'info',
      text: 'Espere por favor...',
    });
    Swal.showLoading();
    this.auth.login(this.usuario).subscribe(
      (resp) => {

        if (resp != null) {
          Swal.close();
          this.router.navigateByUrl('/inicio');
        } else {

          Swal.fire({
            allowOutsideClick: false,
            title: 'info',
            text: "Usuario no valido",
          });

        }
      },
      (err) => {
        console.log(err);

        Swal.fire({
          allowOutsideClick: false,
          title: 'info',
          text: err.error.error.message,
        });
      });
  }
}
