//
//  I18NextTranslationInterpolationSpec.m
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

SpecBegin(I18NextTranslationInterpolation)

describe(@"I18Next translation interpolation", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });

    describe(@"default i18next way", ^{
        
        beforeEach(^{
            options.resourcesStore =
            @{
              @"dev": @{ @"translation": @{ } },
              @"en": @{ @"translation": @{ } },
              @"en-US": @{ @"translation": @{
                                   @"interpolationTest1": @"added __toAdd__",
                                   @"interpolationTest2": @"added __toAdd__ __toAdd__ twice",
                                   @"interpolationTest3": @"added __child.one__ __child.two__",
                                   @"interpolationTest4": @"added __child.grandChild.three__",
                                   } },
              };
            [i18n loadWithOptions:options.asDictionary completion:nil];
        });
        
        it(@"should replace passed in key/values", ^{
            expect([i18n t:@"interpolationTest1" variables:@{ @"toAdd": @"something" }]).to.equal(@"added something");
            expect([i18n t:@"interpolationTest2" variables:@{ @"toAdd": @"something" }]).to.equal(@"added something something twice");
            NSString* value = [i18n t:@"interpolationTest3" variables:@{ @"child": @{ @"one": @"1", @"two": @"2" } }];
            expect(value).to.equal(@"added 1 2");
            NSString* value2 = [i18n t:@"interpolationTest4" variables:@{ @"child": @{ @"grandChild": @{ @"three": @"3" } } }];
            expect(value2).to.equal(@"added 3");
        });
        
        it(@"should not escape HTML", ^{
            expect([i18n t:@"interpolationTest1" variables:@{ @"toAdd": @"<html>" }]).to.equal(@"added <html>");
        });
        
        it(@"should replace passed in key/values on defaultValue", ^{
            expect([i18n t:@"interpolationTest5" variables:@{ @"toAdd": @"something" } defaultValue:@"added __toAdd__"])
            .to.equal(@"added something");
        });
        
        describe(@"when the variable doesn't exist", ^{
            it(@"should fail without raising an exception", ^{
                NSString* value = [i18n t:@"interpolationTest4" variables:@{ @"parent": @{ @"grandChild": @{ @"three": @"3" } } }];
                expect(value).to.equal(@"added __child.grandChild.three__");
            });
        });
        
        describe(@"when the variable is not of a compatible type", ^{
            it(@"should fail without raising an exception", ^{
                NSString* value = [i18n t:@"interpolationTest4" variables:@{ @"child": [NSDate date] }];
                expect(value).to.equal(@"added __child.grandChild.three__");
            });
        });
       
        describe(@"with different prefix/suffix via options", ^{
            
            beforeEach(^{
                options.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{ } },
                  @"en": @{ @"translation": @{ } },
                  @"en-US": @{ @"translation": @{
                                       @"interpolationTest1": @"added *toAdd*",
                                       @"interpolationTest2": @"added *toAdd* *toAdd* twice",
                                       @"interpolationTest3": @"added *child.one* *child.two*",
                                       @"interpolationTest4": @"added *child.grandChild.three*",
                                       } },
                  };
                options.interpolationPrefix = @"*";
                options.interpolationSuffix = @"*";
                [i18n loadWithOptions:options.asDictionary completion:nil];
            });
            
            it(@"should replace passed in key/values", ^{
                expect([i18n t:@"interpolationTest1" variables:@{ @"toAdd": @"something" }]).to.equal(@"added something");
                expect([i18n t:@"interpolationTest2" variables:@{ @"toAdd": @"something" }]).to.equal(@"added something something twice");
                NSString* value = [i18n t:@"interpolationTest3" variables:@{ @"child": @{ @"one": @"1", @"two": @"2" } }];
                expect(value).to.equal(@"added 1 2");
                NSString* value2 = [i18n t:@"interpolationTest4" variables:@{ @"child": @{ @"grandChild": @{ @"three": @"3" } } }];
                expect(value2).to.equal(@"added 3");
            });
            
            it(@"should not escape HTML", ^{
                expect([i18n t:@"interpolationTest1" variables:@{ @"toAdd": @"<html>" }]).to.equal(@"added <html>");
            });
            
            it(@"should replace passed in key/values on defaultValue", ^{
                expect([i18n t:@"interpolationTest5" variables:@{ @"toAdd": @"something" } defaultValue:@"added *toAdd*"])
                .to.equal(@"added something");
            });
            
        });
    });
    
});

SpecEnd
