import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProductogestionComponent } from './productogestion.component';

describe('ProductogestionComponent', () => {
  let component: ProductogestionComponent;
  let fixture: ComponentFixture<ProductogestionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ProductogestionComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ProductogestionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
