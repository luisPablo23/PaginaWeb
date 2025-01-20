import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MarcagestionComponent } from './marcagestion.component';

describe('MarcagestionComponent', () => {
  let component: MarcagestionComponent;
  let fixture: ComponentFixture<MarcagestionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [MarcagestionComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(MarcagestionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
