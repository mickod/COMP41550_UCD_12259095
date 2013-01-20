//
//  PolyAnimateViewController.m
//  HelloPoly
//
//  Created by Mick O'Doherty on 18/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PolyAnimateViewController.h"

#define MOUSE_IMAGE_NAME @"Mouse"
#define MOUSE_IMAGE_FILENAME @"mouse1.png"

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
    [ self setImageSelectorSelectedSegment];
    
}

- (void) setImageSelectorSelectedSegment {
    //Set the selctor index based on the name of the current selected animation image
    NSString *currentImageName = [self.polygonAnimateStateDelegate getCurrentAnimationImageName:self];
    
    //A better method to map the name to the index and visa versa would be a good idea but this will
    //do for the purposes of this exercise
    for (int i=0; i<[self.imageSelectorSegmentControl.subviews count]; i++)
    {
        if ([[self.imageSelectorSegmentControl titleForSegmentAtIndex:i] isEqualToString:currentImageName] )
        {
            self.imageSelectorSegmentControl.selectedSegmentIndex = i;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)imageSelectorEvent:(UISegmentedControl *)sender {
    
    NSLog(@"PolyAnimateViewController imageSelectorEvent");
    [self.polygonAnimateStateDelegate setAnimationImageName:[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] :(self)];
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
