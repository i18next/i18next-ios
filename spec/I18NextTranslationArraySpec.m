//
//  I18NextTranslationArraySpec.m
//  i18next
//
//  Created by Jean Regisser on 29/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextTranslationArray)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });

    describe(@"translation", ^{
        
        describe(@"resource key as array", ^{
           
            beforeEach(^{
                options.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{ @"existing1": @"hello _name_", @"existing2":  @"howdy __name__" } },
                  @"en": @{ @"translation": @{ } },
                  @"en-US": @{ @"translation": @{ } },
                  };
                [i18n loadWithOptions:options.asDictionary completion:nil];
            });
            
            describe(@"when none of the keys exist", ^{
                it(@"return the same value as translating the last non-existent key", ^{
                    NSString* value = [i18n t:@[@"nonexistent1", @"nonexistent2"] variables:@{ @"name": @"Joe" }];
                    expect(value).to.equal([i18n t:@"nonexistent2" variables:@{ @"name": @"Joe" }]);
                });
            });
            
            describe(@"when one of the keys exist", ^{
                it(@"return the same value as translating the one existing key", ^{
                    NSString* value = [i18n t:@[@"nonexistent1", @"existing2"] variables:@{ @"name": @"Joe" }];
                    expect(value).to.equal([i18n t:@"existing2" variables:@{ @"name": @"Joe" }]);
                });
                
            });
            
            describe(@"when two or more of the keys exist", ^{
                it(@"return the same value as translating the first existing key", ^{
                    NSString* value = [i18n t:@[@"nonexistent1", @"existing2", @"existing1"] variables:@{ @"name": @"Joe" }];
                    expect(value).to.equal([i18n t:@"existing2" variables:@{ @"name": @"Joe" }]);
                });
                
            });
            
        });
        
        describe(@"resource string as array", ^{
            
            beforeEach(^{
                options.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{ @"testarray": @[ @"title" , @"text" ] } },
                  @"en": @{ @"translation": @{ } },
                  @"en-US": @{ @"translation": @{ } },
                  };
                [i18n loadWithOptions:options.asDictionary completion:nil];
            });
            
            it(@"should translate the array value", ^{
                expect([i18n t:@"testarray"]).to.equal(@"title\ntext");
            });
            
        });
        
    });
    
});

SpecEnd