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
    __block I18NextOptions* options = nil;
    
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });
    
    describe(@"translation", ^{
        
        describe(@"context usage", ^{
            
            describe(@"basic usage", ^{
                
                beforeEach(^{
                    options.resourcesStore =
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
                    options.namespaces = @[ @"ns.1", @"ns.2" ];
                    options.defaultNamespace = @"ns.1";
                    [i18n loadWithOptions:options.asDictionary completion:nil];
                });
                
                it(@"should provide correct context form", ^{
                    expect([i18n t:@"friend_context"]).to.equal(@"A friend");
                    expect([i18n t:@"friend_context" context:@""]).to.equal(@"A friend");
                    expect([i18n t:@"friend_context" context:@"male"]).to.equal(@"A boyfriend");
                    expect([i18n t:@"friend_context" context:@"female"]).to.equal(@"A girlfriend");
                });
                
            });
            
            describe(@"extended usage - in combination with plurals", ^{
                
                beforeEach(^{
                    options.resourcesStore =
                    @{
                      @"dev": @{ },
                      @"en": @{ @"translation": @{
                                        @"friend_context": @"__count__ friend",
                                        @"friend_context_male": @"__count__ boyfriend",
                                        @"friend_context_female": @"__count__ girlfriend",
                                        @"friend_context_plural": @"__count__ friends",
                                        @"friend_context_male_plural": @"__count__ boyfriends",
                                        @"friend_context_female_plural": @"__count__ girlfriends",
                                        }
                                },
                      @"en-US": @{ @"translation": @{ } },
                      };
                    [i18n loadWithOptions:options.asDictionary completion:nil];
                });
                
                it(@"should provide correct context form", ^{
                    expect([i18n t:@"friend_context" count:1]).to.equal(@"1 friend");
                    expect([i18n t:@"friend_context" context:@"" count:1]).to.equal(@"1 friend");
                    expect([i18n t:@"friend_context" context:@"male" count:1]).to.equal(@"1 boyfriend");
                    expect([i18n t:@"friend_context" context:@"female" count:1]).to.equal(@"1 girlfriend");
                    
                    expect([i18n t:@"friend_context" count:10]).to.equal(@"10 friends");
                    expect([i18n t:@"friend_context" context:@"" count:10]).to.equal(@"10 friends");
                    expect([i18n t:@"friend_context" context:@"male" count:10]).to.equal(@"10 boyfriends");
                    expect([i18n t:@"friend_context" context:@"female" count:10]).to.equal(@"10 girlfriends");
                });
                
            });
            
        });
        
    });
    
});

SpecEnd