//
//  ViewController.m
//  Color Wheel
//
//  Created by George Waters on 7/1/15.
//  Copyright (c) 2015 George Waters. All rights reserved.
//

#import "ViewController.h"
#import "GWColorWheel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GWColorWheel *colorWheel;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapGestureRecognized:(UITapGestureRecognizer *)sender {
    self.bannerView.backgroundColor = [self.colorWheel colorAtPoint:[sender locationInView:self.colorWheel]];
}

- (IBAction)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    self.bannerView.backgroundColor = [self.colorWheel colorAtPoint:[sender locationInView:self.colorWheel]];
}



@end
