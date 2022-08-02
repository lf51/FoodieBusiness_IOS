//
//  DishRatingListView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/08/22.
//

import SwiftUI

struct DishRatingListView: View {
    
    let dishTitle: String
    let dishRating: [DishRating]
    let ratingsCount: String
    let mediaRating: String
    let backgroundColorView: Color
    
    @State private var minMaxRange: (Int,Int) = (0,10)
    //@State private var maxRange: Int = 10
    
    init(dishItem:DishModel,backgroundColorView: Color) {
        self.dishTitle = dishItem.intestazione
        self.dishRating = dishItem.rating
       
        (self.mediaRating,self.ratingsCount) = csIterateDishRating(item: dishItem)
        self.backgroundColorView = backgroundColorView
    }
    
    var body: some View {
       
        CSZStackVB(title: dishTitle, backgroundColorView: backgroundColorView) {
        
            VStack {
                                
                HStack {
                    
                    csSplitRatingByVote()
                        .font(.system(.subheadline, design: .rounded, weight: .light))
                 //   Spacer()
                    
                    VStack {
                        
                        Text(mediaRating)
                            .fontWeight(.black)
                            .font(.largeTitle)
                            .foregroundColor(Color("SeaTurtlePalette_3"))
                        Text("\(self.ratingsCount) recensioni")
                            .font(.subheadline)
                            .foregroundColor(Color("SeaTurtlePalette_3"))
                    }
                    
                    
                }
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        ForEach(dishRating,id:\.self) { rate in
                            // da ordinare seguendo la data
                            if rate.isVoteInRange(min: minMaxRange.0, max: minMaxRange.1) {
                                DishRating_RowView(rating: rate) }
                            
                        }
                        
                    }
                }
                
                CSDivider()
            } // chiusa Vstack Madre
            .padding(.horizontal)
            
        }
    }
    
    // method
    
    private func csSplitRatingByVote() -> some View {
        
        let fromZeroToSix = "da 0 a 6"
        let fromSixTo8 = "da 7 a 8"
       // let from8To9 = "da 8.1 a 9"
        let from9To10 = "da 9 a 10"
        
        var ratingContainer: [String:Int] = [fromZeroToSix:0,fromSixTo8:0,from9To10:0]
        let ratingRangeValue: [String:(Int,Int)] = [fromZeroToSix:(0,6),fromSixTo8:(6,8),from9To10:(9,10)]
        
        for rating in self.dishRating {
            
            guard let vote = Double(rating.voto) else { continue }
            
            if vote <= 6.0 { ratingContainer[fromZeroToSix]! += 1 }
            else if vote <= 8.0 { ratingContainer[fromSixTo8]! += 1 }
            else { ratingContainer[from9To10]! += 1 }
        }
        
        
        
        return VStack(alignment:.leading) {

          ForEach(ratingContainer.sorted(by: >), id: \.key) { key, value in
                        
              let isTheRangeActive = self.minMaxRange == ratingRangeValue[key]!
              
              HStack {
                  
                  Text(key)
                      .foregroundColor(Color.black)
                  Text("( \(value) )")
                      .fontWeight(.black)
                      .foregroundColor(Color("SeaTurtlePalette_3"))
                  
                  Button {
                      withAnimation {
                          self.minMaxRange = isTheRangeActive ? (0,10) : ratingRangeValue[key]!
                      }
                  } label: {
                      Image(systemName: isTheRangeActive ? "eye" : "eye.slash")
                          .imageScale(.medium)
                          .foregroundColor(Color("SeaTurtlePalette_3"))
                          .opacity(isTheRangeActive ? 1.0 : 0.6)
                  }

                  Spacer()
                  
                  
                    }
            }
        }
        
       // interna
    }
    
   
    
}

struct DishRatingListView_Previews: PreviewProvider {
    
    static var dishItem: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Spaghetti alla Carbo"
        newDish.rating = [
            DishRating(voto: "8.0", titolo: "Strepitoso", commento: "Materie Prime eccezzionali perfettamente combinate fra loro per un gusto autentico e genuino."),
            DishRating(voto: "5.0", titolo: "Il mare non c'è", commento: "Pesce congelato senza sapore"),
            DishRating(voto: "9.0", titolo: "Il mare..forse", commento: "Pescato locale sicuramente di primissima qualità, cucinato forse un po' male."),
            DishRating(voto: "10.0", titolo: "Amazing", commento: "I saw the sea from the terrace and feel it in this amazing dish, with a true salty taste!! To eat again again again again for ever!!! I would like to be there again next summer hoping to find Marco and Graziella, two amazing host!! They provide us all kind of amenities, helping with baby food, gluten free, no Milk. No other place in Sicily gave to us such amazing help!!"),
            DishRating(voto: "4.0", titolo: "Sapore di Niente", commento: "NoComment")
            
            ]
        return newDish
    }()
    
  //  static var title = "Spaghetti alla Carbonara"
    static var background = Color("SeaTurtlePalette_1")
    
  /*  static var ratings: [DishRating] = [
    DishRating(voto: "8.9", titolo: "Strepitoso", commento: "Materie Prime eccezzionali perfettamente combinate fra loro per un gusto autentico e genuino."),
    DishRating(voto: "4.0", titolo: "Il mare non c'è", commento: "Pesce congelato senza sapore"),
    DishRating(voto: "9.5", titolo: "Il mare..forse", commento: "Pescato locale sicuramente di primissima qualità, cucinato forse un po' male."),
    DishRating(voto: "10.0", titolo: "Amazing", commento: "I saw the sea from the terrace and feel it in this amazing dish, with a true salty taste!! To eat again again again again for ever!!! I would like to be there again next summer hoping to find Marco and Graziella, two amazing host!! They provide us all kind of amenities, helping with baby food, gluten free, no Milk. No other place in Sicily gave to us such amazing help!!"),
    DishRating(voto: "4.0", titolo: "Sapore di Niente", commento: "NoComment")
    
    ] */
    
    static var previews: some View {
        
        NavigationStack {
            
            DishRatingListView(dishItem:dishItem, backgroundColorView: background)
            
        }
        
    }
}

