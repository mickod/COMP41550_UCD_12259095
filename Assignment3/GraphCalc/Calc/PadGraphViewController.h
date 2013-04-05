//
//  PadGraphViewController.h
//  GraphCalc_Universal
//
//  Created by Mick O'Doherty on 03/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "SplitViewBarButtonItemPresenter.h"
#import "CalcModel.h"
#import "PlotGraphExpressionDelegate.h"

@interface PadGraphViewController : UIViewController <GraphViewDelegateProtocol, SplitViewBarButtonItemPresenter, PlotGraphExpressionDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet GraphView *thisGraphView;
@property (weak, nonatomic) CalcModel *calcModel;
- (CGPoint) getGraphOrigin;
@end
