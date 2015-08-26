//
//  I18NextLoadSpec.m
//  i18next
//
//  Created by Jean Regisser on 06/11/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextLoad)

describe(@"I18Next ", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    NSDictionary* testStore =
    @{
      @"dev": @{ @"translation": @{ @"simple_dev": @"ok_from_dev" } },
      @"en": @{ @"translation": @{ @"simple_en": @"ok_from_en" } },
      @"en-US": @{ @"translation": @{ @"simple_en-US": @"ok_from_en-US" } },
      };
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"load", ^{
        
        describe(@"with passed in resources set", ^{
            
            beforeEach(^{
                options.resourcesStore = testStore;
                [i18n loadWithOptions:options.asDictionary completion:nil];
            });
            
            it(@"should provide passed resources for translation", ^{
                expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_en-US");
                expect([i18n t:@"simple_en"]).to.equal(@"ok_from_en");
                expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_dev");
            });
            
        });
        
        describe(@"loading from server", ^{
            
            describe(@"with static route", ^{
                
                describe(@"with all requests succeeding", ^{
                    
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
                        expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_dev");
                    });
                    
                });
                
                describe(@"with 1 failed request", ^{
                    beforeEach(^{
                        stubRequest(@"GET", @"http:/example.com/locales/en-US/translation.json")
                        .andReturn(200)
                        .withBody(fixtureData(@"locales/en-US/translation.json"));
                        stubRequest(@"GET", @"http:/example.com/locales/en/translation.json")
                        .andReturn(200)
                        .withBody(fixtureData(@"locales/en/translation.json"));
                        stubRequest(@"GET", @"http:/example.com/locales/dev/translation.json")
                        .andReturn(404);
                        
                        options.resourcesBaseURL = [NSURL URLWithString:@"http://example.com"];
                    });
                    
                    it(@"should provide successfully loaded resources for translation", ^{
                        waitUntil(^(DoneCallback done) {
                            [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                                expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_en-US");
                                expect([i18n t:@"simple_en"]).to.equal(@"ok_from_en");
                                // this one failed, so default behavior is to return the key
                                expect([i18n t:@"simple_dev"]).to.equal(@"simple_dev");
                                done();
                            }];
                        });
                    });
                    
                    it(@"should provide an error", ^{
                        waitUntil(^(DoneCallback done) {
                            [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                                expect(error).toNot.beNil();
                                expect(error.domain).to.equal(@"I18NextErrorDomain");
                                expect(error.code).to.equal(I18NextErrorLoadFailed);
                                expect(error.userInfo[I18NextDetailedErrorsKey]).toNot.beEmpty();
                                done();
                            }];
                        });
                    });
                });
                
            });
            
            describe(@"with dynamic route", ^{
                
                beforeEach(^{
                    options.resourcesBaseURL = [NSURL URLWithString:@"http://example.com"];
                    options.resourcesGetPathTemplate = @"locales/resources.json?lng=__lng__&ns=__ns__";
                    options.dynamicLoad = YES;
                });
                
                describe(@"with the request succeeding", ^{
                    
                    beforeEach(^{
                        waitUntil(^(DoneCallback done) {
                            stubRequest(@"GET", @"http:/example.com/locales/resources.json?lng=en-US+en+dev&ns=translation")
                            .andReturn(200)
                            .withBody([NSJSONSerialization dataWithJSONObject:testStore options:NSJSONWritingPrettyPrinted error:nil]);

                            [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                                expect(error).to.beNil();
                                done();
                            }];
                        });
                    });
                    
                    it(@"should provide loaded resources for translation", ^{
                        expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_en-US");
                        expect([i18n t:@"simple_en"]).to.equal(@"ok_from_en");
                        expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_dev");
                    });
                    
                });
                
                describe(@"with the request failing", ^{
                    beforeEach(^{
                        stubRequest(@"GET", @"http:/example.com/locales/resources.json?lng=en-US+en+dev&ns=translation")
                        .andReturn(404);
                    });
                    
                    it(@"should provide no translations", ^{
                        waitUntil(^(DoneCallback done) {
                            [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                                expect([i18n t:@"simple_en-US"]).to.equal(@"simple_en-US");
                                expect([i18n t:@"simple_en"]).to.equal(@"simple_en");
                                expect([i18n t:@"simple_dev"]).to.equal(@"simple_dev");
                                done();
                            }];
                        });
                    });
                    
                    it(@"should provide an error", ^{
                        waitUntil(^(DoneCallback done) {
                            [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                                expect(error).toNot.beNil();
                                expect(error.domain).to.equal(@"I18NextErrorDomain");
                                expect(error.code).to.equal(I18NextErrorLoadFailed);
                                expect(error.userInfo[I18NextDetailedErrorsKey]).toNot.beEmpty();
                                done();
                            }];
                        });
                    });
                });
                
            });
        });
        
    });
    
});

SpecEnd
