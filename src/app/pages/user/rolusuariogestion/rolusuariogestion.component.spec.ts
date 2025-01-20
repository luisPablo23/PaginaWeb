import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RolusuariogestionComponent } from './rolusuariogestion.component';

describe('RolusuariogestionComponent', () => {
  let component: RolusuariogestionComponent;
  let fixture: ComponentFixture<RolusuariogestionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [RolusuariogestionComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RolusuariogestionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
