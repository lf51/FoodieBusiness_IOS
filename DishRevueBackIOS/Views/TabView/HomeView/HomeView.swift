//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI
import UIKit



struct HomeView: View {
    
    @ObservedObject var authProcess: AuthPasswordLess
    @EnvironmentObject var viewModel: AccounterVM
    let backgroundColorView: Color

    @State private var wannaAddNewProperty:Bool = false
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        
        NavigationStack(path:$viewModel.homeViewPath) {
      
            CSZStackVB(title:authProcess.userInfo?.userDisplayName ?? "Home", backgroundColorView: backgroundColorView) {

              
                VStack(alignment: .leading) {
                    
                //    CSDivider()
                    
                    HStack {
                        
                        addNewMenu()
                        Spacer()
                        
                        NavigationLink(value: DestinationPathView.moduloImportazioneVeloce) {
                            
                            HStack(spacing:2) {
                                
                                Text("⚡️Importa")
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                Text("[🍽🧂]")
                                    .font(.subheadline)
                                
                            }
                            .foregroundColor(Color("SeaTurtlePalette_2"))
                            .padding(5)
                            .background {
                                Color("SeaTurtlePalette_1")
                                    .opacity(0.9)
                                    .blur(radius: 10.0)
                                    .cornerRadius(5.0)
                            }
                        }
                        
                    }
                    .padding(.vertical,5)
                    .padding(.horizontal,5)
                    
                    HStack {
                        
                        NavigationLink(value: DestinationPathView.listaDellaSpesa) {
                        
                            HStack {
                                Image(systemName: "cart")
                                    .imageScale(.medium)
                                    .foregroundColor(Color("SeaTurtlePalette_3"))
                                Text("Lista della Spesa")
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                            }
                            .foregroundColor(Color("SeaTurtlePalette_2"))
                            .padding(5)
                            .background {
                                Color("SeaTurtlePalette_1")
                                    .opacity(0.9)
                                    .blur(radius: 10.0)
                                    .cornerRadius(5.0)
                            }
                        }
                        
                    }
                    
                    
                    
                  //  NewItem_BarView()
                    
                    ScrollView {
                       
                        VStack(alignment: .leading) {
                            
                            RoundedRectangle(cornerRadius: 5.0)
                                .frame(width:400,height: 200)
                                .overlay {
                                    Text("Immagine")
                                        .foregroundColor(Color.white)
                                }

                            
                            // Menu Del Giorno 22.09
                            
                            VStack(alignment:.leading) {
                                MenuDiSistema_BoxView(menuDiSistema: .delGiorno)

                                MenuDiSistema_BoxView(menuDiSistema: .delloChef)
                              //  Spacer()
                            }.background {
                              //  Color.red
                            }
                            
                            // end menu dello chef
                            

                            
                        } // VStack End
                      
                    }
                }  .padding(.horizontal)
            }// chiusa ZStack
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .homeView, readOnlyViewModel: viewModel)
            })
         /*  .navigationDestination(for: PropertyModel.self, destination: { property in
                EditingPropertyModel(itemModel: property, backgroundColorView: backgroundColorView)
            }) */
           
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
   
                    NavigationLink(value: DestinationPathView.accountSetup(authProcess)) {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("SeaTurtlePalette_2"))
                    }
           
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink(value: DestinationPathView.propertyList) {
                        HStack {
                            Text("Proprietà")
                                .fontWeight(.bold)
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .imageScale(.medium)
                        }
                        .foregroundColor(Color("SeaTurtlePalette_4"))
                    }
                    
                    
                }
            }
          
        }
  
    }
    // Method

    @ViewBuilder private func addNewMenu() -> some View {
        
        let newDish = DishModel()
        let newING = IngredientModel()
        let newMenu = MenuModel()
        
        Menu {
            
            NavigationButtonGeneric(item: newDish)
            NavigationButtonGeneric(item: newING)
            NavigationButtonGeneric(item: newMenu)
            
            Button {
                viewModel.addToThePath(
                    destinationPath: .homeView,
                    destinationView: DestinationPathView.categoriaMenu)
            } label: {
                Text("Edit Categorie Menu")
                Image(systemName: "list.bullet.clipboard")
            }
            
        } label: {
            Text("[+]")
                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                .foregroundColor(Color("SeaTurtlePalette_2"))
        }
        .padding(5)
        .background {
            Color("SeaTurtlePalette_1")
                .opacity(0.9)
                .blur(radius: 10.0)
                .cornerRadius(5.0)
        }

        
        
    }

}

struct HomeView_Previews: PreviewProvider {
 
    @State static var viewModel = testAccount
    
    static var previews: some View {
        
        NavigationStack {
            
            HomeView(authProcess: AuthPasswordLess(), backgroundColorView: Color("SeaTurtlePalette_1"))
        }.environmentObject(testAccount)

    }
}


struct MenuDiSistema_BoxView:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let menuDiSistema:TipologiaMenu.DiSistema
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            let menuDS = self.viewModel.trovaMenuDiSistema(menuDiSistema: menuDiSistema)
            
            let tipologia:TipologiaMenu = menuDiSistema.returnTipologiaMenu()
            
            CSLabel_conVB(
                placeHolder: "\(menuDiSistema.shortDescription())",
                imageNameOrEmojy: tipologia.imageAssociated(),
                backgroundColor: Color("SeaTurtlePalette_2"),
                backgroundOpacity: menuDS != nil ? 1.0 : 0.2) {
                   
                    HStack {
                        if menuDS == nil {
                            
                            Button {
                                withAnimation {
                                    self.viewModel.switchFraCreaEUpdateModel(itemModel: MenuModel(tipologia: menuDiSistema.returnTipologiaMenu()))
                                }
                            } label: {
                                Text("Abilita")
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                    .foregroundColor(Color("SeaTurtlePalette_3"))
                                    .shadow(radius: 5.0)
                            }
                            
                        } else {
                            
                            let dishIn = menuDS!.rifDishIn.count
                            let allDish = viewModel.allMyDish.count
                            
                            NavigationLink(value: DestinationPathView.vistaPiattiEspansa(menuDS!)) {
                                
                                Text("Espandi(\(dishIn)/\(allDish))")
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                    .foregroundColor(Color("SeaTurtlePalette_3"))
                                    .shadow(radius: 5.0)
                                    .opacity(allDish == 0 ? 0.4 : 1.0)
                                    
                                    
                            }.disabled(allDish == 0)
                            
                        }
                    }
                    
                }
            
            if menuDS != nil {
                
                HStack {
           
                        if menuDS!.rifDishIn.isEmpty {
                            
                            Text("\(menuDiSistema.shortDescription()) Vuoto")
                                .italic()
                                .font(.headline)
                                .foregroundColor(Color("SeaTurtlePalette_2"))
                            
                        } else {
                            
                            ScrollView(.horizontal,showsIndicators: false ) {
                                
                                HStack {
                                    
                                    ForEach(menuDS!.rifDishIn,id:\.self) { idPiatto in
                                           
                                           if let piatto = self.viewModel.modelFromId(id: idPiatto, modelPath: \.allMyDish) {
                                               
                                               DishModel_RowView(item: piatto, rowSize: .sintetico)
              
                                           }
         
                                       }
                                }
                            }
                        }

                }
            }
        
        } // chiusa VStack Madre

    }
}

/*
struct NewItem_BarView:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let newDish:DishModel
    let newMenu:MenuModel
    let newING:IngredientModel
    
    init() {
        self.newDish = DishModel()
        self.newMenu = MenuModel()
        self.newING = IngredientModel()
    }
    var body: some View {
        
        VStack(spacing:15) {
           HStack {
               NewItem_BoxView(item: newMenu)
               Spacer()
               NewItem_BoxView(item: newDish)
               Spacer()
               NewItem_BoxView(item: newING)
           }
           
            HStack {
                NavigationLink(value: DestinationPathView.moduloImportazioneVeloce) {
                    
                    HStack(spacing:2) {
                        
                        Text("⚡️Importa")
                            .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        Text("[🍽🧂]")
                            .font(.subheadline)
                        
                    }
                    .foregroundColor(Color("SeaTurtlePalette_2"))
                }
                
                Spacer()
                
                NavigationLink(value: DestinationPathView.categoriaMenu) {
                    Text("[+]Categoria Menu")
                        .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        .foregroundColor(Color("SeaTurtlePalette_2"))
                }
            }
        }
        .padding(.vertical,5)
        .padding(.horizontal,5)
        .background {
            Color("SeaTurtlePalette_1")
                .opacity(0.1)
                .blur(radius: 10.0)
                .cornerRadius(5.0)
        }
        
        
   
        
        
    }
} */
/*
struct NewItem_BoxView<M:MyProStatusPack_L1>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let item: M
    
    var body: some View {
    
            NavigationLink(value: item.pathDestination()) {
                Text("[+]\(item.viewModelContainerInstance().nomeOggetto)")
                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                    .foregroundColor(Color("SeaTurtlePalette_2"))
            }
    }
} */

struct NavigationButtonGeneric<M:MyProStatusPack_L1>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let item: M
    
    var body: some View {
    
        let(_,_,nome,image) = item.basicModelInfoInstanceAccess()
        
        Button {
            viewModel.addToThePath(destinationPath: .homeView, destinationView: item.pathDestination())
        } label: {
            HStack {
                Text("Crea \(nome)")
                Image(systemName: image)
            }
        }

    }
}
