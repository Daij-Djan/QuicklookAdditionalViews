//
//  DDModifiedQL.h
//  DDModifiedQL
//
//  Created by Dominik Pich on 9/21/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface DDModifiedQL : NSImageView<QLPreviewPanelDelegate, QLPreviewPanelDataSource>

@property(strong,nonatomic) NSArray *urls;

@end
