//
//  PadCalcViewController.h
//  GraphCalc_Universal
//
//  Created by Mick O'Doherty on 03/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalCalcViewController.h"

@interface PadCalcViewController : UniversalCalcViewController <UISplitViewControllerDelegate>
@property (weak, nonatomic) id<PlotGraphExpressionDelegate> plotGraphDelegate;

@end
