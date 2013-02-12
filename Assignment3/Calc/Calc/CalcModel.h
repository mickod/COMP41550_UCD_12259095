//
//  CalcModel.h
//  Calc
//
//  Created by Mick O'Doherty on 12/02/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcModel : NSObject
@property (nonatomic) double operand;
@property (nonatomic) double waitingOperand;
@property (nonatomic, strong) NSString *waitingOperation;
- (double)performOperation:(NSString *)operation;
@end
