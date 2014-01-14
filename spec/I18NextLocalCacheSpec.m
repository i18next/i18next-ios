//
//  I18NextLocalCacheSpec.m
//  i18next
//
//  Created by Jean Regisser on 03/01/14.
//  Copyright (c) 2014 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextLocalCache)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"using local cache", ^{
        
        before(^{
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSError *error = nil;
            [fileManager removeItemAtPath:options.localCachePath error:&error];
        });
            
        beforeEach(^AsyncBlock {
            stubRequest(@"GET", @"http:/example.com/locales/en-US/translation.json")
            .andReturn(200)
            .withBody(fixtureData(@"locales/en-US/translation.json"));
            stubRequest(@"GET", @"http:/example.com/locales/en/translation.json")
            .andReturn(200)
            .withBody(fixtureData(@"locales/en/translation.json"));
            stubRequest(@"GET", @"http:/example.com/locales/dev/translation.json")
            .andReturn(200)
            .withBody(fixtureData(@"locales/dev/translation.json"));
            
            options.resourcesBaseURL = [NSURL URLWithString:@"http://example.com"];
            options.updateLocalCache = YES;
            [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                done();
            }];
        });
        
        it(@"should provide loaded resources for translation", ^{
            expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_en-US");
            expect([i18n t:@"simple_en"]).to.equal(@"ok_from_en");
            expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_dev");
        });
        
        it(@"should write the data in the cache", ^{
            for (NSString* lang in @[@"en-US", @"en", @"dev"]) {
                NSString* file = [options.localCachePath stringByAppendingPathComponent:[lang stringByAppendingPathExtension:@"json"]];
                NSData* data = [NSData dataWithContentsOfFile:file];
                expect(data.length).to.beGreaterThan(0);
            }
        });
        
        describe(@"on later load", ^{
            
            beforeEach(^AsyncBlock {
                i18n = createDefaultI18NextTestInstance();
                options = [I18NextOptions optionsFromDict:i18n.options];
                options.loadFromLocalCache = YES;
                [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                    done();
                }];
            });
            
            it(@"should provide cached resources for translation", ^{
                expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_en-US");
                expect([i18n t:@"simple_en"]).to.equal(@"ok_from_en");
                expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_dev");
            });
            
        });
        
    });
    
});

SpecEnd
