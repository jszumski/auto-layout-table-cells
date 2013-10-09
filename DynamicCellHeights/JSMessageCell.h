//
//  JSMessageCell.h
//  DynamicCellHeights
//
//  Copyright (c) 2013 John Szumski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSMessage;

FOUNDATION_EXPORT const CGFloat JSMessageCellMessageFontSize;
FOUNDATION_EXPORT const CGFloat JSMessageCellUsernameFontSize;
FOUNDATION_EXPORT const CGFloat JSMessageCellTimestampFontSize;
FOUNDATION_EXPORT const CGFloat JSMessageCellPadding;
FOUNDATION_EXPORT const CGFloat JSMessageCellAvatarWidth;
FOUNDATION_EXPORT const CGFloat JSMessageCellAvatarHeight;
FOUNDATION_EXPORT const CGFloat JSMessageCellMediaIconWidth;
FOUNDATION_EXPORT const CGFloat JSMessageCellMediaIconHeight;


@interface JSMessageCell : UITableViewCell

+ (CGFloat)minimumHeightShowingMediaIcon:(BOOL)showingMediaIcon;

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@property(nonatomic,strong) JSMessage *message;
@property(nonatomic,strong) UIImageView *avatarView;
@property(nonatomic,strong) UILabel *usernameLabel;
@property(nonatomic,strong) UILabel *messageTextLabel;
@property(nonatomic,strong) UILabel *timestampLabel;
@property(nonatomic,strong) UIImageView *mediaIconView;

@end