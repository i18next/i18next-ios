//
//  I18NextTranslationObjectValueSpec.m
//  i18next
//
//  Created by Jean Regisser on 31/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextTranslationObjectValue)

describe(@"I18Next translation", ^{
    __block I18Next* i18n = nil;
    
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });
    
    describe(@"resource string is null", ^{
        
        beforeEach(^{
            i18n.resourcesStore =
            @{
              @"dev": @{ @"translation": @{ } },
              @"en": @{ @"translation": @{ } },
              @"en-US": @{ @"translation": @{
                                   @"test": @{ @"simple_en-US": @"ok_from_en-US" }
                                } },
              };
        });
        
        it(@"should return nested string as usual", ^{
            expect([i18n t:@"test.simple_en-US"]).to.equal(@"ok_from_en-US");
        });
        
        it(@"should not fail silently on accessing an objectTree", ^{
            expect([i18n t:@"test"]).to.equal(@"key 'translation:test (en-US)' returned an object instead of a string");
        });
        
        describe(@"optional return an objectTree for UI components", ^{
            
            beforeEach(^{
                i18n.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{
                                     @"test_dev": @{ @"res_dev": @"added __replace__" }
                                     }
                             },
                  @"en": @{ @"translation": @{ } },
                  @"en-US": @{ @"translation": @{
                                       @"test_en_US": @{ @"res_en_US": @"added __replace__" }
                                       }
                               },
                  };
                i18n.returnObjectTrees = YES;
            });
            
            it(@"should return objectTree applying options", ^{
                expect([i18n t:@"test_en_US" variables:@{ @"replace": @"two" }]).to.equal(@{ @"res_en_US": @"added two" });
                expect([i18n t:@"test_en_US" variables:@{ @"replace": @"three" }]).to.equal(@{ @"res_en_US": @"added three" });
                expect([i18n t:@"test_en_US" variables:@{ @"replace": @"four" }]).to.equal(@{ @"res_en_US": @"added four" });
                
                // from fallback
                expect([i18n t:@"test_dev" variables:@{ @"replace": @"two" }]).to.equal(@{ @"res_dev": @"added two" });
            });
            
        });
        
    });
    
});

SpecEnd
