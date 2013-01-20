//
//  PolyAnimateViewController.m
//  HelloPoly
//
//  Created by Mick O'Doherty on 18/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PolyAnimateViewController.h"

@interface PolyAnimateViewController ()
@end

@implementation PolyAnimateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UISwitch*) animateSwitch {
    
    NSLog(@"PolyAnimateViewController animateSwitch setter");
    return _animateSwitch;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get the correct value of the animate switch from the delegate
    NSLog(@"PolyAnimateViewController viewDidLoad");
    [self.animateSwitch setOn: [self.polygonAnimateStateDelegate getCurrentAnimationState:self]  animated:YES];
    self.animationDurationSlider.value = [self.polygonAnimateStateDelegate getCurrentAnimationDuration:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)animateSwitchEvent:(UISwitch*)sender {
    
    NSLog(@"PolyAnimateViewController animateSwitchEvent");
    [self.polygonAnimateStateDelegate setAnimation:[sender isOn] :(self)];
}

- (IBAction)animateSpeedSetEvent:(UISlider*)sender {
    
    NSLog(@"PolyAnimateViewController animateSliderEvent");
    [self.polygonAnimateStateDelegate setAnimationDuration:sender.value :(self)];
    
}
@end
