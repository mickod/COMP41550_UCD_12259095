//
//  MeshDisplayClientModel.m
//  MeshDislayClient
//
//  Created by Mick O'Doherty on 21/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "MeshDisplayClientModel.h"

@interface MeshDisplayClientModel()
@property (strong, nonatomic) NSTimer* serverPollTimer;
@end

@implementation MeshDisplayClientModel

- (id) init {
    
    self = [super init];
    if (self) {
        //set the default property values
        self.eventID = nil;
        self.serverBaseURL = @"http:www.xxx.yyy";
        self.clientID = nil;
        self.textToDisplay = @"";
    }
    
    return self;
}

- (void) joinEvent:(NSString*)newEventID withClient:(NSString*)thisClientID {
    
    //This method add this device to an event and starts a timer to
    //poll the server for text to display in this client
    
    //In case the client is already in an event, leave it first
    [self leaveEvent];
    
    //Check the client id and event if are not nil
    if (newEventID == nil | thisClientID == nil) {
        return;
    }
    
    self.eventID = newEventID;
    self.clientID = thisClientID;
    
    //Message the server with the client and the event id
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.serverBaseURL, @"/addClientToEvent/", self.eventID, @"/", self.clientID];
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
          
             //Start the timer to poll the server for the text to display while this app is
             //in the foreground
             self.serverPollTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self
                                                            selector:@selector(getDisplayTextFromServer:) userInfo:nil repeats:YES];
             
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"MeshDisplayClientModel -> joinEvent: No data returned");
         }
         else if (error != nil){
             NSLog(@"MeshDisplayClientModel -> joinEvent: Error = %@", error);
         }
         
     }];
    
}

- (void) leaveEvent {
    
    //This method messages the server to remove this client from the current event
    
    //Check first that the event if id is not nil
    if (self.eventID
        = nil) {
        return;
    }
    
    //Message the server
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.serverBaseURL, @"/removeClientFromEvent/", self.eventID, @"/", self.clientID];
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
             NSLog(@"MeshDisplayClientModel -> leaveEvent: No data returned");
         }
         else if (error != nil){
             NSLog(@"MeshDisplayClientModel -> leaveEvent: Error = %@", error);
         }
         
     }];
    
    //Set the event peoperty to nil and the text to dsiplay to blank
    self.eventID = nil;
    self.textToDisplay = @"";
}

- (void) getDisplayTextFromServer {
    
    //This method polls the server looking for text to display - it is recognised that this
    //will drain the battery and a move to push notifictaions in the future should be a
    //better approach so long as it does not impose performance or operational restrictions.
    
    //Message the server
    NSString *urlAsString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.serverBaseURL, @"/getTextForDeviceInEvent/", self.eventID, @"/", self.clientID];
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
             //Decode the response and update the client display text
             
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"MeshDisplayClientModel -> setTextForDevice: No data returned");
         }
         else if (error != nil){
             NSLog(@"MeshDisplayClientModel -> setTextForDevice: Error = %@", error);
         }
         
     }];
}

@end
