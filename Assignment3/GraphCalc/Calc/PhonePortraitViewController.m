//
//  ViewController.m
//  Calc
//
//  Created by Mick O'Doherty on 12/02/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PhonePortraitViewController.h"
#import "PhoneGraphViewController.h"
#import "PhoneCalcLandscapeViewController.h"
#define USER_DEFAULT_OPERAND @"USER_DEFAULT_OPERAND"
#define USER_DEFAULT_CALC_DISPLAY @"USER_DEFAULT_CALC_DISPLAY"
#define USER_DEFAULT_INTHEMIDDLEOFTYPING_BOOL @"USER_DEFAULT_INTHEMIDDLEOFTYPING_BOOL"
#define USER_DEFAULT_WAITING_OPERAND @"USER_DEFAULT_WAITING_OPERAND"
#define USER_DEFAULT_WAITING_OPERATION @"USER_DEFAULT_WAITING_OPERATION"
#define USER_DEFAULT_EXPRESSION @"USER_DEFAULT_EXPRESSION"
#define USER_DEFAULT_MEMORY_VALUE @"USER_DEFAULT_MEMORY_VALUE"
#define USER_DEFAULT_DEG_NOT_RAD_BOOL @"USER_DEFAULT_DEG_NOT_RAD_BOOL"
#define USER_DEFAULT_CALC_MODEL_EXPRESSION @"USER_DEFAULT_CALC_MODEL_EXPRESSION"

@interface PhonePortraitViewController ()
@property bool isShowingLandscapeView;
@property UIViewController *currentViewController;
@end

@implementation PhonePortraitViewController

- (IBAction)variableButtonPressed:(UIButton *)sender {
    
    [self.calcModel setVariableAsOperand:sender.titleLabel.text];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"ViewController prepareForSegue");
    if ([[segue identifier] isEqualToString:@"CHECKED_GRAPH_SEGUE"]) {
        NSLog(@"ViewController prepareForSegue - kind is GRAPH_SEGUE");
        PhoneGraphViewController *destinationVC = segue.destinationViewController;
        destinationVC.calcModel = self.calcModel;
    } else if ([[segue identifier] isEqualToString:@"LANDSCAPE_SEGUE"]) {
        NSLog(@"ViewController prepareForSegue - kind is LANDSCAPE_SEGUE");
        PhoneCalcLandscapeViewController *destinationVC = segue.destinationViewController;
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
    
    [super viewDidLoad];
    
    //Set this object as the delegate for its own calcModel
    self.calcModel.calcModelDelegate = self;
    
    //Set it as the delegate for the Navigation controller
    self.navigationController.delegate = self;
    
    //Set the degree or radians mode to the inital value of the segement selector
    NSString *degreeOrRadSelected = [self.radianOrDegreesSegmentedController titleForSegmentAtIndex:self.radianOrDegreesSegmentedController.selectedSegmentIndex];
    [self setCalcModelDegreeOrRadMode:degreeOrRadSelected];
    //Set the displays
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.operand]];
    [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
    [self.expressionDisplay setText:[CalcModel descriptionOfExpression:self.calcModel.expression]];
    
    //Set the defaults
    //Load the user defaults into the model - note that if there are none
    //the default returned are all ok in thi case
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.calcModel.operand = [userDefaults doubleForKey:USER_DEFAULT_OPERAND];
    self.isInTheMiddleOfTypingSomething = [userDefaults boolForKey:USER_DEFAULT_INTHEMIDDLEOFTYPING_BOOL];
    self.calcModel.waitingOperand = [userDefaults doubleForKey:USER_DEFAULT_WAITING_OPERAND];
    self.calcModel.memoryValue = [userDefaults doubleForKey:USER_DEFAULT_MEMORY_VALUE];
    self.calcModel.waitingOperation = [userDefaults objectForKey:USER_DEFAULT_WAITING_OPERATION];
    self.calcModel.useDegreesNotRads = [userDefaults boolForKey:USER_DEFAULT_DEG_NOT_RAD_BOOL];
    NSArray *calcModelExpressionArray = [userDefaults objectForKey:USER_DEFAULT_CALC_MODEL_EXPRESSION];
    id retrievedExpression = [self.calcModel expressionForPropertyList:calcModelExpressionArray];
    self.calcModel.expression = retrievedExpression;
    
    //Set the displays based on the model
    [self.calcDisplay setText:[userDefaults objectForKey:USER_DEFAULT_CALC_DISPLAY]];
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
    //view controller for the landscape view and one for portrait.
    //However we must first check if it is the graph view as we want that to rotate as normal
    UIViewController *currentVC = self.navigationController.visibleViewController;
    if([currentVC isMemberOfClass:NSClassFromString(@"PhoneGraphViewController")]) {
        //If this is the graph view controller then do nothing as we want that to be able to
        //rotate
        return;
    }
    
    //If not the graph view then check orientation and select the view controller appropriately
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

- (void) landscapeViewlaunchedInPortraitEvent:(PhoneCalcLandscapeViewController *)sender {
    
    //The landscape view is telling us it has launched in portrait so pop the view
    [self.navigationController popViewControllerAnimated:NO];
    self.currentViewController = self;
    self.isShowingLandscapeView = NO;
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.operand]];
    [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
    [self.expressionDisplay setText:[CalcModel descriptionOfExpression:self.calcModel.expression]];
}

@end
