//
//  Model.swift
//  SmallFoodApp
//
//  Created by hazem smawy on 10/2/22.
//

import SwiftUI

struct MilkShake:Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title:String
    var price:String
    var image:String

}

var milkShakes: [MilkShake] = [
    .init(title: "Milk Frappe", price: "$53.33", image: "1"),
    .init(title: "Milk & Chocalate\nFrappe", price: "$29.99", image: "5"),
    .init(title: "Frappuccino", price: "$59.99", image: "1"),
    .init(title: "Espresso", price: "$19.33", image: "5"),
    .init(title: "Creme Frappuccino", price: "$23.99", image: "1")

]

struct Tab:Identifiable {
    var id: String = UUID().uuidString
    var tabImage:String
    var tabName:String
    var tabOffset:CGSize
}
var tabs:[Tab] =
[
    .init(tabImage: "4", tabName: "Hot\nCoffee", tabOffset: CGSize(width:0, height: -40)),
    .init(tabImage: "6", tabName: "Frappo", tabOffset: CGSize(width:0, height: -38)),
    .init(tabImage: "7", tabName: "Ice Cream", tabOffset: CGSize(width: 0, height: -25)),
    .init(tabImage: "4", tabName: "Waffles", tabOffset: CGSize(width: -12, height: 28))

]
