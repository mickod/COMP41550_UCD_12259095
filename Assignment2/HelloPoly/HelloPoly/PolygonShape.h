//
//  PolygonShape.h
//  HelloPoly
//
//  Created by CSI COMP41550 on 03/01/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PolygonShape : NSObject

@property (nonatomic) int numberOfSides;
@property (readonly,weak) NSString *name;

- (id)initWithNumberOfSides:(int)sides;

@end
