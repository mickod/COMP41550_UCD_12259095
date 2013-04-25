//
//  DeviceView.h
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 16/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceViewDelegateProtocol <NSObject>
- (void) handleDeviceViewTextEditedEvent:(NSString*) newText forDevice:(NSString*)deviceID;
@end

@interface DeviceView : UIView
@property (strong, nonatomic) IBOutlet UITextField *displayTextField;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (strong, nonatomic) id <DeviceViewDelegateProtocol> deviceViewDelegae;
- (IBAction)textFieldEditEvent:(UITextField *)sender;


@end
