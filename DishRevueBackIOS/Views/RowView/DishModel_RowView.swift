//
//  DishModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI

enum RowSize {
    case sintetico,ridotto,normale
}

struct DishModel_RowView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let item: DishModel
    let rowSize:RowSize
    
    init(item: DishModel, rowSize: RowSize = .normale) {
        self.item = item
        self.rowSize = rowSize
    }
    
    var body: some View { vbSwitchRowSize() }
    
    // View da Switchare
    
    @ViewBuilder private func vbSwitchRowSize() -> some View {
        
        switch rowSize {
        case .sintetico:
            vbSinteticRow()
        case .ridotto:
            vbSmallRow()
        case .normale:
            vbNormalRow()
        }
    }
    
    
    @ViewBuilder private func vbSinteticRow() -> some View {
        
        CSZStackVB_Framed(frameWidth:300) {
            
            VStack(alignment:.leading) {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()

            } // chiuda VStack madre
            .padding(.vertical,5)
            .padding(.horizontal)
            
        }
    }
    
    @ViewBuilder private func vbNormalRow() -> some View {
        
        CSZStackVB_Framed {
            
            VStack(alignment:.leading) {
                
                VStack {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()
 
                }
                 .padding(.top,5)
                
                Spacer()
                
                VStack(spacing:5) {
                    
                    vbBadgeRow()
                    vbIngredientScrollRow()
                    vbDieteCompatibili()
                }
                
                Spacer()
                
             //  VStack(spacing:5){
                    
                   // vbDieteCompatibili()

                    let listaAllergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
                    vbAllergeneScrollRowView(listaAllergeni: listaAllergeni)
                     .padding(.bottom,5)
                       
             //   }
               
                
            } // chiuda VStack madre
            .padding(.horizontal)
                            
        } // chiusa Zstack Madre
        
    }
    
    @ViewBuilder private func vbSmallRow() -> some View {
        
        CSZStackVB_Framed(frameWidth:300) {
            
            VStack(alignment:.leading) {
                
                VStack(alignment:.leading) {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()
                
                }
                 .padding(.top,5)
                
                Spacer()
                vbBadgeRow()
                vbNoticeAllergeni()
                    .padding(.bottom,5)

            } // chiuda VStack madre
            .padding(.horizontal)
            
        } // chiusa Zstack Madre
      /*  .overlay(alignment: .bottomTrailing) {
       // !! NOTA VOCALE 20.09 BADGE !!
            HStack(alignment: .center,spacing:2) {
                
                Image(systemName: "fork.knife.circle.fill")
                    .imageScale(.small)
                    .foregroundColor(Color.yellow)
                Text("del Giorno")
                    .bold()
                    .font(.caption)
                    .foregroundColor(Color.white)
                    
            }
            .padding(2)
            .background(content: {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.yellow.opacity(0.4))
            })
                .offset(x: -5, y: -5)
            
        } */
    }
    
    // Method
    
    @ViewBuilder private func vbBadgeRow() -> some View {
        
        let areAllBio = self.item.areAllIngredientBio(viewModel: self.viewModel)
        let isDelGiorno = viewModel.trovaMenuDiSistema(idPiatto: self.item.id, tipoMenu: .delGiorno) != nil
        let isAdviceByTheChef = self.viewModel.trovaMenuDiSistema(idPiatto: self.item.id, tipoMenu: .delloChef) != nil
        
        ScrollView(.horizontal,showsIndicators: false){
            
            HStack {
                
                if areAllBio {
                    
                    CSEtichetta(
                        text: "BIO",
                        textColor: Color("SeaTurtlePalette_1"),
                        image: "💯",
                        imageColor: nil,
                        imageSize: .large,
                        backgroundColor: Color.green,
                        backgroundOpacity: 1.0)
                }
            
                if isDelGiorno {
                    
                    CSEtichetta(
                        text: "del Giorno",
                        textColor: Color.white,
                        image: "fork.knife.circle.fill",
                        imageColor: Color.yellow,
                        imageSize: .medium,
                        backgroundColor: Color.pink,
                        backgroundOpacity: 0.5)
                }

                if isAdviceByTheChef {
                    
                    CSEtichetta(
                        text: "dello Chef",
                        textColor: Color.white,
                        image: "👨🏻‍🍳", //"🗣️", // person.wave.2
                        imageColor: nil,
                        imageSize: .large,
                        backgroundColor: Color.purple,
                        backgroundOpacity: 0.7)
                }
                
            }
            
        }
    }
    
    @ViewBuilder private func vbNoticeAllergeni() -> some View {
        
        let listaAllergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
        let string = listaAllergeni.isEmpty ? "Non contiene Allergeni" : "Contiene Allergeni"
    
        HStack(spacing:4.0) {
            Image(systemName: "allergens")
                .imageScale(.medium)
            Text(string)
        }
        .fontWeight(.semibold)
        .font(.caption)
        .underline(!listaAllergeni.isEmpty)
        .foregroundColor(Color.black)
    }
    
    @ViewBuilder private func vbIntestazioneDishRow() -> some View {
        
        HStack(alignment:.bottom) {
            
            Text(self.item.intestazione)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundColor(Color.white)
              //  .fixedSize()
            
            Spacer()
            
            vbEstrapolaStatusImage(itemModel: self.item)
            
        }
        
    }
    
    @ViewBuilder private func vbSubIntestazioneDishRow() -> some View {
        
        let (price,count) = csIterateDishPricing()
        // add 21.09
        let moneyCode = Locale.current.currency?.identifier ?? "EUR"
        let priceDouble = Double(price) ?? 0
        // end 21.09
      //  let (mediaRating,ratingCount) = csIterateDishRating(item: self.item)
        let (mediaRating,ratingCount,_) = self.item.ratingInfo(readOnlyViewModel: viewModel)
        
        HStack(alignment:.center,spacing: 3) {
            
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
              //  Text("€ \(price)") // 21.09
                Text("\(priceDouble,format: .currency(code: moneyCode))")
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
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(Color("SeaTurtlePalette_4"))
                        
                        Text("•")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("SeaTurtlePalette_4"))

                    }
                }
            }
        }
    }
    
    @ViewBuilder private func vbIngredientScrollRow() -> some View {
        
        // Modifiche 21.09
        let allFilteredIngredients = self.item.allMinusArchiviati(viewModel: self.viewModel)
       // let areAllBio = self.item.areAllIngredientBio(viewModel: self.viewModel)
       
            HStack(spacing: 4.0) {
               
              //  if areAllBio {
                    
                  /*  VStack(spacing:0) {
                        
                        Text("💯")
                        Text("BIO")
                            .font(.system(.caption2, design: .monospaced, weight: .black))
                            .foregroundColor(Color("SeaTurtlePalette_1"))
                        
                    }.background(Color.green.cornerRadius(5.0)) */
              //  } else {
                    
                    Image(systemName: "list.bullet.rectangle")
                        .imageScale(.medium)
                        .foregroundColor(Color("SeaTurtlePalette_4"))
             //   }
                // end 21.09
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
                        .frame(height:150)
                    DishModel_RowView(item: dishSample,rowSize: .ridotto)
                        .frame(height:100)
             
                  //  DishModel_RowView(item: dishSample3)
                  //  DishModel_RowView(item: dishSample4)
                    
                }
                
            }
            
        }
        .onAppear{
            viewModel.allMyIngredients = [ing1,ing2,ing3,ing4]
        }
        .environmentObject(viewModel)
        
    }
}


