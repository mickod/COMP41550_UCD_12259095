//
//  MeshDisplayControllerModel.m
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 17/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "MeshDisplayControllerModel.h"
#import "ClientDevice.h"

@interface MeshDisplayControllerModel()

@property (strong, nonatomic) NSTimer* serverPollTimer;
@end

@implementation MeshDisplayControllerModel


- (id) init {
    
    self = [super init];
    if (self) {
        //set the default property values
        self.eventID = nil;
        self.serverBaseURL = @"http:www.xxx.yyy";
        self.clientDevices = nil;
        
        //Create a timer to poll the server while this app is in the foreground
        //XXXXself.serverPollTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self
        //XXXX                                                selector:@selector(pollServer:) userInfo:nil repeats:YES];
        
    }
    
    return self;
}

- (void) createEvent:(NSString*)newEventID {
    
    //This method creates a new event for the controller to manage.
    //At this time the controller can only control one event at a time so it first
    //deletes any current event
    [self deleteCurrentEvent];
    
    self.eventID = newEventID;
    
    //Message the server with the new event name - this is currently fire and forget but
    //should check for acknowledgement ideally
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@", self.serverBaseURL, @"/newEvent"];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             //We are not intersted in the response in this
             //case so simply do nothing
             
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"MeshDisplayControllerModel -> createEvent: No data returned");
         }
         else if (error != nil){
             NSLog(@"MeshDisplayControllerModel -> createEvent: Error = %@", error);
         }
         
     }];
    
}

- (void)setEventID:(NSString *)newEventID {
    
    //Overwrite the setter to use create event in case it is accessed directly in the future
    if (newEventID != nil) {
        [self createEvent:newEventID];
    } else {
        _eventID = nil;
    }
}

- (void) deleteCurrentEvent {
    
    //This method messages the server to delete the current event and set the
    //event in this controller to nil
    
    //Message the server - this is a fire and forget message, as the server will
    //kill the event anyway when it receives no messages from the controller within
    //a given timeframe. 
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@/%@", self.serverBaseURL, @"/deleteEvent/", self.eventID];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             //We are not intersted in the response in this
             //case so simply do nothing
             
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"MeshDisplayControllerModel -> deleteCurrentEvent: No data returned");
         }
         else if (error != nil){
             NSLog(@"MeshDisplayControllerModel -> deleteCurrentEvent: Error = %@", error);
         }
         
     }];
    
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
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.serverBaseURL, @"/updateDeviceText/", deviceToSet, @"/", newText];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             //We are not intersted in the response in this
             //case so simply do nothing
             
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"MeshDisplayControllerModel -> setTextForDevice: No data returned");
         }
         else if (error != nil){
             NSLog(@"MeshDisplayControllerModel -> setTextForDevice: Error = %@", error);
         }
         
     }];
}

- (void) pollServer {
    
    //This method checks the server to get the latest device list - it is recognised that this
    //will drain the battery and a move to push notifictaions in the future would be a
    //better approach.
    
    //Send the message to the server to check the current device list. This is safely fire and
    //forget as any missed responses will be simply repeated when the poll is reeapted shortly
    //shortly afterwards
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@/%@", self.serverBaseURL, @"/getDeviceListForEvent/", self.eventID];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             //Decode the response and update the device list property
             
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"MeshDisplayControllerModel -> pollServer: No data returned");
         }
         else if (error != nil){
             NSLog(@"MeshDisplayControllerModel -> pollServer: Error = %@", error);
         }
         
     }];
    
    
}


@end
