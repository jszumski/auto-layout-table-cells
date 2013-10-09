//
//  JSLabel.m
//  DynamicCellHeights
//
//  Copyright (c) 2013 John Szumski. All rights reserved.
//

#import "JSLabel.h"

@implementation JSLabel

- (id)init {
	self = [super init];
	
	// required to prevent Auto Layout from compressing the label (by 1 point usually) for certain constraint solutions
	[self setContentCompressionResistancePriority:UILayoutPriorityRequired
										  forAxis:UILayoutConstraintAxisVertical];
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
		
	self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
					
	[super layoutSubviews];
}

@end