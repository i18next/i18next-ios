//
//  I18NextSpecHelper.m
//  i18next
//
//  Created by Jean Regisser on 30/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18NextSpecHelper.h"
#import "Nocilla.h"

// Start/stop Nocilla globally
@interface NocillaSpecHelper : NSObject; @end
@implementation NocillaSpecHelper
+ (void)beforeEach {
    [[LSNocilla sharedInstance] start];
}
+ (void)afterEach {
	[[LSNocilla sharedInstance] clearStubs];
    [[LSNocilla sharedInstance] stop];
}
@end

I18Next* createDefaultI18NextTestInstance() {
    I18Next* i18n = [I18Next new];
    i18n.lang = @"en-US";
    return i18n;
}

NSData* fixtureData(NSString* fixtureName) {
    NSString* resourcePath = [NSBundle bundleForClass:[I18Next class]].resourcePath;
	NSString* filePath = [NSString pathWithComponents:@[resourcePath, @"fixtures", fixtureName]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		[NSException raise:@"FixtureNotFound" format:@"No fixture found at path '%@'", filePath];
    }
	return [NSData dataWithContentsOfFile:filePath];
}
