//
//  I18NextNestingSpec.m
//  i18next
//
//  Created by Jean Regisser on 15/01/14.
//  Copyright (c) 2014 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextTranslationNesting)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"translation", ^{
        
        describe(@"resource nesting", ^{
            
            beforeEach(^{
                options.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{ @"nesting1": @"1 $t(nesting2)" } },
                  @"en": @{ @"translation": @{ @"nesting2": @"2 $t(nesting3)" } },
                  @"en-US": @{ @"translation": @{ @"nesting3": @"3" } },
                  };
                [i18n loadWithOptions:options.asDictionary completion:nil];
            });
            
            it(@"should translate nested value", ^{
                expect([i18n t:@"nesting1"]).to.equal(@"1 2 3");
            });
            
            it(@"should apply nested value on defaultValue", ^{
                expect([i18n t:@"nesting_default" defaultValue:@"0 $t(nesting1)"]).to.equal(@"0 1 2 3");
            });
            
            describe(@"with setting new options", ^{
                
                beforeEach(^{
                    options.resourcesStore =
                    @{
                      @"dev": @{
                              @"translation": @{
                                         @"nesting1_plural": @"$t(nesting2, {\"count\": __girls__}) and __count__ boys"
                                         }
                              },
                      @"en": @{ @"translation": @{ @"nesting2_plural": @"__count__ girls" } },
                      };
                    options.lang = @"en";
                    [i18n loadWithOptions:options.asDictionary completion:nil];
                });
                
                it(@"should translate nested value and set new options", ^{
                    expect([i18n t:@"nesting1" count:2 variables:@{ @"girls": @(3) }]).to.equal(@"3 girls and 2 boys");
                });
                
            });
            
        });
        
    });
    
});

SpecEnd
