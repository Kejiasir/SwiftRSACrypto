//
// Copyright (C) 2014 Michael Hohl <http://www.michaelhohl.net/>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MIHSecureHashAlgorithm384.h"
#import "MIHInternal.h"
#import "sha.h"

@implementation MIHSecureHashAlgorithm384

- (NSData *)hashValueOfData:(NSData *)data
{
    SHA512_CTX sha384Ctx;
    unsigned char hashValue[SHA384_DIGEST_LENGTH];
    if(!SHA384_Init(&sha384Ctx)) {
        @throw [NSException openSSLException];
    }
    if (!SHA384_Update(&sha384Ctx, data.bytes, data.length)) {
        @throw [NSException openSSLException];
    }
    if (!SHA384_Final(hashValue, &sha384Ctx)) {
        @throw [NSException openSSLException];
    }
    return [NSData dataWithBytes:hashValue length:SHA384_DIGEST_LENGTH];
}

@end
