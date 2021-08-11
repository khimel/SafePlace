//
//  ContactRow.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 30/06/2021.
//

import SwiftUI

struct ContactRow: View {
    let contact: Contact
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(contact.name)
                .font(.system(size:21, weight: .medium, design: .default))
            Text(contact.email)
        }
    }
}
//
//struct ContactRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactRow()
//    }
//}
