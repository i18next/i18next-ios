//
//  I18NextTranslationContextSpec.m
//  i18next
//
//  Created by Jean Regisser on 29/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextTranslationContext)

describe(@"I18Next", ^{
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
    
    describe(@"translation", ^{
        
        describe(@"context usage", ^{
            
            describe(@"basic usage", ^{
                
                beforeEach(^{
                    i18n.resourcesStore =
                    @{
                      @"dev": @{ @"ns.2": @{
                                         @"friend_context": @"A friend from ns2",
                                         @"friend_context_male": @"A boyfriend from ns2",
                                         @"friend_context_female": @"A girlfriend from ns2",
                                         }
                                 },
                      @"en": @{ @"ns.1": @{
                                        @"friend_context": @"A friend",
                                        @"friend_context_male": @"A boyfriend",
                                        @"friend_context_female": @"A girlfriend",
                                        }
                                },
                      @"en-US": @{ @"translation": @{ } },
                      };
                    i18n.namespaces = @[ @"ns.1", @"ns.2" ];
                    i18n.defaultNamespace = @"ns.1";
                });
                
                it(@"should provide correct context form", ^{
                    expect([i18n t:@"friend_context"]).to.equal(@"A friend");
                    expect([i18n t:@"friend_context" context:@""]).to.equal(@"A friend");
                    expect([i18n t:@"friend_context" context:@"male"]).to.equal(@"A boyfriend");
                    expect([i18n t:@"friend_context" context:@"female"]).to.equal(@"A girlfriend");
                });
                
            });
            
        });
        
    });
    
});

SpecEnd