//
//  CalcModel.m
//  Calc
//
//  Created by Mick O'Doherty on 12/02/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "CalcModel.h"

@interface CalcModel()
@property (nonatomic, strong) NSMutableArray *expressionAsArray;
@end

@implementation CalcModel
@synthesize operand = _operand;
@synthesize waitingOperand = _waitingOperand;
@synthesize waitingOperation = _waitingOperation;

- init
{
    self = [super init];
    if (!self) return nil;
    
    //Initialise the Expression mutable Array
    self.expressionAsArray = [[NSMutableArray alloc] init];
    
    return self;
}

- (id) expression {
    //Externally the expression is just an 'id' but
    //internally we use an NSMutableArray. The getter for the
    //externally visible expression property converts from
    //the internal NSMutableArray to an id.
    return self.expressionAsArray;
}

- (void) setExpression:(id)expression {
    ////Externally the expression is just an 'id' but
    //internally we use an NSMutableArray. Set the internal
    //variable with the id passed in
    
    //First conevrt to muttable array
    self.expressionAsArray = expression;
}

- (void) setUserEnteredOperand:(double)userEnteredOperand {
    
    //Add the operand to the model's expression
    [self addItemToExpression: [NSNumber numberWithDouble:userEnteredOperand]];
    
    //Now set the operand
    self.operand = userEnteredOperand;
}

- (void) setVariableAsOperand:(NSString *)variableName {
   
    //Add the operand to the model's expression
    [self addItemToExpression: variableName];
}

- (void) addItemToExpression:(id)item {
    
    [self.expressionAsArray addObject:item];
}

+ (NSString *) descriptionOfExpression:(id)anExpression {
    
    return [[anExpression valueForKey:@"description"] componentsJoinedByString:@""];
}

- (double)performOperation:(NSString *)operation {
    
    //Add the operation to the model's expression
    [self addItemToExpression:operation];
    
    //Now perform the operation
    if([operation isEqualToString:@"sqrt"]) {
        if(self.operand >= 0) {
            self.operand = sqrt(self.operand);
        }else {
            [self.calcModelDelegate receiveNotificationOfError:self :@"Cannot get sqrt of negative" ];
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
        [self.expressionAsArray removeAllObjects];
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

+ (NSSet *) variablesInExpression:(id)anExpression {
    
    NSArray *expressionArray = anExpression;
    NSMutableSet *variableMutableSet = [[NSMutableSet alloc] init];
    
    for (id expressionItem in expressionArray) {
        //Check each string in the expression to see if it is one of our variables
        if ([expressionItem isKindOfClass:[NSString class]]) {
            //If the item is an operator then perform the operation
            if ([expressionItem isEqualToString:@"x"] |
                [expressionItem isEqualToString:@"a"] |
                [expressionItem isEqualToString:@"b"] |
                [expressionItem isEqualToString:@"c"]) {
                
                if ( ![variableMutableSet containsObject:expressionItem] ) {
                    [variableMutableSet addObject:expressionItem];
                }
            }
        }
    }
    
    if ([variableMutableSet count] > 0) {
        return variableMutableSet;
    } else {
        return nil;
    }
}

+ (double) evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables {
    
    //Get the variables in the expression
    NSSet *variablesInExpression = [CalcModel variablesInExpression:anExpression];
    
    //Now enumerate through expression again and evaluate it using
    //an instance of this class CalcModel
    NSArray *evaluationExpressionArray = anExpression;
    CalcModel *tempCalcModel = [[CalcModel alloc] init];
    double result = 0;
    for (id expressionItem in evaluationExpressionArray) {
        if ([expressionItem isKindOfClass:[NSNumber class] ]) {
            //If the item is an operand simply set the operand
           [tempCalcModel setUserEnteredOperand:[expressionItem doubleValue]];
        } else if ([expressionItem isKindOfClass:[NSString class]]) {
            //Check if the string is one of our variables
            if ( [variablesInExpression containsObject:expressionItem]) {
                //Switch the variable for its corresponding double value
                double variableValue = [[variables objectForKey:expressionItem] doubleValue];
                //Enter the operand
                [tempCalcModel setUserEnteredOperand:variableValue];
            } else {
                //The string is an operator so perform the operation
                result = [tempCalcModel performOperation:expressionItem];
            }
        } else {
            result = 0;
            break;
        }
    }
    
    //Return the result
    return result;
}

+ (id) propertyListForExpression:(id)anExpression {
    
    //This method returns a property list for an expression
    NSArray *expressionAsArray = anExpression;
    return expressionAsArray;
}

- (id) expressionForPropertyList:(id)propertyList {
    
    //This method returns an expression for an input property list
    NSArray *expressionAsArray = propertyList;
    return expressionAsArray;
}

@end
