//
//  JSMessage.h
//  DynamicCellHeights
//
//  Copyright (c) 2013 John Szumski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSMessage : NSObject

@property(nonatomic, strong)	NSNumber	*uniqueIdentifier;
@property(nonatomic, copy)		NSString	*username;
@property(nonatomic, copy)		NSString	*messageText;
@property(nonatomic, strong)	NSDate		*dateSent;
@property(nonatomic, assign)	BOOL		hasMedia;

@end