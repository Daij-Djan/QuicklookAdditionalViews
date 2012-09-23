//
//  DDAppDelegate.m
//  DDModifiedQL
//
//  Created by Dominik Pich on 9/21/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import "DDAppDelegate.h"
#import "QLPreviewPanel+AdditionalViews.h"

@implementation DDAppDelegate {
    NSButton *_button1;
    NSButton *_button2;
}

- (NSButton*)button1 {
    NSButton *button = _button1;
    if(!button) {
        //prepare button
        button = [[NSButton alloc] init];
        [button setButtonType:NSMomentaryPushInButton];
        [button setFrame:NSMakeRect(0, 0, 120, 22)];
        [[button cell] setBezelStyle:NSTexturedRoundedBezelStyle];
        button.title = @"testClick1:";
        button.tag = 80804;
        button.autoresizingMask = NSViewMinXMargin;
        [button setEnabled:YES];
        [button setTarget:self];
        [button setAction:@selector(testClick1:)];
        
        _button1 = button;
    }
    return _button1;
}

- (NSButton*)button2 {
    NSButton *button = _button2;
    if(!button) {
        //prepare button
        button = [[NSButton alloc] init];
        [button setButtonType:NSMomentaryPushInButton];
        [button setFrame:NSMakeRect(0, 0, 120, 22)];
        [[button cell] setBezelStyle:NSTexturedRoundedBezelStyle];
        button.title = @"testClick2:";
        button.tag = 80804;
        button.autoresizingMask = NSViewMaxXMargin | NSViewMinYMargin;
        [button setEnabled:YES];
        [button setTarget:self];
        [button setAction:@selector(testClick2:)];
        
        _button2 = button;
    }
    return _button2;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[QLPreviewPanel sharedPreviewPanel] setLeftBarView:[self button1]];
    [[QLPreviewPanel sharedPreviewPanel] setRightBarView:[self button2]];
    
    self.view.urls = @[[[NSBundle mainBundle] URLForImageResource:@"demo"],
    [[NSBundle mainBundle] URLForResource:@"demo2" withExtension:@"pdf"],
    [[NSBundle mainBundle] URLForResource:@"demo3" withExtension:@"txt"]];
}

- (IBAction)testClick1:(id)sender {
    NSLog(@"testClick1:");
}

- (IBAction)testClick2:(id)sender {
    NSLog(@"testClick2:");
}

@end
