//
//  JSAutoMessageCell.m
//  DynamicCellHeights
//
//  Copyright (c) 2013 John Szumski. All rights reserved.
//

#import "JSAutoMessageCell.h"
#import "JSMessage.h"
#import "NSLayoutConstraint+ClassMethodPriority.h"


@interface JSAutoMessageCell()

@property(nonatomic,strong) NSMutableArray *rightGutterConstraints;
@property(nonatomic,strong) NSMutableArray *mediaIconConstraints;

@end


@implementation JSAutoMessageCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithReuseIdentifier:reuseIdentifier];
	
	self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
	self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.messageTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.mediaIconView.translatesAutoresizingMaskIntoConstraints = NO;
	
	self.rightGutterConstraints = [NSMutableArray array];
	self.mediaIconConstraints = [NSMutableArray array];
	[self applyConstraints];
	
	return self;
}


#pragma mark - State

- (void)setMessage:(JSMessage *)message {
	[super setMessage:message];
		
	if (message.hasMedia) {
		self.mediaIconView.hidden = NO;
	
	} else {
		self.mediaIconView.hidden = YES;
	}
	
	[self setNeedsUpdateConstraints];
	[self setNeedsLayout];
}


#pragma mark - Layout

- (CGFloat)rightGutterWidth {
	if (self.message.hasMedia) {
		return JSMessageCellMediaIconWidth + JSMessageCellPadding*2;
		
	} else {
		return JSMessageCellPadding;
	}
}

- (void)updateConstraints {
	[super updateConstraints];
	
	// update the right gutter
	for (NSLayoutConstraint *c in self.rightGutterConstraints) {
		c.constant = [self rightGutterWidth];
	}
	
	// add contraints if media icon is visible, otherwise remove them
	if (self.message.hasMedia) {
		[self.contentView addConstraints:self.mediaIconConstraints];
	
	} else {
		[self.contentView removeConstraints:self.mediaIconConstraints];
	}
}

- (void)applyConstraints {
	[self.contentView removeConstraints:self.contentView.constraints];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeTop
																multiplier:1
																  constant:JSMessageCellPadding]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
																 attribute:NSLayoutAttributeBottom
																 relatedBy:NSLayoutRelationGreaterThanOrEqual
																	toItem:self.avatarView
																 attribute:NSLayoutAttributeBottom
																multiplier:1
																  constant:JSMessageCellPadding
																  priority:UILayoutPriorityDefaultLow]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeLeft
																multiplier:1
																  constant:JSMessageCellPadding]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView
																 attribute:NSLayoutAttributeHeight
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1
																  constant:JSMessageCellAvatarHeight
																  priority:UILayoutPriorityRequired]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1
																  constant:JSMessageCellAvatarWidth
																  priority:UILayoutPriorityRequired]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameLabel
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.avatarView
																 attribute:NSLayoutAttributeRight
																multiplier:1
																  constant:JSMessageCellPadding]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameLabel
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeTop
																multiplier:1
																  constant:JSMessageCellPadding]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageTextLabel
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.avatarView
																 attribute:NSLayoutAttributeRight
																multiplier:1
																  constant:JSMessageCellPadding]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageTextLabel
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.usernameLabel
																 attribute:NSLayoutAttributeBottom
																multiplier:1
																  constant:0]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timestampLabel
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.avatarView
																 attribute:NSLayoutAttributeRight
																multiplier:1
																  constant:JSMessageCellPadding]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
																 attribute:NSLayoutAttributeRight
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.timestampLabel
																 attribute:NSLayoutAttributeRight
																multiplier:1
																  constant:JSMessageCellPadding]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timestampLabel
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationGreaterThanOrEqual
																	toItem:self.messageTextLabel
																 attribute:NSLayoutAttributeBottom
																multiplier:1
																  constant:0
																  priority:UILayoutPriorityDefaultHigh]];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
																 attribute:NSLayoutAttributeBottom
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.timestampLabel
																 attribute:NSLayoutAttributeBottom
																multiplier:1
																  constant:JSMessageCellPadding]];
	
	/*
	 * constraints that change constants in the presence of a media icon
	 */
	[self.rightGutterConstraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
																		attribute:NSLayoutAttributeRight
																		relatedBy:NSLayoutRelationEqual
																		   toItem:self.usernameLabel
																		attribute:NSLayoutAttributeRight
																	   multiplier:1
																		 constant:[self rightGutterWidth]]];
	
	[self.rightGutterConstraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
																		attribute:NSLayoutAttributeRight
																		relatedBy:NSLayoutRelationEqual
																		   toItem:self.messageTextLabel
																		attribute:NSLayoutAttributeRight
																	   multiplier:1
																		 constant:[self rightGutterWidth]]];
	
	[self.contentView addConstraints:self.rightGutterConstraints];
	
	
	/*
	 * media icon
	 */
	[self.mediaIconConstraints addObject:[NSLayoutConstraint constraintWithItem:self.timestampLabel
																	  attribute:NSLayoutAttributeTop
																	  relatedBy:NSLayoutRelationGreaterThanOrEqual
																		 toItem:self.mediaIconView
																	  attribute:NSLayoutAttributeBottom
																	 multiplier:1
																	   constant:JSMessageCellPadding
																	   priority:999]];
	
	[self.mediaIconConstraints addObject:[NSLayoutConstraint constraintWithItem:self.mediaIconView
																	  attribute:NSLayoutAttributeLeft
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:self.usernameLabel
																	  attribute:NSLayoutAttributeRight
																	 multiplier:1
																	   constant:JSMessageCellPadding]];
	
	[self.mediaIconConstraints addObject:[NSLayoutConstraint constraintWithItem:self.mediaIconView
																	  attribute:NSLayoutAttributeTop
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:self.contentView
																	  attribute:NSLayoutAttributeTop
																	 multiplier:1
																	   constant:JSMessageCellPadding]];
	
	[self.mediaIconConstraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
																	  attribute:NSLayoutAttributeRight
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:self.mediaIconView
																	  attribute:NSLayoutAttributeRight
																	 multiplier:1
																	   constant:JSMessageCellPadding]];
	
	[self.mediaIconConstraints addObject:[NSLayoutConstraint constraintWithItem:self.mediaIconView
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																	attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1
																  constant:JSMessageCellMediaIconWidth]];
	
	[self.mediaIconConstraints addObject:[NSLayoutConstraint constraintWithItem:self.mediaIconView
																	  attribute:NSLayoutAttributeHeight
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:nil
																	  attribute:NSLayoutAttributeNotAnAttribute
																	 multiplier:1
																	   constant:self.mediaIconView.image.size.height]];
}

@end