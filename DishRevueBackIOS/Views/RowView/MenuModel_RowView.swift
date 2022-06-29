//
//  MenuModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI

enum MenuModelOption {
    
    case modifica,duplica
    
    func simpleDescription() -> String {
        
        switch self {
        case .modifica:
            return "Modifica"
        case .duplica:
            return "Duplica"
        }
    }
}

/// MenuModel-RowView come label di un Menu 
/*struct MenuModel_RowLabelMenu<Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var menuItem: MenuModel
    let backgroundColorView: Color
    @ViewBuilder var content: Content
  //  @State private var activeEditMenuLink = false
   
    var body: some View {
        
        
        Menu {
            
          /*  Button {
                self.activeEditMenuLink = true
            } label: {
                HStack {
                    
                    Text("Modifica")
                    Image(systemName: "arrow.up.right.square")
                      
                }
            } */
          /*  NavigationLink("Modifica") {
                Text("Modifica")
            }
            NavigationLink("Duplica") {
                Text("Duplica")
            } */

                content

      
                vbStatusButton()
            
            
            Button {
               let index = self.viewModel.allMyMenu.firstIndex(of: menuItem)
                self.viewModel.allMyMenu.remove(at: index!)
            } label: {
                Text("Rimuovi")
            }


            
        } label: {

              MenuModel_RowView(menuItem: $menuItem)
          /*  NavigationLink(
                isActive: $activeEditMenuLink) {
                    NuovoMenuMainView(nuovoMenu: menuItem, backgroundColorView: backgroundColorView)
                } label: {
                    MenuModel_RowView(menuItem: $menuItem)
                } */

        

            
            
           
        }
        
    }
    
    // Method
    
    @ViewBuilder private func vbStatusButton() -> some View {
        
        
        if menuItem.status == .bozza {
            
            Button {
                menuItem.status = .completo(.inPausa)
            } label: {
                Text("MarcaCompleto")
            }

            
        } // Da ELIMINARE x TEST
        
        
        if menuItem.status == .completo(.pubblico) {
            
            Button {
                menuItem.status = .completo(.inPausa)
            } label: {
                HStack {
                    Text("Metti in Pausa")
                    
                    Image(systemName: "pause.circle")
                
                    
                }
            }
            
        } else if menuItem.status == .completo(.inPausa) {
            
            Button {
                menuItem.status = .completo(.pubblico)
            } label: {
                HStack {
                    Text("Pubblica")
                    
                    Image(systemName: "play.circle")
                
                    
                }
            }
            
            
        }
        
        
        
        
        
    }
  
} */ // Deprecata 24.06 per trasformazione in Maschera Generica

struct MenuModel_RowView: View {
    
   // @Binding var menuItem: MenuModel
    let menuItem: MenuModel
    
    var body: some View {
        
        CSZStackVB_Framed {
            
            VStack {
                
                HStack(alignment:.top) {
                    
                    VStack(alignment:.leading) {
                        
                        iteratingIntestazioneMenu(item: menuItem)
                        iteratingTipologiaMenu(item: menuItem)
                        
                    }
                      
                    Spacer()
                    // Status
                    
                    vbEstrapolaStatusImage(itemModel: menuItem)

                }
                .padding()
                    
                Spacer()
                
                HStack {
                        
                        ForEach(GiorniDelServizio.allCases) { day in
         
                            iteratingGiorniDelServizio(day: day, arrayData: menuItem.giorniDelServizio)
                            
                        }
                        
                    Spacer()
                    
                }
                .padding(.horizontal)
                
            } // chiuda VStack madre
         
        } // chiusa Zstack Madre
    }
    
}
/*
struct MenuModel_RowView_Previews: PreviewProvider {
    
    @State static var menuItem: MenuModel = MenuModel(nome: "SomeDay", tipologia: .allaCarta, giorniDelServizio: [.lunedi,.martedi])
    
    static var previews: some View {
        

        NavigationStack {
            
           /* MenuModel_RowLabelMenu(menuItem: $menuItem, backgroundColorView: Color("SeaTurtlePalette_1") {
                
                Text("Test Preview")
            } */
                                   
            MenuModel_RowLabelMenu(menuItem: $menuItem, backgroundColorView: Color("SeaTurtlePalette_1"), content: {
                Text("Test Preview")
            })
                                   
        }
    
        
    }
} */

@ViewBuilder func iteratingGiorniDelServizio(day:GiorniDelServizio, arrayData:[GiorniDelServizio]) -> some View {
    
        
        ZStack {
            
            Image(systemName: day.imageAssociated() ?? "circle")
                .imageScale(.large)
                .foregroundColor(Color("SeaTurtlePalette_2"))
                .zIndex(0)
            
            if !arrayData.contains(day) {
                
                Image(systemName: "circle.slash")
                    .imageScale(.large)
                    .foregroundColor(Color("SeaTurtlePalette_2"))
                    .zIndex(1)
                
            }
        }
}

@ViewBuilder func iteratingIntestazioneMenu(item:MenuModel) -> some View {
    
    HStack {
        
        Text(item.intestazione)
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(Color.white)
        
    switch item.tipologia {
        
    case .fisso(let pax, _):
        
        let rangePax = 1...(Int(pax) ?? 1)
        
        ForEach(rangePax, id:\.self) { _ in
        
           Image(systemName: "person")
                .imageScale(.large)
                .foregroundColor(Color("SeaTurtlePalette_2"))
                .padding(.trailing,-10)
            
        }
        
    default: EmptyView()
        
        }
    }
}

@ViewBuilder func iteratingTipologiaMenu(item:MenuModel) -> some View {
    
        HStack {
            
            Text(item.tipologia.simpleDescription().lowercased())
                .italic()
            
            switch item.tipologia {
            
            case .allaCarta:
                Image(systemName: "cart")
                   
            case .fisso(_, let price):
                Text("( \(price) € )")
                    
            default: EmptyView()
                
            }
        }
        .font(.callout)
        .foregroundColor(Color("SeaTurtlePalette_2"))
 
}


