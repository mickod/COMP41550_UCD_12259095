//
//  MeshDisplayControllerModel.m
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 17/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "MeshDisplayControllerModel.h"
#import "ClientDevice.h"

#define AWS_BASE_URL @"http://ec2-54-216-7-173.eu-west-1.compute.amazonaws.com/index.php/api/example"
#define MAMP_BASE_URL @"http://localhost:8888/codeigniter-restserver-master/index.php/api/example"

@interface MeshDisplayControllerModel()

@property (strong, nonatomic) NSTimer* serverPollTimer;
@end

@implementation MeshDisplayControllerModel


- (id) init {
    
    self = [super init];
    if (self) {
        //set the default property values
        self.eventID = nil;
        self.serverBaseURL = AWS_BASE_URL;
        self.clientDevices = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) startPollingServer {
    
    //Create and start the timer for polling the server
    //Create a timer to poll the server while this app is in the foreground
    if (self.eventID == nil) {
        //Don't poll the server if the event id is nil
        return;
    }
    self.serverPollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                          selector:@selector(pollServer) userInfo:nil repeats:YES];
    
}

- (void) createEvent:(NSString*)newEventID {
    
    //This method creates a new event for the controller to manage.
    //At this time the controller can only control one event at a time so it first
    //deletes any current event
    [self deleteCurrentEvent];
    
    self.eventID = newEventID;
    
    //Message the server with the new event name - this is currently fire and forget but
    //should check for acknowledgement ideally
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@", self.serverBaseURL, @"event"];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *postBodyString = [NSString stringWithFormat:@"%@=%@", @"event_id", self.eventID];;
    [urlRequest setHTTPBody:[postBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
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
    
    //Start the polling timer
    [self startPollingServer];
    
}

- (void) deleteCurrentEvent {
    
    //This method messages the server to delete the current event and set the
    //event in this controller to nil
    if (self.eventID == nil) {
        return;
    }
    
    //Stop the polling timer
    [self.serverPollTimer invalidate];
    self.serverPollTimer = nil;
    
    //Message the server - this is a fire and forget message, as the server will
    //kill the event anyway when it receives no messages from the controller within
    //a given timeframe. 
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@", self.serverBaseURL, @"event"];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"DELETE"];
    NSString *deleteBodyString = [NSString stringWithFormat:@"%@=%@", @"event_id", self.eventID];
    [urlRequest setHTTPBody:[deleteBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
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
    
    //Remove all devices from the display and all objects from the client devices dictionary
    //Note if the controller is modified to control multiple events this will need to be updated
    for (id key in self.clientDevices) {
        ClientDevice *thisDevice = [self.clientDevices objectForKey:key];
        [self.MeshDisplayModelViewDelegate handleClientDeviceRemovedEvent:thisDevice];
    }
    [self.clientDevices removeAllObjects];
    
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
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@", self.serverBaseURL, @"event_client_text"];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *postBodyString = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@", @"event_id", self.eventID, @"client_id", deviceToSet, @"text", newText];
    [urlRequest setHTTPBody:[postBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    //will drain the battery and a move to push notifictaions in the future should be a
    //better approach so long as it does not impose performance or operational restrictions.
    NSLog(@"self.cleintdevices at start of pollServer: %@", self.clientDevices);
    
    
    //Don't poll if the event-id is not set
    if (self.eventID == nil) {
        return;
    }
    
    //Send the message to the server to check the current device list. This is safely fire and
    //forget as any missed responses will be simply repeated when the poll is reeapted shortly
    //shortly afterwards
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@/%@", self.serverBaseURL, @"device_list_for_event/event_id", self.eventID];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
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
             NSError *e = nil;
             NSArray *deviceListJsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
             
             if (!deviceListJsonArray) {
                 NSLog(@"MeshDisplayControllerModel pollServer Error parsing JSON: %@", e);
             } else {
                 NSMutableArray *clientIdsReturned = [[NSMutableArray alloc] init];
                 for(NSDictionary *eventClientInfo in deviceListJsonArray) {
                     if (![eventClientInfo isKindOfClass:[NSDictionary class]]) {
                         //Unexpected return value - simply log it and return
                         NSLog(@"MeshDisplayControllerModel pollServer completionHandler unexpected return: %@", [deviceListJsonArray description]);
                         return;
                     }
                     NSString *device_clientID = [eventClientInfo objectForKey:@"client_id"];
                     [clientIdsReturned addObject:device_clientID];
                     NSLog(@"client_id: %@", device_clientID);
                     //Check if this clientDevice is already in the device list
                     NSLog(@"self.cleintdevices etc: %@", self.clientDevices);
                     if ([self.clientDevices objectForKey:device_clientID] == nil ) {
                         //If it is not then add it to the mode devicesList
                         ClientDevice *newClientDevice = [[ClientDevice alloc] init];
                         newClientDevice.deviceID = device_clientID;
                         newClientDevice.text = [eventClientInfo objectForKey:@"client_text"];;
                         [self.clientDevices setValue:newClientDevice forKey:device_clientID];
                         //Do the UI update on the main thread - hard to debug errors if you don't...
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             [self.clientDevices setValue:newClientDevice forKey:device_clientID];
                             NSLog(@"self.cleintdevices after update: %@", self.clientDevices);
                             [self.MeshDisplayModelViewDelegate handleClientDeviceAddedEvent:newClientDevice];
                         });
                     }
                 }
                 
                 //Now check for any devices removed
                 NSMutableArray *deviceIDsToRemove = [[NSMutableArray alloc] init];
                 for (id key in self.clientDevices) {
                     ClientDevice *thisDevice = [self.clientDevices objectForKey:key];
                     if (![clientIdsReturned containsObject:thisDevice.deviceID]) {
                         //A device in the model list is no longer in the list returned
                         //from the server so remove it from the model list
                         //Do the UI update on the main thread - hard to debug errors if you don't...
                         [deviceIDsToRemove addObject:thisDevice.deviceID];
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             [self.MeshDisplayModelViewDelegate handleClientDeviceRemovedEvent:thisDevice];
                         });  
                     }
                 }
                 //Remove the devices
                 NSLog(@"self.cleintdevices before removal: %@", self.clientDevices);
                 for (NSString *deviceIDToRemove in deviceIDsToRemove) {
                     [self.clientDevices removeObjectForKey:deviceIDToRemove];
                 }
             }
             
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
