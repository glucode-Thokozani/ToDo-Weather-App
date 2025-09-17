//
//  BackgroundView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/15.
//
import SwiftUI

struct BackgroundView: View {
    @StateObject var backgroundViewModel = BackgroundViewModel()
    
    var weatherText: ForecastDay? {
        if backgroundViewModel.dailyForecast.count > 1 {
            return backgroundViewModel.dailyForecast[1]
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            if let weather = weatherText?.day.condition.text {
                LinearGradient(
                    gradient: Gradient(colors: backgroundViewModel.gradientFor(weather: weather)),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if weather.contains("Sunny") {
                    SunnyEffect()
                }
                else if weather.contains("Cloudy") {
                    CloudyEffect()
                }
                else if weather.contains("Rain") {
                    RainEffect()
                } else if weather.contains("Snow") {
                    SnowEffect()
                }
            } else if backgroundViewModel.isLoading {
                ProgressView("Loading weather...")
                    .foregroundStyle(.white)
            } else {
                Text("Unable to load weather.")
                    .foregroundStyle(.white)
            }
        }
        .onAppear {
            Task {
                await backgroundViewModel.getWeatherText(for: "Johannesburg")
            }
        }
    }
}

struct SunnyEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let rotation = Angle.degrees(time.truncatingRemainder(dividingBy: 60) * 6)

            Canvas { context, size in
                let center = CGPoint(x: size.width * 0.85, y: size.height * 0.15)
                let sunRadius: CGFloat = 45
                let rayCount = 16
                let rayInnerRadius = sunRadius + 6
                let rayOuterRadius = sunRadius + 40

                let glowPath = Path(ellipseIn: CGRect(
                    x: center.x - sunRadius * 2,
                    y: center.y - sunRadius * 2,
                    width: sunRadius * 4,
                    height: sunRadius * 4
                ))
                context.addFilter(.blur(radius: 10))
                context.fill(glowPath, with: .radialGradient(
                    Gradient(colors: [.white.opacity(0.25), .clear]),
                    center: center,
                    startRadius: 0,
                    endRadius: sunRadius * 3
                ))
                context.addFilter(.blur(radius: 0))

                let sunCircle = Path(ellipseIn: CGRect(
                    x: center.x - sunRadius,
                    y: center.y - sunRadius,
                    width: sunRadius * 2,
                    height: sunRadius * 2
                ))
                context.fill(sunCircle, with: .radialGradient(
                    Gradient(colors: [.yellow.opacity(0.5), .white.opacity(10.0), .white.opacity(0.9)]),
                    center: center,
                    startRadius: 0,
                    endRadius: sunRadius
                ))
                for i in 0..<rayCount {
                    let angle = Angle.degrees(Double(i) / Double(rayCount) * 360) + rotation
                    let start = CGPoint(
                        x: center.x + cos(angle.radians) * rayInnerRadius,
                        y: center.y + sin(angle.radians) * rayInnerRadius
                    )
                    let end = CGPoint(
                        x: center.x + cos(angle.radians) * rayOuterRadius,
                        y: center.y + sin(angle.radians) * rayOuterRadius
                    )

                    var ray = Path()
                    ray.move(to: start)
                    ray.addLine(to: end)

                    context.stroke(ray, with: .color(Color.white.opacity(0.1)), lineWidth: 5)
                }
            }
        }
        .ignoresSafeArea()
    }
}
struct Cloud {
    var y: CGFloat
    var scale: CGFloat
    var speed: Double
    var xOffset: CGFloat
}

struct CloudyEffect: View {
    let clouds: [Cloud] = [
        Cloud(y: 100, scale: 2.5, speed: 2.0, xOffset: -300),
        Cloud(y: 200, scale: 3.0, speed: 2.3, xOffset: -100),
        Cloud(y: 300, scale: 1.8, speed: 1.5, xOffset: -500),
        Cloud(y: 250, scale: 3.5, speed: 1.8, xOffset: -700),
        Cloud(y: 180, scale: 4.0, speed: 2.1, xOffset: -400)
    ]
    
    func cloudShape() -> Path {
        var path = Path()
        
        let ellipses = [
            CGRect(x: -35, y: -22, width: 70, height: 45),
            CGRect(x: 5, y: -47, width: 60, height: 60),
            CGRect(x: 45, y: -22, width: 70, height: 45),
            CGRect(x: -15, y: -12, width: 80, height: 50)
        ]
        
        for ellipse in ellipses {
            path.addEllipse(in: ellipse)
        }
        return path
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                for cloud in clouds {
                    let xPos = (CGFloat(time * cloud.speed) + cloud.xOffset)
                        .truncatingRemainder(dividingBy: size.width + 1000) - 300
                    
                    let yPos = cloud.y + CGFloat(sin(time * 0.5 + Double(cloud.y))) * 10
                    
                    let morph = 1.0 + 0.03 * CGFloat(sin(time * 0.8 + Double(cloud.y)))
                    let finalScale = cloud.scale * morph
                    
                    var path = cloudShape()
                    let transform = CGAffineTransform(translationX: xPos, y: yPos)
                        .scaledBy(x: finalScale, y: finalScale)
                    path = path.applying(transform)
                    
                    let gradient = Gradient(colors: [
                        Color.white.opacity(0.9),
                        Color.white.opacity(0.1)
                    ])
                    
                    let rect = path.boundingRect
                    context.fill(path, with: .radialGradient(
                        gradient,
                        center: CGPoint(x: rect.midX, y: rect.midY),
                        startRadius: 30,
                        endRadius: 250 * finalScale
                    ))
                }
            }
        }
        .ignoresSafeArea()
        .background(Color.blue.opacity(0.6))
    }
}

struct RainEffect: View {
    let dropCount = 150
    
    // Precompute raindrop data once
    let drops: [DropData] = (0..<150).map { _ in
        DropData(
            x: CGFloat.random(in: 0...1),
            speed: CGFloat.random(in: 150...400),
            length: CGFloat.random(in: 10...25),
            opacity: Double.random(in: 0.3...0.7)
        )
    }
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/60)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                for drop in drops {
                    let distance = CGFloat(time).truncatingRemainder(dividingBy: 10) * drop.speed
                    let y = (distance).truncatingRemainder(dividingBy: size.height + drop.length) - drop.length
                    let x = drop.x * size.width
                    let rect = CGRect(x: x, y: y, width: 1.2, height: drop.length)
                    
                    let gradient = Gradient(stops: [
                        .init(color: .white.opacity(0.0), location: 0.0),
                        .init(color: .white.opacity(drop.opacity), location: 1.0)
                    ])
                    
                    context.fill(
                        Path(rect),
                        with: .linearGradient(
                            gradient,
                            startPoint: CGPoint(x: rect.midX, y: rect.minY),
                            endPoint: CGPoint(x: rect.midX, y: rect.maxY)
                        )
                    )
                }
            }
        }
        .ignoresSafeArea()
        .background(Color.gray)
    }
}

struct DropData {
    var x: CGFloat
    var speed: CGFloat
    var length: CGFloat
    var opacity: Double
}

struct SnowEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for _ in 0..<30 {
                    let x = Double.random(in: 0..<size.width)
                    let y = Double.random(in: 0..<size.height)
                    let circle = CGRect(x: x, y: y, width: 4, height: 4)
                    context.fill(Path(ellipseIn: circle), with: .color(.white))
                }
            }
        }
    }
}

#Preview {
    RainEffect()
}



