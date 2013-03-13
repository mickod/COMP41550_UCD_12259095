//
//  AxesDrawer.h
//  AxisDrawing
//
//  Created by CSI COMP41550 on 10/02/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AxesDrawer : NSObject
+ (void)drawAxesInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)pointsPerUnit;

@end
