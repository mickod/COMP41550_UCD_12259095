//
//  GraphCalcLandscapeViewController.h
//  GraphCalc
//
//  Created by Mick O'Doherty on 14/03/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhoneCalcLandscapeViewController;

@protocol GraphCalcLandscapeViewControllerDelegate
- (void) landscapeViewlaunchedInPortraitEvent:(PhoneCalcLandscapeViewController *) sender;
@end

@interface PhoneCalcLandscapeViewController : UIViewController <CalcModelDelegate>
@property id <GraphCalcLandscapeViewControllerDelegate> viewControllerdelegate;
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
- (IBAction)graphButtonPressed:(id)sender;
- (IBAction)degreeOrRadSelectionEvent:(UISegmentedControl*)sender;
@end
