//
//  QLPreviewPanel+AdditionalViews.m
//  DDModifiedQL
//
//  Created by Dominik Pich on 9/22/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import "QLPreviewPanel+AdditionalViews.h"
#import <objc/runtime.h>
#import "NSView+findSubview.h"

static void * const kDDAssociatedStorageKeyLeftBarView = (void*)&kDDAssociatedStorageKeyLeftBarView;
static void * const kDDAssociatedStorageKeyRightBarView = (void*)&kDDAssociatedStorageKeyRightBarView;

static void * const kDDAssociatedStorageKeyDelegate = (void*)&kDDAssociatedStorageKeyDelegate;
static void * const kDDAssociatedStorageKeyDataSource = (void*)&kDDAssociatedStorageKeyDelegate;

@implementation QLPreviewPanel (AdditionalViews)

- (void)setLeftBarView:(NSView *)leftBarView {
    NSView *view = self.leftBarView;
    [view removeFromSuperview];
    
    objc_setAssociatedObject(self, kDDAssociatedStorageKeyLeftBarView, leftBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //if the QL panel is visible, update it
    if(self == [QLPreviewPanel sharedPreviewPanel] &&
       [[QLPreviewPanel sharedPreviewPanel] isVisible])
        [self addViewsTo:[QLPreviewPanel sharedPreviewPanel]];
}

- (NSView *)leftBarView {
    return objc_getAssociatedObject(self, kDDAssociatedStorageKeyLeftBarView);
}

- (void)setRightBarView:(NSView *)rightBarView {
    NSView *view = self.rightBarView;
    [view removeFromSuperview];
    
    objc_setAssociatedObject(self, kDDAssociatedStorageKeyRightBarView, rightBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    //if the QL panel is visible, update it
    if(self == [QLPreviewPanel sharedPreviewPanel] &&
       [[QLPreviewPanel sharedPreviewPanel] isVisible])
        [self addViewsTo:[QLPreviewPanel sharedPreviewPanel]];
}

- (NSView *)rightBarView {
    return objc_getAssociatedObject(self, kDDAssociatedStorageKeyRightBarView);
}

#pragma mark - view placing

- (void)addLeftBarViewTo:(NSView *)themeFrame {
    NSView *view = self.leftBarView;
    if(!view)
        return;
    
    if(!view.superview) {
        //prepare view
        [view setFrame:NSMakeRect(0, 0, 120, 22)];
        view.autoresizingMask = NSViewMaxXMargin | NSViewMinYMargin;
        [themeFrame addSubview:view];
    }
    
    //get frames
    NSRect c = themeFrame.frame;  // c for "container"
    NSRect aV = view.frame;    // aV for "accessory view"
    
    //find the X+width of the last subview left of the middle and make that our minimum
    CGFloat minX = 0;
    for (NSView *subview in themeFrame.subviews) {
        if(subview.frame.origin.x < c.size.width/3 && subview != view)
        {
            //check if it is an empty container
            if(subview.subviews.count) {
                NSArray *containers = [subview subviewsOfKind:NSClassFromString(@"QLControlsContainerView")];
                if(![containers.lastObject subviews].count)
                    continue;
            }

            //NSLog(@"%@ %@", subview, NSStringFromRect(subview.frame));
            minX = MAX(subview.frame.origin.x + subview.frame.size.width, minX);
        }
    }
    
    //prepare rect
    NSRect newFrame = NSMakeRect(minX + 5,  // x position
                                 (c.size.height - aV.size.height)/2,    // y position
                                 aV.size.width,  // width
                                 aV.size.height); // height
    
    //apply
    view.frame = newFrame;
}

- (void)addRightBarViewTo:(NSView *)themeFrame {
    NSView *view = self.rightBarView;
    if(!view)
        return;
    
    if(!view.superview) {
        //prepare view
        [view setFrame:NSMakeRect(0, 0, 120, 22)];
        view.autoresizingMask = NSViewMaxXMargin | NSViewMinYMargin;
        [themeFrame addSubview:view];
    }
    
    //get frames
    NSRect c = themeFrame.frame;  // c for "container"
    NSRect aV = view.frame;    // aV for "accessory view"
    
    //find the X of the first subview right of the middle and make that our maximum
    CGFloat maxX = c.size.width;
    for (NSView *subview in themeFrame.subviews) {
        if(subview.frame.origin.x > c.size.width/2 && subview != view)
        {
            maxX = MIN(subview.frame.origin.x, maxX);
        }
    }
    
    //prepare rect
    NSRect newFrame = NSMakeRect(maxX - aV.size.width - 5,  // x position
                                 (c.size.height - aV.size.height)/2,    // y position
                                 aV.size.width,  // width
                                 aV.size.height); // height
    
    //apply
    view.frame = newFrame;
}

- (void)addViewsTo:(NSWindow*)window {
    NSView *themeFrame = [[window contentView] firstSubviewOfKind:NSClassFromString(@"QLPreviewTitleBarView")];
    
    [self addLeftBarViewTo:themeFrame];
    [self addRightBarViewTo:themeFrame];
}

#pragma mark - swizzeling

/*
 * load function
 */
+ (void)load {
    SEL originalSelector = @selector(setDelegate:);
    SEL overrideSelector = @selector(setDelegate_xchg:);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
    
    originalSelector = @selector(setDataSource:);
    overrideSelector = @selector(setDataSource_xchg:);
    originalMethod = class_getInstanceMethod(self, originalSelector);
    overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

/*
 * Setting the delegate
 */
- (void)setDelegate_xchg:(id <QLPreviewPanelDelegate>)delegate {
    objc_setAssociatedObject(self, kDDAssociatedStorageKeyDelegate, delegate, OBJC_ASSOCIATION_ASSIGN);

    [self setDelegate_xchg:(id<QLPreviewPanelDelegate>)self];
}

- (id <QLPreviewPanelDelegate>)originalDelegate {
    return objc_getAssociatedObject(self, kDDAssociatedStorageKeyDelegate);
}

/*
 * Setting the dataSource
 */
- (void)setDataSource_xchg:(id <QLPreviewPanelDataSource>)dataSource {
    objc_setAssociatedObject(self, kDDAssociatedStorageKeyDataSource, dataSource, OBJC_ASSOCIATION_ASSIGN);

    [self setDataSource_xchg:(id<QLPreviewPanelDataSource>)self];
}

- (id <QLPreviewPanelDataSource>)originalDataSource {
    return objc_getAssociatedObject(self, kDDAssociatedStorageKeyDataSource);
}

#pragma mark - Quick Look panel data source

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
    if([(id)[self originalDataSource] respondsToSelector:@selector(numberOfPreviewItemsInPreviewPanel:)])
        return [[self originalDataSource] numberOfPreviewItemsInPreviewPanel:panel];
    return 0;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    [self performSelector:@selector(addViewsTo:) withObject:panel afterDelay:0]; //!
    
    if([(id)[self originalDataSource] respondsToSelector:@selector(previewPanel:previewItemAtIndex:)])
        return [[self originalDataSource] previewPanel:panel previewItemAtIndex:index];
    return nil;
}

#pragma mark Quick Look panel delegate

// window delegate
- (void)windowDidResize:(NSNotification *)notification {
    [self addViewsTo:notification.object];

    if([[self originalDelegate] respondsToSelector:@selector(windowDidResize:)])
        [[self originalDelegate] windowDidResize:notification];
}

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event {
    if([[self originalDelegate] respondsToSelector:@selector(previewPanel:handleEvent:)])
        return [[self originalDelegate] previewPanel:panel handleEvent:event];
    return NO;
}

// This delegate method provides the rect on screen from which the panel will zoom.
- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {
    if([[self originalDelegate] respondsToSelector:@selector(previewPanel:sourceFrameOnScreenForPreviewItem:)])
        return [[self originalDelegate] previewPanel:panel sourceFrameOnScreenForPreviewItem:item];
    return NSZeroRect;
}

// This delegate method provides a transition image between the table view and the preview panel
- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect {
    if([[self originalDelegate] respondsToSelector:@selector(previewPanel:transitionImageForPreviewItem:)])
        return [[self originalDelegate] previewPanel:panel transitionImageForPreviewItem:item contentRect:contentRect];
    return nil;
}

@end
