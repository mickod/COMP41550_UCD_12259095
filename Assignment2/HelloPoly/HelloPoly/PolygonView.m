//
//  PolygonView.m
//  HelloPoly
//
//  Created by Mick O'Doherty on 16/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PolygonView.h"
#import <QuartzCore/QuartzCore.h>

@interface PolygonView() 
    @property (nonatomic) NSArray* polygonPoints;
    @property int currentPoints;
    + (NSArray *)pointsForPolygonInRect:(CGRect)rect numberOfSides:(int)numberOfSides;
@end

@implementation PolygonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (NSArray *)pointsForPolygonInRect:(CGRect)rect numberOfSides:(int)numberOfSides {
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    float radius = 0.9 * center.x; NSMutableArray *result = [NSMutableArray array];
    float angle = (2.0 * M_PI) / numberOfSides;
    float exteriorAngle = M_PI - angle;
    float rotationDelta = angle - (0.5 * exteriorAngle);
    for (int currentAngle = 0; currentAngle < numberOfSides; currentAngle++) {
        float newAngle = (angle * currentAngle) - rotationDelta;
        float curX = cos(newAngle) * radius;
        float curY = sin(newAngle) * radius;
        [result addObject:[NSValue valueWithCGPoint:
                           CGPointMake(center.x+curX,center.y+curY)]];
    }
    return result;
}


- (void)drawRect:(CGRect)rect
{
    //Get the number of sides from the controller using a protocol delegate mechanism
    int numberOfSideFromDelegate = [self.polygonViewDelegate numberOfSidesForPolygonView:self];
    NSLog(@"PolygonView - drawRect number of sides: %i", numberOfSideFromDelegate);
    if (numberOfSideFromDelegate < 3) return;
    
    //Generate the new polygon point array
    NSArray *polygonPoints = [PolygonView pointsForPolygonInRect:self.bounds
                                                  numberOfSides:numberOfSideFromDelegate];
    
    //draw the rectangle, chceking firt that there are at least 3 points in case
    //something went wrong getting the points
    if ([polygonPoints count] < 3) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor greenColor] setFill];
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(context, 2.0);
    CGContextBeginPath(context);
    CGPoint firstPoint = [polygonPoints[0] CGPointValue];
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    for (id pointObject in polygonPoints) {
        //get the CGPoint from the object
        CGPoint nextPoint = [pointObject CGPointValue];
        NSLog(@"PolygonView - drawRect point x %f", nextPoint.x);
        NSLog(@"PolygonView - drawRect point y %f", nextPoint.y);
        CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
    }
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}


- (void) animateNow {
    
    //Get the number of sides from the controller using a protocol delegate mechanism
    NSLog(@"PolygonView - animateNow");
    int numberOfSideFromDelegate = [self.polygonViewDelegate numberOfSidesForPolygonView:self];
    if (numberOfSideFromDelegate < 3) return;
    
    //Generate the new polygon point array
    NSArray *polygonPoints = [PolygonView pointsForPolygonInRect:self.bounds
                                                   numberOfSides:numberOfSideFromDelegate];
    
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint firstPoint = [polygonPoints[0] CGPointValue];
    CGPathMoveToPoint(curvedPath, NULL, firstPoint.x, firstPoint.y);
    for (id pointObject in polygonPoints) {
        //get the CGPoint from the object
        CGPoint nextPoint = [pointObject CGPointValue];
        NSLog(@"curvedPath - drawRect point x %f", nextPoint.x);
        NSLog(@"curvedPath - drawRect point y %f", nextPoint.y);
        CGPathMoveToPoint(curvedPath, NULL, nextPoint.x, nextPoint.y);
    }
    
    CAKeyframeAnimation *moveAlongPath = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [moveAlongPath setPath:curvedPath]; // As a CGPath
    
    [moveAlongPath setDuration:5.0];
    
    //We will now draw a circle at the start of the path which we will animate to follow the path
    //We use the same technique as before to draw to a bitmap context and then eventually create
    //a UIImageView which we add to our view
    UIGraphicsBeginImageContext(CGSizeMake(20,20));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //Set context variables
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    //Draw a circle - and paint it with a different outline (white) and fill color (green)
    CGContextAddEllipseInRect(ctx, CGRectMake(1, 1, 18, 18));
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage *circle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *circleView = [[UIImageView alloc] initWithImage:circle];
    circleView.frame = CGRectMake(1, 1, 20, 20);
    [self addSubview:circleView];
    
    [[circleView layer] addAnimation:moveAlongPath forKey:@"animatePolyGon"];
}


- (void) animateNowOLDOLDOLD {
    
    //Get the number of sides from the controller using a protocol delegate mechanism
    NSLog(@"PolygonView - animateNow");
    int numberOfSideFromDelegate = [self.polygonViewDelegate numberOfSidesForPolygonView:self];
    if (numberOfSideFromDelegate < 3) return;
    
    //Generate the new polygon point array
    NSArray *polygonPoints = [PolygonView pointsForPolygonInRect:self.bounds
                                                   numberOfSides:numberOfSideFromDelegate];
    
    //Prepare the animation - we use keyframe animation for animations of this complexity
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 5.0;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 1000;
    
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint firstPoint = [polygonPoints[0] CGPointValue];
    CGPathMoveToPoint(curvedPath, NULL, firstPoint.x, firstPoint.y);
    for (id pointObject in polygonPoints) {
        //get the CGPoint from the object
        CGPoint nextPoint = [pointObject CGPointValue];
        NSLog(@"PolygonView - drawRect point x %f", nextPoint.x);
        NSLog(@"PolygonView - drawRect point y %f", nextPoint.y);
        CGPathMoveToPoint(curvedPath, NULL, nextPoint.x, nextPoint.y);
    }
    
    //Now we have the path, we tell the animation we want to use this path - then we release
    //the path
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    //We will now draw a circle at the start of the path which we will animate to follow the path
    //We use the same technique as before to draw to a bitmap context and then eventually create
    //a UIImageView which we add to our view
    UIGraphicsBeginImageContext(CGSizeMake(20,20));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //Set context variables
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    //Draw a circle - and paint it with a different outline (white) and fill color (green)
    CGContextAddEllipseInRect(ctx, CGRectMake(1, 1, 18, 18));
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage *circle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *circleView = [[UIImageView alloc] initWithImage:circle];
    circleView.frame = CGRectMake(1, 1, 20, 20);
    [self addSubview:circleView];
    
    //Add the animation to the circleView - once you add the animation to the layer, the animation starts
    [circleView.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];

}

@end
