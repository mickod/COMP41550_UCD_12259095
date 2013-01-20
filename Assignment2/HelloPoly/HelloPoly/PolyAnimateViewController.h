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
polygonAnimateStateDelegator;
- (Boolean) getCurrentAnimationState: (PolyAnimateViewController *)
polygonAnimateStateDelegator;
- (float) getCurrentAnimationDuration: (PolyAnimateViewController *)
polygonAnimateStateDelegator;
@end

@interface PolyAnimateViewController : UIViewController
@property (strong, nonatomic) PolygonShape *model;
@property id <PolygonAnimateViewProtocol> polygonAnimateStateDelegate;
@property (weak, nonatomic) IBOutlet UISwitch *animateSwitch;
@property (weak, nonatomic) IBOutlet UISlider *animationDurationSlider;
- (IBAction)animateSwitchEvent:(UISwitch*)sender;
- (IBAction)animateSpeedSetEvent:(UISlider*)sender;
@end
