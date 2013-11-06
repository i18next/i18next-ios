//
//  I18NextTranslationNullValueSpec.m
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

SpecBegin(I18NextTranslationNullValue)

describe(@"I18Next translation", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"resource string is null", ^{
        
        beforeEach(^{
            options.resourcesStore =
            @{
              @"dev": @{ @"translation": @{ @"key1": [NSNull null], @"key2": @{ @"key3": [NSNull null] } } },
              @"en": @{ @"translation": @{ } },
              @"en-US": @{ @"translation": @{ } },
              };
            options.returnObjectTrees = YES;
            options.fallbackOnNull = NO;
            [i18n loadWithOptions:options.asDictionary completion:nil];
        });
        
        it(@"should translate value", ^{
            //expect([i18n t:@"key1"]).to.equal([NSNull null]);
            expect([i18n t:@"key2"]).to.equal(@{ @"key3": [NSNull null] });
        });
        
        describe(@"with option fallbackOnNull enabled", ^{
           
            beforeEach(^{
                options.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{ @"key1": @"fallbackKey1", @"key2": @{ @"key3": @"fallbackKey3" } } },
                  @"en": @{ @"translation": @{ } },
                  @"en-US": @{ @"translation": @{ @"key1": [NSNull null], @"key2": @{ @"key3": [NSNull null] } } },
                  };
                options.fallbackOnNull = YES;
                [i18n loadWithOptions:options.asDictionary completion:nil];
            });
            
            it(@"should translate value", ^{
                expect([i18n t:@"key1"]).to.equal(@"fallbackKey1");
                expect([i18n t:@"key2.key3"]).to.equal(@"fallbackKey3");
            });
            
        });
        
    });
    
});

SpecEnd
