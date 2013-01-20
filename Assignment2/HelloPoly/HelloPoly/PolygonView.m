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
    @property UIImageView* animationImageView;
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
    
    //draw the rectangle, chceking first that there are at least 3 points in case
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

- (void ) animateNow {
    //Get the number of sides from the controller using a protocol delegate mechanism
    int numberOfSideFromDelegate = [self.polygonViewDelegate numberOfSidesForPolygonView:self];
    NSLog(@"PolygonView - drawRect number of sides: %i", numberOfSideFromDelegate);
    if (numberOfSideFromDelegate < 3) return;
    
    //Generate the new polygon point array
    NSArray *polygonPoints = [PolygonView pointsForPolygonInRect:self.bounds
                                                   numberOfSides:numberOfSideFromDelegate];
    
    //Use key frame animation (whihc uses the Quartz framework)
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = [self.polygonViewDelegate getAnimationDuartionForView:self];
    pathAnimation.removedOnCompletion = YES;
    
    //Setup the path for the animation - note to self.. - you must start with a point and
    //then addline to the point (or add curve to point etc). Just setting up a path with move to
    //point will not work as it starts a new path each time (annoyingly, and unintuitively enough...).
    CGMutablePathRef animationPath = CGPathCreateMutable();
    CGPoint firstPoint = [polygonPoints[0] CGPointValue];
    CGPathMoveToPoint(animationPath, NULL, firstPoint.x, firstPoint.y);
    for (id pointObject in polygonPoints) {
        //get the CGPoint from the object
        CGPoint nextPoint = [pointObject CGPointValue];
        NSLog(@"PolygonView - drawRect point x %f", nextPoint.x);
        NSLog(@"PolygonView - drawRect point y %f", nextPoint.y);
        CGPathAddLineToPoint(animationPath, NULL, nextPoint.x, nextPoint.y);
    }
    CGPathCloseSubpath(animationPath);
    
    //Tell the animation to use this path
    pathAnimation.path = animationPath;
    pathAnimation.delegate = self;
    CGPathRelease(animationPath);
    
    //Generate the image to animate - get name from the delegate
    UIImage *animationImage;
    NSString *imageName = [self.polygonViewDelegate getAnimationImageFileName:self];
    if ( !imageName ) {
        //Delegate returned nil so use the default which is a self drawn circle. Circle drawing is
        //from: http://www.devedup.com/index.php/2010/03/03/iphone-animate-an-object-along-a-path/
        UIGraphicsBeginImageContext(CGSizeMake(20,20));
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1.5);
        CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        //Draw a circle - and paint it with a different outline (white) and fill color (green)
        CGContextAddEllipseInRect(ctx, CGRectMake(1, 1, 18, 18));
        CGContextDrawPath(ctx, kCGPathFillStroke);
        animationImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        //load an image from a fileName based on the name from the delegate
        animationImage = [UIImage imageNamed:@"mouse1.png"];
    }
    self.animationImageView = [[UIImageView alloc] initWithImage:animationImage];
    self.animationImageView.layer.position = firstPoint;
    [self addSubview:self.animationImageView];
    
    //Add the animation to the circleView - once you add the animation to the layer, the animation starts
    [self.animationImageView.layer addAnimation:pathAnimation forKey:@"Polygon animation"];
    self.animationImageView.layer.position = firstPoint;
}

- (void) stopAnimation {
  
    [self.animationImageView removeFromSuperview];
}


- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSLog(@"PolygonView - animation stopped!!!");
    //hide the image
    self.animationImageView.hidden = YES;
    
}

- (void) animationDidStart:(CAAnimation *)anim {
    
        NSLog(@"PolygonView - animation started!!!");
}

@end
