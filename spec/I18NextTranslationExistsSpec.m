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

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextTranslationExists)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"translation", ^{
        
        describe(@"check for existence of keys", ^{
            
            beforeEach(^{
                options.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{ @"iExist": @"" } },
                  @"en": @{ @"translation": @{ } },
                  @"en-US": @{ @"translation": @{ } },
                  };
                [i18n loadWithOptions:options.asDictionary completion:nil];
            });
            
            it(@"should exist", ^{
                expect([i18n exists:@"iExist"]).to.beTruthy();
            });
            
            it(@"should not exist", ^{
                expect([i18n exists:@"iDontExist"]).to.beFalsy();
            });
            
            describe(@"missing on unspecific", ^{
                
                beforeEach(^{
                    options.resourcesStore =
                    @{
                      @"dev": @{ @"translation": @{ @"iExist": @"text" } },
                      @"en": @{ @"translation": @{ } },
                      @"en-US": @{ @"translation": @{ @"empty": @"" } },
                      };
                    options.lang = @"en";
                    [i18n loadWithOptions:options.asDictionary completion:nil];
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
