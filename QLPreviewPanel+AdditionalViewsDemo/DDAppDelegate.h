//
//  DDAppDelegate.h
//  DDModifiedQL
//
//  Created by Dominik Pich on 9/21/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DDModifiedQL.h"

@interface DDAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet DDModifiedQL *view;

@end
