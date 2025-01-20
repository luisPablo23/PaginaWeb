import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ClasificacionproductogestionComponent } from './clasificacionproductogestion.component';

describe('ClasificacionproductogestionComponent', () => {
  let component: ClasificacionproductogestionComponent;
  let fixture: ComponentFixture<ClasificacionproductogestionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ClasificacionproductogestionComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ClasificacionproductogestionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
