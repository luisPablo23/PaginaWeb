import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UsuariogestionComponent } from './usuariogestion.component';

describe('UsuariogestionComponent', () => {
  let component: UsuariogestionComponent;
  let fixture: ComponentFixture<UsuariogestionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [UsuariogestionComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(UsuariogestionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
