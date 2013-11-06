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

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextNamespace)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"initialisation", ^{
        
        describe(@"with namespace", ^{
            
            describe(@"with one namespace set", ^{
                
                beforeEach(^{
                    options.resourcesStore =
                    @{
                      @"dev": @{ @"ns.special": @{ @"simple_dev": @"ok_from_special_dev" } },
                      @"en": @{ @"ns.special": @{ @"simple_en": @"ok_from_special_en" } },
                      @"en-US": @{ @"ns.special": @{ @"simple_en-US": @"ok_from_special_en-US" } },
                      };
                    options.namespace = @"ns.special";
                    [i18n loadWithOptions:options.asDictionary completion:nil];
                });
                
                it(@"should provide passed resources for translation", ^{
                    expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_special_en-US");
                    expect([i18n t:@"simple_en"]).to.equal(@"ok_from_special_en");
                    expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_special_dev");
                });
                
            });
            
            describe(@"with more than one namespace set", ^{
                
                beforeEach(^{
                    options.resourcesStore =
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
                    options.namespaces = @[@"ns.common", @"ns.special"];
                    options.defaultNamespace = @"ns.special";
                    [i18n loadWithOptions:options.asDictionary completion:nil];
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
                        options.resourcesStore =
                        @{
                          @"dev": @{ @"ns.special": @{ @"simple_dev": @"ok_from_dev" } },
                          @"en": @{ @"ns.special": @{ @"simple_en": @"ok_from_en" } },
                          @"en-US": @{ @"ns.special": @{ @"simple_en-US": @"ok_from_en-US" } },
                          };
                        options.namespaces = @[@"ns.common", @"ns.special"];
                        options.defaultNamespace = @"ns.special";
                        options.fallbackToDefaultNamespace = YES;
                        [i18n loadWithOptions:options.asDictionary completion:nil];
                    });
                    
                    it(@"should fallback to default ns", ^{
                        expect([i18n t:@"ns.common:simple_en-US"]).to.equal(@"ok_from_en-US");
                        expect([i18n t:@"ns.common:simple_en"]).to.equal(@"ok_from_en");
                        expect([i18n t:@"ns.common:simple_dev"]).to.equal(@"ok_from_dev");
                    });
                    
                });
                
                describe(@"and fallbacking to set namespace", ^{
                    
                    beforeEach(^{
                        options.resourcesStore =
                        @{
                          @"dev": @{
                                  @"ns.special": @{ @"simple_dev": @"ok_from_dev" },
                                  @"ns.fallback": @{ @"simple_fallback": @"ok_from_fallback" }
                                  },
                          @"en": @{ @"ns.special": @{ @"simple_en": @"ok_from_en" } },
                          @"en-US": @{ @"ns.special": @{ @"simple_en-US": @"ok_from_en-US" } },
                          };
                        options.namespaces = @[@"ns.common", @"ns.special", @"ns.fallback"];
                        options.defaultNamespace = @"ns.special";
                        options.fallbackNamespace = @"ns.fallback";
                        [i18n loadWithOptions:options.asDictionary completion:nil];
                    });
                    
                    it(@"should fallback to set fallback namespace", ^{
                        expect([i18n t:@"ns.common:simple_fallback"]).to.equal(@"ok_from_fallback");
                    });
                    
                });
                
                describe(@"and fallbacking to multiple set namespace", ^{
                    
                    beforeEach(^{
                        options.resourcesStore =
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
                        options.namespaces = @[@"ns.common", @"ns.special", @"ns.fallback"];
                        options.defaultNamespace = @"ns.special";
                        options.fallbackNamespaces = @[@"ns.fallback1", @"ns.fallback2"];
                        [i18n loadWithOptions:options.asDictionary completion:nil];
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
