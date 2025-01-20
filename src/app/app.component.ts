import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'appClinica';
  paginalogin = false;
  constructor(
    private router: Router) { }

  ngOnInit() {

    if (localStorage.getItem('parmid')) {

      this.paginalogin=true;
    }
    else{

      this.paginalogin=false;
      this.router.navigateByUrl('/login');
    }
  }
}
