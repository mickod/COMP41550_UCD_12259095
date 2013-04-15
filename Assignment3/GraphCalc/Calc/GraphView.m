//
//  GraphView.m
//  AxisDrawing
//
//  Created by CSI COMP41550 on 10/02/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()
-(void) drawGraph:(NSArray *) graphPoints atOrigin:(CGPoint)graphOrigin withScale: (float) scale;
@end

@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //Get the Graph Origin - use the relative offset supplied by the delegate
    CGPoint graphOriginOffset = [self.graphViewdelegate getGraphOriginOffset];
    CGPoint graphOrigin = CGPointMake(CGRectGetMidX(self.bounds) + graphOriginOffset.x,CGRectGetMidY(self.bounds) + graphOriginOffset.y);
    
    //Draw the Axes
    NSLog(@"GraphView - drawRect origin x,y %f,%f", graphOrigin.x, graphOrigin.y);
    [AxesDrawer drawAxesInRect:rect originAtPoint:graphOrigin scale:self.scalingValue];
    
    //Draw the graph
    NSArray *pointsToGraph = [self.graphViewdelegate getGraphPoints];
    if (pointsToGraph) {
        [self drawGraph:pointsToGraph atOrigin:graphOrigin withScale: self.scalingValue];
    }

}

-(void) drawGraph:(NSArray *) graphPoints atOrigin:(CGPoint)graphOrigin withScale: (float) scale{
    
    //Draw a graph onto the view based on the set of points provided
    if ([graphPoints count] < 3) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(context, 2.0);
    CGPoint firstPoint = [graphPoints[0] CGPointValue];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, scale*firstPoint.x+ graphOrigin.x, -(scale*firstPoint.y - graphOrigin.y));
    for (id pointObject in graphPoints) {
        //get the CGPoint from the object
        CGPoint nextPoint = [pointObject CGPointValue];
        //NSLog(@"GraphView - drawGraph point x %f", nextPoint.x);
        //NSLog(@"GraphView - drawGraph point y %f", nextPoint.y);
        //NSLog(@"GraphView - drawGraph origin adjusted x %f", nextPoint.x + graphOrigin.x);
        //NSLog(@"GraphView - drawGraph origin adjusted y %f", -(nextPoint.y - graphOrigin.y));
        CGContextAddLineToPoint(context, (scale*nextPoint.x + graphOrigin.x), -((scale*nextPoint.y - graphOrigin.y)));
    }
    CGContextDrawPath(context, kCGPathStroke);
}

@end
