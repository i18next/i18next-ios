//
//  I18NextNamespaceSpec.m
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

SpecBegin(I18NextNamespace)

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
    
    describe(@"initialisation", ^{
        
        describe(@"with namespace", ^{
            
            describe(@"with one namespace set", ^{
                
                beforeEach(^{
                    i18n.resourcesStore =
                    @{
                      @"dev": @{ @"ns.special": @{ @"simple_dev": @"ok_from_special_dev" } },
                      @"en": @{ @"ns.special": @{ @"simple_en": @"ok_from_special_en" } },
                      @"en-US": @{ @"ns.special": @{ @"simple_en-US": @"ok_from_special_en-US" } },
                      };
                    i18n.namespace = @"ns.special";
                });
                
                it(@"should provide passed resources for translation", ^{
                    expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_special_en-US");
                    expect([i18n t:@"simple_en"]).to.equal(@"ok_from_special_en");
                    expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_special_dev");
                });
                
            });
            
            describe(@"with more than one namespace set", ^{
                
                beforeEach(^{
                    i18n.resourcesStore =
                    @{
                      @"dev": @{
                              @"ns.common": @{ @"simple_dev": @"ok_from_common_dev" },
                              @"ns.special": @{ @"simple_dev": @"ok_from_special_dev" }
                              },
                      @"en": @{
                              @"ns.common": @{ @"simple_en": @"ok_from_common_en" },
                              @"ns.special": @{ @"simple_en": @"ok_from_special_en" }
                              },
                      @"en-US": @{
                              @"ns.common": @{ @"simple_en-US": @"ok_from_common_en-US" },
                              @"ns.special": @{ @"simple_en-US": @"ok_from_special_en-US" }
                              },
                      };
                    i18n.namespaces = @[@"ns.common", @"ns.special"];
                    i18n.defaultNamespace = @"ns.special";
                });
                
                it(@"should provide passed resources for translation", ^{
                    // default ns
                    expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_special_en-US");
                    expect([i18n t:@"simple_en"]).to.equal(@"ok_from_special_en");
                    expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_special_dev");
                    
                    // default ns
                    expect([i18n t:@"ns.common:simple_en-US"]).to.equal(@"ok_from_common_en-US");
                    expect([i18n t:@"ns.common:simple_en"]).to.equal(@"ok_from_common_en");
                    expect([i18n t:@"ns.common:simple_dev"]).to.equal(@"ok_from_common_dev");
                    
                    // ns in options
                    expect([i18n t:@"simple_en-US" namespace:@"ns.common"]).to.equal(@"ok_from_common_en-US");
                    expect([i18n t:@"simple_en" namespace:@"ns.common"]).to.equal(@"ok_from_common_en");
                    expect([i18n t:@"simple_dev" namespace:@"ns.common"]).to.equal(@"ok_from_common_dev");
                });
                
                describe(@"and fallbacking to default namespace", ^{
                    
                    beforeEach(^{
                        i18n.resourcesStore =
                        @{
                          @"dev": @{ @"ns.special": @{ @"simple_dev": @"ok_from_dev" } },
                          @"en": @{ @"ns.special": @{ @"simple_en": @"ok_from_en" } },
                          @"en-US": @{ @"ns.special": @{ @"simple_en-US": @"ok_from_en-US" } },
                          };
                        i18n.namespaces = @[@"ns.common", @"ns.special"];
                        i18n.defaultNamespace = @"ns.special";
                        i18n.fallbackToDefaultNamespace = YES;
                    });
                    
                    it(@"should fallback to default ns", ^{
                        expect([i18n t:@"ns.common:simple_en-US"]).to.equal(@"ok_from_en-US");
                        expect([i18n t:@"ns.common:simple_en"]).to.equal(@"ok_from_en");
                        expect([i18n t:@"ns.common:simple_dev"]).to.equal(@"ok_from_dev");
                    });
                    
                });
                
                describe(@"and fallbacking to set namespace", ^{
                    
                    beforeEach(^{
                        i18n.resourcesStore =
                        @{
                          @"dev": @{
                                  @"ns.special": @{ @"simple_dev": @"ok_from_dev" },
                                  @"ns.fallback": @{ @"simple_fallback": @"ok_from_fallback" }
                                  },
                          @"en": @{ @"ns.special": @{ @"simple_en": @"ok_from_en" } },
                          @"en-US": @{ @"ns.special": @{ @"simple_en-US": @"ok_from_en-US" } },
                          };
                        i18n.namespaces = @[@"ns.common", @"ns.special", @"ns.fallback"];
                        i18n.defaultNamespace = @"ns.special";
                        i18n.fallbackNamespace = @"ns.fallback";
                    });
                    
                    it(@"should fallback to set fallback namespace", ^{
                        expect([i18n t:@"ns.common:simple_fallback"]).to.equal(@"ok_from_fallback");
                    });
                    
                });
                
                describe(@"and fallbacking to multiple set namespace", ^{
                    
                    beforeEach(^{
                        i18n.resourcesStore =
                        @{
                          @"dev": @{
                                  @"ns.common": @{},
                                  @"ns.special": @{ @"simple_dev": @"ok_from_dev" },
                                  @"ns.fallback1": @{
                                          @"simple_fallback": @"ok_from_fallback1",
                                          @"simple_fallback1": @"ok_from_fallback1",
                                          }
                                  },
                          @"en": @{
                                  @"ns.special": @{ @"simple_en": @"ok_from_en" },
                                  @"ns.fallback2": @{
                                          @"simple_fallback": @"ok_from_fallback2",
                                          @"simple_fallback2": @"ok_from_fallback2",
                                          }
                                  },
                          @"en-US": @{ @"ns.special": @{ @"simple_en-US": @"ok_from_en-US" } },
                          };
                        i18n.namespaces = @[@"ns.common", @"ns.special", @"ns.fallback"];
                        i18n.defaultNamespace = @"ns.special";
                        i18n.fallbackNamespaces = @[@"ns.fallback1", @"ns.fallback2"];
                    });
                    
                    it(@"should fallback to set fallback namespace", ^{
                        expect([i18n t:@"ns.common:simple_fallback"]).to.equal(@"ok_from_fallback1");
                        expect([i18n t:@"ns.common:simple_fallback1"]).to.equal(@"ok_from_fallback1");
                        expect([i18n t:@"ns.common:simple_fallback2"]).to.equal(@"ok_from_fallback2");
                    });
                    
                });
                
            });
            
        });
        
    });
    
});

SpecEnd
