## HarmonyOS X Deepseek (ArkUI)

一个基于 HarmonyOS Next（Stage 模式）与 ArkUI（ETS）的简洁聊天应用示例，集成 DeepSeek Chat/Reasoner 模型，提供消息对话、打字机动画展示、基础设置与持久化存储等功能。
### 界面展示
- **聊天界面**:

*正常聊天界面*

![img](https://github.com/SJYssr/img/raw/main/HarmonyOS%20X%20Deepseek/%E6%AD%A3%E5%B8%B8%E8%81%8A%E5%A4%A9%E7%95%8C%E9%9D%A2.png)

*深色聊天界面*

![img](https://github.com/SJYssr/img/raw/main/HarmonyOS%20X%20Deepseek/%E6%B7%B1%E8%89%B2%E8%81%8A%E5%A4%A9%E7%95%8C%E9%9D%A2.png)

- **设置界面**:

*正常设置界面*

![img](https://github.com/SJYssr/img/raw/main/HarmonyOS%20X%20Deepseek/%E6%AD%A3%E5%B8%B8%E8%AE%BE%E7%BD%AE%E7%95%8C%E9%9D%A2.png)

*深色设置界面*

![img](https://github.com/SJYssr/img/raw/main/HarmonyOS%20X%20Deepseek/%E6%B7%B1%E8%89%B2%E8%AE%BE%E7%BD%AE%E7%95%8C%E9%9D%A2.png)

- **效果预览**:

*正常回答效果*

![img](https://github.com/SJYssr/img/raw/main/HarmonyOS%20X%20Deepseek/%E6%AD%A3%E5%B8%B8%E5%9B%9E%E7%AD%94%E6%95%88%E6%9E%9C.png)

*深色回答效果*

![img](https://github.com/SJYssr/img/raw/main/HarmonyOS%20X%20Deepseek/%E6%B7%B1%E8%89%B2%E5%9B%9E%E7%AD%94%E6%95%88%E6%9E%9C.png)

### 功能特性
- **聊天对话**: 发送消息并获取 DeepSeek 模型回复，支持逐字打字机动画展示。
- **模型切换**: 在设置中切换 `deepseek-chat` 与 `deepseek-reasoner` 模型。
- **密钥管理**: 在本地偏好（Preferences）中安全持久化保存 API Key 与模型配置。
- **基础导航**: 使用 `Tabs` 在“聊天”和“设置”页之间切换。
- **网络权限**: 已申请 `ohos.permission.INTERNET`。

### 技术栈
- ArkUI（ETS）组件式开发
- Stage 模式（`UIAbility`）
- HTTP 能力：`@ohos.net.http`
- 偏好存储：`@ohos.data.preferences`

### 目录结构
```
AppScope/
  app.json5                 # 应用级配置
  resources/                # 应用级资源
entry/
  src/main/ets/
    entryability/EntryAbility.ets        # 入口 Ability，加载首页
    entrybackupability/EntryBackupAbility.ets
    pages/Index.ets                      # 顶层 Tabs 容器
    pages/ChatPage.ets                   # 聊天页面逻辑与 UI
    pages/SettingsPage.ets               # 设置页面（API Key / 模型）
    services/DeepSeekService.ets         # DeepSeek 接口封装
    services/SettingsService.ets         # 偏好存储封装
    types/AiTypes.ets                    # 类型定义
  src/main/module.json5                  # 模块与权限配置
  resources/                             # 模块资源（颜色、媒体、页面配置等）
  build-profile.json5                    # 模块构建配置
  hvigorfile.ts                          # 模块 Hvigor 配置
build-profile.json5                      # 工程构建配置（含签名/产品）
hvigorfile.ts                            # 工程 Hvigor 配置
oh-package.json5 / entry/oh-package.json5
```

### 运行环境
- HarmonyOS Next（5.0.5 及以上）SDK
- DevEco Studio（推荐）或 Hvigor CLI
- 电脑操作系统：Windows（本工程路径示例基于 Windows）

### 快速开始
1) 打开工程
- 使用 DevEco Studio 打开项目根目录 `MyApplication1`。

2) 连接设备/模拟器
- 连接 HarmonyOS 设备或启动模拟器（需与 SDK 版本匹配）。

3) 配置 DeepSeek API Key（应用内）
- 首次运行后，切换到“设置”页：
  - 在“API Key”输入框中粘贴你的 DeepSeek 密钥。
  - 选择模型：`deepseek-chat` 或 `deepseek-reasoner`。
  - 点击“保存设置”。

4) 构建与运行
- DevEco Studio：在工具栏选择目标设备，点击 Run。
- Hvigor CLI（可选）：
  - 在工程根目录执行（Windows PowerShell）
    ```bash
    # 生成调试包（示例，具体命令以本地 Hvigor 版本为准）
    hvigorw assembleDebug | cat
    hvigorw installDebug | cat
    ```

### 关键模块说明
- `EntryAbility.ets`
  - 初始化应用配色模式、初始化 `SettingsService` 上下文，并加载主页 `pages/Index`。
- `Index.ets`
  - 使用 `Tabs` 构建两页：`ChatPage` 与 `SettingsPage`。
- `ChatPage.ets`
  - 输入并发送用户消息，调用 `DeepSeekService.createChatCompletion` 获取回复。
  - 采用逐字显示动画，将最终回复追加到消息列表。
- `SettingsPage.ets`
  - 管理 API Key 与模型，使用 `SettingsService` 持久化保存。
- `DeepSeekService.ets`
  - 基于 `@ohos.net.http` 调用 `https://api.deepseek.com/chat/completions`。
  - 需要在请求头中携带 `Authorization: Bearer <API_KEY>`。
- `SettingsService.ets`
  - 通过 `@ohos.data.preferences` 存储/读取 `api_key` 与 `model`。

### 配置与常量
- Bundle 名：`com.example.myapplication1`（见 `AppScope/app.json5`）。
- 权限：`ohos.permission.INTERNET`（见 `entry/src/main/module.json5`）。
- 设备类型：phone、tablet、2in1。
- 入口页面：`pages/Index`。

### 安全与合规
- 请妥善保管 DeepSeek API Key，不要将真实密钥提交到仓库。
- 工程 `build-profile.json5` 中包含用于本地开发的签名配置路径，仅用于本机调试；请勿在公共仓库中提交真实签名材料。

### 测试
- 单元与集成测试样例位于：
  - `entry/ohosTest/ets/test/*`
  - `entry/test/*`
- 可在 DevEco Studio 的测试工具窗口运行。

### 常见问题
- 运行后提示“请先在设置中配置 API Key”：
  - 打开应用“设置”页，填入有效的 DeepSeek 密钥并保存。
- 返回内容为空或 HTTP 非 2xx：
  - 检查网络与密钥是否正确、配额是否充足。
  - 观察日志输出，定位 `DeepSeekService` 抛出的错误信息。
- 颜色/资源未正常加载：
  - 检查 `entry/src/main/resources` 下资源与引用标识是否一致。

## 🎁 赞赏支持

<div align="center">
<p>如果您觉得此项目对您有所帮助，可以扫描以下二维码进行赞赏支持：</p>

<img src="https://github.com/SJYssr/img/raw/main/1/zanshang.jpg" alt="赞赏码" width="200">

<p><i>您的支持是我持续更新的动力</i></p>
</div>

## ⚖️ 免责声明

<div style="padding: 15px; border: 1px solid #d9534f; background-color:rgb(238, 156, 156); border-radius: 5px; margin: 10px 0;">
<h4>⚠️ 免责声明</h4>
<ul>
<li>本代码遵循 <a href="https://github.com/SJYssr/SJYssr/blob/main/LICENSE">GPL-3.0 License</a> 协议，允许<strong>开源/免费使用和引用/修改/衍生代码的开源/免费使用</strong>，不允许<strong>修改和衍生的代码作为闭源的商业软件发布和销售</strong>，禁止<strong>使用本代码盈利</strong>，以此代码为基础的程序<strong>必须</strong>同样遵守 <a href="https://github.com/SJYssr/SJYssr/blob/main/LICENSE">GPL-3.0 License</a>协议</li>
<li>本代码仅用于<strong>学习讨论</strong>，禁止<strong>用于盈利</strong>和<strong>非法用途</strong></li>
<li>他人或组织使用本代码进行的任何<strong>违法行为</strong>与本人无关</li>
<li>使用本项目造成的任何后果由使用者自行承担</li>
</ul>
</div>

---

<div align="center">
<p>Made with ❤️ by <a href="https://github.com/SJYssr">SJYssr</a></p>
<p>
  <a href="#">回到顶部</a> •
  <a href="https://github.com/SJYssr/HarmonyOS-X-Deepseek-/issues">报告问题</a> •
  <a href="https://github.com/SJYssr/SJYssr/blob/main/LICENSE">许可协议</a>
</p>
</div>


