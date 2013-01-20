//
//  PolyAnimateViewController.h
//  HelloPoly
//
//  Created by Mick O'Doherty on 18/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonShape.h"
@class PolyAnimateViewController;

@protocol PolygonAnimateViewProtocol
- (void) setAnimation:(Boolean) animateState: (PolyAnimateViewController *)
polygonAnimateStateDelegator;
- (void) setAnimationDuration:(float) animateState: (PolyAnimateViewController *)
polygonAnimateControllerDelegator;
- (Boolean) getCurrentAnimationState: (PolyAnimateViewController *)
polygonAnimateControllerDelegator;
- (float) getCurrentAnimationDuration: (PolyAnimateViewController *)
polygonAnimateControllerDelegator;
- (void) setAnimationImageName:(NSString*) imageName: (PolyAnimateViewController *)
polygonAnimateControllerDelegator;
- (NSString*) getCurrentAnimationImageName: (PolyAnimateViewController *)
polygonAnimateControllerDelegator;
@end

@interface PolyAnimateViewController : UIViewController
@property (strong, nonatomic) PolygonShape *model;
@property id <PolygonAnimateViewProtocol> polygonAnimateStateDelegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *imageSelectorSegmentControl;
@property (weak, nonatomic) IBOutlet UISwitch *animateSwitch;
@property (weak, nonatomic) IBOutlet UISlider *animationDurationSlider;
- (IBAction)imageSelectorEvent:(UISegmentedControl *)sender;
- (IBAction)animateSwitchEvent:(UISwitch*)sender;
- (IBAction)animateSpeedSetEvent:(UISlider*)sender;
@end
