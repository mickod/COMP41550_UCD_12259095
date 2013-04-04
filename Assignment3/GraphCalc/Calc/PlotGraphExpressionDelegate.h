//
//  PlotGraphExpressionDelegate.h
//  GraphCalc_Universal
//
//  Created by Mick O'Doherty on 04/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalcModel;

@protocol PlotGraphExpressionDelegate
- (void)plotGraphFromExpressionInModel:(CalcModel *)passedCalcModel;
@end
