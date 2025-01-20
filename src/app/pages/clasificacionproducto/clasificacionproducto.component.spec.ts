import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ClasificacionproductoComponent } from './clasificacionproducto.component';

describe('ClasificacionproductoComponent', () => {
  let component: ClasificacionproductoComponent;
  let fixture: ComponentFixture<ClasificacionproductoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ClasificacionproductoComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ClasificacionproductoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
