//
//  I18NextLoadBehaviorSpec.m
//  i18next
//
//  Created by Jean Regisser on 20/01/14.
//  Copyright (c) 2014 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextLoadBehavior)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"setting load", ^{
        
        describe(@"to current", ^{
            
            beforeEach(^{
                waitUntil(^(DoneCallback done) {
                    stubRequest(@"GET", @"http:/example.com/locales/en-US/translation.json")
                    .andReturn(200)
                    .withBody(fixtureData(@"locales/en-US/translation.json"));
                    stubRequest(@"GET", @"http:/example.com/locales/en/translation.json")
                    .andReturn(200)
                    .withBody(fixtureData(@"locales/en/translation.json"));
                    stubRequest(@"GET", @"http:/example.com/locales/dev/translation.json")
                    .andReturn(200)
                    .withBody(fixtureData(@"locales/dev/translation.json"));

                    options.langLoadType = I18NextLangLoadTypeCurrent;
                    options.resourcesBaseURL = [NSURL URLWithString:@"http://example.com"];
                    [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                        expect(error).to.beNil();
                        done();
                    }];
                });
            });
            
            it(@"should provide loaded resources for translation", ^{
                expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_en-US");
                expect([i18n t:@"simple_en"]).toNot.equal(@"ok_from_en");
                expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_dev");
            });
            
        });
        
        describe(@"to unspecific", ^{
            
            beforeEach(^{
                waitUntil(^(DoneCallback done) {
                    stubRequest(@"GET", @"http:/example.com/locales/en-US/translation.json")
                    .andReturn(200)
                    .withBody(fixtureData(@"locales/en-US/translation.json"));
                    stubRequest(@"GET", @"http:/example.com/locales/en/translation.json")
                    .andReturn(200)
                    .withBody(fixtureData(@"locales/en/translation.json"));
                    stubRequest(@"GET", @"http:/example.com/locales/dev/translation.json")
                    .andReturn(200)
                    .withBody(fixtureData(@"locales/dev/translation.json"));

                    options.langLoadType = I18NextLangLoadTypeUnspecific;
                    options.resourcesBaseURL = [NSURL URLWithString:@"http://example.com"];
                    [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                        expect(error).to.beNil();
                        done();
                    }];
                });
            });
            
            it(@"should provide loaded resources for translation", ^{
                expect([i18n t:@"simple_en-US"]).toNot.equal(@"ok_from_en-US");
                expect([i18n t:@"simple_en"]).to.equal(@"ok_from_en");
                expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_dev");
            });
            
            it(@"should return unspecific language", ^{
                expect(i18n.lang).to.equal(@"en");
            });
            
        });
        
    });
    
    describe(@"with fallback language set to nil", ^{
        
        beforeEach(^{
            waitUntil(^(DoneCallback done) {
                stubRequest(@"GET", @"http:/example.com/locales/en-US/translation.json")
                .andReturn(200)
                .withBody(fixtureData(@"locales/en-US/translation.json"));
                stubRequest(@"GET", @"http:/example.com/locales/en/translation.json")
                .andReturn(200)
                .withBody(fixtureData(@"locales/en/translation.json"));

                options.fallbackLang = nil;
                options.resourcesBaseURL = [NSURL URLWithString:@"http://example.com"];
                [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                    expect(error).to.beNil();
                    done();
                }];
            });
        });
        
        it(@"should provide loaded resources for translation", ^{
            expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_en-US");
            expect([i18n t:@"simple_en"]).to.equal(@"ok_from_en");
            expect([i18n t:@"simple_dev"]).toNot.equal(@"ok_from_dev");
        });
        
    });
    
    describe(@"using an underscore to separate the language from the country code", ^{
        
        beforeEach(^{
            options.lang = @"en_US";
            options.resourcesStore = @{ @"en-US": @{ @"translation": @{ @"simple_en-US": @"ok_from_en-US" } } };
            [i18n loadWithOptions:options.asDictionary completion:nil];
        });
        
        it(@"should translate the dash separated lang value", ^{
            expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_en-US");
        });
        
        it(@"should return a dash separated lang", ^{
            expect(i18n.lang).to.equal(@"en-US");
        });
        
    });
    
});

SpecEnd
