//
//  PlaylistItemsViewContrller.m
//  YoutubeExample
//
//  Created by tom.hsu on 13/8/2.
//  Copyright (c) 2013年 tom.hsu. All rights reserved.
//

#import "PlaylistItemsViewContrller.h"
#import "ServiceYouTube.h"
#import "VideoViewController.h"

@interface PlaylistItemsViewContrller ()
@property (strong, nonatomic) IBOutlet UITableView *playListItemsTable;
@property (strong, nonatomic) NSArray *playListItemsArr;
@end

@implementation PlaylistItemsViewContrller

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"PlaylistItem";
	
	// Do any additional setup after loading the view.
	GTLServiceYouTube *service = [ServiceYouTube youTubeService];
	
	GTLQueryYouTube *query = [GTLQueryYouTube queryForPlaylistItemsListWithPart:@"snippet,contentDetails"];
	query.maxResults = 50;
	query.playlistId = self.playlistId;
	
	[service executeQuery:query completionHandler:
	 ^(GTLServiceTicket *ticket, id object, NSError *error) {
		 if (!error) {
			 GTLYouTubePlaylistItemListResponse *playlistItem = object;
			 self.playListItemsArr = playlistItem.items;
			 [self.playListItemsTable reloadData];
		 }
		 else {
			 NSLog(@"%@", error);
		 }
	 }
	 ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_playListItemsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playListItemsCell" forIndexPath:indexPath];
	GTLYouTubePlaylistItem *playlistItem = _playListItemsArr[indexPath.row];
	GTLYouTubePlaylistItemSnippet *snippet = playlistItem.snippet;
	
	UIImageView *titleImageView = (UIImageView *)[cell viewWithTag:1];
	[titleImageView setImageWithURL:[NSURL URLWithString:snippet.thumbnails.defaultProperty.url]
				   placeholderImage:[UIImage imageNamed:@"Default.png"]
							options:SDWebImageRetryFailed
						   progress:nil
						  completed:nil];
	
	UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
	titleLabel.text = snippet.title;
	
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [_playListItemsTable indexPathForSelectedRow];
	[_playListItemsTable deselectRowAtIndexPath:indexPath animated:YES];
	
    VideoViewController *videoViewController = [segue destinationViewController];
	videoViewController.items = _playListItemsArr[indexPath.row];
}

@end
