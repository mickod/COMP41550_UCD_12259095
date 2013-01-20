//
//  PolygonShape.m
//  HelloPoly
//
//  Created by CSI COMP41550 on 03/01/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import "PolygonShape.h"

#define MAX_SIDES 12
#define MIN_SIDES 3

#define USER_DEFAULT_POLYGON_SIDES @"USER_DEFAULT_POLYGON_SIDES"

@implementation PolygonShape

@synthesize numberOfSides = _numberOfSides;

- (id)init {    
    //Load the number of sides from the user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.numberOfSides = [userDefaults integerForKey:USER_DEFAULT_POLYGON_SIDES];
    if (self.numberOfSides < 3 || self.numberOfSides > 12) {
        self.numberOfSides = 5;
    }
	return [self initWithNumberOfSides:self.numberOfSides];
}

- (id)initWithNumberOfSides:(int)sides {
    if (!(self = [super init])) return nil;
    self.numberOfSides = sides;
	return self;
}

- (void)setNumberOfSides:(int)numberOfSides {
    if(numberOfSides > MAX_SIDES) {
		NSLog(@"Invalid number of sides: %d is greater than the maximum of %d allowed", numberOfSides, MAX_SIDES);
		return;
	}
	if(numberOfSides < MIN_SIDES) {
		NSLog(@"Invalid number of sides: %d is smaller than the minimum of %d allowed", numberOfSides, MIN_SIDES);
		return;
	}
	_numberOfSides = numberOfSides;
    
    //Store number of sides in user defaults
    //Save key values in the user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.numberOfSides
                   forKey:USER_DEFAULT_POLYGON_SIDES];
    [userDefaults synchronize];
}

- (NSString *)name {
	return [[NSArray 
             arrayWithObjects:@"Triangle",
             @"Square",
             @"Pentagon",
             @"Hexagon",
             @"Heptagon",
             @"Octagon",
             @"Nonagon",
             @"Decagon",
             @"Hendecagon",
             @"Dodecagon",
             nil] 
            objectAtIndex:self.numberOfSides-MIN_SIDES];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Hello I am a %d-sided polygon (aka a %@).", self.numberOfSides,self.name];
}

@end
