//
//  GraphViewController.m
//  GraphCalc
//
//  Created by Mick O'Doherty on 12/03/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PhoneGraphViewController.h"
#import "AxesDrawer.h"

@interface PhoneGraphViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation PhoneGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.thisGraphView.scalingValue = 1;
    self.thisGraphView.graphViewdelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ZoomPlusEvent:(id)sender {
    
    
}
- (IBAction)zoomPlusEvent:(id)sender {
    
    if (self.thisGraphView.scalingValue < 10) {
        self.thisGraphView.scalingValue +=1;
        [self.thisGraphView setNeedsDisplay];
    }
}

- (IBAction)zoomMinusEvent:(id)sender {
    
    if (self.thisGraphView.scalingValue > 1) {
        self.thisGraphView.scalingValue -=1;
        [self.thisGraphView setNeedsDisplay];
    }
}

- (NSArray*) getGraphPoints {
    
    //Check first that the expression has an x variable
    NSSet *variablesInExpression = [CalcModel variablesInExpression:self.calcModel.expression];
    
    if ( ![variablesInExpression containsObject:@"x"] || variablesInExpression.count > 1) {
        return nil;
    }
    
    //Calculate graph points for a set of x values and return them
    //in an array
    NSArray *xValues = @[@-100, @-50, @0, @50, @100];
    NSMutableArray *graphPoints = [[NSMutableArray alloc] init];
    NSMutableDictionary *evaluationVariables = [[NSMutableDictionary alloc] init];
    
    //Calculate the y value for each x value
    for (NSNumber *xValue in xValues) {

        [evaluationVariables setValue:xValue forKey:@"x"];
        double evaluationResult = [CalcModel evaluateExpression:self.calcModel.expression usingVariableValues:evaluationVariables];
        
        [graphPoints addObject:[NSValue valueWithCGPoint:CGPointMake( [xValue doubleValue], evaluationResult) ]];
    }
    
    return graphPoints;
}

@end
