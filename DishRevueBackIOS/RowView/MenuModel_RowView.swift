//
//  MenuModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI

struct MenuModel_RowView: View {
    
    let item: MenuModel
    
    var body: some View {
        
        ZStack(alignment:.leading) {
            
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color.white.opacity(0.3))
                .shadow(radius: 5.0)
                
            
            VStack {
                
                HStack(alignment:.top) {
                    
                    VStack(alignment:.leading) {
                        
                        iteratingIntestazioneMenu(item: item)
                        iteratingTipologiaMenu(item: item)
                        
                    }
                      
                    Spacer()
                    // Status
                    Image(systemName: "circle.fill")
                        .foregroundColor(Color.green)
                    //
                }
                .padding()
                    
                Spacer()
                
                HStack {
                        
                        ForEach(GiorniDelServizio.allCases) { day in

                                
                            iteratingGiorniDelServizio(day: day, arrayData: item.giorniDelServizio)
                            
                        }
                        
                    Spacer()
                    
                }
                .padding(.horizontal)
                
            } // chiuda VStack madre
                
                
            
            
                
                
        } // chiusa Zstack Madre
       // .background(Color.red)
        .frame(width: 300, height: 150)
        
   
    }
    
}

struct MenuModel_RowView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            Group {
                
                MenuModel_RowView(item: MenuModel(nome: "SomeDay", tipologia: .allaCarta, giorniDelServizio: [.lunedi,.martedi]))
                
              /*  MenuModel_RowView(item: MenuModel(
                    nome: "FerialDay",
                    tipologia: .fisso(persone: "2", costo: "25"),
                    giorniDelServizio: [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi]))
                */
                
               /* DishModel_RowView(item: DishModel(intestazione: "Spaghetti alla Carbonara", aBaseDi: .carne, categoria: .primo, tipologia: .standard))
                
                IngredientModel_RowView(item: IngredientModel(nome: "Guanciale", provenienza: .Italia, metodoDiProduzione: .convenzionale, conservazione: .custom("Stagionato"))) */
                
            }
            
        }
        
    }
}

@ViewBuilder func iteratingGiorniDelServizio(day:GiorniDelServizio, arrayData:[GiorniDelServizio]) -> some View {
    
        
        ZStack {
            
            Image(systemName: day.imageAssociated() ?? "circle")
                .imageScale(.large)
                .zIndex(0)
            
            if !arrayData.contains(day) {
                
                Image(systemName: "circle.slash")
                    .imageScale(.large)
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
 
}
