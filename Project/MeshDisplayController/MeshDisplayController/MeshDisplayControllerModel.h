//
//  MeshDisplayControllerModel.h
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 17/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientDevice.h"

@protocol MeshDisplayModelViewEventProtocol <NSObject>

- (void) handleClientDeviceAddedEvent:(ClientDevice*) clientDeviceAdded;
- (void) handleClientDeviceRemovedEvent:(ClientDevice*) clientDeviceRemoved;

@end

@interface MeshDisplayControllerModel : NSObject
@property id <MeshDisplayModelViewEventProtocol> MeshDisplayModelViewDelegate;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *serverBaseURL;
@property (strong, nonatomic) NSMutableDictionary *clientDevices;
- (void) createEvent:(NSString*)newEventID;
- (void) deleteCurrentEvent;
- (void) setTextForDevice:(NSString*)deviceToSet withText:(NSString*)newText;
- (void) pollServer;
- (void) startPollingServer;
@end
