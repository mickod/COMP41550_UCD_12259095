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


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"ViewController prepareForSegue");
    if ([[segue identifier] isEqualToString:@"LANDSCAPE_GRAPH_SEGUE"]) {
        NSLog(@"ViewController prepareForSegue - kind is LANDSCAPE_GRAPH_SEGUE");
        PhoneGraphViewController *destinationVC = segue.destinationViewController;
        destinationVC.calcModel = self.calcModel;
    } 
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

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    //Hide the navigation controller back button
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    //Set this object as the delegate for its own calcModel
    self.calcModel.calcModelDelegate = self;
    
    //Set the degree or radians mode to the inital value of the segement selector
    NSString *degreeOrRadSelected = [self.radianOrDegreesSegmentedController titleForSegmentAtIndex:self.radianOrDegreesSegmentedController.selectedSegmentIndex];
    [self setCalcModelDegreeOrRadMode:degreeOrRadSelected];
    //Set the displays
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.operand]];
    [self.memoryDisplay setText:[NSString stringWithFormat:@"%g", self.calcModel.memoryValue]];
    [self.expressionDisplay setText:[CalcModel descriptionOfExpression:self.calcModel.expression]];

    //Set the back button on the navigator bar to generic calculator as the user may
    //rotate and then go back to the basic portrait calculator
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Calculator" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void) viewDidAppear:(BOOL)animated {
    
    //Check to see if the orientation is portrait when the view is appearing and if so
    //inform the delegate in case the delagte wants to do something (like pop this view...)
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
        [self.viewControllerdelegate landscapeViewlaunchedInPortraitEvent:self];
    }
}

@end
