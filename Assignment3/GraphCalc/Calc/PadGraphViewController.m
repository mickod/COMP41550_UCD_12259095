//
//  PadGraphViewController.m
//  GraphCalc_Universal
//
//  Created by Mick O'Doherty on 03/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PadGraphViewController.h"

@interface PadGraphViewController ()
@property CGPoint currentGraphOrigin;
@end

@implementation PadGraphViewController

@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

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
    
    //Set initial view properties
	self.thisGraphView.scalingValue = 1;
    self.thisGraphView.graphViewdelegate = self;
    self.currentGraphOrigin = CGPointMake(CGRectGetMidX(self.thisGraphView.bounds),CGRectGetMidY(self.thisGraphView.bounds));
    
    //Attach the pinch gesture
    UIPinchGestureRecognizer *graphPinchGesture =[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureEventOnGraphView:)];
    [self.thisGraphView addGestureRecognizer:graphPinchGesture];
    
    //Add the pan gesture
    UIPanGestureRecognizer *graphPanGesture = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(panGestureEventOnGraphView:)];
    
    [self.thisGraphView addGestureRecognizer:graphPanGesture];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if(_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if(_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if(splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
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

- (void) plotGraphFromExpressionInModel:(CalcModel *)passedCalcModel {
    
    //Plot the Graph
    self.thisGraphView.scalingValue = 1;
    self.thisGraphView.graphViewdelegate = self;
    self.calcModel = passedCalcModel;
    [self.thisGraphView setNeedsDisplay];
}

- (IBAction)zoomPlusEvent {
    
    if (self.thisGraphView.scalingValue < 10) {
        self.thisGraphView.scalingValue +=1;
        [self.thisGraphView setNeedsDisplay];
    }
}

- (IBAction)zoomMinusEvent {
    
    if (self.thisGraphView.scalingValue > 1) {
        self.thisGraphView.scalingValue -=1;
        [self.thisGraphView setNeedsDisplay];
    }
}

- (void)pinchGestureEventOnGraphView:(UIPinchGestureRecognizer *)sender {
    
    //Check to see if it was a pinch in or pinch out and zoom accordingly
    NSLog(@"Scale: %.2f | Velocity: %.2f",sender.scale,sender.velocity);
    if (sender.scale > 1) {
        [self zoomPlusEvent];
    } else {
        [self zoomMinusEvent];
    }
}

- (void)panGestureEventOnGraphView:(UIPanGestureRecognizer *)sender {
    
    //Move the origin with the pan
    NSLog(@"Pan Gesture");
    CGPoint translation = [sender translationInView:self.view];
    self.currentGraphOrigin = translation;
    [self.thisGraphView setNeedsDisplay];

}

- (CGPoint) getGraphOrigin {
    
    //This is the delegate method to return the graph orgin for a requesting
    //Graph View
    return self.currentGraphOrigin;
}

@end
