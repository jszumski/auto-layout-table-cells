//
//  JSManualCell.h
//  DynamicCellHeights
//
//  Copyright (c) 2013 John Szumski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageCell.h"


@interface JSManualMessageCell : JSMessageCell

+ (CGFloat)heightForMessage:(JSMessage*)message constrainedToWidth:(CGFloat)width;

@end