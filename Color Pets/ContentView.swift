//
//  ContentView.swift
//  Color Pets
//
//  Created by Rohan Rao on 4/21/21.
//

import SwiftUI
import Combine

class ColorPet {
    let id = UUID()
    var name : String?
    var color : Color?
    var date : String?
    init(n: String, c : Color,d : String) {
        name = n
        color = c
        date = d
    }
}
class UserData: ObservableObject {
    @Published var pets : [ColorPet] = []
    @Published var favorite : ColorPet?
    
}


struct ContentView: View {
    @StateObject var userData = UserData()
    @State private var isShowingAddPets = false
    @State private var isShowingPetDetails = false
    let layout = [GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        NavigationView{
            VStack(spacing: 10.0){
                if (self.userData.favorite != nil){
                    Text("Favorite Pet")
                    NavigationLink(destination: ShowPetDetails( pet: userData.favorite!, fav: true), isActive: self.$isShowingPetDetails)
                        { EmptyView() }
                        .frame(width: 0, height: 0)
                        .disabled(true)
                    Button(action:{
                        self.isShowingPetDetails = true
                    })
                    {
                        VStack(spacing : 5){
                            Circle()
                                .size(CGSize(width: 115.0, height: 115))
                                .foregroundColor(self.userData.favorite?.color)
                                .frame(width: 115, height: 115)
                            Text((self.userData.favorite?.name!)!)
                                .multilineTextAlignment(.center)
                            Text("Adopted on " + (self.userData.favorite?.date!)!)
                                .font(.subheadline)
                                .fontWeight(.thin)
                                .foregroundColor(Color.gray)
                            
                        }
                    }
                    
                }
                Text("All Pets")
                    .padding(.horizontal)
                if self.userData.pets.isEmpty{
                    Text("It appears you have no pets. Press the + icon in the top right to add one.")
                        .font(.footnote)
                        .fontWeight(.thin)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Spacer()
                }
                else{
                    ScrollView {
                        LazyVGrid(columns: layout, spacing: 20) {
                            ForEach(self.userData.pets, id: \.id) { pet in
                                PetView(pet: pet)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                NavigationLink(destination: AddColorPet(), isActive: self.$isShowingAddPets)
                    { EmptyView() }
                    .frame(width: 0, height: 0)
                    .disabled(true)
            }
            .padding(.top)
            .navigationBarTitle("Your Pets", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action:{ self.isShowingAddPets = true }) { Image(systemName: "plus").imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/) }
            )
        }.environmentObject(userData)
    }
}
struct PetView: View {
    @EnvironmentObject  var userData : UserData
    @State private var isShowingPetDetails = false
    var pet: ColorPet
    @State private var isActive = false
    var body: some View {
        NavigationLink(destination: ShowPetDetails( pet: pet, fav: isFav(pet1: pet)), isActive: self.$isShowingPetDetails)
        {
            Button(action:{
                self.isShowingPetDetails = true
            })
            {
                VStack(spacing : 5){
                    Circle()
                        .size(CGSize(width: 60.0, height: 60.0))
                        .foregroundColor(pet.color)
                        .frame(width: 60.0, height: 60.0)
                    Text(pet.name!)
                        .multilineTextAlignment(.center)
                    Text("Adopted on " + pet.date!)
                        .font(.subheadline)
                        .fontWeight(.thin)
                        .foregroundColor(Color.gray)
                }
            }
        }
        
        
    }
    func isFav(pet1 : ColorPet) -> Bool{
        if userData.favorite != nil{
            return pet1 === userData.favorite
        }
        return false
    }
}

struct AddColorPet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject  var userData : UserData
    @State private var name: String = ""
    @State private var fav = false
    @State private var color = Color.blue
    var body: some View {
        VStack(spacing: 20.0){
            ColorPicker("Pick you Pet's Color", selection: $color)
                .padding(.horizontal)
            TextField("Enter Your Pet's Name", text: $name)
                .background(Color(UIColor.white))
                .cornerRadius(5)
                .padding(.horizontal)
            Toggle("Your favorite pet?", isOn: $fav )
                .padding(.horizontal)
            
            Button(action: {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                let datetime = formatter.string(from: Date())
                let pet = ColorPet(n:name,c:color,d : datetime)
                if fav {
                    self.userData.favorite = pet
                }
                self.userData.pets.append(pet)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create Pet")
                    .frame(minWidth: 0, maxWidth: 75)
                    .padding()
                    .foregroundColor(.blue)
                    .background(Color(UIColor.black))
                    .cornerRadius(20)
                    .font(.subheadline)
            }
            Spacer()
            
        }
        .padding(.top)
        .navigationBarTitle("Add a Pet", displayMode: .inline)
    }
}

struct ShowPetDetails: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userData : UserData
    @State var pet: ColorPet
    @State var fav : Bool
    @State private var name: String = ""
    @State private var color = Color.blue
    var body: some View {
        VStack(spacing: 20.0){
            Circle()
                .size(CGSize(width: 100.0, height: 100))
                .foregroundColor(self.pet.color)
                .frame(width: 100, height: 100)
            Text((self.pet.name!))
                .multilineTextAlignment(.center)
            Text("Adopted on " + (self.pet.date!))
                .font(.subheadline)
                .fontWeight(.thin)
                .foregroundColor(Color.gray)
            Toggle("Your favorite pet?", isOn: self.$fav )
                .padding(.horizontal)
            Button(action: {
                if fav {
                    self.userData.favorite = pet
                    
                }
                else{
                    self.userData.favorite = nil
                }
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Changes")
                    .frame(minWidth: 0, maxWidth: 75)
                    .padding()
                    .foregroundColor(.blue)
                    .background(Color(UIColor.black))
                    .cornerRadius(20)
                    .font(.subheadline)
            }
            Spacer()
            
        }
        .padding(.top)
        .navigationBarTitle("Add a Pet", displayMode: .inline)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}

