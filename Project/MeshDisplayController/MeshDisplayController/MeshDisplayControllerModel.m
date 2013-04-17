//
//  MeshDisplayControllerModel.m
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 17/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "MeshDisplayControllerModel.h"
#import "ClientDevice.h"

@implementation MeshDisplayControllerModel


- (id) init {
    
    self = [super init];
    if (self) {
        //set the default property values
        self.eventID = nil;
        self.serverURL = @"http:www.xxx.yyy";
        self.clientDevices = nil;
    }
    
    return self;
}

- (void) createEvent:(NSString*)newEventID {
    
    //This method creates a new event for the controller to manage.
    //At this time the controller can only control one event at a time so it first
    //deletes any current event
    [self deleteCurrentEvent];
    
    self.eventID = newEventID;
}

- (void)setEventID:(NSString *)newEventID {
    
    //Overwrite the setter to use create event in case it is accessed directly in the future
    
    [self createEvent:newEventID];
}

- (void) deleteCurrentEvent {
    
    //This method messages the server to delete the current event and set the
    //event in this controller to nil
    
    //Message the server - this is a fire and forget message, as the server will
    //kill the event anyway when it receives no messages from the controller within
    //a given timeframe. In other words we do not have to wait for and react to the
    //response
    
    //Set the event peoperty to nil
    self.eventID = nil;
}

- (void) setTextForDevice:(NSString*)deviceToSet withText:(NSString*)newText {
    
    //Set the text for a given device
    ClientDevice *deviceToUpdate = [self.clientDevices objectForKey:deviceToSet];
    deviceToUpdate.text = newText;
    
    //Message the server with the new text for the device - for now this message is send
    //and forget but it would be good to update in future to check for acknowldegement and
    //and resend if not received
    
    
}

@end
