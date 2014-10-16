//
//  PlaylistViewController.m
//  YoutubeExample
//
//  Created by tom.hsu on 13/8/1.
//  Copyright (c) 2013年 tom.hsu. All rights reserved.
//

#import "PlaylistViewController.h"
#import "ServiceYouTube.h"
#import "PlaylistItemsViewContrller.h"

@interface PlaylistViewController ()
@property (strong, nonatomic) IBOutlet UITableView *playListTable;
@property (strong, nonatomic) NSArray *playListArr;
@end

@implementation PlaylistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.title = @"Playlist";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playListBtn:(id)sender {
	GTLServiceYouTube *service = [ServiceYouTube youTubeService];
	
	GTLQueryYouTube *query = [GTLQueryYouTube queryForPlaylistsListWithPart:@"snippet"];
	query.mine = YES;
	query.maxResults = 50;
	
	[service executeQuery:query completionHandler:
		^(GTLServiceTicket *ticket, id object, NSError *error) {
			if (!error) {
				GTLYouTubePlaylistListResponse *playlist = object;
				self.playListArr = playlist.items;
				[self.playListTable reloadData];
			}
			else {
				NSLog(@"%@", error);
			}
		}
	 ];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_playListArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayListCell" forIndexPath:indexPath];
	GTLYouTubePlaylist *playList = _playListArr[indexPath.row];
	GTLYouTubePlaylistSnippet *snippet = playList.snippet;
	
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
    NSIndexPath *indexPath = [_playListTable indexPathForSelectedRow];
	[_playListTable deselectRowAtIndexPath:indexPath animated:YES];
	
    PlaylistItemsViewContrller *playListItemsViewContrller = [segue destinationViewController];
	GTLYouTubePlaylist *playList = _playListArr[indexPath.row];
	playListItemsViewContrller.playlistId = playList.identifier;
}

@end
