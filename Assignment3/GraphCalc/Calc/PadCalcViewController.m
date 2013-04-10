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

@interface PadCalcViewController ()

@end

@implementation PadCalcViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // tell the detail view to take button away
    [self splitViewBarButtonPresenter].splitViewBarButtonItem = nil;
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

- (IBAction)variableButtonPressed:(UIButton *)sender {
    
    [self.calcModel setVariableAsOperand:sender.titleLabel.text];
}


@end
