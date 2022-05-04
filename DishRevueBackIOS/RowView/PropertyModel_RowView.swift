//
//  IngredientModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/04/22.
//

import SwiftUI
import MapKit // necessario per la preview. Da eliminare

struct PropertyModel_RowView: View {

    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: PropertyModel

    var body: some View {
            
        CSZStackVB_Framed {
                    
                    VStack(alignment:.leading) {
            
                        HStack(alignment: .center) {
  
                                Text(itemModel.intestazione)
                                    .font(.system(.title2,design:.rounded))
                                    .fontWeight(.heavy)
                                    .lineLimit(1)
                                    .foregroundColor(Color.white)
                     
                            Spacer()
                            
                            NavigationLink {
                                EditItemModel(itemModel: $itemModel, backgroundColorView: Color.cyan)
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .imageScale(.medium)
                                    .foregroundColor(Color.white)
                            }
             
                        }
                        
                        Spacer()
                            
                            VStack(alignment:.leading,spacing:5) {

                                Text(itemModel.cityName)
                                .fontWeight(.semibold)

                                Text("\(itemModel.streetAdress), \(itemModel.numeroCivico)")
                                    .italic()
                                    .fontWeight(.light)
                                    .lineLimit(1)

                                Text(itemModel.webSite)
                                .fontWeight(.ultraLight)
                                .lineLimit(1)

                                HStack {
                                    
                                    Image(systemName: "phone.fill")
                                    Text(itemModel.phoneNumber)
                                    .fontWeight(.semibold)
                                }
                
                            }
                   
                    } // chiuda VStack madre
                    ._tightPadding()
                    
            } // chiusa Zstack Madre
    }
}

struct PropertyModel_RowView_Previews: PreviewProvider {
    
    @State static var testProperty: PropertyModel = PropertyModel(
        intestazione: "Osteria del Corso",
        cityName: "Sciacca",
        coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        webSite: "https://osteriadelcorso.com",
        phoneNumber: "3337213895",
        streetAdress: "via roma",
        numeroCivico: "21")
    
    static var previews: some View {
        
            
          /*  ZStack {
                
                Color.cyan.ignoresSafeArea()
                
            /*    PropertyModel_RowView(itemModel: PropertyModel(
                    intestazione: "Osteria del Corso",
                    cityName: "Sciacca",
                    coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
                    webSite: "https://osteriadelcorso.com",
                    phoneNumber: "3337213895",
                    streetAdress: "via roma",
                    numeroCivico: "21")) */
            } */
     
        NavigationView {
            EditItemModel(itemModel: $testProperty, backgroundColorView: Color.cyan)
        }.navigationBarTitleDisplayMode(.large)
        
    }
}

struct EditItemModel: View {
    
    @Binding var itemModel: PropertyModel
    let backgroundColorView: Color
    
    var body: some View {
        
        CSZStackVB(title: itemModel.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {
                
                CSDivider()
                    
                ScrollView {
                    
                    VStack(alignment:.leading) {
                        
                        Text("Data ultimo aggiornamento")
                        Text(itemModel.descrizione)
                         
                    }.padding(.bottom)
                    
                    GenericBoxEditor_RowView(itemModel: $itemModel)
                
                }
                
            }
            .padding(.horizontal)
        }
    }
}



struct GenericBoxEditor_RowView<M:MyModelProtocol>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var itemModel: M
  
    @State private var description: String = ""
    @State private var showPlaceHolder: Bool = true
    
    var body: some View {

          //  VStack {
                
                TextEditor(text: $description)
                        .font(.system(.body,design:.rounded))
                        .foregroundColor(Color.cyan)
                        .accentColor(Color.cyan)
                        .cornerRadius(5.0)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(true)
                        .keyboardType(.default)
                        .overlay(alignment:.bottomTrailing) {
                            ZStack {
                            
                                if showPlaceHolder {
                                    
                                    Color.black.opacity(0.3).cornerRadius(5.0)
                                    Text("[+] Inserire una descrizione (Optional)")
                                    .font(.system(.body,design:.rounded))
                                    .foregroundColor(Color.white)
                                    .onTapGesture {
                                        withAnimation(.linear(duration: 0.4)) {
                                            self.showPlaceHolder = false
                                        }
                                    }
                                
                            } else {
             
                                    CSButton_tight(
                                        title: "Salva",
                                        fontWeight: .heavy,
                                        titleColor: .blue,
                                        fillColor: .clear) {

                                         //   newItem()
                                            self.showPlaceHolder = true
                                  
                                        }
                            }
                        }
                    }
               // }
            }
    
    // Method
    
    private func newItem() {
        
        var varianteProperty = itemModel
        varianteProperty.descrizione = description
        
        viewModel.updateItemModel(itemModel:varianteProperty)
       
    }
    
}


/*struct PropertyModel_RowView: View {

    @EnvironmentObject var viewModel: AccounterVM
    @Environment(\.isPresented) var isPresented
    @Binding var itemModel: PropertyModel
    
    @State private var openSideMenu: Bool = false
    @State private var openEditor: Bool = false

    var body: some View {
        
        HStack {
            
            ZStack(alignment:.leading){
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.white.opacity(0.3))
                    .shadow(radius: 3.0)
                    
                    VStack(alignment:.leading) {
            
                        HStack(alignment: .center) {
           
                            VStack {
                                
                                Text(itemModel.intestazione)
                                    .font(.system(.title2,design:.rounded))
                                    .fontWeight(.heavy)
                                    .lineLimit(1)
                                    .foregroundColor(Color.white)
                                
                                Text(itemModel.descrizione) // provvisorio
                                    .font(.caption)
                                
                            } //Provvisorio - da togliere
                           
                            Spacer()
                            
                            CSButton_image(
                                activationBool: openSideMenu,
                                frontImage: "rectangle.portrait.and.arrow.right",
                                imageScale: .medium,
                                backColor: Color.red,
                                frontColor: Color.white,
                                rotationDegree: 180.0) {
                                    withAnimation(.easeInOut) { self.openSideMenu.toggle() }
                                    
                                }
                        }
                        
                        Spacer()

                        if !openEditor {
                            
                            VStack(alignment:.leading,spacing:5) {

                                Text(itemModel.cityName)
                                .fontWeight(.semibold)

                                Text("\(itemModel.streetAdress), \(itemModel.numeroCivico)")
                                    .italic()
                                    .fontWeight(.light)
                                    .lineLimit(1)

                                Text(itemModel.webSite)
                                .fontWeight(.ultraLight)
                                .lineLimit(1)

                                HStack {
                                    
                                    Image(systemName: "phone.fill")
                                    Text(itemModel.phoneNumber)
                                    .fontWeight(.semibold)
                                }
                
                            }
                            
                        } else {
                           GenericBoxEditor_RowView(itemModel: $itemModel)
                               
                        }
                 
                    } // chiuda VStack madre
                    ._tightPadding()
                    
            } // chiusa Zstack Madre
            .frame(width: 300, height: 150)
            .onTapGesture {
                
            }
            
            
            if openSideMenu {
                
                VStack(spacing: 5.0) {
                    
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(Color.blue)
                        .frame(width: 50, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(Color.white)

                        )
                    
                 /*   NavigationLink {
                        GenericBoxEditor_RowView(itemModel: $itemModel)
                        
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(Color.white)
                            .frame(width: 50, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(Color.blue)
                            )
                    } */

                    
                   Button {
                        withAnimation {
                            self.openEditor.toggle() }
                 
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(Color.white)
                            .frame(width: 50, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(Color.blue)
                            )
                    }

                    
                    Button {
                        viewModel.deleteItemModel(itemModel: itemModel)
                
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color.white)
                            .frame(width: 50, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(Color.red)
                                   
                            )
                    }
                }
            }
        }.onChange(of: isPresented) { newValue in
            print("isPresentedChanged in \(newValue.description)")
            if newValue {
                
                self.openSideMenu = false
                
                
            }
        }
    }
} */ // 04.05 -> BackUP
