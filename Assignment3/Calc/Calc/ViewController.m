//
//  ViewController.m
//  Calc
//
//  Created by Mick O'Doherty on 12/02/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize calcModel = _calcModel;
@synthesize calcDisplay = _calcDisplay;
@synthesize isInTheMiddleOfTypingSomething = _isInTheMiddleOfTypingSomething;
- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.titleLabel.text;
    if (self.isInTheMiddleOfTypingSomething) {
        //check to see if button pressed is a decimal point
        if ([digit isEqualToString:@"."]) {
            //If it is a decimal point check if there is one already - if so
            //just return without doing anything else
            if ([self.calcDisplay.text rangeOfString:@"."].location != NSNotFound) {
                return;
            }
        }
        self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
    } else {
        [self.calcDisplay setText:digit];
        self.isInTheMiddleOfTypingSomething = YES;
    }
}
- (IBAction)operationPressed:(UIButton *)sender {
    if (self.isInTheMiddleOfTypingSomething) {
        self.calcModel.operand = [self.calcDisplay.text doubleValue];
        self.isInTheMiddleOfTypingSomething = NO;
    }
    NSString *operation = sender.titleLabel.text;
    double result = [self.calcModel performOperation:operation];
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", result]];
    [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
}

- (IBAction)degreeOrRadSelectionEvent:(UISegmentedControl*)sender {
    NSString *segmentSelectedTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex] ;
    
    [self setCalcModelDegreeOrRadMode:segmentSelectedTitle];
}

- (void) receiveNotificationOfError:(CalcModel *)withErrorText :(NSString *)errorText {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:errorText
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void) viewDidLoad {
    //Set this object as the delegate for its own calcModel
    self.calcModel.calcModelDelegate = self;
    //Set the degree or radians mode to the inital value of the segement selector
    NSString *degreeOrRadSelected = [self.radianOrDegreesSegmentedController titleForSegmentAtIndex:self.radianOrDegreesSegmentedController.selectedSegmentIndex];
    [self setCalcModelDegreeOrRadMode:degreeOrRadSelected];
}

-(void) setCalcModelDegreeOrRadMode:(NSString*) selectionText {
    
    //If the selector is rad set the calc model to use radians, otherwise
    //default to degrees (this covers the error case where the selected value is
    //neither for some reason
    if ( [selectionText isEqualToString:@"Rad"] ) {
        self.calcModel.useDegreesNotRads = NO;
    } else {
        self.calcModel.useDegreesNotRads = YES;
    }
}

@end
