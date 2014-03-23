//
//  AppDelegate.h
//  polycodetest
//
//  Created by Elliot Saba on 3/8/14.
//  Copyright (c) 2014 Elliot Saba. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Cocoa/Cocoa.h>
#import "PolycodeView.h"
#import "GLPaintApp.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
    PolycodeView *mainView;
    GLPaintApp *app;
    NSTimer *timer;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet PolycodeView *mainView;

@end
