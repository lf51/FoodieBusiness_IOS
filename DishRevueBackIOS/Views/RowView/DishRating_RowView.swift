//
//  DishRating_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/08/22.
//

import SwiftUI

struct DishRating_RowView: View {
    
    let rating: DishRatingModel
    
    var body: some View {
        
        CSZStackVB_Framed {
            
            VStack(alignment:.leading) {
                
                HStack {
                    
                    Text(rating.voto)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(Color("SeaTurtlePalette_4"))
                        .padding(.horizontal,5)
                        .background(rating.rateColor().cornerRadius(5.0))
   
                    Text(rating.titolo)
                        .font(.system(.largeTitle, design: .serif, weight: .semibold))
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                        .lineLimit(1)
                    
                }
               .padding(.vertical)
           
                
                ScrollView {
                    
                    VStack {
                        
                        Text(rating.commento)
                            .font(.system(.body, design: .serif, weight: .light))
                            .foregroundColor(Color("SeaTurtlePalette_4"))
                        
                    }
                    
                    
                }
 
                Spacer()
                
                HStack {
                    Spacer()
                    Text( csTimeFormatter().data.string(from: rating.dataRilascio) )
                    Text( csTimeFormatter().ora.string(from: rating.dataRilascio) )
                    
                }
                .italic()
                .font(.system(.caption, design: .serif, weight: .ultraLight))
                .foregroundColor(Color.black)
                .padding(.bottom,5)
                
            }
            .padding(.horizontal,10)
            .background(Color.black.opacity(0.1))
            ._tightPadding()
            
            
        }
    }
}

struct DishRating_RowView_Previews: PreviewProvider {
    
    static var ratings: [DishRatingModel] = []/*[
    DishRatingModel(voto: "8.9", titolo: "Strepitoso", commento: "Materie Prime eccezzionali perfettamente combinate fra loro per un gusto autentico e genuino."),
    DishRatingModel(voto: "4.0", titolo: "Il mare non c'è", commento: "Pesce congelato senza sapore"),
    DishRatingModel(voto: "6.5", titolo: "Il mare..forse", commento: "Pescato locale sicuramente di primissima qualità, cucinato forse un po' male."),
    DishRatingModel(voto: "10.0", titolo: "Amazing", commento: "I saw the sea from the terrace and feel it in this amazing dish, with a true salty taste!! To eat again again again again for ever!!! I would like to be there again next summer hoping to find Marco and Graziella, two amazing host!! They provide us all kind of amenities, helping with baby food, gluten free, no Milk. No other place in Sicily gave to us such amazing help!!")
    
    ] */
    
    static var previews: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color("SeaTurtlePalette_1").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        ForEach(ratings,id:\.self) { rate in
                            
                            
                            DishRating_RowView(rating: rate)
                            
                            
                        }
                        
                    }
                }
                
               
            }
        }
    }
}
