import Foundation
import SwiftUI

struct GreyPhysicsEntryScreen: View {
    @StateObject private var loader: GreyPhysicsWebLoader

    init(loader: GreyPhysicsWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            GreyPhysicsWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                GreyPhysicsProgressIndicator(value: percent)
            case .failure(let err):
                GreyPhysicsErrorIndicator(err: err)  // err теперь String
            case .noConnection:
                GreyPhysicsOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct GreyPhysicsProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            GreyPhysicsLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct GreyPhysicsErrorIndicator: View {
    let err: String  // было Error, стало String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct GreyPhysicsOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
