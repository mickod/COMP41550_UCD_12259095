//
//  GraphCalcLandscapeViewController.h
//  GraphCalc
//
//  Created by Mick O'Doherty on 14/03/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalCalcViewController.h"
@class PhoneCalcLandscapeViewController;

@protocol GraphCalcLandscapeViewControllerDelegate
- (void) landscapeViewlaunchedInPortraitEvent:(PhoneCalcLandscapeViewController *) sender;
@end

@interface PhoneCalcLandscapeViewController : UniversalCalcViewController 
@property id <GraphCalcLandscapeViewControllerDelegate> viewControllerdelegate;
@end
