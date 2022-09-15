//
//  DishModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI

struct DishModel_RowView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let item: DishModel
  //  let listaAllergeni:[AllergeniIngrediente]
    
 /*   init(item: DishModel) {
        self.item = item
        self.listaAllergeni = item.calcolaAllergeniNelPiatto(viewModel: viewModel)
    } */
  //  var idSelectedIngredient: String = ""
  //  var nomeIngredienteSostituto: String = ""
    
    var body: some View {
        
        CSZStackVB_Framed {
            
            VStack(alignment:.leading) {
                
                VStack{

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()
 
                }
                 .padding(.top,5)
                
                Spacer()
                
                vbIngredientScrollRow()
                
                Spacer()
                
                VStack(spacing:5){
                    
                    vbDieteCompatibili()
                    
                 //   vbIngredientScrollRow()
                    let listaAllergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
                    vbAllergeneScrollRowView(listaAllergeni: listaAllergeni)
                  //  vbAllergeneScrollRowView(listaAllergeni: self.item.allergeni)
                       
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
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundColor(Color.white)
            
            Spacer()
            
            vbEstrapolaStatusImage(itemModel: self.item)
            
        }
        
    }
    
    @ViewBuilder private func vbSubIntestazioneDishRow() -> some View {
        
        let (price,count) = csIterateDishPricing()
      //  let (mediaRating,ratingCount) = csIterateDishRating(item: self.item)
        let (mediaRating,ratingCount,_) = self.item.ratingInfo(readOnlyViewModel: viewModel)
        
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
        
        let dietAvaible = self.item.returnDietAvaible(viewModel: self.viewModel).inStringa
        
        HStack(spacing: 4.0) {
            
            Image(systemName: "person.fill.checkmark")
                .imageScale(.medium)
                .foregroundColor(Color("SeaTurtlePalette_4"))
         
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(spacing: 2.0) {
                    
                    ForEach(dietAvaible,id:\.self) { diet in
                        
                        Text(diet)
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
        
        // Modifiche 26.08 - 30.08

     /*   let allIngredientsID = self.item.ingredientiPrincipali + self.item.ingredientiSecondari
        let allTheIngredients = self.viewModel.modelCollectionFromCollectionID(collectionId: allIngredientsID, modelPath: \.allMyIngredients)
        let allFilteredIngredients = allTheIngredients.filter({
            $0.status != .completo(.archiviato) &&
            $0.status != .bozza
        }) */
        
        let allFilteredIngredients = self.item.allMinusArchiviati(viewModel: self.viewModel)
        let areAllBio = self.item.areAllIngredientBio(viewModel: self.viewModel)
        // end 26.08
            HStack(spacing: 4.0) {
               
                if areAllBio {
                    
                    VStack(spacing:0) {
                        
                        Text("💯")
                        Text("BIO")
                            .font(.system(.caption2, design: .monospaced, weight: .black))
                            .foregroundColor(Color("SeaTurtlePalette_1"))
                        
                    }.background(Color.green.cornerRadius(5.0))
                } else {
                    
                    Image(systemName: "list.bullet.rectangle")
                        .imageScale(.medium)
                        .foregroundColor(Color("SeaTurtlePalette_4"))
                }

                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(alignment:.lastTextBaseline, spacing: 2.0) {
                        
                        ForEach(allFilteredIngredients) { ingredient in
                            
                            let (isPrincipal,hasAllergene,isTemporaryOff,idSostituto,isBio) = self.analizingIngredient(ingredient: ingredient)
                            
                           HStack(spacing:5) {
                                
                               Text(ingredient.intestazione)
                                    .font(isPrincipal ? .headline : .subheadline)
                                    .foregroundColor(isTemporaryOff ? Color("SeaTurtlePalette_1") : Color("SeaTurtlePalette_4"))
                                    .strikethrough(isTemporaryOff, color: Color.gray)
                                    .underline(isBio, pattern: .solid, color: Color.green)
                                    .overlay(alignment:.topTrailing) {
                                        if hasAllergene {
                                            Text("*")
                                                .foregroundColor(Color.black)
                                                .offset(x: 5, y: -3)
                                        }
                                    }
                                
                            /*   if isBio {
                                   Text("✅")
                                       .font(.caption2)
                                  //     .font(.system(.caption2, design: .monospaced, weight: .black))
                                      // .foregroundColor(Color.green)
                                     //  .background(Color("SeaTurtlePalette_4").cornerRadius(5.0))
                                   
                               } */
                               // Modifiche 30.08
                               /* if isTemporaryOff && isThereSostituto {
                                    
                                    Text("(\(nameSostituto))")
                                        .font(isPrincipal ? .headline : .subheadline)
                                        .foregroundColor(Color("SeaTurtlePalette_3"))
                                } */
                               if idSostituto != nil {
                                    
                                   let (isActive,name,allergeniIn) = self.viewModel.infoFromId(id: idSostituto!, modelPath: \.allMyIngredients)
                                   
                                   if isActive {
                                       
                                       Text("(\(name))")
                                           .font(isPrincipal ? .headline : .subheadline)
                                           .foregroundColor(Color("SeaTurtlePalette_3"))
                                           .overlay(alignment:.topTrailing) {
                                               if allergeniIn {
                                                   Text("*")
                                                       .foregroundColor(Color.black)
                                                       .offset(x: 5, y: -3)
                                               }
                                           }
                                   }
                                   
                                    
                                }
                               // end 30.08
                            }
                            
                            Text("•")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("SeaTurtlePalette_4"))
           
                        }
                    }
                }
            }
       // }
    }
    
    private func analizingIngredient(ingredient:IngredientModel) -> (isPrincipal:Bool,hasAllergene:Bool,isTemporary:Bool,idSostituto:String?,isBio:Bool) {
        
        let allTemporaryOff = self.item.elencoIngredientiOff
        
        let isPrincipal = self.item.ingredientiPrincipali.contains(ingredient.id)
        let hasAllergene = !ingredient.allergeni.isEmpty
        let isItBio = ingredient.produzione == .biologico
        // Modifiche 30.08
        
       // let isOff = allTemporaryOff.keys.contains(ingredient.id)
        var isOff: Bool = false
        
        if self.item.idIngredienteDaSostituire == ingredient.id {isOff = true}
      //  else { isOff = ingredient.status == .completo(.inPausa) }
        else { isOff = ingredient.status.checkStatusTransition(check: .inPausa) }
       // let isOff = ingredient.status == .completo(.inPausa)
        var idSostituto: String? = nil
        
      //  var isThereSosti: Bool = false
      //  var nomeSosti: String = ""
        
        if isOff {
            
            for (key,value) in allTemporaryOff {
                
                if ingredient.id == key {
                    // Modifica 02.09
                    let isAlreadyIn = self.item.checkIngredientsInPlain(idIngrediente: value)
                    idSostituto = isAlreadyIn ? nil : value
                    // end - Vedi Nota Vocale 02.09 - bug "Menta(Mango)" 
                    break
                }
                
               /* if ingredient.id == key && value != nil {
                    isThereSosti = true
                    nomeSosti = self.viewModel.nomeIngredienteFromId(id: value!) ?? ""
                    break
                } */
                
            }
        }
        
        return (isPrincipal,hasAllergene,isOff,idSostituto,isItBio)
        // end 30.08

    }
    
    /*
    private func analizingIngredient(ingredient:IngredientModel) -> (isPrincipal:Bool,hasAllergene:Bool,isTemporary:Bool,isThereSostituto:Bool,nomeSostituto:String) {
        
        let allTemporaryOff = self.item.elencoIngredientiOffDEPRECATO
        
        let isPrincipal = self.item.ingredientiPrincipaliDEPRECATO.contains(ingredient)
        let hasAllergene = !ingredient.allergeni.isEmpty
            
        let isOff = allTemporaryOff.keys.contains(ingredient.id)
        var isThereSosti: Bool = false
        var nomeSosti: String = ""
        
        if isOff {
            
            for (key,value) in allTemporaryOff {
                
                if ingredient.id == key && value != nil {
                    isThereSosti = true
                    nomeSosti = value!.intestazione
                    break
                }
                
            }
        }
        
        return (isPrincipal,hasAllergene,isOff,isThereSosti,nomeSosti)
       
        
        
      /*  let (isTemporaryOff,isThereSostituto,nameSostituto):(Bool,Bool,String) = {
                
            guard allTemporaryOff.keys.contains(ingredient.id) else {
               return (false,false,"")
            }
            
            if let modelSostituto = allTemporaryOff[ingredient.id] {
                let nomeSostituto = modelSostituto!.intestazione
                return (true,true,nomeSostituto)
           
            } else {
                return(true,false,"")
            }

            
            }() */
        
        
    } */ // Deprecata 26.08
    
    /*
    @ViewBuilder private func vbIngredientScrollRow() -> some View {
        
        let allTheIngredients = self.item.ingredientiPrincipali + self.item.ingredientiSecondari
        let allTemporaryOff = self.item.sostituzioneIngredientiTemporanea
        
      //  VStack {

            HStack(spacing: 4.0) {
                
                Image(systemName: "list.bullet.rectangle")
                    .imageScale(.medium)
                    .foregroundColor(Color("SeaTurtlePalette_4"))
             
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(alignment:.lastTextBaseline, spacing: 2.0) {
                        
                        ForEach(allTheIngredients) { ingredient in
                            
                        let isPrincipal = self.item.ingredientiPrincipali.contains(ingredient)
                        let hasAllergene = !ingredient.allergeni.isEmpty
                            
                        let (isTemporaryOff,isThereSostituto,nameSostituto):(Bool,Bool,String) = {
                                
                            guard allTemporaryOff.keys.contains(ingredient.id) else {
                               return (false,false,"")
                            }
                            var nomeSostituto = allTemporaryOff[ingredient.id]!
                            let isSostituto = nomeSostituto != ""
                            if isSostituto {
                                nomeSostituto = self.viewModel.findModelFromId(id: nomeSostituto)
                            }
                            return (true,isSostituto,nomeSostituto)
                            }()
                            
                           HStack(spacing:5) {
                                
                                Text(ingredient.intestazione)
                                    .font(isPrincipal ? .headline : .subheadline)
                                    .foregroundColor(isTemporaryOff ? Color("SeaTurtlePalette_1") : Color("SeaTurtlePalette_4"))
                                    .strikethrough(isTemporaryOff, color: Color.gray)
                                    .overlay(alignment:.topTrailing) {
                                        if hasAllergene {
                                            Text("*")
                                                .foregroundColor(Color.black)
                                                .offset(x: 5, y: -3)
                                        }
                                    }
                                
                                if isTemporaryOff && isThereSostituto {
                                    
                                    Text("(\(nameSostituto))")
                                        .font(isPrincipal ? .headline : .subheadline)
                                        .foregroundColor(Color("SeaTurtlePalette_3"))
                                }
    
                            }
                            
                            Text("•")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("SeaTurtlePalette_4"))
           
                        }
                    }
                }
            }
       // }
    } */ // deprecata 11.08
    
    
   /* @ViewBuilder private func vbIngredientScrollRow() -> some View {
        
        let allTheIngredients = self.item.ingredientiPrincipali + self.item.ingredientiSecondari
        
      //  VStack {

            HStack(spacing: 4.0) {
                
                Image(systemName: "list.bullet.rectangle")
                    .imageScale(.medium)
                    .foregroundColor(Color("SeaTurtlePalette_4"))
             
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(alignment:.lastTextBaseline, spacing: 2.0) {
                        
                        ForEach(allTheIngredients) { ingredient in
                            
                            let isPrincipal = self.item.ingredientiPrincipali.contains(ingredient)
                            let hasAllergene = !ingredient.allergeni.isEmpty
                            let isSelected = ingredient.id == idSelectedIngredient
                            let isThereSostituto: Bool = nomeIngredienteSostituto != ""
                            
                            HStack(spacing:5) {
                                
                                Text(ingredient.intestazione)
                                    .font(isPrincipal ? .headline : .subheadline)
                                    .foregroundColor(isSelected ? Color.blue : Color("SeaTurtlePalette_4"))
                                    .strikethrough(isSelected && isThereSostituto, color: Color.gray)
                                    .overlay(alignment:.topTrailing) {
                                        if hasAllergene {
                                            Text("*")
                                                .foregroundColor(Color.black)
                                                .offset(x: 5, y: -3)
                                        }
                                    }
                                
                                if isSelected && isThereSostituto {
                                    
                                    Text("\(nomeIngredienteSostituto)")
                                        .font(isPrincipal ? .headline : .subheadline)
                                        .foregroundColor(Color("SeaTurtlePalette_3"))
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
    }*/ //BackUp 08.08
    
    
    
} // chiusa Struct


struct DishModel_RowView_Previews: PreviewProvider {
    
    static var viewModel:AccounterVM = AccounterVM()
        
    static let ing1 = IngredientModel(intestazione: "Guanciale", descrizione: "", conservazione: .congelato, produzione: .biologico, provenienza: .italia, allergeni: [], origine: .animale, status: .completo(.disponibile))
        
    static let ing2 = IngredientModel(intestazione: "Prezzemolo", descrizione: "", conservazione: .congelato, produzione: .convenzionale, provenienza: .restoDelMondo, allergeni: [.sedano], origine: .vegetale, status: .completo(.inPausa))
    
    static let ing3 = IngredientModel(intestazione: "Latte Scremato", descrizione: "", conservazione: .altro, produzione: .biologico, provenienza: .europa, allergeni: [.latte_e_derivati], origine: .animale, status: .bozza())
    
    static let ing4 = IngredientModel(intestazione: "Basilico", descrizione: "", conservazione: .altro, produzione: .biologico, provenienza: .europa, allergeni: [.senape], origine: .vegetale, status: .completo(.disponibile))
    
    static var dishSample = {
       
        var dish = DishModel()
        dish.intestazione = "Spaghetti alla Carbonara"
        dish.status = .completo(.disponibile)
      /*  dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ] */
        
        let price = {
           var priceFirst = DishFormat(type: .mandatory)
            priceFirst.price = "12.5"
            return priceFirst
        }()
        
        dish.pricingPiatto = [price]
        dish.ingredientiPrincipali = [ing1.id,ing2.id]
        dish.ingredientiSecondari = [ing3.id]
        dish.elencoIngredientiOff = [ing2.id:ing4.id]
        
        
        return dish
    }()
    static var dishSample2 = {
       
        var dish = DishModel()
        dish.intestazione = "Bucatini alla Matriciana"
        dish.status = .completo(.disponibile)
      /*  dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ] */
        
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
        dish.ingredientiPrincipali = [ing1.id,ing4.id]
        dish.ingredientiSecondari = [ing2.id,ing3.id]

      /*  dish.dieteCompatibili = TipoDieta.returnDietAvaible(ingredients: [ing1,ing2,ing3,ing4]).inDishTipologia */
        
        return dish
    }()
    static var dishSample3 = {
       
        var dish = DishModel()
        dish.intestazione = "Trofie Pesto Noci e Gamberi"
      /*  dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),
            DishRatingModel(voto: "6.7", titolo: "", commento: ""),
            DishRatingModel(voto: "8.7", titolo: "", commento: ""),
            DishRatingModel(voto: "9.7", titolo: "", commento: ""),
            DishRatingModel(voto: "9.7", titolo: "", commento: ""),
            DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ] */
        
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
        dish.status = .completo(.disponibile)
        dish.pricingPiatto = [price1,price2]
        dish.ingredientiPrincipali = [ing3.id]
        dish.ingredientiSecondari = [ing1.id,ing2.id,ing4.id]
    
        
        return dish
    }()
    
    static var dishSample4 = {
       
        var dish = DishModel()
        dish.intestazione = "Birra bionda alla Spina"
       /* dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ] */
        
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
    
        dish.status = .completo(.disponibile)
        dish.pricingPiatto = [price1,price2]
        dish.ingredientiPrincipali = [ing4.id]

        
        
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
        .onAppear{
            viewModel.allMyIngredients = [ing1,ing2,ing3,ing4]
        }
        .environmentObject(viewModel)
        
    }
}


