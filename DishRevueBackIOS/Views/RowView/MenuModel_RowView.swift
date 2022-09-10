//
//  MenuModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI

/*
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
} */

struct MenuModel_RowView: View {
    
   // @Binding var menuItem: MenuModel
    let menuItem: MenuModel
    
    var body: some View {
        
        CSZStackVB_Framed { // ha uno sfondo bianco con opacità 0.3 - Questo conferisce un colore azzurro chiaro alle schedine
            
            VStack {
                
                HStack(alignment:.top) {
                    
                    VStack(alignment:.leading) {
                        
                        iteratingIntestazioneMenu()
                        iteratingTipologiaMenu()
                        
                    }
                    
                    Spacer()
                    // Status
                    VStack(alignment:.trailing,spacing:3) {
                        
                        vbEstrapolaStatusImage(itemModel: menuItem)
                        vbDishCountInMenu()
                        
                    }
   
                }
                //  .padding(.horizontal)
                .padding(.top,5)
                
                Spacer()
                
                iteratingCalendarMenuInformation()
                
                Spacer()
                
                HStack(spacing:2){
                    
                    ForEach(GiorniDelServizio.allCases) { day in
                        
                        iteratingGiorniDelServizio(day: day)
                        
                    }
                    
                    Spacer()
                    
                    /*   Text("\(menuItem.dishIn.count)")
                     .fontWeight(.light)
                     .foregroundColor(Color.white)
                     Image(systemName: "fork.knife.circle.fill")
                     .imageScale(.large)
                     .foregroundColor(Color.white) */
                    
                    //  Spacer()
                    
                }
                //  .padding(.horizontal)
                .padding(.bottom,5)
                
            } // chiuda VStack madre
             .padding(.horizontal)
        } // chiusa Zstack Madre
        
    }
    
    // Method
   
    @ViewBuilder private func iteratingCalendarMenuInformation() -> some View {
          
        let avaibility = self.menuItem.isAvaibleWhen
        let(incipit,postFix,showPost) = avaibility.iteratingAvaibilityMenu()
        
        let dataInizio = csTimeFormatter().data.string(from:self.menuItem.dataInizio)
        let dataFine = csTimeFormatter().data.string(from:self.menuItem.dataFine)
        let oraInizio = csTimeFormatter().ora.string(from:self.menuItem.oraInizio)
        let oraFine = csTimeFormatter().ora.string(from:self.menuItem.oraFine)
        
        VStack(alignment:.leading) {
            
            HStack {
                
                Group {
                    
                    Text(incipit)
                    Text(dataInizio)
                                            
                }
                .fontWeight(.semibold)
                .font(.headline)
                .foregroundColor(Color("SeaTurtlePalette_3"))
                
                Spacer()
                
                Text(oraInizio)
                    .fontWeight(.semibold)
                    .font(.headline)
                    .foregroundColor(Color.white)
            
            }
                
            HStack {
                
                Group {
                    Text(postFix)
                        .italic(!showPost)
                    if showPost {Text(dataFine) }
                    
                }
                .fontWeight(.semibold)
                .font(.subheadline)
                .foregroundColor(Color("SeaTurtlePalette_3"))
               
                
                Spacer()
                Text(oraFine)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .foregroundColor(Color.white)
            }
    
        }
        
        
    }
    

    @ViewBuilder private func iteratingGiorniDelServizio(day:GiorniDelServizio) -> some View {
        
        if self.menuItem.giorniDelServizio.contains(day) {
            
            let image = "\(day.imageAssociated()).fill"
            
            Image(systemName: image)
                .imageScale(.large)
                .foregroundColor(Color("SeaTurtlePalette_2"))
                .zIndex(0)
            
        } else {
            
            ZStack {
                
                Image(systemName: day.imageAssociated())
                    .imageScale(.large)
                    .foregroundColor(Color("SeaTurtlePalette_2"))
                    .zIndex(0)
                    
                Image(systemName: "circle.slash")
                        .imageScale(.large)
                        .foregroundColor(Color("SeaTurtlePalette_2"))
                        .zIndex(1)
                    
            }
        }
    }
    
    @ViewBuilder private func iteratingIntestazioneMenu() -> some View {
        
      //  HStack {
            
            Text(self.menuItem.intestazione)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
              //  .scaledToFit()
              //  .minimumScaleFactor(0.5)
                .foregroundColor(Color.white)
               
            
      /*  switch self.menuItem.tipologia {
            
        case .fisso(let pax, _):
            Spacer()
            Image(systemName: pax.imageAssociated())
                 .imageScale(.large)
                 .foregroundColor(Color("SeaTurtlePalette_2"))
                 .padding(.trailing,-10)
            
        default: EmptyView()
            
            } */
      //  }
    }

    @ViewBuilder private func vbDishCountInMenu() -> some View {
        
        HStack(spacing:3) {
            
            Text("\(self.menuItem.dishIn.count)")
            Image(systemName: "fork.knife.circle")
                .imageScale(.large)
            
        }
            .fontWeight(.semibold)
            .foregroundColor(Color("SeaTurtlePalette_4"))
            .padding(.leading,5)
            .background(Color("SeaTurtlePalette_2").cornerRadius(5.0))
    }
    
    @ViewBuilder private func iteratingTipologiaMenu() -> some View {
        
        HStack {
                
                Text(self.menuItem.tipologia.simpleDescription().lowercased())
                    .italic()
                
                switch self.menuItem.tipologia {
                
                case .allaCarta:
                    Image(systemName: "cart")
                       
                case .fisso(let pax, let price):

                        Text("€ \(price)")
                            .bold()
                        HStack(spacing:0) {
                            Text("x")
                            Image(systemName: pax.imageAssociated())
                                 .imageScale(.large)
                                 .foregroundColor(Color("SeaTurtlePalette_2"))
                        }
                    
                default: EmptyView()
                    
                }
            }
            .font(.callout)
            .foregroundColor(Color("SeaTurtlePalette_2"))
    }
    
    
}

struct MenuModel_RowView_Previews: PreviewProvider {
    
     static var menuItem: MenuModel = {
         var menu = MenuModel()
        menu.intestazione = "SomeDay"
        menu.tipologia = .allaCarta
         menu.isAvaibleWhen = .dataEsatta
      //   menu.giorniDelServizio = [ .lunedi,.martedi,.mercoledi]
        menu.status = .completo(.archiviato)
       
        return menu
        
    }()
        
    static var menuItem2: MenuModel = {
        var menu = MenuModel()
       menu.intestazione = "EveryDay"
        menu.tipologia = .fisso(persone: .uno, costo: "12.5")
        menu.isAvaibleWhen = .intervalloAperto
        menu.giorniDelServizio = [ .lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato]
        menu.status = .completo(.disponibile)
       
       return menu
       
   }()
    
    static var menuItem3: MenuModel = {
        var menu = MenuModel()
       menu.intestazione = "SunDay"
        menu.tipologia = .fisso(persone: .due, costo: "23.5")
        menu.isAvaibleWhen = .intervalloChiuso
        menu.giorniDelServizio = [ .domenica]
        menu.status = .bozza()
       
       return menu
       
   }()
    
    static var menuItem4: MenuModel = {
        var menu = MenuModel()
       menu.intestazione = "AlmostEveryDay"
        menu.tipologia = .fisso(persone: .uno, costo: "12.5")
        menu.giorniDelServizio = [ .lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato]
        menu.status = .completo(.inPausa)
       return menu
       
   }()
    
    static var previews: some View {
        

        NavigationStack {
                    
            ZStack {
                
                Color("SeaTurtlePalette_1").ignoresSafeArea()
                VStack {
                    
                    MenuModel_RowView(menuItem: menuItem)
                    MenuModel_RowView(menuItem: menuItem2)
                    MenuModel_RowView(menuItem: menuItem3)
                    MenuModel_RowView(menuItem: menuItem4)
                }
            }
        
        }
    
        
    }
}




/*
 @ViewBuilder private func iteratingGiorniDelServizio(day:GiorniDelServizio, arrayData:[GiorniDelServizio]) -> some View {
     
         ZStack {
             
             Image(systemName: day.imageAssociated())
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
 
 @ViewBuilder private func iteratingIntestazioneMenu(item:MenuModel) -> some View {
     
     HStack {
         
         Text(item.intestazione)
             .font(.title)
             .fontWeight(.semibold)
             .foregroundColor(Color.white)
         
     switch item.tipologia {
         
     case .fisso(let pax, _):
         
         Image(systemName: pax.imageAssociated())
              .imageScale(.large)
              .foregroundColor(Color("SeaTurtlePalette_2"))
              .padding(.trailing,-10)
         
     default: EmptyView()
         
         }
     }
 }

 @ViewBuilder private func iteratingTipologiaMenu(item:MenuModel) -> some View {
     
         HStack {
             
             Text(item.tipologia?.simpleDescription().lowercased() ?? "")
                 .italic()
             
             switch item.tipologia {
             
             case .allaCarta:
                 Image(systemName: "cart")
                    
             case .fisso(_, let price):
                 Text("€ \(price)")
                     
             default: EmptyView()
                 
             }
         }
         .font(.callout)
         .foregroundColor(Color("SeaTurtlePalette_2"))
  
 }
 
 */
