//
//  NSLayoutConstraint+ClassMethodPriority.m
//  DynamicCellHeights
//
//  Copyright (c) 2013 John Szumski. All rights reserved.
//

#import "NSLayoutConstraint+ClassMethodPriority.h"

@implementation NSLayoutConstraint (ClassMethodPriority)

+ (id)constraintWithItem:(id)view1
			   attribute:(NSLayoutAttribute)attr1
			   relatedBy:(NSLayoutRelation)relation
				  toItem:(id)view2
			   attribute:(NSLayoutAttribute)attr2
			  multiplier:(CGFloat)multiplier
				constant:(CGFloat)c
				priority:(UILayoutPriority)priority {
	
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1
																  attribute:attr1
																  relatedBy:relation
																	 toItem:view2
																  attribute:attr2
																 multiplier:multiplier
																   constant:c];
	constraint.priority = priority;
	
	return constraint;
}

@end