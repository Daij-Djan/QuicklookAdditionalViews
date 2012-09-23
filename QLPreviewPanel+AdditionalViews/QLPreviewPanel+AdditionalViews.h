//
//  QLPreviewPanel+AdditionalViews.h
//  DDModifiedQL
//
//  Created by Dominik Pich on 9/22/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface QLPreviewPanel (AdditionalViews)
@property(nonatomic, retain) NSView *leftBarView;
@property(nonatomic, retain) NSView *rightBarView;
@end
