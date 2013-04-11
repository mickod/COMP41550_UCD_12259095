//
//  SplitViewBarButtonItemPresenter.h
//  GeometryTutor
//
//  Created by CSI COMP41550 on 01/03/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SplitViewBarButtonItemPresenter <NSObject>
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
- (void) hideToolBar;
- (void) showToolBar;
@end
