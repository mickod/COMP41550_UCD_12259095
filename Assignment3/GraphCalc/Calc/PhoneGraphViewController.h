//
//  GraphViewController.h
//  GraphCalc
//
//  Created by Mick O'Doherty on 12/03/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "CalcModel.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface PhoneGraphViewController : UIViewController <GraphViewDelegateProtocol>
@property (weak, nonatomic) IBOutlet GraphView *thisGraphView;
@property (weak, nonatomic) CalcModel *calcModel;
- (IBAction)zoomPlusEvent:(id)sender;
- (IBAction)zoomMinusEvent:(id)sender;
@end
