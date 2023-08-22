//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online ePayments on 17/05/2023
// Copyright © 2023 Global Collect Services. All rights reserved.
// 

import Foundation

public class Macros: NSObject {
    public static func DLog(message: String, functionName: String = #function, fileName: String = #file) {
        #if DEBUG
        print(
            """
            DLog: Original_Message = \(message)\n File_Name = \(fileName)\n
            Method_Name = \(functionName)\n Line_Number = \(#line)
            """
        )
        #else
        print("DLog: Original_Message = \(message)")
        #endif
    }
}
