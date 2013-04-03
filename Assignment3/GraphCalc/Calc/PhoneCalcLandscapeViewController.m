//
//  GraphCalcLandscapeViewController.m
//  GraphCalc
//
//  Created by Mick O'Doherty on 14/03/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PhonePortraitViewController.h"
#import "PhoneGraphViewController.h"
#import "PhoneCalcLandscapeViewController.h"

@interface PhoneCalcLandscapeViewController ()
@property bool isShowingLandscapeView;
@property UIViewController *currentViewController;
@end

@implementation PhoneCalcLandscapeViewController

- (IBAction)variableButtonPressed:(UIButton *)sender {
    
    [self.calcModel setVariableAsOperand:sender.titleLabel.text];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"ViewController prepareForSegue");
    if ([[segue identifier] isEqualToString:@"LANDSCAPE_GRAPH_SEGUE"]) {
        NSLog(@"ViewController prepareForSegue - kind is LANDSCAPE_GRAPH_SEGUE");
        PhoneGraphViewController *destinationVC = segue.destinationViewController;
        destinationVC.calcModel = self.calcModel;
    } 
}

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
        [self.calcModel setUserEnteredOperand:[self.calcDisplay.text doubleValue]];
        self.isInTheMiddleOfTypingSomething = NO;
    }
    NSString *operation = sender.titleLabel.text;
    double result = [self.calcModel performOperation:operation];
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", result]];
    [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
    [self.expressionDisplay setText:[CalcModel descriptionOfExpression:self.calcModel.expression]];
}

- (IBAction)solveButtonPressed:(id)sender {
    
    //Clear the display first
    [self.calcDisplay setText:@""];
    
    //Set dictionary values to test the evaluation
    NSMutableDictionary *testVariables = [[NSMutableDictionary alloc] init];
    [testVariables setValue:[NSNumber numberWithDouble:1] forKey:@"x"];
    [testVariables setValue:[NSNumber numberWithDouble:2] forKey:@"a"];
    [testVariables setValue:[NSNumber numberWithDouble:3] forKey:@"b"];
    [testVariables setValue:[NSNumber numberWithDouble:4] forKey:@"c"];
    
    double evaluationResult = [CalcModel evaluateExpression:self.calcModel.expression usingVariableValues:testVariables];
    
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", evaluationResult]];
}

- (IBAction)graphButtonPressed:(id)sender {
    
    //Check that the expression has a variable in it
    if (![CalcModel variablesInExpression:self.calcModel.expression]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Expression has no variable"
                                                          message:@""
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    
    //Perform the segue
    [self performSegueWithIdentifier:@"LANDSCAPE_GRAPH_SEGUE" sender:sender];
    
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
    
    //Hide the navigation controller back button
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    //Set this object as the delegate for its own calcModel
    self.calcModel.calcModelDelegate = self;
    //Set the degree or radians mode to the inital value of the segement selector
    NSString *degreeOrRadSelected = [self.radianOrDegreesSegmentedController titleForSegmentAtIndex:self.radianOrDegreesSegmentedController.selectedSegmentIndex];
    [self setCalcModelDegreeOrRadMode:degreeOrRadSelected];
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.operand]];
    [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
    [self.expressionDisplay setText:[CalcModel descriptionOfExpression:self.calcModel.expression]];
    
    //Set the back button on the navigator bar to generic calculator as the user may
    //rotate and then go back to the basic portrait calculator
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Calculator" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void) viewWillAppear:(BOOL)animated {
    
    //Check to see if the orientation is portrait when the view is appearing and if so
    //infomr the delegate in case the delagte want to do something (like pop this view...)
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
        [self.viewControllerdelegate landscapeViewlaunchedInPortraitEvent:self];
    }
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
