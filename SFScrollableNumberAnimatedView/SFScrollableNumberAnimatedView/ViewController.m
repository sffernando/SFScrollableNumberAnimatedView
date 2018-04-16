//
//  ViewController.m
//  SFScrollableNumberAnimatedView
//
//  Created by Fernando on 2018/4/13.
//  Copyright © 2018年 Fernando. All rights reserved.
//

#import "ViewController.h"
#import "SFScrollableNumberAnimatedView.h"

@interface ViewController () {
    SFScrollableNumberAnimatedView *scrollNumberView;
    NSArray *numbers;
    NSUInteger currentIndex;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    currentIndex = 0;
    
    numbers = @[@(2654),@(462976),@(42.56),@(-256924),@(-55), @(-42532.74), @(-3.5),@(-9)];
    
    scrollNumberView = [[SFScrollableNumberAnimatedView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 80)];
    scrollNumberView.font = [UIFont boldSystemFontOfSize:30];
    scrollNumberView.minLength = 5;
    [self.view addSubview:scrollNumberView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startAnimation:(id)sender {
    NSNumber *number = [numbers objectAtIndex:currentIndex];
    
    [scrollNumberView setValue:number];
    [scrollNumberView startAnimation];
    
    currentIndex += 1;
    if (currentIndex >= numbers.count) {
        currentIndex = 0;
    }
}

@end
