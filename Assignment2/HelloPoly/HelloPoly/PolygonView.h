//
//  PolygonView.h
//  HelloPoly
//
//  Created by Mick O'Doherty on 16/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol polygonViewDataProvider
- (int) numberOfSidesForPolygonView;
@end

@interface PolygonView : UIView
    @property id <polygonViewDataProvider> polygonViewDelegate;
@end
