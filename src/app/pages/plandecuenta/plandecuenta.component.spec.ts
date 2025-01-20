import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PlandecuentaComponent } from './plandecuenta.component';

describe('PlandecuentaComponent', () => {
  let component: PlandecuentaComponent;
  let fixture: ComponentFixture<PlandecuentaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [PlandecuentaComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PlandecuentaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
