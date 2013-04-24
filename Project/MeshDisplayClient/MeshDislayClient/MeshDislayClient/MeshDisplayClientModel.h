//
//  MeshDisplayClientModel.h
//  MeshDislayClient
//
//  Created by Mick O'Doherty on 21/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeshDisplayClientDelegate <NSObject>

-(void) handleModelDisplayTextUpdatedEvent;

@end

@interface MeshDisplayClientModel : NSObject
@property (strong, nonatomic) id <MeshDisplayClientDelegate> meshDisplayClientDelegate;
@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *serverBaseURL;
@property (strong, nonatomic) NSString *textToDisplay;
- (void) joinEvent:(NSString*)newEventID withClient:(NSString*)thisClientID;
- (void) leaveEvent;
@end
