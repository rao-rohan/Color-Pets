//
//  AddColorPet.swift
//  Color Pets
//
//  Created by Rohan Rao on 4/21/21.
//

import SwiftUI

struct AddColorPet: View {
    @State private var name: String = ""
    @State private var favorite = false
    var body: some View {
            VStack(spacing: 20.0){
                HStack(){
                    Text("Pick you Pet's Color")
                        .padding(.leading)
                    Spacer()
                    Text("Color Picker")
                        .padding(.trailing)
                        
                }
                TextField("Enter Your Pet's Name", text: $name)
                    .padding(.horizontal)
                Toggle("Your favorite pet?", isOn: $favorite )
                    .padding(.horizontal)
                NavigationLink(destination: ContentView()) {
                    Text("Create Pet")
                    .frame(minWidth: 0, maxWidth: 75)
                    .padding()
                    .foregroundColor(.blue)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(20)
                    .font(.subheadline)
                }
                Spacer()

            }
            .padding(.top)
            .navigationBarTitle("Add a Pet", displayMode: .inline)
    }
}

struct AddColorPet_Previews: PreviewProvider {
    static var previews: some View {
        AddColorPet()
    }
}
