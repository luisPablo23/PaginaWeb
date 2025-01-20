import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PlandecuentagestionComponent } from './plandecuentagestion.component';

describe('PlandecuentagestionComponent', () => {
  let component: PlandecuentagestionComponent;
  let fixture: ComponentFixture<PlandecuentagestionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [PlandecuentagestionComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PlandecuentagestionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
