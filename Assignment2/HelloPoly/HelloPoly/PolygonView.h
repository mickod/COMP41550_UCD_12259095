//
//  PolygonView.h
//  HelloPoly
//
//  Created by Mick O'Doherty on 16/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PolygonView;

@protocol PolygonViewDataProvider
- (int) numberOfSidesForPolygonView:(PolygonView *) polygonViewDelegator;
- (NSString*) getAnimationImageFileName:(PolygonView *) polygonViewDelegator;
@end

@interface PolygonView : UIView
    @property id <PolygonViewDataProvider> polygonViewDelegate;
- (void) animateNow;
- (void) stopAnimation;
@end
