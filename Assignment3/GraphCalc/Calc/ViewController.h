//
//  ViewController.h
//  Calc
//
//  Created by Mick O'Doherty on 12/02/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcModel.h"

@interface ViewController : UIViewController <CalcModelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *expressionDisplay;
@property (nonatomic, strong) IBOutlet CalcModel *calcModel;
@property (nonatomic,weak) IBOutlet UILabel *calcDisplay;
@property (nonatomic,weak) IBOutlet UILabel *memoryDisplay;
@property (nonatomic) BOOL isInTheMiddleOfTypingSomething;
@property (weak, nonatomic) IBOutlet UISegmentedControl *radianOrDegreesSegmentedController;
- (IBAction)variableButtonPressed:(UIButton *)sender;
- (IBAction)digitPressed: (UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)solveButtonPressed:(UIButton *)sender;
- (IBAction)degreeOrRadSelectionEvent:(UISegmentedControl*)sender;
@end
