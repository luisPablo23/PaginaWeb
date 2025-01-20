import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SalirComponent } from './pages/salir/salir.component';
import { LoginComponent } from './pages/login/login.component';
import { InicioComponent } from './pages/inicio/inicio.component';
import { UsuarioComponent } from './pages/user/usuario/usuario.component';
import { UsuariogestionComponent } from './pages/user/usuariogestion/usuariogestion.component';
import { RolusuariogestionComponent } from './pages/user/rolusuariogestion/rolusuariogestion.component';
import { ProductoComponent } from './pages/producto/producto.component';
import { ProductogestionComponent } from './pages/productogestion/productogestion.component';
import { MarcaComponent } from './pages/marca/marca.component';
import { MarcagestionComponent } from './pages/marcagestion/marcagestion.component';
import { PlandecuentaComponent } from './pages/plandecuenta/plandecuenta.component';
import { PlandecuentagestionComponent } from './pages/plandecuentagestion/plandecuentagestion.component';
import { ClasificacionproductoComponent } from './pages/clasificacionproducto/clasificacionproducto.component';
import { ClasificacionproductogestionComponent } from './pages/clasificacionproductogestion/clasificacionproductogestion.component';

const routes: Routes = [

  { path: 'usuario', component: UsuarioComponent },
  { path: 'usuariogestion/:id/:soloroles', component: UsuariogestionComponent },
  { path: 'rolusuariogestion/:id/:idusuario', component: RolusuariogestionComponent },

  { path: 'producto', component: ProductoComponent },
  { path: 'productogestion/:id', component: ProductogestionComponent },
  { path: 'marca', component: MarcaComponent },
  { path: 'marcagestion/:id', component: MarcagestionComponent },
  { path: 'marca', component: PlandecuentaComponent },
  { path: 'marcagestion/:id', component: PlandecuentagestionComponent },
  { path: 'plandecuenta', component: PlandecuentaComponent },
  { path: 'plandecuentagestion/:id', component: PlandecuentagestionComponent },
  { path: 'salir', component: SalirComponent },
  { path: 'login', component: LoginComponent },
  { path: '**', component: InicioComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { useHash: true })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
