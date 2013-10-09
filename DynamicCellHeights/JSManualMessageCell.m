//
//  JSManualCell.m
//  DynamicCellHeights
//
//  Copyright (c) 2013 John Szumski. All rights reserved.
//

#import "JSManualMessageCell.h"
#import "JSMessage.h"
#import "NSDate+TimeAgo.h"


@implementation JSManualMessageCell

#pragma mark - Class methods

+ (CGFloat)heightForMessage:(JSMessage*)message constrainedToWidth:(CGFloat)width {
	CGFloat labelWidth = width - JSMessageCellPadding - JSMessageCellAvatarWidth - JSMessageCellPadding;
	
	CGFloat calculatedHeight = JSMessageCellPadding +
							   [[self class] heightForUsernameFromMessage:message] +
							   [[self class] heightForTextFromMessage:message constrainedToWidth:labelWidth] +
							   [[self class] heightForTimestampFromMessage:message] +
							   JSMessageCellPadding;
	
	return MAX([[self class] minimumHeightShowingMediaIcon:message.hasMedia], calculatedHeight);
}

+ (CGFloat)heightForUsernameFromMessage:(JSMessage*)message {
	// assumed to be only one line
	return ceil([message.username sizeWithFont:[UIFont boldSystemFontOfSize:JSMessageCellUsernameFontSize]
									   forWidth:MAXFLOAT // this can be anything since we only care about height for one line
								  lineBreakMode:NSLineBreakByWordWrapping].height);
}

+ (CGFloat)heightForTextFromMessage:(JSMessage*)message constrainedToWidth:(CGFloat)width {
	// must be multi-line
	return ceil([message.messageText sizeWithFont:[UIFont systemFontOfSize:JSMessageCellMessageFontSize]
								constrainedToSize:CGSizeMake(width, MAXFLOAT)
									lineBreakMode:NSLineBreakByWordWrapping].height);
}

+ (CGFloat)heightForTimestampFromMessage:(JSMessage*)message {
	// assumed to be only one line
	return ceil([[message.dateSent timeAgo] sizeWithFont:[UIFont systemFontOfSize:JSMessageCellTimestampFontSize]
												forWidth:MAXFLOAT // this can be anything since we only care about height for one line
										   lineBreakMode:NSLineBreakByWordWrapping].height);
}


#pragma mark - State

- (void)setMessage:(JSMessage *)message {
	[super setMessage:message];
	
	[self setNeedsLayout];
}


#pragma mark - Layout

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat iconGutterWidth = JSMessageCellPadding + self.avatarView.image.size.width + JSMessageCellPadding;
	CGFloat cellWidth = CGRectGetWidth(self.bounds);
	CGFloat labelWidth = cellWidth - iconGutterWidth - JSMessageCellPadding;
	
	// adjust the label width to make room for the media icon
	if (self.message.hasMedia) {
		labelWidth -= self.mediaIconView.image.size.width + JSMessageCellPadding;
	}
	
	self.avatarView.frame = CGRectMake(JSMessageCellPadding,
									   JSMessageCellPadding,
									   JSMessageCellAvatarWidth,
									   JSMessageCellAvatarHeight);
	
	self.usernameLabel.frame = CGRectMake(iconGutterWidth,
										  JSMessageCellPadding,
										  labelWidth,
										  [[self class] heightForUsernameFromMessage:self.message]);
	
	self.messageTextLabel.frame = CGRectMake(iconGutterWidth,
											 CGRectGetMaxY(self.usernameLabel.frame),
											 labelWidth,
											 [[self class] heightForTextFromMessage:self.message constrainedToWidth:labelWidth]);
	
	// case 1: an avatar + message text
	CGFloat timestampYOrigin = JSMessageCellAvatarHeight + JSMessageCellPadding - [[self class] heightForTimestampFromMessage:self.message];
	
	// case 2: no message text + no media icon
	timestampYOrigin = MAX(timestampYOrigin, CGRectGetMaxY(self.messageTextLabel.frame));
	
	// case 3: no message text + media icon, this ends up being taller than case 2
	if (self.message.hasMedia) {
		timestampYOrigin = MAX(timestampYOrigin, CGRectGetMaxY(self.mediaIconView.frame) + JSMessageCellPadding);
	}
	
	self.timestampLabel.frame = CGRectMake(iconGutterWidth,
										   timestampYOrigin-1,
										   cellWidth - iconGutterWidth - JSMessageCellPadding,
										   [[self class] heightForTimestampFromMessage:self.message]);
	
	if (self.message.hasMedia) {
		self.mediaIconView.hidden = NO;
		
		self.mediaIconView.frame = CGRectMake(cellWidth - self.mediaIconView.image.size.width - JSMessageCellPadding,
											  JSMessageCellPadding,
											  self.mediaIconView.image.size.width,
											  self.mediaIconView.image.size.height);
		
	} else {
		self.mediaIconView.hidden = YES;
	}
}

@end