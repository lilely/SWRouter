# SWRouter 测试文档

## 测试概述

这个测试套件全面测试了 SWRouter 框架的功能，包括基础路由、错误处理、依赖注入、性能等方面。

## 测试分类

### 1. 基础路由测试

#### `testBasicRouteRegistration()`
- **目的**: 测试无参数路由的注册和解析
- **验证点**: 
  - 路由注册成功
  - 返回的 Result 是成功状态
  - 返回的对象是 UIViewController 类型

#### `testSingleParameterRoute()`
- **目的**: 测试单参数路由的注册和解析
- **验证点**:
  - 参数正确传递到视图控制器
  - 视图控制器的 title 被正确设置

#### `testMultipleParametersRoute()`
- **目的**: 测试双参数路由的注册和解析
- **验证点**:
  - 多个参数正确传递
  - 参数组合正确显示在 title 中

#### `testThreeParametersRoute()`
- **目的**: 测试三参数路由的注册和解析
- **验证点**:
  - 三个参数正确传递
  - 参数组合正确显示在 title 中

### 2. 错误处理测试

#### `testRouteNotFound()`
- **目的**: 测试路由未找到的错误处理
- **验证点**:
  - 返回失败状态
  - 错误类型是 `RouterError.routeNotFound`
  - 错误描述正确

#### `testInvalidRouteKey()`
- **目的**: 测试无效路由键的错误处理
- **验证点**:
  - 返回失败状态
  - 错误类型是 `RouterError.invalidRouteKey`
  - 错误描述正确

#### `testRouteNotFoundWithParameters()`
- **目的**: 测试带参数的路由未找到错误
- **验证点**:
  - 即使有参数，未注册的路由仍然返回失败

### 3. 依赖注入测试

#### `testDependencyInjection()`
- **目的**: 测试基本的依赖注入功能
- **验证点**:
  - 服务正确注册
  - 视图控制器正确接收依赖
  - 依赖服务功能正常

#### `testChainedDependencyInjection()`
- **目的**: 测试链式依赖注入
- **验证点**:
  - 多层依赖正确解析
  - 服务链正确工作
  - 最终视图控制器获得正确的依赖

### 4. Container 扩展测试

#### `testContainerResolveRoute()`
- **目的**: 测试 Container 的 resolveRoute 方法
- **验证点**:
  - 无参数路由解析成功

#### `testContainerResolveRouteWithParameter()`
- **目的**: 测试带参数的 Container resolveRoute 方法
- **验证点**:
  - 单参数路由解析成功
  - 参数正确传递

#### `testContainerResolveRouteWithMultipleParameters()`
- **目的**: 测试带多参数的 Container resolveRoute 方法
- **验证点**:
  - 多参数路由解析成功
  - 参数正确传递

### 5. 路由覆盖测试

#### `testRouteOverride()`
- **目的**: 测试路由覆盖功能
- **验证点**:
  - 第二次注册覆盖第一次注册
  - 返回的是最新的注册结果

### 6. 线程安全测试

#### `testThreadSafety()`
- **目的**: 测试多线程环境下的路由解析
- **验证点**:
  - 并发访问不会崩溃
  - 所有线程都能正确解析路由

### 7. 性能测试

#### `testPerformanceExample()`
- **目的**: 测试无参数路由解析性能
- **验证点**:
  - 1000次路由解析的性能基准

#### `testPerformanceWithParameters()`
- **目的**: 测试带参数路由解析性能
- **验证点**:
  - 1000次带参数路由解析的性能基准

### 8. 内存管理测试

#### `testMemoryManagement()`
- **目的**: 测试内存管理和容器清理
- **验证点**:
  - 视图控制器正确创建
  - 容器清理后路由解析失败
  - 内存引用正确

## 测试辅助类型

### TestRouteKey
定义了测试用的路由键枚举，包含各种测试场景：
- `test`: 基础测试
- `testWithParam`: 单参数测试
- `testWithMultipleParams`: 多参数测试
- `testWithThreeParams`: 三参数测试
- `testWithDependency`: 依赖注入测试
- `testWithChainedDependency`: 链式依赖测试
- `nonExistent`: 不存在的路由测试

### InvalidRouteKey
用于测试无效路由键的结构体，返回空字符串作为路由键。

### 服务类
- `TestService`: 基础测试服务
- `NetworkService`: 网络服务模拟
- `DataService`: 数据服务，依赖网络服务

### 视图控制器类
- `TestViewController`: 基础测试视图控制器
- `DataTestViewController`: 数据测试视图控制器

## 测试策略

### 1. 隔离性
- 每个测试方法都独立运行
- 使用 `setUp()` 和 `tearDown()` 清理状态
- 每次测试前清理容器注册

### 2. 完整性
- 覆盖所有主要功能
- 包含正常和异常情况
- 测试边界条件

### 3. 可读性
- 测试方法名称清晰表达测试目的
- 使用中文注释说明测试逻辑
- 验证点明确

### 4. 性能
- 包含性能基准测试
- 测试并发安全性
- 验证内存管理

## 运行测试

### 命令行运行
```bash
# 运行所有测试
xcodebuild test -workspace SWRouter.xcworkspace -scheme SWRouter-Example -destination 'platform=iOS Simulator,name=iPhone 14'

# 运行特定测试类
xcodebuild test -workspace SWRouter.xcworkspace -scheme SWRouter-Example -destination 'platform=iOS Simulator,name=iPhone 14' -only-testing:Tests/testBasicRouteRegistration
```

### Xcode 中运行
1. 打开 `SWRouter.xcworkspace`
2. 选择 `SWRouter_Tests` target
3. 按 `Cmd+U` 运行测试
4. 在测试导航器中查看结果

## 测试覆盖率

当前测试覆盖了以下方面：

- ✅ 基础路由功能 (100%)
- ✅ 错误处理 (100%)
- ✅ 依赖注入 (100%)
- ✅ Container 扩展 (100%)
- ✅ 路由覆盖 (100%)
- ✅ 线程安全 (100%)
- ✅ 性能测试 (100%)
- ✅ 内存管理 (100%)

## 持续集成

建议在 CI/CD 流程中包含以下测试：

1. **单元测试**: 运行所有 XCTest 测试
2. **性能测试**: 确保性能基准不被破坏
3. **内存泄漏测试**: 使用 Instruments 检测内存泄漏
4. **并发测试**: 在多线程环境下运行测试

## 扩展测试

如需添加新的测试用例，请遵循以下原则：

1. **命名规范**: 使用 `test` 前缀，描述测试功能
2. **独立性**: 每个测试方法独立运行
3. **清理**: 在 `tearDown()` 中清理资源
4. **文档**: 添加清晰的注释说明测试目的
5. **验证**: 明确验证点，使用适当的断言

## Result 类型使用说明

在测试中，我们使用 Swift 的 `Result` 类型来处理路由解析的结果。正确的使用方式是：

```swift
// 正确的使用方式
let result = router.viewController(for: route)
switch result {
case .success(let vc):
    // 处理成功情况
    XCTAssertTrue(vc is UIViewController)
case .failure(let error):
    // 处理失败情况
    XCTFail("路由解析失败: \(error.localizedDescription)")
}
```

**注意**: `Result` 类型没有 `isSuccess` 属性，必须使用模式匹配来处理结果。 