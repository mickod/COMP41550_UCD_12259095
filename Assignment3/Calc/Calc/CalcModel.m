//
//  CalcModel.m
//  Calc
//
//  Created by Mick O'Doherty on 12/02/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "CalcModel.h"

@implementation CalcModel
@synthesize operand = _operand;
@synthesize waitingOperand = _waitingOperand;
@synthesize waitingOperation = _waitingOperation;
- (double)performOperation:(NSString *)operation {
    if([operation isEqualToString:@"sqrt"]) {
        if(self.operand > 0) {
            self.operand = sqrt(self.operand);
        }else {
            self.operand = 0;
        }
    } else if ([operation isEqualToString:@"+/-"]) {
        self.operand = -self.operand;
    } else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    
    return self.operand;
}

- (void) performWaitingOperation {
    if ([self.waitingOperation isEqualToString:@"+"])
        self.operand = self.waitingOperand + self.operand;
    else if ([self.waitingOperation isEqualToString:@"-"])
        self.operand = self.waitingOperand - self.operand;
    else if ([self.waitingOperation isEqualToString:@"*"])
        self.operand = self.waitingOperand * self.operand;
    else if ([self.waitingOperation isEqualToString:@"/"])
        if (self.operand) self.operand = self.waitingOperand / self.operand;
}

@end
