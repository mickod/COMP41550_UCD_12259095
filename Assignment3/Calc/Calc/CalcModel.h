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
@property (nonatomic, strong) id expression;
@property (nonatomic) double memoryValue;
@property (nonatomic) BOOL useDegreesNotRads;
@property id <CalcModelDelegate> calcModelDelegate;
- (double)performOperation:(NSString *)operation;
- (void) setVariableAsOperand:(NSString *)variableName;
+ (double) evaluateExpression:(id)anExpression
          usingVariableValues:(NSDictionary *)variables;
+ (NSSet *) variablesInExpression:(id)anExpression;
+ (NSString *) descriptionOfExpression:(id)anExpression;
//+ (id) propertyListForExpression:(id)anExpression;
//- (id) expressionForPropertyList:(id)propertyList;
- (void) setUserEnteredOperand:(double)userEnteredOperand;
@end

