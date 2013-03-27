//
//  ViewController.m
//  Calc
//
//  Created by Mick O'Doherty on 12/02/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "ViewController.h"
#import "GraphViewController.h"
#import "GraphCalcLandscapeViewController.h"

@interface ViewController ()
@property bool isShowingLandscapeView;
@property UIViewController *currentViewController;
@end

@implementation ViewController

- (IBAction)variableButtonPressed:(UIButton *)sender {
    
    [self.calcModel setVariableAsOperand:sender.titleLabel.text];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"ViewController prepareForSegue");
    if ([[segue identifier] isEqualToString:@"CHECKED_GRAPH_SEGUE"]) {
        NSLog(@"ViewController prepareForSegue - kind is GRAPH_SEGUE");
        GraphViewController *destinationVC = segue.destinationViewController;
        destinationVC.calcModel = self.calcModel;
    } else if ([[segue identifier] isEqualToString:@"LANDSCAPE_SEGUE"]) {
        NSLog(@"ViewController prepareForSegue - kind is LANDSCAPE_SEGUE");
        GraphCalcLandscapeViewController *destinationVC = segue.destinationViewController;
        destinationVC.calcModel = self.calcModel;
        destinationVC.viewControllerdelegate = self;
        self.currentViewController = destinationVC;
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
    [self performSegueWithIdentifier:@"CHECKED_GRAPH_SEGUE" sender:sender];
    
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
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.operand]];
    [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
    [self.expressionDisplay setText:[CalcModel descriptionOfExpression:self.calcModel.expression]];
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

- (void) awakeFromNib {
    
    //This method registers this view controller with the shared UIDevice object to
    //receive orientation chnage notifictaions.
    self.isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    
    //When an orientation change is detected switch view controllers - there is one
    //view controller for the landscape view and one for portrait. First check if it
    //is the graph view as that we want to rotate as normal
    UIViewController *currentVC = self.navigationController.visibleViewController;
    if([currentVC isMemberOfClass:NSClassFromString(@"GraphViewController")]) {
        //If this is the graph view controller then do nothing as we want that to be able to
        //rotate
        return;
    }
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !self.isShowingLandscapeView)
    {
        [self performSegueWithIdentifier:@"LANDSCAPE_SEGUE" sender:self];
        self.isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             self.isShowingLandscapeView)
    {
        [self.navigationController popViewControllerAnimated:YES];
        self.currentViewController = self;
        self.isShowingLandscapeView = NO;
        [self.calcDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.operand]];
        [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
        [self.expressionDisplay setText:[CalcModel descriptionOfExpression:self.calcModel.expression]];
    }
    
}


- (void) landscapeViewlaunchedInPortraitEvent:(GraphCalcLandscapeViewController *)sender {
    
    //The landscape view is tell us it has launched in portrait so pop the view
    [self.navigationController popViewControllerAnimated:NO];
    self.currentViewController = self;
    self.isShowingLandscapeView = NO;
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.operand]];
    [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
    [self.expressionDisplay setText:[CalcModel descriptionOfExpression:self.calcModel.expression]];
}

@end
