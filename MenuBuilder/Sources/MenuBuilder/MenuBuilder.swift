@resultBuilder
public struct MenuBuilder {
    public static func buildBlock() -> [Menu] {
        []
    }
}

public protocol MenuConvertible {
    func asMenu() -> [Menu]
}

public extension MenuBuilder {
    static func buildBlock(_ components: MenuConvertible...) -> [Menu] {
        components.flatMap { $0.asMenu() }
    }
    
    static func buildOptional(_ component: [Menu]?) -> [Menu] {
        component ?? []
    }
    
    static func buildEither(first component: [Menu]) -> [Menu] {
        component
    }
    
    static func buildEither(second component: [Menu]) -> [Menu] {
        component
    }
    
}

public func makeMenu(@MenuBuilder _ content: () -> [Menu]) -> [Menu] {
    content()
}

public struct Button: MenuConvertible {
    var title: String
    var action: () -> Void
    
    public func asMenu() -> [Menu] {
        [.init(title: title,
               action: action,
               childrenContent: {})]

    }
}

public struct Menu: MenuConvertible {
    var title: String
    var action: (() -> Void)?
    @MenuBuilder var childrenContent: () -> [Menu]
    
    var children: [Menu]? {
        let children = childrenContent()
        
        if children.isEmpty {
            return nil
        }
        
        return children
    }
    
    public func asMenu() -> [Menu] {
        [.init(title: title,
               action: action,
               childrenContent: childrenContent)]
    }
}

public struct Divider: MenuConvertible {
    public func asMenu() -> [Menu] {
        [.init(title: "",
               action: nil,
               childrenContent: {})]
    }
}
