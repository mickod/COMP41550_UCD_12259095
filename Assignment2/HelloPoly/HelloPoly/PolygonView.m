//
//  PolygonView.m
//  HelloPoly
//
//  Created by Mick O'Doherty on 16/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PolygonView.h"

@interface PolygonView() 
    @property (nonatomic) NSArray* polygonPoints;
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
    int numberOfSideFromDelegate = [self.polygonViewDelegate numberOfSidesForPolygonView];
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
    CGContextStrokePath(context);
}

@end
