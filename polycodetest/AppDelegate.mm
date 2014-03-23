//
//  AppDelegate.m
//  polycodetest
//
//  Created by Elliot Saba on 3/8/14.
//  Copyright (c) 2014 Elliot Saba. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize mainView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	app = new GLPaintApp(mainView);
	timer = [NSTimer timerWithTimeInterval:(1.0f/60.0f)
                                    target:self
                                  selector:@selector(animationTimer:)
                                  userInfo:nil
                                   repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSEventTrackingRunLoopMode];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void)animationTimer:(NSTimer *)timer
{
	if(!app->Update()) {
		[[NSApplication sharedApplication] stop:self];
	}
}


@end
