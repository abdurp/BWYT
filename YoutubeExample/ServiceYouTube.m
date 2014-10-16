//
//  ServiceYouTube.m
//  YoutubeExample
//
//  Created by tom.hsu on 13/8/1.
//  Copyright (c) 2013年 tom.hsu. All rights reserved.
//

#import "ServiceYouTube.h"

@implementation ServiceYouTube
+ (GTLServiceYouTube *)youTubeService {
	static GTLServiceYouTube *service;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		service = [[GTLServiceYouTube alloc] init];
		
		// Have the service object set tickets to fetch consecutive pages
		// of the feed so we do not need to manually fetch them.
		service.shouldFetchNextPages = YES;
		
		// Have the service object set tickets to retry temporary error conditions
		// automatically.
		service.retryEnabled = YES;
	});
	return service;
}
@end
