//
//  GraphView.h
//  AxisDrawing
//
//  Created by CSI COMP41550 on 10/02/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDelegateProtocol
- (NSArray*) getGraphPoints;
- (CGPoint) getGraphOriginOffset;
@end

@interface GraphView : UIView
@property id <GraphViewDelegateProtocol> graphViewdelegate;
@property float scalingValue;
@end
