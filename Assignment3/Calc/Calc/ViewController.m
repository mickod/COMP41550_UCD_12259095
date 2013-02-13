//
//  ViewController.m
//  Calc
//
//  Created by Mick O'Doherty on 12/02/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) BOOL decimalPointAlreadyEntered;
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
            //If it is a decimal point is there one already - if so
            //just return without doing anything else
            if (self.decimalPointAlreadyEntered) {
                return;
            } else {
                self.decimalPointAlreadyEntered = YES;
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
        self.decimalPointAlreadyEntered = NO;
    }
    NSString *operation = sender.titleLabel.text;
    double result = [self.calcModel performOperation:operation];
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", result]];
}
@end
