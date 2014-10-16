//
//  SettingViewController.m
//  YoutubeExample
//
//  Created by tom.hsu on 13/8/1.
//  Copyright (c) 2013年 tom.hsu. All rights reserved.
//

#import "SettingViewController.h"
#import "ServiceYouTube.h"

// Keychain item name for saving the user's authentication information.
NSString *const kKeychainItemName = @"YouTubeSample: YouTube";

@interface SettingViewController ()
@property (strong, nonatomic) IBOutlet UIButton *signInBtn;
@property (strong, nonatomic) IBOutlet UILabel *userAccountLabel;
@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.title = @"Setting";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInBtn:(id)sender {
	if (![self isSignedIn]) {
		// Sign in.
		[self signIn];
	} else {
		// Sign out.
		[GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
		[[ServiceYouTube youTubeService] setAuthorizer:nil];
		[self updateUI];
	}
}

- (void)signIn {
	NSString *clientID = @"404415981542-mm1ttug2evkg2je5bhg5fef2bsddkk9a.apps.googleusercontent.com";
	NSString *clientSecret = @"lQZuQS4OfWGxCIYphaYFFqei";
	
	GTMOAuth2ViewControllerTouch *viewController;
	viewController = [GTMOAuth2ViewControllerTouch controllerWithScope:kGTLAuthScopeYouTube
															  clientID:clientID
														  clientSecret:clientSecret
													  keychainItemName:kKeychainItemName
													 completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
														 if (error == NULL) {
															 [[ServiceYouTube youTubeService] setAuthorizer:auth];
															 [self updateUI];
														 }
														 else {
															 NSLog(@"AuthError: %@", error);
														 }
													 }];
	
	[self.navigationController pushViewController:viewController animated:YES];
}

- (void)updateUI {
	BOOL isSignedIn = [self isSignedIn];
	NSString *username = [self signedInUsername];
	[self.signInBtn setTitle:(isSignedIn?@"Sign Out":@"Sign In") forState:UIControlStateNormal];
	[self.userAccountLabel setText:(isSignedIn ? username : @"No")];
}

- (BOOL)isSignedIn {
	NSString *name = [self signedInUsername];
	return (name != nil);
}

- (NSString *)signedInUsername {
	// Get the email address of the signed-in user.
	GTMOAuth2Authentication *auth = [[ServiceYouTube youTubeService] authorizer];
	BOOL isSignedIn = auth.canAuthorize;
	if (isSignedIn) {
		return auth.userEmail;
	} else {
		return nil;
	}
}


@end
