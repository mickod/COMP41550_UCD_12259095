//
//  PadCalcViewController.m
//  GraphCalc_Universal
//
//  Created by Mick O'Doherty on 03/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PadCalcViewController.h"
#import "SplitViewBarButtonItemPresenter.h"
#import "PadGraphViewController.h"

#define USER_DEFAULT_OPERAND @"USER_DEFAULT_OPERAND"
#define USER_DEFAULT_CALC_DISPLAY @"USER_DEFAULT_CALC_DISPLAY"
#define USER_DEFAULT_INTHEMIDDLEOFTYPING_BOOL @"USER_DEFAULT_INTHEMIDDLEOFTYPING_BOOL"
#define USER_DEFAULT_WAITING_OPERAND @"USER_DEFAULT_WAITING_OPERAND"
#define USER_DEFAULT_WAITING_OPERATION @"USER_DEFAULT_WAITING_OPERATION"
#define USER_DEFAULT_EXPRESSION @"USER_DEFAULT_EXPRESSION"
#define USER_DEFAULT_MEMORY_VALUE @"USER_DEFAULT_MEMORY_VALUE"
#define USER_DEFAULT_DEG_NOT_RAD_BOOL @"USER_DEFAULT_DEG_NOT_RAD_BOOL"
#define USER_DEFAULT_CALC_MODEL_EXPRESSION @"USER_DEFAULT_CALC_MODEL_EXPRESSION"

@interface PadCalcViewController ()

@end

@implementation PadCalcViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter]   addObserver:self
                                                   selector:@selector(graphCalcAppWillResignActive:)
                                                       name:UIApplicationWillResignActiveNotification
                                                     object:[UIApplication sharedApplication]];
        [[NSNotificationCenter defaultCenter]   addObserver:self
                                                   selector:@selector(graphCalcAppWillTerminate:)
                                                       name:UIApplicationWillTerminateNotification
                                                     object:[UIApplication sharedApplication]];
    }
    return self;
}

- (void) awakeFromNib {
    self.splitViewController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)graphCalcAppWillResignActive:(NSNotification *)notification {
    
    //Applictaion is going into the background so store the applictaion state
    //in NSUserDefaults
    [self storeApplictaionState];
    
}

- (void) graphCalcAppWillTerminate:(NSNotification *)notification {
    
    //Applictaion is going to terminate so store the applictaion state
    //in NSUserDefaults
    [self storeApplictaionState];
}

- (void) storeApplictaionState {
    
    //Store the applictaion state
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:self.calcModel.operand
                     forKey:USER_DEFAULT_OPERAND];
    [userDefaults setObject:self.calcDisplay.text forKey:USER_DEFAULT_CALC_DISPLAY];
    [userDefaults setBool:self.isInTheMiddleOfTypingSomething forKey:USER_DEFAULT_INTHEMIDDLEOFTYPING_BOOL];
    [userDefaults setDouble:self.calcModel.waitingOperand
                     forKey:USER_DEFAULT_WAITING_OPERAND];
    [userDefaults setDouble:self.calcModel.memoryValue
                     forKey:USER_DEFAULT_MEMORY_VALUE];
    [userDefaults setBool:self.calcModel.useDegreesNotRads
                   forKey:USER_DEFAULT_DEG_NOT_RAD_BOOL];
    [userDefaults setObject:self.calcModel.waitingOperation forKey:USER_DEFAULT_WAITING_OPERATION];
    NSArray *calcModelExpressionAsArray = [CalcModel propertyListForExpression:self.calcModel.expression];
    [userDefaults setObject:calcModelExpressionAsArray forKey:USER_DEFAULT_CALC_MODEL_EXPRESSION];
    [userDefaults synchronize];
}

- (PadGraphViewController *)getPadGraphViewController {
    id padGraphVC = [self.splitViewController.viewControllers lastObject];
    if(![padGraphVC isKindOfClass:[PadGraphViewController class]]) padGraphVC =  nil;
    return padGraphVC;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonPresenter
{
    //This method simply returns the last object in the split view controller array, which is
    //the 'big' view, so long as it confomrs to the SplitViewBarButtonItemPresenter protcol
    //which it always should in our case. If it does not it retruns nil.
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) detailVC = nil;
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    //To explain this slightly obscure line... this means
    //if the splitViewBarButtonPresenter method does not return nil
    //    then return YES (I.e hide the view controller) if the UI interface is Portrait
    //         and NO if it is not
    //else
    //    simply return NO
    //
    //This makes sure that we only hide the view controller when in Portrait and when the view
    //controller conforms to the SplitViewBarButtonItemPresenter protocol, and hence
    //has a bar button item.
    return [self splitViewBarButtonPresenter]?UIInterfaceOrientationIsPortrait(orientation):NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonPresenter].splitViewBarButtonItem = barButtonItem;
    [[self splitViewBarButtonPresenter] showToolBar];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // tell the detail view to take button away
    [self splitViewBarButtonPresenter].splitViewBarButtonItem = nil;
    [[self splitViewBarButtonPresenter] hideToolBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
    
    //Ask the graph to plot itself
    [self.plotGraphDelegate plotGraphFromExpressionInModel:self.calcModel];
    
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
    
    //Set this object as the delegate for its split view controller
    self.splitViewController.delegate = self;
    
    //set the graph view delegate to be the detail view (i.e. the big view on the iPad)
    self.plotGraphDelegate = [self getPadGraphViewController];
    
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
    [self setCalcModelDegreeOrRadDisplayBasedOn:self.calcModel.useDegreesNotRads];
    [self.calcDisplay setText:[userDefaults objectForKey:USER_DEFAULT_CALC_DISPLAY]];
    [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
    [self.expressionDisplay setText:[CalcModel descriptionOfExpression:self.calcModel.expression]];
}

- (void) viewWillAppear:(BOOL)animated {
    

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

-(void) setCalcModelDegreeOrRadDisplayBasedOn:(Boolean)useDegNotRadBool {
    
    //If the selector is rad set the calc model to use radians, otherwise
    //default to degrees (this covers the error case where the selected value is
    //neither for some reason
    if (useDegNotRadBool) {
        self.radianOrDegreesSegmentedController.selectedSegmentIndex = 0;
    } else {
        self.radianOrDegreesSegmentedController.selectedSegmentIndex = 1;
    }

}

- (IBAction)variableButtonPressed:(UIButton *)sender {
    
    [self.calcModel setVariableAsOperand:sender.titleLabel.text];
}


@end
