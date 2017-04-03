// refer : https://gist.github.com/oleganza/997155
// refer : https://gist.github.com/cherpake/4709652

import Foundation

class DataEncodingHelper {
//  bits
//  7   	U+007F      0xxxxxxx
//  11   	U+07FF      110xxxxx	10xxxxxx
//  16  	U+FFFF      1110xxxx	10xxxxxx	10xxxxxx
//  21  	U+1FFFFF    11110xxx	10xxxxxx	10xxxxxx	10xxxxxx
//  26  	U+3FFFFFF   111110xx	10xxxxxx	10xxxxxx	10xxxxxx	10xxxxxx
//  31  	U+7FFFFFFF  1111110x	10xxxxxx	10xxxxxx	10xxxxxx	10xxxxxx	10xxxxxx

    static let b00000000:UInt8 = 0x00
    static let b10000000:UInt8 = 0x80
    static let b11000000:UInt8 = 0xc0
    static let b11100000:UInt8 = 0xe0
    static let b11110000:UInt8 = 0xf0
    static let b11111000:UInt8 = 0xf8
    static let b11111100:UInt8 = 0xfc
    static let b11111110:UInt8 = 0xfe

    static func healing(_ data: Data) -> Data {
        let length = data.count

        if (length == 0) {
            return data
        }

        let replacementCharacter = "�"
        let replacementCharacterData = replacementCharacter.data(using: .utf8)!

        let resultData = NSMutableData(length: 0)!

        return data.withUnsafeBytes{(bytes:UnsafePointer<UInt8>)->Data in
            let bufferMaxSize = 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferMaxSize) // not initialized, but will be filled in completely before copying to resultData
            var bufferIndex = 0
            var byteIndex = 0
            var invalidByte = false
            while (byteIndex < length) {
                let byte = bytes[byteIndex];

                // ASCII character is always a UTF-8 character
                if ((byte & b10000000) == b00000000) { // 0xxxxxxx
                    if ((bufferIndex + 5) >= bufferMaxSize) {
                        resultData.append(buffer, length: bufferIndex)
                        bufferIndex = 0;
                    }
                    buffer[bufferIndex] = byte;
                    bufferIndex += 1
                } else if ((byte & b11100000) == b11000000) { // 110xxxxx 10xxxxxx
                    if (byteIndex + 1 >= length) {
                        if (bufferIndex > 0) {
                            resultData.append(buffer, length: bufferIndex)
                            bufferIndex = 0
                        }
                        return resultData as Data
                    }
                    byteIndex += 1
                    let byte2 = bytes[byteIndex];
                    if ((byte2 & b11000000) == b10000000) {
                        // This 2-byte character still can be invalid. Check if we can create a string with it.
                        let tuple = [byte, byte2]
                        let cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 2, CFStringBuiltInEncodings.UTF8.rawValue, false);
                        if (cfstr != nil) {
//                            CFRelease(cfstr);
                            if ((bufferIndex + 5) >= bufferMaxSize) {
                                resultData.append(buffer, length: bufferIndex)
                                bufferIndex = 0;
                            }
                            buffer[bufferIndex] = byte;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte2;
                            bufferIndex += 1
                        } else {
                            invalidByte = true;
                        }
                    } else {
                        byteIndex -= 1;
                        invalidByte = true;
                    }
                } else if ((byte & b11110000) == b11100000) { // 1110xxxx 10xxxxxx 10xxxxxx
                    if (byteIndex + 2 >= length) {
                        if (bufferIndex > 0) {
                            resultData.append(buffer, length: bufferIndex)
                            bufferIndex = 0
                        }
                        return resultData as Data
                    }
                    byteIndex += 1
                    let byte2 = bytes[byteIndex];
                    byteIndex += 1
                    let byte3 = bytes[byteIndex];
                    if ((byte2 & b11000000) == b10000000 &&
                            (byte3 & b11000000) == b10000000) {
                        // This 3-byte character still can be invalid. Check if we can create a string with it.
                        let tuple = [byte, byte2, byte3];
                        let cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 3, CFStringBuiltInEncodings.UTF8.rawValue, false);
                        if (cfstr != nil) {
//                            CFRelease(cfstr);
                            if ((bufferIndex + 5) >= bufferMaxSize) {
                                resultData.append(buffer, length: bufferIndex)
                                bufferIndex = 0;
                            }
                            buffer[bufferIndex] = byte;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte2;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte3;
                            bufferIndex += 1
                        } else {
                            invalidByte = true;
                        }
                    } else {
                        byteIndex -= 2;
                        invalidByte = true;
                    }
                } else if ((byte & b11111000) == b11110000) { // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
                    if (byteIndex + 3 >= length) {
                        if (bufferIndex > 0) {
                            resultData.append(buffer, length: bufferIndex)
                            bufferIndex = 0
                        }
                        return resultData as Data
                    }
                    byteIndex += 1
                    let byte2 = bytes[byteIndex];
                    byteIndex += 1
                    let byte3 = bytes[byteIndex];
                    byteIndex += 1
                    let byte4 = bytes[byteIndex];
                    if ((byte2 & b11000000) == b10000000 &&
                            (byte3 & b11000000) == b10000000 &&
                            (byte4 & b11000000) == b10000000) {
                        // This 4-byte character still can be invalid. Check if we can create a string with it.
                        let tuple = [byte, byte2, byte3, byte4];
                        let cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 4, CFStringBuiltInEncodings.UTF8.rawValue, false);
                        if (cfstr != nil) {
//                            CFRelease(cfstr);
                            if ((bufferIndex + 5) >= bufferMaxSize) {
                                resultData.append(buffer, length: bufferIndex)
                                bufferIndex = 0;
                            }
                            buffer[bufferIndex] = byte;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte2;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte3;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte4;
                            bufferIndex += 1
                        } else {
                            invalidByte = true;
                        }
                    } else {
                        byteIndex -= 3;
                        invalidByte = true;
                    }
                } else if ((byte & b11111100) == b11111000) { // 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
                    if (byteIndex + 4 >= length) {
                        if (bufferIndex > 0) {
                            resultData.append(buffer, length: bufferIndex)
                            bufferIndex = 0
                        }
                        return resultData as Data
                    }
                    byteIndex += 1
                    let byte2 = bytes[byteIndex];
                    byteIndex += 1
                    let byte3 = bytes[byteIndex];
                    byteIndex += 1
                    let byte4 = bytes[byteIndex];
                    byteIndex += 1
                    let byte5 = bytes[byteIndex];
                    if ((byte2 & b11000000) == b10000000 &&
                            (byte3 & b11000000) == b10000000 &&
                            (byte4 & b11000000) == b10000000 &&
                            (byte5 & b11000000) == b10000000) {
                        // This 5-byte character still can be invalid. Check if we can create a string with it.
                        let tuple = [byte, byte2, byte3, byte4, byte5];
                        let cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 5, CFStringBuiltInEncodings.UTF8.rawValue, false);
                        if (cfstr != nil) {
//                            CFRelease(cfstr);
                            if ((bufferIndex + 5) >= bufferMaxSize) {
                                resultData.append(buffer, length: bufferIndex)
                                bufferIndex = 0;
                            }
                            buffer[bufferIndex] = byte;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte2;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte3;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte4;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte5;
                            bufferIndex += 1
                        } else {
                            invalidByte = true;
                        }
                    } else {
                        byteIndex -= 4;
                        invalidByte = true;
                    }
                } else if ((byte & b11111110) == b11111100) { // 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
                    if (byteIndex + 5 >= length) {
                        if (bufferIndex > 0) {
                            resultData.append(buffer, length: bufferIndex)
                            bufferIndex = 0
                        }
                        return resultData as Data
                    }
                    byteIndex += 1
                    let byte2 = bytes[byteIndex];
                    byteIndex += 1
                    let byte3 = bytes[byteIndex];
                    byteIndex += 1
                    let byte4 = bytes[byteIndex];
                    byteIndex += 1
                    let byte5 = bytes[byteIndex];
                    byteIndex += 1
                    let byte6 = bytes[byteIndex];
                    if ((byte2 & b11000000) == b10000000 &&
                            (byte3 & b11000000) == b10000000 &&
                            (byte4 & b11000000) == b10000000 &&
                            (byte5 & b11000000) == b10000000 &&
                            (byte6 & b11000000) == b10000000) {
                        // This 6-byte character still can be invalid. Check if we can create a string with it.
                        let tuple = [byte, byte2, byte3, byte4, byte5, byte6];
                        let cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 6, CFStringBuiltInEncodings.UTF8.rawValue, false);
                        if (cfstr != nil) {
//                            CFRelease(cfstr);
                            if ((bufferIndex + 5) >= bufferMaxSize) {
                                resultData.append(buffer, length: bufferIndex)
                                bufferIndex = 0;
                            }
                            buffer[bufferIndex] = byte;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte2;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte3;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte4;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte5;
                            bufferIndex += 1
                            buffer[bufferIndex] = byte6;
                            bufferIndex += 1
                        } else {
                            invalidByte = true;
                        }

                    } else {
                        byteIndex -= 5;
                        invalidByte = true;
                    }
                } else {
                    invalidByte = true;
                }

                if (invalidByte) {
                    invalidByte = false;
                    if (bufferIndex > 0) {
                        resultData.append(buffer, length: bufferIndex)
                        bufferIndex = 0
                    }
                    resultData.append(replacementCharacterData)
                }

                byteIndex += 1
            }
            if (bufferIndex > 0) {
                resultData.append(buffer, length: bufferIndex)
                bufferIndex = 0
            }
            return resultData as Data
        }
    }
}