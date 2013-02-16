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
            [self.calcModelDelegate receiveNotificationOfError:self :@"Cannot get sqrt of 0" ];
            self.operand = 0;
        }
    } else if ([operation isEqualToString:@"+/-"]) {
        self.operand = -self.operand;
    } else if ([operation isEqualToString:@"Sin"]) {
        if (self.useDegreesNotRads) {
            //Convert the number to use degrees first
            self.operand= self.operand * M_PI/180;
        }
        self.operand = sin(self.operand);
    } else if ([operation isEqualToString:@"Cos"]) {
        if (self.useDegreesNotRads) {
            //Convert the number to use degrees first
            self.operand= self.operand * M_PI/180;
        }        
        self.operand = cos(self.operand);
    } else if ([operation isEqualToString:@"STO"]) {
        self.memoryValue = self.operand;
    } else if ([operation isEqualToString:@"RCL"]) {
        self.operand = self.memoryValue;
    } else if ([operation isEqualToString:@"M+"]) {
        self.memoryValue = self.memoryValue + self.operand;
    } else if ([operation isEqualToString:@"π"]) {
        self.operand = M_PI;
    } else if ([operation isEqualToString:@"C"]) {
        self.memoryValue = 0;
        self.operand = 0;
        self.waitingOperation = Nil;
        self.waitingOperand = 0;
    } else if ([operation isEqualToString:@"1/x"]) {
        if (self.operand != 0) {
            self.operand = 1/self.operand;
        } else {
            [self.calcModelDelegate receiveNotificationOfError:self :@"Cannot divide by 0" ];
        }
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
    else if ([self.waitingOperation isEqualToString:@"/"]) {
        if (self.operand) {
            self.operand = self.waitingOperand / self.operand;
        } else {
            [self.calcModelDelegate receiveNotificationOfError:self :@"Cannot divide by 0" ];
        }
    }
}

@end
