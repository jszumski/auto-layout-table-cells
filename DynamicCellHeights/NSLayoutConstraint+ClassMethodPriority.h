//
//  NSLayoutConstraint+ClassMethodPriority.h
//  DynamicCellHeights
//
//  Copyright (c) 2013 John Szumski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (ClassMethodPriority)

+ (id)constraintWithItem:(id)view1
			   attribute:(NSLayoutAttribute)attr1
			   relatedBy:(NSLayoutRelation)relation
				  toItem:(id)view2
			   attribute:(NSLayoutAttribute)attr2
			  multiplier:(CGFloat)multiplier
				constant:(CGFloat)c
				priority:(UILayoutPriority)priority;

@end