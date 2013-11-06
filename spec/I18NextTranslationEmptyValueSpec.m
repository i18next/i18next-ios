//
//  I18NextTranslationEmptyValueSpec.m
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

SpecBegin(I18NextTranslationEmptyValue)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    

    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"translation", ^{
        
        describe(@"key with empty string value as valid option", ^{
            
            beforeEach(^{
                options.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{ @"empty": @"" } },
                  @"en": @{ @"translation": @{ } },
                  @"en-US": @{ @"translation": @{ } },
                  };
                [i18n loadWithOptions:options.asDictionary completion:nil];
            });
            
            it(@"should translate correctly", ^{
                expect([i18n t:@"empty"]).to.equal(@"");
            });
            
            describe(@"missing on unspecific", ^{
                
                beforeEach(^{
                    options.resourcesStore =
                    @{
                      @"dev": @{ @"translation": @{ @"empty": @"text" } },
                      @"en": @{ @"translation": @{ } },
                      @"en-US": @{ @"translation": @{ @"empty": @"" } },
                      };
                    options.lang = @"en";
                    [i18n loadWithOptions:options.asDictionary completion:nil];
                });
                
                it(@"should translate correctly", ^{
                    expect([i18n t:@"empty"]).to.equal(@"text");
                });
                
            });
            
            describe(@"on specific language", ^{
                
                beforeEach(^{
                    options.resourcesStore =
                    @{
                      @"dev": @{ @"translation": @{ @"empty": @"text" } },
                      @"en": @{ @"translation": @{ } },
                      @"en-US": @{ @"translation": @{ @"empty": @"" } },
                      };
                    [i18n loadWithOptions:options.asDictionary completion:nil];
                });
                
                it(@"should translate correctly", ^{
                    expect([i18n t:@"empty"]).to.equal(@"");
                });
                
            });
            
        });
        
    });
    
});

SpecEnd