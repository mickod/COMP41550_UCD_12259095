//
//  GraphViewController.m
//  GraphCalc
//
//  Created by Mick O'Doherty on 12/03/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PhoneGraphViewController.h"
#import "AxesDrawer.h"

#define USER_DEFAULT_GRAPH_ORIGIN @"USER_DEFAULT_GRAPH_ORIGIN"
#define USER_DEFAULT_SCALING_FACTOR @"USER_DEFAULT_SCALING_FACTOR"

@interface PhoneGraphViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property CGPoint currentGraphOriginOffset;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.thisGraphView.scalingValue = 1;
    self.thisGraphView.graphViewdelegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    
    //The frame size can be reliably used at this point - it is not reliable in viewdidload
    //as it apparently uses the orientation and size etc from the xib (storyboard)
    self.currentGraphOriginOffset = CGPointMake(0,0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)zoomPlusEvent {
    
    if (self.thisGraphView.scalingValue < 10) {
        self.thisGraphView.scalingValue +=0.1;
        [self.thisGraphView setNeedsDisplay];
    }
}

- (IBAction)zoomMinusEvent {
    
    if (self.thisGraphView.scalingValue > 1) {
        self.thisGraphView.scalingValue -=0.1;
        [self.thisGraphView setNeedsDisplay];
    }
}

- (void)handlePinchGestureEventOnGraphView:(UIPinchGestureRecognizer *)sender {
    
    //Check to see if it was a pinch in or pinch out and zoom accordingly
    NSLog(@"Scale: %.2f | Velocity: %.2f",sender.scale,sender.velocity);
    if (sender.scale > 1) {
        [self zoomPlusEvent];
    } else {
        [self zoomMinusEvent];
    }
}

- (void)handlePanGestureEventOnGraphView:(UIPanGestureRecognizer *)sender {
    
    //Move the origin with the pan
    NSLog(@"Pan Gesture");
    
    CGPoint translation = [sender translationInView:self.view];
    self.currentGraphOriginOffset = CGPointMake(self.currentGraphOriginOffset.x + translation.x, self.currentGraphOriginOffset.y + translation.y);
    [self.thisGraphView setNeedsDisplay];
    
    //set the translation view as translationInView gives the delta from the initial
    //point not from the last time it was called
    [sender setTranslation:CGPointZero inView:self.view];
    
}

- (CGPoint) getGraphOriginOffset {
    
    //This is the delegate method to return the graph orgin for a requesting
    //Graph View
    return self.currentGraphOriginOffset;
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

- (IBAction)pinchGestureEvent:(UIPinchGestureRecognizer *)sender {
    
    //Check to see if it was a pinch in or pinch out and zoom accordingly
    NSLog(@"Scale: %.2f | Velocity: %.2f",sender.scale,sender.velocity);
    if (sender.scale > 1) {
        [self zoomPlusEvent];
    } else {
        [self zoomMinusEvent];
    }
}

- (IBAction)tapGestureEvent:(UITapGestureRecognizer *)sender {
    
    //Move the origin back to the center of the veiw
    self.currentGraphOriginOffset = CGPointMake(0,0);
    [self.thisGraphView setNeedsDisplay];
}

- (IBAction)panGestureEvent:(UIPanGestureRecognizer *)sender {
    
    //Move the origin with the pan
    NSLog(@"Pan Gesture");
    
    CGPoint translation = [sender translationInView:self.view];
    self.currentGraphOriginOffset
    = CGPointMake(self.currentGraphOriginOffset.x + translation.x, self.currentGraphOriginOffset.y + translation.y);
    [self.thisGraphView setNeedsDisplay];
    
    //set the translation view as translationInView gives the delta from the initial
    //point not from the last time it was called
    [sender setTranslation:CGPointZero inView:self.view];
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
    NSString *originOffsetAsString = NSStringFromCGPoint(self.currentGraphOriginOffset);
    [userDefaults setObject:originOffsetAsString forKey:USER_DEFAULT_GRAPH_ORIGIN];
    [userDefaults setFloat:self.thisGraphView.scalingValue forKey:USER_DEFAULT_SCALING_FACTOR];
    
    [userDefaults synchronize];
}

@end
