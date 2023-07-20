//
//  BlueSwipeModeView.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/11/23.
//

import SwiftUI

struct HungryModeView: View {
    @State var card: Card
    @SceneStorage("HungryMode") var HungryMode: Bool = false

    let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .topLeading) {
                    if let image = card.image {
                        Image(uiImage: image)
                            .resizable()
                            .clipped()
                    }
                    LinearGradient(gradient: cardGradient, startPoint: .top, endPoint: .bottom)
                    VStack {
                        Spacer()
                        VStack(alignment: .leading) {
                            HStack {
                                Text(card.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text(String(card.age))
                                    .font(.title)
                            }
                            Text(card.bio)
                                .font(.body)
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Adjust the frame to fit the card content
                .cornerRadius(8)
                .offset(x: card.x, y: card.y)
                .rotationEffect(.init(degrees: card.degree))
                .gesture (
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.default) {
                                card.x = value.translation.width
                                card.y = value.translation.height
                                card.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                            }
                        }
                        .onEnded { (value) in
                            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                                switch value.translation.width {
                                case 0...100:
                                    card.x = 0; card.degree = 0; card.y = 0
                                case let x where x > 100:
                                    card.x = 500; card.degree = 12
                                    let swipedProfileID = card.id
                                    rightSwipe(swipedProfileID: swipedProfileID) { error in
                                        if let error = error {
                                            print("Error swiping right: \(error.localizedDescription)")
                                        } else {
                                            print("Swiped right successfully!")
                                        }
                                    }
                                case (-100)...(-1):
                                    card.x = 0; card.degree = 0; card.y = 0
                                case let x where x < -100:
                                    card.x  = -500; card.degree = -12
                                default:
                                    card.x = 0; card.y = 0
                                }
                            }
                        }
                )
                
                Spacer()
                
                Button(action: {
                    HungryMode = false
                }) {
                    Text("Hungry")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(8)
                }
                .padding(.bottom, 16)
            }
            .padding(.bottom, 40)
            //NavigationSection()
        }
    }
}





/**struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.data[0])
            .previewLayout(.sizeThatFits)
    }
}
*/

