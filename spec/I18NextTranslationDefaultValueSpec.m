//
//  I18NextTranslationDefaultValueSpec.m
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

SpecBegin(I18NextTranslationDefaultValue)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"translation", ^{
            
            describe(@"default value", ^{
                
                beforeEach(^{
                    options.resourcesStore =
                    @{
                      @"dev": @{ @"translation": @{ } },
                      @"en": @{ @"translation": @{ } },
                      @"en-US": @{ @"translation": @{ @"test": @"hi" } },
                      };
                    [i18n loadWithOptions:options.asDictionary completion:nil];
                });
                
                it(@"should return the default value when key is not found", ^{
                    expect([i18n t:@"notFound" defaultValue:@"second param defaultValue"]).to.equal(@"second param defaultValue");
                });
                
                xit(@"should recognize the defaultValue syntax set as shortcutFunction", ^{
                    // Not sure We'll support this though
                    //expect([i18n t:@"notFound", @"second param defaultValue"]).to.equal(@"second param defaultValue");
                });
                
            });
        
    });
    
});

SpecEnd
