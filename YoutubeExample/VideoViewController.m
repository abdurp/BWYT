//
//  VideoViewController.m
//  YoutubeExample
//
//  Created by tom.hsu on 13/8/2.
//  Copyright (c) 2013年 tom.hsu. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIWebView *videoWebView;
@end

@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.title = @"Video";
	
	self.titleLabel.text = self.items.snippet.title;
	self.descriptionTextView.text = self.items.snippet.descriptionProperty;
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", self.items.contentDetails.videoId]]];
	[self.videoWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
