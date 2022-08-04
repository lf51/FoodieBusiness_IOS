//
//  DishModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI

struct DishModel_RowView: View {
    
    let item: DishModel
    
    var body: some View {
        
        CSZStackVB_Framed {
            
            VStack(alignment:.leading) {
                
                VStack{

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()
 
                }
                 .padding(.top,5)
                
                VStack(spacing:10){
                    
                    vbDieteCompatibili()
                    
                    vbIngredientScrollRow()
 
                    vbAllergeneScrollRowView(listaAllergeni: self.item.allergeni)
                       
                }
                .padding(.vertical,5)
                
            } // chiuda VStack madre
            .padding(.horizontal)
                            
        } // chiusa Zstack Madre
    
    }
    
    // Method
    
    @ViewBuilder private func vbIntestazioneDishRow() -> some View {
        
        HStack(alignment:.bottom) {
            
            Text(self.item.intestazione)
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundColor(Color.white)
            
            Spacer()
            
            vbEstrapolaStatusImage(itemModel: self.item)
            
        }
        
    }
    
    @ViewBuilder private func vbSubIntestazioneDishRow() -> some View {
        
        let (price,count) = csIterateDishPricing()
        let (mediaRating,ratingCount) = csIterateDishRating(item: self.item)
        
        HStack(alignment:.bottom,spacing: 3) {
            
            Text(mediaRating) // media
                .fontWeight(.light)
                .foregroundColor(Color("SeaTurtlePalette_1"))
                .padding(.horizontal,5)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color("SeaTurtlePalette_2"))
                )
               // ._tightPadding()
              /*  .background(
                    Circle()
                        .fill(Color("SeaTurtlePalette_2"))
                )*/
            
            Group {
                Text("/")
                Text("\(ratingCount) recensioni") // valore da importare
                    .italic()
            }
            .fontWeight(.semibold)
            .foregroundColor(Color("SeaTurtlePalette_2"))
            
            Spacer()
            
            HStack(alignment:.top,spacing:1) {
                
                Text("€ \(price)")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(Color("SeaTurtlePalette_4"))
                
                Text("+\(count)")
                    .fontWeight(.bold)
                    .font(.caption2)
                    .foregroundColor(Color("SeaTurtlePalette_3"))
            }
            
            
        }
       .font(.subheadline)
        
    }
    /*
    private func csIterateDishRating() -> (media:String,count:String) {
        
        var sommaVoti: Double = 0.0
        var mediaRating: String = "0.00"
        
        let ratingCount: Int = self.item.rating.count
        let stringCount = String(ratingCount)
        
        guard !self.item.rating.isEmpty else {
            
            return (mediaRating,stringCount)
        }
        
        for rating in self.item.rating {
            
            let voto = Double(rating.voto)
            sommaVoti += voto ?? 0.00
        }
        
        let mediaAritmetica = sommaVoti / Double(ratingCount)
        mediaRating = String(format:"%.1f", mediaAritmetica)
        return (mediaRating,stringCount)
        
    } */ // deprecata come Private - resa Public per essere utilizzata nella DishRatingList
    
    private func csIterateDishPricing() -> (price:String,count:String) {
        
        var mandatoryPrice:String = "0.00"
        let pricingCount = self.item.pricingPiatto.count
        let normalizedCount = pricingCount > 0 ? (pricingCount - 1) : pricingCount
        let stringCount:String = String(normalizedCount)
        
        guard !self.item.pricingPiatto.isEmpty else {
          
            return (mandatoryPrice,stringCount)
        }
            
            for format in self.item.pricingPiatto {
                
                if format.type == .mandatory {
                    mandatoryPrice = format.price
                    break
                }
               
            }

            return (mandatoryPrice,stringCount)
            
    }
    
    @ViewBuilder private func vbDieteCompatibili() -> some View {
        
        HStack(spacing: 4.0) {
            
            Image(systemName: "person.fill.checkmark")
                .imageScale(.medium)
                .foregroundColor(Color("SeaTurtlePalette_4"))
         
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(spacing: 2.0) {
                    
                    ForEach(self.item.dieteCompatibili) { diet in
                        
                        Text(diet.simpleDescription())
                            .font(.callout)
                            .fontWeight(.black)
                            .foregroundColor(Color("SeaTurtlePalette_4"))
                        
                        Text("•")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("SeaTurtlePalette_4"))

                    }
                }
            }
        }
    }
    
    @ViewBuilder private func vbIngredientScrollRow() -> some View {
        
        let allTheIngredients = self.item.ingredientiPrincipali + self.item.ingredientiSecondari
        
      //  VStack {

            HStack(spacing: 4.0) {
                
                Image(systemName: "list.bullet.rectangle")
                    .imageScale(.medium)
                    .foregroundColor(Color("SeaTurtlePalette_4"))
             
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(spacing: 2.0) {
                        
                        ForEach(allTheIngredients) { ingredient in
                            
                            let isPrincipal = self.item.ingredientiPrincipali.contains(ingredient)
                            let hasAllergene = !ingredient.allergeni.isEmpty
                            
                            Text(ingredient.intestazione)
                                .font(isPrincipal ? .headline : .subheadline)
                                .foregroundColor(Color("SeaTurtlePalette_4"))
                                .overlay(alignment:.topTrailing) {
                                    if hasAllergene {
                                        Text("*")
                                            .foregroundColor(Color.black)
                                            .offset(x: 5, y: -3)
                                    }
                                }
                            
                            Text("•")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("SeaTurtlePalette_4"))
                            
                        }
                    }
                }
            }
       // }
    }
    
    
    
} // chiusa Struct


struct DishModel_RowView_Previews: PreviewProvider {
    
   
        
    static let ing1 = IngredientModel(intestazione: "Guanciale", descrizione: "", conservazione: .congelato, produzione: .biologico, provenienza: .italia, allergeni: [.anidride_solforosa_e_solfiti,.arachidi_e_derivati], origine: .carneAnimale, status: .vuoto, idIngredienteDiRiserva: "")
        
    static let ing2 = IngredientModel(intestazione: "Prezzemolo", descrizione: "", conservazione: .congelato, produzione: .convenzionale, provenienza: .restoDelMondo, allergeni: [.sedano], origine: .vegetale, status: .vuoto, idIngredienteDiRiserva: "")
    static let ing3 = IngredientModel(intestazione: "Latte Scremato", descrizione: "", conservazione: .altro, produzione: .biologico, provenienza: .europa, allergeni: [.glutine], origine: .latteAnimale, status: .vuoto, idIngredienteDiRiserva: "")
    
    static let ing4 = IngredientModel(intestazione: "Basilico", descrizione: "", conservazione: .altro, produzione: .biologico, provenienza: .europa, allergeni: [], origine: .vegetale, status: .vuoto, idIngredienteDiRiserva: "")
    
    static var dishSample = {
       
        var dish = DishModel()
        dish.intestazione = "Spaghetti alla Carbonara"
        dish.status = .completo(.inPausa)
        dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ]
        
        let price = {
           var priceFirst = DishFormat(type: .mandatory)
            priceFirst.price = "12.5"
            return priceFirst
        }()
        
        dish.pricingPiatto = [price]
        dish.ingredientiPrincipali = [ing1,ing2]
        dish.ingredientiSecondari = [ing3,ing4]
        dish.allergeni = AllergeniIngrediente.returnAllergeniIn(ingredients: [ing1,ing2,ing3,ing4])
        
        return dish
    }()
    static var dishSample2 = {
       
        var dish = DishModel()
        dish.intestazione = "Bucatini alla Matriciana"
        dish.status = .completo(.archiviato)
        dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ]
        
        let price1 = {
           var priceFirst = DishFormat(type: .opzionale)
            priceFirst.label = "Pizzetta"
            priceFirst.price = "4.5"
            return priceFirst
        }()
        let price2 = {
           var priceFirst = DishFormat(type: .opzionale)
            priceFirst.label = "Pizza"
            priceFirst.price = "9.5"
            return priceFirst
        }()
        let price3 = {
           var priceFirst = DishFormat(type: .mandatory)
            priceFirst.label = "Tabisca"
            priceFirst.price = "14.9"
            return priceFirst
        }()
        
        dish.pricingPiatto = [price1,price2,price3]
        dish.ingredientiPrincipali = [ing1,ing4]
        dish.ingredientiSecondari = [ing2,ing3]
        dish.allergeni = AllergeniIngrediente.returnAllergeniIn(ingredients: [ing1,ing2,ing3,ing4])
        dish.dieteCompatibili = TipoDieta.returnDietAvaible(ingredients: [ing1,ing2,ing3,ing4]).inDishTipologia
        
        return dish
    }()
    static var dishSample3 = {
       
        var dish = DishModel()
        dish.intestazione = "Trofie Pesto Noci e Gamberi"
        dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ]
        
        let price1 = {
           var priceFirst = DishFormat(type: .mandatory)
            priceFirst.label = "Mezza Pinta"
            priceFirst.price = "4.0"
            return priceFirst
        }()
        let price2 = {
           var priceFirst = DishFormat(type: .opzionale)
            priceFirst.label = "Pinta"
            priceFirst.price = "7.5"
            return priceFirst
        }()
    
        dish.pricingPiatto = [price1,price2]
        dish.ingredientiPrincipali = [ing3]
        dish.ingredientiSecondari = [ing1,ing2,ing4]
        dish.allergeni = AllergeniIngrediente.returnAllergeniIn(ingredients: [ing1,ing2,ing3,ing4])
        
        return dish
    }()
    
    static var dishSample4 = {
       
        var dish = DishModel()
        dish.intestazione = "Birra bionda alla Spina"
        dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ]
        
        let price1 = {
           var priceFirst = DishFormat(type: .mandatory)
            priceFirst.label = "Mezza Pinta"
            priceFirst.price = "4.0"
            return priceFirst
        }()
        let price2 = {
           var priceFirst = DishFormat(type: .opzionale)
            priceFirst.label = "Pinta"
            priceFirst.price = "7.5"
            return priceFirst
        }()
    
        dish.pricingPiatto = [price1,price2]
        dish.ingredientiPrincipali = [ing4]
        dish.allergeni = AllergeniIngrediente.returnAllergeniIn(ingredients: [ing4])
        
        
        return dish
    }()
    
    
    static var previews: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color("SeaTurtlePalette_1").ignoresSafeArea()
                
                VStack(spacing:15) {

                    
                    DishModel_RowView(item: dishSample)
                    DishModel_RowView(item: dishSample2)
                    DishModel_RowView(item: dishSample3)
                    DishModel_RowView(item: dishSample4)
                    
                }
                
            }
            
        }
        
    }
}


