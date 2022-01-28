import Foundation

struct MainCellViewModel {
    let id: String
    let title: String
    let imageURL: URL
    
    init(item: GifObject) {
        self.id = item.id
        self.title = item.title
        self.imageURL = item.images.fixed_height.url
    }
}
