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
      
            CSZStackVB(title:authProcess.currentUser?.userDisplayName ?? "Home", backgroundColorView: backgroundColorView) {

              
                VStack(alignment: .leading) {
                    
                //    CSDivider()
       
                    vbTopView()
                        .padding(5)
                        .background {
                            Color.white
                                .opacity(0.03)
                                .cornerRadius(5.0)
                        }
                  
                    
                  //  NewItem_BarView()
                    
                    ScrollView(showsIndicators:false) {
                       
                        VStack(alignment: .leading) {
                            
                          /*  Image("TavolaIngredienti")
                                .resizable()
                                .scaledToFill()
                                .frame(width:400,height: 200)
                                .cornerRadius(5.0)
                           /* RoundedRectangle(cornerRadius: 5.0)
                                .frame(width:400,height: 200) */
                                .overlay {
                                    Text("Scroll Foto + Commento ultime Recensioni")
                                        .font(.largeTitle)
                                        .fontWeight(.black)
                                        .foregroundColor(Color.white)
                                } */

                           MonitorServizio()
                                .padding(.bottom,1)
                            
                          
                            
                            
                            // Menu Del Giorno 22.09
                            
                            VStack(alignment:.leading) {
                                MenuDiSistema_BoxView(menuDiSistema: .delGiorno)

                                MenuDiSistema_BoxView(menuDiSistema: .delloChef)
                              //  Spacer()
                            }.background {
                              //  Color.red
                            }
                            
                            // end menu dello chef
                           
                            CSZStackVB_Framed(frameWidth:500,backgroundOpacity: 0.05,shadowColor: .clear) {
                                
                                    ScheduleServizio()
                                        .padding(5)
                            }
                            .padding(.bottom,1)
                            
                            
                            MonitorReview()
                                 .padding(.bottom,1)
                            
                        let allPrepRated = compilaArrayPreparazioni()
                            
                            TopRated_SubView(
                                allRated: allPrepRated,
                                destinationPathView: .vistaRecensioniEspansa,
                                label: "Preparazioni Top Rated",
                                linkTitle: "Tutte")
                                .padding(.bottom,5)
                            
                        let (allMenuRated,allRifMenu) = compilaArrayMenu()
                            
                           TopRated_SubView(
                            allRated: allMenuRated,
                            destinationPathView: .listaGenericaMenu(_containerRif: allRifMenu, _label: "Menu Rated(Prov)"),
                            label: "Menu Top Rated",
                            linkTitle: "Tutti")
                                .padding(.bottom,5)
                        } // VStack End
                      
                       
                    } // End Scroll
                    
                    CSDivider()
                    
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
   
    
                   /* NavigationLink(value: DestinationPathView.accountSetup(authProcess)) {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("SeaTurtlePalette_2"))
                    }*/
                    
                    CSButton_image(frontImage: "person.fill", imageScale: .large, frontColor: Color("SeaTurtlePalette_2")) {
                        csSetupButton()
                    }
           
                    
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink(value: DestinationPathView.propertyList) {
                        
                        HStack(alignment:.lastTextBaseline,spacing:2) {
                            Image(systemName: "house")
                                .imageScale(.medium)
                            Text("Proprietà")
                                .fontWeight(.bold)
                          //  Image(systemName: "rectangle.portrait.and.arrow.right")
                           
                        }
                        .foregroundColor(Color("SeaTurtlePalette_4"))
                    }
                    
                    
                }
            }
          
        }
  
    }
    // Method
    
    
    private func csSetupButton() {
        
        guard self.authProcess.currentUser != nil else {
             return self.authProcess.openSignInView = true
           
        }
        
        self.viewModel.homeViewPath.append(DestinationPathView.accountSetup(self.authProcess))
        
    }
    
    private func compilaArrayPreparazioni() -> [DishModel] {
        
        let tutteLePreparazioni = self.viewModel.allMyDish.filter({$0.percorsoProdotto != .prodottoFinito})
        
        let topRated = tutteLePreparazioni.sorted(by: {
            $0.topRatedValue(readOnlyVM: self.viewModel) > $1.topRatedValue(readOnlyVM: self.viewModel)
        })
                
        return topRated
        
    }
    
    private func compilaArrayMenu() -> (model:[MenuModel],rif:[String]) {
        
        let allMenu = self.viewModel.allMyMenu.filter({$0.mediaValorePiattiInMenu(readOnlyVM: self.viewModel) > 0.0 })
        
        let allSorted = allMenu.sorted(by: {
            $0.mediaValorePiattiInMenu(readOnlyVM: self.viewModel) > $1.mediaValorePiattiInMenu(readOnlyVM: self.viewModel)
        })
        
        let allRif = allSorted.map({$0.id})
        
        return (allSorted,allRif)
        
    } // Le func di compilazione possono essere in futuro spostate nel viewModel e rese generiche. Attendiamo di fare le liste e i sistemi di filtraggio. Queste qui possono unirsi e conformarsi ai sistemi di filtraggio


    @ViewBuilder private func vbTopView() -> some View {
        
        VStack(alignment:.leading) {
            
            HStack {
                
                addNewModel()
                
                Spacer()
                
                NavigationLink(value: DestinationPathView.categoriaMenu) {
                
                    
                    HStack(alignment:.lastTextBaseline,spacing:3) {
                        Image(systemName: "list.bullet.clipboard")
                            .imageScale(.small)
                        Text("Categorie")
                            .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        
                    }
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                      //  .padding(5)
                       /* .background {
                            Color("SeaTurtlePalette_1")
                                .opacity(0.9)
                                .blur(radius: 10.0)
                                .cornerRadius(5.0)
                        } */
                     
                }
                
                Spacer()
                NavigationLink(value: DestinationPathView.moduloImportazioneVeloce) {
                    
                //    HStack(spacing:2) {
                        
                        Text("⚡️Import⚡️")
                            .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                      //  Text("[🍽🧂]")
                        //    .font(.subheadline)
                        
                 //   }
                    .foregroundColor(Color("SeaTurtlePalette_3"))
                   /* .padding(5)
                    .background {
                        Color("SeaTurtlePalette_1")
                            .opacity(0.9)
                            .blur(radius: 10.0)
                            .cornerRadius(5.0)
                    }*/
                }
                
            }
            .lineLimit(1)
            .padding(.bottom,5)
           // .padding(.vertical,5)
           // .padding(.horizontal,5)
            
            HStack {
                
                NavigationLink(value: DestinationPathView.listaDellaSpesa) {
                
                    HStack(alignment:.lastTextBaseline,spacing:2) {
                        Image(systemName: "cart")
                            .imageScale(.medium)
                            .foregroundColor(Color("SeaTurtlePalette_3"))
                        Text("Lista della Spesa")
                            .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                    }
                    .foregroundColor(Color("SeaTurtlePalette_3"))
                  /*  .padding(5)
                    .background {
                        Color("SeaTurtlePalette_1")
                            .opacity(0.9)
                            .blur(radius: 10.0)
                            .cornerRadius(5.0)
                    } */
                }
                
                Spacer()
                
                let propertyDestination:DestinationPathView? = {
                    
                    let allProp = self.viewModel.allMyProperties
                    
                    guard !allProp.isEmpty else { return nil }
                    
                    let model = allProp[0]
                    return DestinationPathView.property(model)

                    }()
                
                NavigationLink(value: propertyDestination) {
                    
                        HStack(alignment:.lastTextBaseline,spacing:2) {
                            Image(systemName: "house")
                                .imageScale(.medium)
                            Text("Edit")
                                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        }
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                    }
                    .opacity(propertyDestination == nil ? 0.5 : 1.0)
              
 
                
                Spacer()
            
                let trashDestination:DestinationPathView? = {
                    
                    let isTrashEmpty = self.viewModel.remoteStorage.modelRif_deleted.isEmpty
                    
                    guard !isTrashEmpty else { return nil }
                    
                    return DestinationPathView.elencoModelDeleted

                    }()
                
                
                NavigationLink(value: trashDestination) {
                    Image(systemName: "trash")
                          .imageScale(.medium)
                          .foregroundColor(Color("SeaTurtlePalette_4"))
                }
                .opacity(trashDestination == nil ? 0.5 : 1.0)
                
            
            }
            .lineLimit(1)
        }
    }
    
    private func nuovePreparazioni() -> (food:DishModel,drink:DishModel,pf:DishModel) {
        
        let newDish = DishModel()
        
        let newDrink = {
           var new = DishModel()
            new.percorsoProdotto = .preparazioneBeverage
            return new
        }()
        let newPF = {
           var new = DishModel()
            new.percorsoProdotto = .prodottoFinito
            return new
        }()
        
        return (newDish,newDrink,newPF)
    }
    
    @ViewBuilder private func addNewModel() -> some View {
        
        let newDish = DishModel()
        let newING = IngredientModel()
        let newMenu = MenuModel()
        
        Menu {
            
            NavigationButtonGeneric(item: newING)
            NavigationButtonGeneric(item: newDish)
            NavigationButtonGeneric(item: newMenu)

        } label: {
            Text("[+] Aggiungi")
                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                .foregroundColor(Color("SeaTurtlePalette_3"))
        }
       /* .padding(5)
        .background {
            Color("SeaTurtlePalette_1")
                .opacity(0.9)
                .blur(radius: 10.0)
                .cornerRadius(5.0)
        } */

        
        
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
            
           // let tipologia:TipologiaMenu = menuDiSistema.returnTipologiaMenu()
           
            CSLabel_conVB(
                placeHolder: "\(menuDiSistema.shortDescription())",
                imageNameOrEmojy: menuDiSistema.imageAssociated(),
                backgroundColor: Color("SeaTurtlePalette_2"),
                backgroundOpacity: menuDS != nil ? 1.0 : 0.2) {
                   
                    HStack {
                        
                        if menuDS == nil {
                            
                            Button {
                                
                              //  let newDS = MenuModel(tipologia: tipologia)
                                let newDS = MenuModel(tipologiaDiSistema: menuDiSistema)
                                withAnimation {
                                    self.viewModel.switchFraCreaEUpdateModel(itemModel: newDS)
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
                                
                                HStack(spacing:0) {
                                    Text("Espandi(\(dishIn)/\(allDish))")
                                        .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                        
                                    Image(systemName: "arrow.up.right.square")
                                        .imageScale(.medium)
                                    
                                }
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
                                               
                                             //  DishModel_RowView(item: piatto, rowSize: .sintetico)
                                               GenericItemModel_RowViewMask(
                                                model: piatto,
                                                rowSize: .sintetico) {
                                                   
                                                    Button {
                                                        
                                                        viewModel.manageInOutPiattoDaMenuDiSistema(idPiatto: idPiatto, menuDiSistema: menuDiSistema)

                                                    } label: {
                                                        HStack{
                                                            
                                                            Text("Rimuovi da \(menuDiSistema.simpleDescription()) ")
                                                           
                                                        }
                                                    }
                                                    
                                                    
                                                }
              
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
    
       // let(_,_,nome,image) = item.basicModelInfoInstanceAccess()
        let (incipit,nome,image) = self.infoItem()
        
        Button {
            viewModel.addToThePath(destinationPath: .homeView, destinationView: item.pathDestination())
        } label: {
            HStack {
                Text("\(incipit) \(nome)")
                Image(systemName: image)
             
            }
        }

    }
    
    // Method
    
    private func infoItem() -> (incipit:String,nome:String,image:String) {
        
        let incipit:String
        let nome:String
        let image:String
        
        if let localItem = item as? DishModel {
            
                incipit = "Nuova"
                nome = "Preparazione"
                image = localItem.basicModelInfoInstanceAccess().imageAssociated
                
  
        } else {
            
            incipit = "Nuovo"
            (_,_,nome,image) = item.basicModelInfoInstanceAccess()
            
        }
        
        return (incipit,nome,image)
        
    }
    
}

struct TopRated_SubView<M:MyProVisualPack_L1>:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    let allRated:[M]
    let destinationPathView:DestinationPathView
    let label:String
    let linkTitle:String
    
    var body: some View {
        
        VStack(alignment:.leading,spacing:10) {

            let topThree = self.allRated.prefix(3).enumerated()
            let disabled = self.allRated.isEmpty
            
            CSLabel_conVB(
                placeHolder: label,
                imageNameOrEmojy: "medal",
                backgroundColor: Color("SeaTurtlePalette_2"),
                backgroundOpacity: disabled ? 0.2 : 1.0) {
                    
                    NavigationLink(value:destinationPathView) {
                        
                        HStack(spacing:2) {
                            Text(linkTitle)
                                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                
                            Image(systemName: "arrow.up.right.square")
                                .imageScale(.medium)
                            
                        }
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                        .shadow(radius: 5.0)
                        .opacity(disabled ? 0.4 : 1.0)
                            
                            
                    }.disabled(disabled)
                }
            
            VStack(spacing:10) {
                
                ForEach(Array(topThree),id:\.element) {position,element in

                    HStack {
                     //   element.returnModelRowView(rowSize: .sintetico)
                       GenericItemModel_RowViewMask(
                        model: element,
                        rowSize: .sintetico) {
                            element.vbMenuInterattivoModuloCustom(viewModel: self.viewModel, navigationPath: \.homeViewPath)
                        }
                        
                        Text(csRatingMedalReward(position: position))
                            .font(.largeTitle)

                    }
                    
                }
            }
            
        }
        
        
    }
}

/*
struct TopRatedMenu_SubView:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    var body: some View {
        
        VStack(alignment:.leading,spacing: 10) {
            
            let allRated = compilaArrayPreparazioni()
            let topThree = allRated.prefix(3).enumerated()
            let disabled = allRated.isEmpty
            
            CSLabel_conVB(
                placeHolder: "Menu Top Rated",
                imageNameOrEmojy: "medal",
                backgroundColor: Color("SeaTurtlePalette_2"),
                backgroundOpacity: disabled ? 0.2 : 1.0) {
                    
                    NavigationLink(value: DestinationPathView.vistaRecensioniEspansa) {
                        
                        HStack(spacing:2) {
                            Text("Classifica")
                                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                
                            Image(systemName: "arrow.up.right.square")
                                .imageScale(.medium)
                            
                        }
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                        .shadow(radius: 5.0)
                        .opacity(disabled ? 0.4 : 1.0)
                            
                            
                    }.disabled(disabled)
                }
            
            VStack(spacing:10) {
                
                ForEach(Array(topThree),id:\.element) {position,element in
                    
                    HStack {
                      
                        MenuModel_RowView(menuItem: element,rowSize: .sintetico)
                        Text(csRatingMedalReward(position:position))
                            .font(.largeTitle)

                    }
                    
                }
            }
            
        }
        
        
    }
    
    // Method
    
    private func compilaArrayPreparazioni() -> [MenuModel] {
        
        let allMenu = self.viewModel.allMyMenu.filter({$0.mediaValorePiattiInMenu(readOnlyVM: self.viewModel) > 0.0 })
        
        let allSorted = allMenu.sorted(by: {
            $0.mediaValorePiattiInMenu(readOnlyVM: self.viewModel) > $1.mediaValorePiattiInMenu(readOnlyVM: self.viewModel)
        })
        
        return allSorted
        
    }
} */ // 28.10 Deprecata per trasformazione in generico

/*
struct TopRated_SubView:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    var body: some View {
        
        VStack(alignment:.leading,spacing:10) {
            
            let allRated = compilaArrayPreparazioni()
            let topThree = allRated.prefix(3).enumerated()
            let disabled = allRated.isEmpty
            
            CSLabel_conVB(
                placeHolder: "Preparazioni Top Rated",
                imageNameOrEmojy: "medal",
                backgroundColor: Color("SeaTurtlePalette_2"),
                backgroundOpacity: disabled ? 0.2 : 1.0) {
                    
                    NavigationLink(value: DestinationPathView.vistaRecensioniEspansa) {
                        
                        HStack(spacing:2) {
                            Text("Classifica")
                                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                
                            Image(systemName: "arrow.up.right.square")
                                .imageScale(.medium)
                            
                        }
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                        .shadow(radius: 5.0)
                        .opacity(disabled ? 0.4 : 1.0)
                            
                            
                    }.disabled(disabled)
                }
            
            VStack(spacing:10) {
                
                ForEach(Array(topThree),id:\.element) {position,element in
                    
                    HStack {
                        
                        DishModel_RowView(item: element,rowSize: .sintetico)
                        Text(csRatingMedalReward(position: position))
                            .font(.largeTitle)

                    }
                    
                }
            }
            
        }
        
        
    }
    
    // Method
    
    private func compilaArrayPreparazioni() -> [DishModel] {
        
        let tutteLePreparazioni = self.viewModel.allMyDish.filter({$0.percorsoProdotto != .prodottoFinito})
        
        let topRated = tutteLePreparazioni.sorted(by: {
            $0.topRatedValue(readOnlyVM: self.viewModel) > $1.topRatedValue(readOnlyVM: self.viewModel)
        })
                
        return topRated
        
    }
}*/ // BackUp 28.10
 
