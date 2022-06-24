//
//  DishModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI

struct DishModel_RowView: View {
    
  //  let item: DishModel
    @Binding var item: DishModel
    
    var body: some View {
        
     /*   ZStack(alignment:.leading){
            
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color.white.opacity(0.3))
                .shadow(radius: 2.0) */
        CSZStackVB_Framed {
            
            VStack {
    
                IntestazioneDishRow_Sub(item: item)
                    .padding(.top)
                    .padding(.horizontal)
                
                Spacer()
     
                Divider().padding(.horizontal)
                
                BottomDishRow_Sub(item: item)
                
            } // chiuda VStack madre
                            
        } // chiusa Zstack Madre
       // .frame(width: 300, height: 150)
    
    }
    
}

struct DishModel_RowView_Previews: PreviewProvider {
    
    @State static var dishSample = DishModel(intestazione: "Spaghetti alla Carbonara", aBaseDi: .carneAnimale, categoria: .primo, tipologia: .standard, status: .bozza)
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            Group {
                
                DishModel_RowView(item: $dishSample)
                
              /*  IngredientModel_RowView(item: IngredientModel(nome: "Guanciale", provenienza: .Italia, metodoDiProduzione: .convenzionale, conservazione: .custom("Stagionato"))) */
                
            }
            
        }
        
    }
}


struct IntestazioneDishRow_Sub: View {
    
    let item: DishModel

    var body: some View {
                    
            HStack(alignment:.top) {
                
                HStack(alignment: .top) {
                    
                    Text(item.intestazione)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(Color.white)
                    
                    Text(item.aBaseDi.imageAssociated() ?? "")
                }
            
                Spacer()
                
                Text(item.rating)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    ._tightPadding()
                    .background(
                        Circle()
                            .stroke()
                            .fill(Color.white)
                            .scaledToFill()

                    )

                Spacer()

                // Status
                VStack { // TEMPORANEO -> Deprecato sostituibile con viewBuilder
                    
                    Image(systemName: "circle.fill")
                        .foregroundColor(item.status == .bozza ? Color.orange : Color.red)
                        .background(
                        
                            Circle()
                                .strokeBorder()
                                .foregroundColor(Color.black.opacity(0.8))
                               
                        )
                    
                  test()
                    
                } // TEMPORANEO
                // end Status
            }

    }
    
    // Method

 func test() -> some View { // Temporanea
     
     var prices: [String] = []
     
     for x in self.item.formatiDelPiatto {
         
         let price = x.showAssociatedValue().prezzo
         prices.append(price)
         
     }
     
     
     if !prices.isEmpty {
        return Text(prices[0])
         
     } else {return Text("€ 0,00") }
     
     
 }
        
        
    }


struct BottomDishRow_Sub: View {
    
    var item: DishModel
    
    var body: some View {
        
        VStack {

            HStack(spacing: 4.0) {
                
                Image(systemName: "list.bullet.rectangle")
                    .imageScale(.medium)
             
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(spacing: 2.0) {
                        
                        ForEach(item.ingredientiPrincipali) { ingredient in
                            
                            Text(ingredient.intestazione)
                                .font(.callout)
                                .fontWeight(.thin)
                                .foregroundColor(Color.black)
                            
                            Text("•")
                            
                        }
                    }
                }
            }
            
            HStack(spacing: 4.0) {
                
                Image(systemName: "allergens")
                    .imageScale(.medium)
            
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(spacing: 2.0) {
                        
                        ForEach(item.allergeni) { allergene in
                            
                            Text(allergene.simpleDescription().replacingOccurrences(of: " ", with: ""))
                                .font(.caption)
                                .foregroundColor(Color.black)
                                .italic()
                            
                            Text("•")
                            
                        }
                        
                    }
                }
            }
     
        }
        ._tightPadding()
        
        
    }
}


