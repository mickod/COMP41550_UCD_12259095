//
//  DeviceView.m
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 16/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "DeviceView.h"

@implementation DeviceView

- (id)initWithFrame:(CGRect)frame
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ClientDeviceView" owner:self options:nil];
    self = [subviewArray objectAtIndex:0];
    if (self) {
        // Initialization code
        //self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
