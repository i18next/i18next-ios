//
//  I18NextSpecHelper.m
//  i18next
//
//  Created by Jean Regisser on 30/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18NextSpecHelper.h"

I18Next* createDefaultI18NextTestInstance() {
    I18Next* i18n = [I18Next new];
    i18n.lang = @"en-US";
    return i18n;
}
