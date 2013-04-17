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
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation MeshDisplayControllerModel


- (id) init {
    
    self = [super init];
    if (self) {
        //set the default property values
        self.eventID = nil;
        self.serverURL = @"http:www.xxx.yyy";
        self.clientDevices = nil;
        
        //Create a timer to poll the server while this app is in the foreground
        self.serverPollTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self
                                                        selector:@selector(pollServer:) userInfo:nil repeats:YES];
        
        //Create the http request
        self.responseData = [NSMutableData data];
        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:self.serverURL]];
        NSURLConnection *serverConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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

- (void) pollServer {
    
    //This method checks the server to get the latest device list - it is recognised that this
    //will drain the battery and a move to push notifictaions in the future would be a
    //better approach.
    
    //Send the message to the server to check the current device list. This is safely fire and
    //forget as any missed responses will be simply repeated when the poll is reeapted shortly
    //shortly afterwards
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //NSURLConnection delegate method for response received
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //NSURLConnection delegate method for data received
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    //NSURLConnection delegate method for failure notifictaion received
    NSLog(@"NSURLConnection didFailWithError");
    NSLog(@"%@",[NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //NSURLConnection delegate method for connection finished loading - this is the
    //method called when the full response has been received so this is were we
    //decode the response
    NSLog(@"NSURLConnection connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
    
}

@end
