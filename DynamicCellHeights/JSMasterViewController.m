//
//  JSMasterViewController.m
//  DynamicCellHeights
//
//  Copyright (c) 2013 John Szumski. All rights reserved.
//

#import "JSMasterViewController.h"
#import "JSMessage.h"
#import "JSAutoMessageCell.h"
#import "JSManualMessageCell.h"


// set to 1 to turn on row height caching
#define PERFORMANCE_ENABLE_HEIGHT_CACHE 1

// set to 1 to turn on a separate cell ID for rows showing the media icon
#define PERFORMANCE_ENABLE_MEDIA_CELL_ID 1

// set to 1 to use iOS 7's estimatedRowHeight table optimization
#define PERFORMANCE_ENABLE_ESTIMATED_ROW_HEIGHT 1


@interface JSMasterViewController()

@property(nonatomic, strong) UISegmentedControl		*cellTypeSwitcher;
@property(nonatomic, strong) NSArray				*messages;
@property(nonatomic, strong) NSMutableDictionary	*rowHeightCache;
@property(nonatomic, strong) JSAutoMessageCell		*sizingCell;

@end


@implementation JSMasterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
		
	/*
	 * create a segmented control to switch between cell types
	 */
	self.cellTypeSwitcher = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Manual Layout", nil),
																		NSLocalizedString(@"Auto Layout", nil)]];
	self.cellTypeSwitcher.segmentedControlStyle = UISegmentedControlStyleBar;
	self.cellTypeSwitcher.selectedSegmentIndex = 1;
	[self.cellTypeSwitcher addTarget:self action:@selector(cellTypeChanged:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = self.cellTypeSwitcher;
	

	/*
	 * create a cell instance to use for auto layout sizing
	 */
	self.sizingCell = [[JSAutoMessageCell alloc] initWithReuseIdentifier:nil];
	self.sizingCell.autoresizingMask = UIViewAutoresizingFlexibleWidth; // this must be set for the cell heights to be calculated correctly in landscape
	self.sizingCell.hidden = YES;
	
	[self.tableView addSubview:self.sizingCell];
	
	self.sizingCell.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 0);
	
	
	/*
	 * create and prime our cache if enabled
	 */
	#if PERFORMANCE_ENABLE_HEIGHT_CACHE
		self.rowHeightCache = [NSMutableDictionary dictionary];
	#endif
	
	
	/*
	 * load our dummy data
	 */
	self.messages = [self messagesFromFile];
}


#pragma mark - UI response

- (void)cellTypeChanged:(id)sender {
	// invalidate the cache if enabled
	#if PERFORMANCE_ENABLE_HEIGHT_CACHE
		self.rowHeightCache = [NSMutableDictionary dictionary];
	#endif
	
	// load the new cell type
	[self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.messages.count;
}

#if PERFORMANCE_ENABLE_ESTIMATED_ROW_HEIGHT
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [JSMessageCell minimumHeightShowingMediaIcon:NO];
}
#endif

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	JSMessage *message = self.messages[indexPath.row];
	
	// check the cache first if enabled
	#if PERFORMANCE_ENABLE_HEIGHT_CACHE
		NSNumber *cachedHeight = self.rowHeightCache[message.uniqueIdentifier];
	
		if (cachedHeight != nil) {
			return [cachedHeight floatValue];
		}
	#endif
	
	
	CGFloat calculatedHeight = 0;
	
	// determine which dyanmic height method to use
	if (self.cellTypeSwitcher.selectedSegmentIndex == 0) {
		calculatedHeight = [JSManualMessageCell heightForMessage:message constrainedToWidth:CGRectGetWidth(tableView.bounds)];
	
	} else {
		self.sizingCell.message = message;
		
		[self.sizingCell setNeedsLayout];
		[self.sizingCell layoutIfNeeded];
		
		calculatedHeight = [self.sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
	}
	
	// cache the value if enabled
	#if PERFORMANCE_ENABLE_HEIGHT_CACHE
		self.rowHeightCache[message.uniqueIdentifier] = @(calculatedHeight);
	#endif
	
	return calculatedHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *manualCellId = @"manualCell";
	static NSString *autoCellId = @"autoCell";
	static NSString *autoCellMediaId = @"autoMediaCell";

	JSMessageCell *cell = nil;
	JSMessage *message = self.messages[indexPath.row];
	
	// manual layout cells
	if (self.cellTypeSwitcher.selectedSegmentIndex == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:manualCellId];
		
		if (cell == nil) {
			cell = [[JSManualMessageCell alloc] initWithReuseIdentifier:manualCellId];
		}
		
	// auto layout cells
	} else {
		NSString *cellId = nil;
		
		// choose the appropriate cell ID
		#if PERFORMANCE_ENABLE_MEDIA_CELL_ID
			if (message.hasMedia) {
				cellId = autoCellMediaId;
				
			} else {
				cellId = autoCellId;
			}
		
		#else
			cellId = autoCellId;
		#endif
		
		
		cell = [tableView dequeueReusableCellWithIdentifier:cellId];
		
		if (cell == nil) {
			cell = [[JSAutoMessageCell alloc] initWithReuseIdentifier:cellId];
		}
	}
	
	cell.message = message;

	return cell;
}


#pragma mark - Data management

- (NSArray*)messagesFromFile {
	NSError *error = nil;
	NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"json"]]
														 options:kNilOptions
														   error:&error];
	if (error != nil) {
		NSLog(@"Error: was not able to load messages.");
		return nil;
	}
	
	NSArray *rawMessages = data[@"messages"];
	NSMutableArray *finalMessages = [NSMutableArray array];
	
	for (NSDictionary *messageData in rawMessages) {
		JSMessage *m = [[JSMessage alloc] init];
		
		m.uniqueIdentifier = messageData[@"uniqueIdentifier"];
		m.username = messageData[@"username"];
		m.messageText = messageData[@"messageText"];
		m.dateSent = [NSDate dateWithTimeIntervalSince1970:[messageData[@"messageDate"] doubleValue]];
		m.hasMedia = [messageData[@"hasMedia"] boolValue];
		
		[finalMessages addObject:m];
	}
	
	return finalMessages;
}

@end