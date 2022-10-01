//
//  TestAccount.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/09/22.
//

import Foundation

var testAccount: AccounterVM = {
    
    let today = Date()
    let todayString = csTimeFormatter().data.string(from: today)
    
    let oldDate = Date().addingTimeInterval(-172800)
    let oldDateString = csTimeFormatter().data.string(from: oldDate)
    let otherDate = Date().addingTimeInterval(-259200)
    let otherDateString = csTimeFormatter().data.string(from: otherDate)
    
    let otherDate1 = Date().addingTimeInterval(-388800)
    let otherDateString1 = csTimeFormatter().data.string(from: otherDate1)
    
    let otherDate2 = Date().addingTimeInterval(-583200)
    let otherDateString2 = csTimeFormatter().data.string(from: otherDate2)
    
    var vm = AccounterVM()
     vm.allMyMenu = [menuSample_Test,menuSample2_Test,menuSample3_Test,menuDelGiorno_Test]
     vm.allMyDish = [dishItem3_Test,dishItem4_Test]
     vm.allMyIngredients = [ingredientSample_Test,ingredientSample2_Test,ingredientSample3_Test,ingredientSample4_Test,ingredientSample5_Test,ingredientSample6_Test,ingredientSample7_Test,ingredientSample8_Test]
    vm.inventarioScorte.ingInEsaurimento = [/*ingredientSample5_Test.id,*/ingredientSample6_Test.id,ingredientSample7_Test.id,ingredientSample8_Test.id]
    vm.inventarioScorte.ingEsauriti = [/*ingredientSample_Test.id,*/ingredientSample2_Test.id,ingredientSample3_Test.id,ingredientSample4_Test.id]
    vm.inventarioScorte.cronologiaAcquisti = [
        ingredientSample_Test.id:[otherDateString2,otherDateString1,otherDateString,oldDateString,todayString],ingredientSample5_Test.id:[oldDateString,todayString]
    
    ]
    
     return vm
 }()

 var property_Test:PropertyModel = {
  
    var prp = PropertyModel()
    prp.intestazione = "Osteria del Vicolo"
    prp.cityName = "Sciacca"
    prp.streetAdress = "vicolo San Martino"
    prp.numeroCivico = "22"
    prp.webSite = "https:\\osteriadelvicolo.it"
    prp.phoneNumber = "340 67 13 777"
    return prp
}()

 var dishItem3_Test: DishModel = {
    
    var newDish = DishModel()
    newDish.intestazione = "Bucatini alla Matriciana"
    newDish.status = .completo(.inPausa)
    newDish.ingredientiPrincipali = [ingredientSample4_Test.id]
    newDish.ingredientiSecondari = [ingredientSample2_Test.id]
    let price:DishFormat = {
        var pr = DishFormat(type: .mandatory)
        pr.label = "Porzione"
        pr.price = "22.5"
        return pr
    }()
    let price1:DishFormat = {
        var pr = DishFormat(type: .opzionale)
        pr.label = "1/2 Porzione"
        pr.price = "10.5"
        return pr
    }()
    newDish.pricingPiatto = [price,price1]
    
    return newDish
}()

var dishItem4_Test: DishModel = {
    
    var newDish = DishModel()
    newDish.intestazione = "Trofie al Pesto"
    newDish.status = .completo(.inPausa)
    newDish.ingredientiPrincipali = [ingredientSample_Test.id]
    newDish.ingredientiSecondari = [ingredientSample3_Test.id]
    let price:DishFormat = {
        var pr = DishFormat(type: .mandatory)
        pr.price = "22.5"
        return pr
    }()
    newDish.pricingPiatto = [price]
    
    return newDish
}()

 var menuSample_Test: MenuModel = {

     var menu = MenuModel()
     menu.intestazione = "Pranzo della Domenica di Agosto"
     menu.tipologia = .fisso(persone: .due, costo: "18")
    // menu.tipologia = .allaCarta
     menu.isAvaibleWhen = .dataEsatta
     menu.giorniDelServizio = [.lunedi]
   //  menu.dishInDEPRECATO = [dishItem3]
    menu.rifDishIn = [dishItem3_Test.id]
     menu.status = .bozza(.archiviato)
     
     return menu
 }()
 
  var menuSample2_Test: MenuModel = {
    
     var menu = MenuModel()
     menu.intestazione = "Pranzo della Domenica"
     menu.tipologia = .allaCarta
   //  menu.tipologia = .allaCarta
     menu.giorniDelServizio = [.domenica]
     menu.rifDishIn = [dishItem3_Test.id]
   //  menu.dishInDEPRECATO = [dishItem3]
     menu.status = .completo(.inPausa)
     
     return menu
 }()
 
 var menuSample3_Test: MenuModel = {
    
     var menu = MenuModel()
     menu.intestazione = "Pranzo della"
     menu.tipologia = .fisso(persone: .uno, costo: "18.5")
   //  menu.tipologia = .allaCarta
     menu.giorniDelServizio = [.domenica]
     menu.rifDishIn = [dishItem3_Test.id]
    // menu.dishInDEPRECATO = [dishItem3]
     menu.status = .completo(.inPausa)
     
     return menu
 }()

var menuDelGiorno_Test:MenuModel = {
 
    var mDD = MenuModel(tipologia: .delGiorno)
    mDD.rifDishIn = [dishItem4_Test.id,dishItem3_Test.id]
    return mDD
    
}()
    
var ingredientSample_Test =  IngredientModel(
    intestazione: "Guanciale Nero",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .biologico,
    provenienza: .defaultValue,
    allergeni: [.glutine],
    origine: .animale,
    status: .completo(.disponibile)
)

var ingredientSample2_Test =  IngredientModel(
    intestazione: "Merluzzo",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .surgelato,
    produzione: .biologico,
    provenienza: .italia,
    allergeni: [.pesce],
    origine: .animale,
    status: .bozza(.archiviato)
        )

var ingredientSample3_Test =  IngredientModel(
    intestazione: "Basilico",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .biologico,
    provenienza: .restoDelMondo,
    allergeni: [],
    origine: .vegetale,
    status: .bozza(.disponibile))

 var ingredientSample4_Test =  IngredientModel(
    intestazione: "Mozzarella di Bufala",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .congelato,
    produzione: .convenzionale,
    provenienza: .europa,
    allergeni: [.latte_e_derivati],
    origine: .animale,
    status: .bozza(.inPausa)
)

var ingredientSample5_Test =  IngredientModel(
    intestazione: "Mortadella",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .convenzionale,
    provenienza: .defaultValue,
    allergeni: [.glutine],
    origine: .animale,
    status: .completo(.disponibile)
)

var ingredientSample6_Test =  IngredientModel(
    intestazione: "Gambero Rosa",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .surgelato,
    produzione: .convenzionale,
    provenienza: .italia,
    allergeni: [.pesce],
    origine: .animale,
    status: .bozza(.disponibile)
        )

var ingredientSample7_Test =  IngredientModel(
    intestazione: "Aglio",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .biologico,
    provenienza: .restoDelMondo,
    allergeni: [],
    origine: .vegetale,
    status: .bozza(.disponibile))

 var ingredientSample8_Test =  IngredientModel(
    intestazione: "Pecorino Romano DOP",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .convenzionale,
    provenienza: .europa,
    allergeni: [.latte_e_derivati],
    origine: .animale,
    status: .bozza(.inPausa)
)

