//
//  CalcModel.h
//  Calc
//
//  Created by Mick O'Doherty on 12/02/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CalcModel;

@protocol CalcModelDelegate
- (void) receiveNotificationOfError:(CalcModel *) withErrorText:(NSString*) errorText;
@end

@interface CalcModel : NSObject
@property (nonatomic) double operand;
@property (nonatomic) double waitingOperand;
@property (nonatomic, strong) NSString *waitingOperation;
@property (nonatomic) double memoryValue;
@property (nonatomic) BOOL useDegreesNotRads;
@property id <CalcModelDelegate> calcModelDelegate;
- (double)performOperation:(NSString *)operation;
@end
