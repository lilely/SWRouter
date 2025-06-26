import XCTest
import SWRouter
import UIKit

class Tests: XCTestCase {
    
    var router: Router!
    
    override func setUp() {
        super.setUp()
        router = Router.shared
        // 清理之前的注册
        router.container.removeAll()
    }
    
    override func tearDown() {
        router.container.removeAll()
        router = nil
        super.tearDown()
    }
    
    // MARK: - 基础路由测试
    func testBasicRouteRegistration() {
        // 测试无参数路由注册
        router.register(UIViewController.self, route: TestRouteKey.test) { resolver in
            return UIViewController()
        }
        
        let result = router.viewController(for: TestRouteKey.test)
        switch result {
        case .success(let vc):
            XCTAssertTrue(vc is UIViewController)
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    func testSingleParameterRoute() {
        // 测试单参数路由注册
        router.register(UIViewController.self, route: TestRouteKey.testWithParam) { (resolver, param: String) in
            let vc = UIViewController()
            vc.title = param
            return vc
        }
        
        let result = router.viewController(for: TestRouteKey.testWithParam, arg: "test")
        switch result {
        case .success(let vc):
            XCTAssertEqual(vc.title, "test")
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    func testMultipleParametersRoute() {
        // 测试多参数路由注册
        router.register(UIViewController.self, route: TestRouteKey.testWithMultipleParams) { (resolver, param1: String, param2: String) in
            let vc = UIViewController()
            vc.title = "\(param1)_\(param2)"
            return vc
        }
        
        let result = router.viewController(for: TestRouteKey.testWithMultipleParams, arguments: "test1", "test2")
        switch result {
        case .success(let vc):
            XCTAssertEqual(vc.title, "test1_test2")
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    func testThreeParametersRoute() {
        // 测试三参数路由注册
        router.register(UIViewController.self, route: TestRouteKey.testWithThreeParams) { (resolver, param1: String, param2: String, param3: String) in
            let vc = UIViewController()
            vc.title = "\(param1)_\(param2)_\(param3)"
            return vc
        }
        
        let result = router.viewController(for: TestRouteKey.testWithThreeParams, arguments: "test1", "test2", "test3")
        switch result {
        case .success(let vc):
            XCTAssertEqual(vc.title, "test1_test2_test3")
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 错误处理测试
    func testRouteNotFound() {
        let result = router.viewController(for: TestRouteKey.nonExistent)
        
        switch result {
        case .success:
            XCTFail("应该返回失败")
        case .failure(let error):
            XCTAssertEqual(error, RouterError.routeNotFound("non_existent"))
            XCTAssertEqual(error.localizedDescription, "路由未找到: non_existent")
        }
    }
    
    func testInvalidRouteKey() {
        let invalidKey = InvalidRouteKey()
        let result = router.viewController(for: invalidKey)
        
        switch result {
        case .success:
            XCTFail("应该返回失败")
        case .failure(let error):
            XCTAssertEqual(error, RouterError.routeNotFound(""))
            XCTAssertEqual(error.localizedDescription, "路由未找到: ")
        }
    }
    
    func testRouteNotFoundWithParameters() {
        let result = router.viewController(for: TestRouteKey.nonExistent, arg: "test")
        
        switch result {
        case .success:
            XCTFail("应该返回失败")
        case .failure(let error):
            XCTAssertEqual(error, RouterError.routeNotFound("non_existent"))
        }
    }
    
    // MARK: - 依赖注入测试
    func testDependencyInjection() {
        // 注册服务
        router.container.register(TestService.self) { _ in
            return TestService()
        }
        
        // 注册依赖服务的视图控制器
        router.register(UIViewController.self, route: TestRouteKey.testWithDependency) { resolver in
            let service = resolver.resolve(TestService.self)!
            return TestViewController(service: service)
        }
        
        let result = router.viewController(for: TestRouteKey.testWithDependency)
        switch result {
        case .success(let vc):
            XCTAssertTrue(vc is TestViewController)
            let testVC = vc as! TestViewController
            XCTAssertNotNil(testVC.service)
            XCTAssertEqual(testVC.service.doSomething(), "test")
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    func testChainedDependencyInjection() {
        // 注册基础服务
        router.container.register(NetworkService.self) { _ in
            return NetworkService()
        }
        
        // 注册依赖网络服务的数据服务
        router.container.register(DataService.self) { resolver in
            let networkService = resolver.resolve(NetworkService.self)!
            return DataService(networkService: networkService)
        }
        
        // 注册依赖数据服务的视图控制器
        router.register(UIViewController.self, route: TestRouteKey.testWithChainedDependency) { resolver in
            let dataService = resolver.resolve(DataService.self)!
            return DataTestViewController(dataService: dataService)
        }
        
        let result = router.viewController(for: TestRouteKey.testWithChainedDependency)
        switch result {
        case .success(let vc):
            XCTAssertTrue(vc is DataTestViewController)
            let dataVC = vc as! DataTestViewController
            XCTAssertNotNil(dataVC.dataService)
            XCTAssertEqual(dataVC.dataService.getData(), "网络数据")
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Container 扩展测试
    func testContainerResolveRoute() {
        router.register(UIViewController.self, route: TestRouteKey.test) { resolver in
            return UIViewController()
        }
        
        let result = router.container.resolveRoute(key: TestRouteKey.test)
        switch result {
        case .success(let vc):
            XCTAssertTrue(vc is UIViewController)
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    func testContainerResolveRouteWithParameter() {
        router.register(UIViewController.self, route: TestRouteKey.testWithParam) { (resolver, param:String) in
            let vc = UIViewController()
            vc.title = param
            return vc
        }
        
        let result = router.container.resolveRoute(key: TestRouteKey.testWithParam, argument: "test_param")
        switch result {
        case .success(let vc):
            XCTAssertEqual(vc.title, "test_param")
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    func testContainerResolveRouteWithMultipleParameters() {
        router.register(UIViewController.self, route: TestRouteKey.testWithMultipleParams) { (resolver, param1: String, param2: String) in
            let vc = UIViewController()
            vc.title = "\(param1)_\(param2)"
            return vc
        }
        
        let result = router.container.resolveRoute(key: TestRouteKey.testWithMultipleParams, arguments: "param1", "param2")
        switch result {
        case .success(let vc):
            XCTAssertEqual(vc.title, "param1_param2")
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 路由覆盖测试
    func testRouteOverride() {
        // 第一次注册
        router.register(UIViewController.self, route: TestRouteKey.test) { resolver in
            let vc = UIViewController()
            vc.title = "first"
            return vc
        }
        
        // 第二次注册，应该覆盖第一次
        router.register(UIViewController.self, route: TestRouteKey.test) { resolver in
            let vc = UIViewController()
            vc.title = "second"
            return vc
        }
        
        let result = router.viewController(for: TestRouteKey.test)
        switch result {
        case .success(let vc):
            XCTAssertEqual(vc.title, "second")
        case .failure(let error):
            XCTFail("路由解析失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 线程安全测试
    func testThreadSafety() {
        router.register(UIViewController.self, route: TestRouteKey.test) { resolver in
            return UIViewController()
        }
        
        let expectation = XCTestExpectation(description: "Thread safety test")
        let queue = DispatchQueue.global(qos: .default)
        
        for _ in 0..<10 {
            queue.async {
                let result = self.router.viewController(for: TestRouteKey.test)
                switch result {
                case .success:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("线程安全测试失败: \(error.localizedDescription)")
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - 性能测试
    func testPerformanceExample() {
        router.register(UIViewController.self, route: TestRouteKey.test) { resolver in
            return UIViewController()
        }
        
        self.measure() {
            // 测试路由解析性能
            for _ in 0..<1000 {
                let result = router.viewController(for: TestRouteKey.test)
                switch result {
                case .success:
                    break
                case .failure:
                    XCTFail("性能测试中路由解析失败")
                }
            }
        }
    }
    
    func testPerformanceWithParameters() {
        router.register(UIViewController.self, route: TestRouteKey.testWithParam) { (resolver, param: String) in
            return UIViewController()
        }
        
        self.measure() {
            // 测试带参数的路由解析性能
            for _ in 0..<1000 {
                let result = router.viewController(for: TestRouteKey.testWithParam, arg: "test")
                switch result {
                case .success:
                    break
                case .failure:
                    XCTFail("性能测试中路由解析失败")
                }
            }
        }
    }
    
    // MARK: - 内存管理测试
    func testMemoryManagement() {
        weak var weakVC: UIViewController?
        
        router.register(UIViewController.self, route: TestRouteKey.test) { resolver in
            let vc = UIViewController()
            weakVC = vc
            return vc
        }
        
        let result = router.viewController(for: TestRouteKey.test)
        switch result {
        case .success(let vc):
            XCTAssertNotNil(weakVC)
            XCTAssertEqual(weakVC, vc)
        case .failure(let error):
            XCTFail("内存管理测试失败: \(error.localizedDescription)")
        }
        
        // 清理容器
        router.container.removeAll()
        
        // 验证内存释放
        // 注意：由于Router是单例，这里主要是测试容器清理
        let newResult = router.viewController(for: TestRouteKey.test)
        switch newResult {
        case .success:
            XCTFail("容器清理后应该返回失败")
        case .failure:
            // 这是预期的结果
            break
        }
    }
}

// MARK: - 测试辅助类型
enum TestRouteKey: RoutableKey {
    case test
    case testWithParam
    case testWithMultipleParams
    case testWithThreeParams
    case testWithDependency
    case testWithChainedDependency
    case nonExistent
    
    var routeKey: String {
        switch self {
        case .test:
            return "test"
        case .testWithParam:
            return "test_with_param"
        case .testWithMultipleParams:
            return "test_with_multiple_params"
        case .testWithThreeParams:
            return "test_with_three_params"
        case .testWithDependency:
            return "test_with_dependency"
        case .testWithChainedDependency:
            return "test_with_chained_dependency"
        case .nonExistent:
            return "non_existent"
        }
    }
}

struct InvalidRouteKey: RoutableKey {
    var routeKey: String {
        return ""
    }
}

class TestService {
    func doSomething() -> String {
        return "test"
    }
}

class NetworkService {
    func fetchData() -> String {
        return "网络数据"
    }
}

class DataService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getData() -> String {
        return networkService.fetchData()
    }
}

class TestViewController: UIViewController {
    let service: TestService
    
    init(service: TestService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DataTestViewController: UIViewController {
    let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
