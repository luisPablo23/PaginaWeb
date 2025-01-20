import { LOCALE_ID, NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { SalirComponent } from './pages/salir/salir.component';
import { InicioComponent } from './pages/inicio/inicio.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { NavbarComponent } from './components/navbar/navbar.component';
import { FooterComponent } from './components/footer/footer.component';
import { UsuarioComponent } from './pages/user/usuario/usuario.component';
import { UsuariogestionComponent } from './pages/user/usuariogestion/usuariogestion.component';
import { RolusuariogestionComponent } from './pages/user/rolusuariogestion/rolusuariogestion.component';
import { DatePipe,registerLocaleData } from '@angular/common';
import localEs from '@angular/common/locales/es';
import { ProductoComponent } from './pages/producto/producto.component';
import { ProductogestionComponent } from './pages/productogestion/productogestion.component';
import { MarcaComponent } from './pages/marca/marca.component';
import { MarcagestionComponent } from './pages/marcagestion/marcagestion.component';
import { ClasificacionproductoComponent } from './pages/clasificacionproducto/clasificacionproducto.component';
import { ClasificacionproductogestionComponent } from './pages/clasificacionproductogestion/clasificacionproductogestion.component';
import { PlandecuentaComponent } from './pages/plandecuenta/plandecuenta.component';
import { PlandecuentagestionComponent } from './pages/plandecuentagestion/plandecuentagestion.component';
registerLocaleData(localEs);
@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    SalirComponent,
    InicioComponent,
    NavbarComponent,
    FooterComponent,
    UsuarioComponent,
    UsuariogestionComponent,
    RolusuariogestionComponent,
    ProductoComponent,
    ProductogestionComponent,
    MarcaComponent,
    MarcagestionComponent,
    ClasificacionproductoComponent,
    ClasificacionproductogestionComponent,
    PlandecuentaComponent,
    PlandecuentagestionComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    ReactiveFormsModule,
  ],
  providers: [DatePipe,
    {
      provide: LOCALE_ID,
      useValue: 'es'
    }],
  bootstrap: [AppComponent]
})
export class AppModule { }
