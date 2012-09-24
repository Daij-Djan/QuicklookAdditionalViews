//
//  DDModifiedQL.m
//  DDModifiedQL
//
//  Created by Dominik Pich on 9/21/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import "DDModifiedQL.h"

@implementation DDModifiedQL {
    BOOL _isOwner;
    NSInteger _currentIndex;
    BOOL _all;
}

- (void)setUrls:(NSArray *)urls {
    _urls = urls;
    _currentIndex = 0;
    
    self.image = [[NSImage alloc] initWithContentsOfURL:_urls[_currentIndex]];
    if(_isOwner)
        [[QLPreviewPanel sharedPreviewPanel] reloadData];
}

#pragma mark - handle first responder

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    return YES;
}

#pragma mark - handle key events: space or arrow keys

- (void)keyDown:(NSEvent *)theEvent {
    //trigger ql
    if([theEvent.characters isEqualToString:@" "]) {
        QLPreviewPanel *panel = [QLPreviewPanel sharedPreviewPanel];
        [panel makeKeyAndOrderFront:nil];
    }
    else if([theEvent.characters isEqualToString:@"0"]) {
        _all = !_all;
        if(_isOwner)
            [[QLPreviewPanel sharedPreviewPanel] reloadData];
    }
    else {
        [self handleArrowKeyEvent:theEvent];
    }
}

- (BOOL)handleArrowKeyEvent:(NSEvent*)theEvent {
    switch (theEvent.keyCode) {
        case 123:    // Left arrow
            _currentIndex-=1;
            if(_currentIndex<0)
                _currentIndex=self.urls.count-1;
            break;
        case 124:    // Right arrow
            _currentIndex+=1;
            if(_currentIndex>self.urls.count-1)
                _currentIndex=0;
            break;
        case 125:    // Down arrow
            _currentIndex-=1;
            if(_currentIndex<0)
                _currentIndex=self.urls.count-1;
            break;
        case 126:    // Up arrow
            _currentIndex+=1;
            if(_currentIndex>self.urls.count-1)
                _currentIndex=0;
            break;
        default:
            return NO;
            break;
    }
    
    self.image = [[NSImage alloc] initWithContentsOfURL:self.urls[_currentIndex]];
    if(_isOwner)
        [[QLPreviewPanel sharedPreviewPanel] reloadData];
    
    return YES;
}

#pragma mark - Quick Look Delegates

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
    // This document is now responsible of the preview panel
    // It is allowed to set the delegate, data source and refresh panel.
    _isOwner = YES;
    [QLPreviewPanel sharedPreviewPanel].delegate = self;
    [QLPreviewPanel sharedPreviewPanel].dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
    // This document loses its responsisibility on the preview panel
    // Until the next call to -beginPreviewPanelControl: it must not
    // change the panel's delegate, data source or refresh it.
    _isOwner = NO;
}

#pragma mark - Quick Look panel data source

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
    return _all ? self.urls.count : 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    return self.urls[_all ? index : _currentIndex];
}

// Quick Look panel delegate

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event {
    assert(_isOwner);
    
    //only handle keydowns
    if( event.type != NSKeyDown)
        return NO;
    
    if([event.characters isEqualToString:@"0"]) {
        _all = !_all;
        [[QLPreviewPanel sharedPreviewPanel] reloadData];
        return YES;
    }
    else {
        // handle arrow keys
        return [self handleArrowKeyEvent:event];
    }
}

// This delegate method provides the rect on screen from which the panel will zoom.
- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {
    return [self.window convertRectToScreen:[self convertRect:self.frame toView:nil]];
}

// This delegate method provides a transition image between the table view and the preview panel
- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect {
    return self.image;
}

@end
