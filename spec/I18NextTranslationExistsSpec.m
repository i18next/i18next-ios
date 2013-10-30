//
//  I18NextTranslationExistsSpec.m
//  i18next
//
//  Created by Jean Regisser on 30/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

#import "I18Next.h"

SpecBegin(I18NextTranslationExists)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    
    beforeEach(^{
        i18n = [I18Next new];
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });
    
    describe(@"translation", ^{
        
        describe(@"check for existence of keys", ^{
            
            beforeEach(^{
                i18n.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{ @"iExist": @"" } },
                  @"en": @{ @"translation": @{ } },
                  @"en-US": @{ @"translation": @{ } },
                  };
            });
            
            it(@"should exist", ^{
                expect([i18n exists:@"iExist"]).to.beTruthy();
            });
            
            it(@"should not exist", ^{
                expect([i18n exists:@"iDontExist"]).to.beFalsy();
            });
            
            describe(@"missing on unspecific", ^{
                
                beforeEach(^{
                    i18n.resourcesStore =
                    @{
                      @"dev": @{ @"translation": @{ @"iExist": @"text" } },
                      @"en": @{ @"translation": @{ } },
                      @"en-US": @{ @"translation": @{ @"empty": @"" } },
                      };
                    i18n.lang = @"en";
                });
                
                it(@"should exist", ^{
                    expect([i18n exists:@"iExist"]).to.beTruthy();
                });
                
                it(@"should not exist", ^{
                    expect([i18n exists:@"iDontExist"]).to.beFalsy();
                });
                
            });
            
        });
        
    });
    
});

SpecEnd
