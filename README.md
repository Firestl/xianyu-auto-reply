# 🐟 闲鱼自动回复系统

## 📋 项目概述

一个功能完整的闲鱼自动回复和管理系统，采用现代化的技术架构，支持多用户、多账号管理，具备智能回复、自动发货、自动确认发货、商品管理等企业级功能。系统基于Python异步编程，使用FastAPI提供RESTful API，SQLite数据库存储，支持Docker一键部署。

## 🏗️ 技术架构

### 核心技术栈
- **后端框架**: FastAPI + Python 3.11+ 异步编程
- **数据库**: SQLite 3 + 多用户数据隔离 + 自动迁移
- **前端**: Bootstrap 5 + Vanilla JavaScript + 响应式设计
- **通信协议**: WebSocket + RESTful API + 实时通信
- **部署方式**: Docker + Docker Compose + 一键部署
- **日志系统**: Loguru + 文件轮转 + 实时收集
- **安全认证**: JWT + 图形验证码 + 邮箱验证 + 权限控制


## 📁 项目结构

<details>
<summary>点击展开查看详细项目结构</summary>

```
xianyu-auto-reply/
├── 📄 核心文件
│   ├── Start.py                    # 项目启动入口，初始化所有服务
│   ├── XianyuAutoAsync.py         # 闲鱼WebSocket连接和消息处理核心
│   ├── reply_server.py            # FastAPI Web服务器和完整API接口
│   ├── db_manager.py              # SQLite数据库管理，支持多用户数据隔离
│   ├── cookie_manager.py          # 多账号Cookie管理和任务调度
│   ├── ai_reply_engine.py         # AI智能回复引擎，支持多种AI模型
│   ├── order_status_handler.py    # 订单状态处理和更新模块
│   ├── file_log_collector.py      # 实时日志收集和管理系统
│   ├── config.py                  # 全局配置文件管理器
│   ├── usage_statistics.py        # 用户统计和数据分析模块
│   ├── simple_stats_server.py     # 简单统计服务器（可选）
│   ├── secure_confirm_ultra.py    # 自动确认发货模块（多层加密保护）
│   ├── secure_confirm_decrypted.py # 自动确认发货模块（解密版本）
│   ├── secure_freeshipping_ultra.py # 自动免拼发货模块（多层加密保护）
│   └── secure_freeshipping_decrypted.py # 自动免拼发货模块（解密版本）
├── 🛠️ 工具模块
│   └── utils/
│       ├── xianyu_utils.py        # 闲鱼API工具函数（加密、签名、解析）
│       ├── message_utils.py       # 消息格式化和处理工具
│       ├── ws_utils.py            # WebSocket客户端封装
│       ├── image_utils.py         # 图片处理和管理工具
│       ├── image_uploader.py      # 图片上传到闲鱼CDN
│       ├── image_utils.py         # 图片处理工具（压缩、格式转换）
│       ├── item_search.py         # 商品搜索功能（基于Playwright，无头模式）
│       ├── order_detail_fetcher.py # 订单详情获取工具
│       └── qr_login.py            # 二维码登录功能
├── 🌐 前端界面
│   └── static/
│       ├── index.html             # 主管理界面（集成所有功能模块）
│       ├── login.html             # 用户登录页面
│       ├── register.html          # 用户注册页面（邮箱验证）
│       ├── js/
│       │   └── app.js             # 主要JavaScript逻辑和所有功能模块
│       ├── css/
│       │   ├── variables.css      # CSS变量定义
│       │   ├── layout.css         # 布局样式
│       │   ├── components.css     # 组件样式
│       │   ├── accounts.css       # 账号管理样式
│       │   ├── keywords.css       # 关键词管理样式
│       │   ├── items.css          # 商品管理样式
│       │   ├── logs.css           # 日志管理样式
│       │   ├── notifications.css  # 通知样式
│       │   ├── dashboard.css      # 仪表板样式
│       │   ├── admin.css          # 管理员样式
│       │   └── app.css            # 主应用样式
│       ├── lib/
│       │   ├── bootstrap/         # Bootstrap框架
│       │   └── bootstrap-icons/   # Bootstrap图标
│       ├── uploads/
│       │   └── images/            # 上传的图片文件
│       ├── xianyu_js_version_2.js # 闲鱼JavaScript工具库
│       ├── wechat-group.png       # 微信群二维码
│       └── qq-group.png           # QQ群二维码
├── 🐳 Docker部署
│   ├── Dockerfile                 # Docker镜像构建文件（优化版）
│   ├── Dockerfile-cn             # 国内优化版Docker镜像构建文件
│   ├── docker-compose.yml        # Docker Compose一键部署配置
│   ├── docker-compose-cn.yml     # 国内优化版Docker Compose配置
│   ├── docker-deploy.sh          # Docker部署管理脚本（Linux/macOS）
│   ├── docker-deploy.bat         # Docker部署管理脚本（Windows）
│   ├── entrypoint.sh              # Docker容器启动脚本
│   └── .dockerignore             # Docker构建忽略文件
├── 🌐 Nginx配置
│   └── nginx/
│       ├── nginx.conf            # Nginx反向代理配置
│       └── ssl/                  # SSL证书目录
├── 📋 配置文件
│   ├── global_config.yml         # 全局配置文件（WebSocket、API等）
│   ├── requirements.txt          # Python依赖包列表（精简版，无内置模块）
│   ├── .gitignore                # Git忽略文件配置（完整版）
│   └── README.md                 # 项目说明文档（本文件）
└── 📊 数据目录（运行时创建）
    ├── data/                     # 数据目录（Docker挂载，自动创建）
    │   ├── xianyu_data.db        # SQLite主数据库文件
    │   ├── user_stats.db         # 用户统计数据库
    │   └── xianyu_data_backup_*.db # 数据库备份文件
    ├── logs/                     # 按日期分割的日志文件
    └── backups/                  # 其他备份文件
```

</details>

## 🏗️ 系统架构

```
┌─────────────────────────────────────┐
│           Web界面 (FastAPI)         │
│         用户管理 + 功能界面          │
└─────────────┬───────────────────────┘
              │
┌─────────────▼───────────────────────┐
│        CookieManager               │
│         多账号任务管理              │
└─────────────┬───────────────────────┘
              │
┌─────────────▼───────────────────────┐
│      XianyuLive (多实例)           │
│     WebSocket连接 + 消息处理        │
└─────────────┬───────────────────────┘
              │
┌─────────────▼───────────────────────┐
│        SQLite数据库                │
│   用户数据 + 商品信息 + 配置数据     │
└─────────────────────────────────────┘
```

## 📁 核心文件功能说明

### 🚀 核心启动模块
- **`Start.py`** - 项目启动入口，初始化CookieManager和FastAPI服务，从数据库加载账号任务并启动后台API服务，支持环境变量配置
- **`XianyuAutoAsync.py`** - 闲鱼WebSocket连接核心，处理消息收发、自动回复、指定商品回复、自动发货、商品信息收集、AI回复
- **`reply_server.py`** - FastAPI Web服务器，提供完整的管理界面和RESTful API接口，支持多用户系统、JWT认证、权限管理
- **`cookie_manager.py`** - 多账号Cookie管理器，负责账号任务的启动、停止、状态管理和线程安全操作，支持数据库持久化

### 🗄️ 数据和配置管理
- **`db_manager.py`** - SQLite数据库管理器，支持多用户数据隔离、自动迁移、版本管理、完整的CRUD操作、邮箱验证、系统设置
- **`config.py`** - 全局配置文件管理器，加载YAML配置和环境变量，提供配置项访问接口，支持动态配置更新
- **`global_config.yml`** - 全局配置文件，包含WebSocket、API、自动回复、AI、通知等所有系统配置项

### 🤖 智能功能模块
- **`ai_reply_engine.py`** - AI智能回复引擎，支持OpenAI、通义千问等多种AI模型，意图识别、上下文管理、个性化回复
- **`secure_confirm_ultra.py`** - 自动确认发货模块，采用多层加密保护，调用闲鱼API确认发货状态，支持锁机制防并发
- **`secure_freeshipping_ultra.py`** - 自动免拼发货模块，支持批量处理、异常恢复、智能匹配、规格识别
- **`file_log_collector.py`** - 实时日志收集器，提供Web界面日志查看、搜索、过滤、下载和管理功能

### 🛠️ 工具模块 (`utils/`)
- **`xianyu_utils.py`** - 闲鱼API核心工具，包含加密算法、签名生成、数据解析、Cookie处理、请求封装
- **`message_utils.py`** - 消息处理工具，格式化消息内容、变量替换、内容过滤、模板渲染、表情处理
- **`ws_utils.py`** - WebSocket客户端封装，处理连接管理、心跳检测、重连机制、消息队列、异常恢复
- **`qr_login.py`** - 二维码登录功能，生成登录二维码、状态检测、Cookie获取、验证、自动刷新
- **`item_search.py`** - 商品搜索功能，基于Playwright获取真实闲鱼商品数据，支持分页、过滤、排序
- **`order_detail_fetcher.py`** - 订单详情获取工具，解析订单信息、买家信息、SKU详情，支持缓存优化、锁机制
- **`image_utils.py`** - 图片处理工具，支持压缩、格式转换、尺寸调整、水印添加、质量优化
- **`image_uploader.py`** - 图片上传工具，支持多种CDN服务商、自动压缩、格式优化、批量上传
- **`xianyu_slider_stealth.py`** - 增强版滑块验证模块，采用高级反检测技术，支持密码登录、自动重试、并发控制，包含授权期限验证机制（可编译为二进制模块以提升性能和安全性）
- **`refresh_util.py`** - Cookie刷新工具，自动检测和刷新过期的Cookie，保持账号连接状态

### 🌐 前端界面 (`static/`)
- **`index.html`** - 主管理界面，集成所有功能模块：账号管理、关键词管理、商品管理、发货管理、系统监控、用户管理等
- **`login.html`** - 用户登录页面，支持图形验证码、记住登录状态、多重安全验证
- **`register.html`** - 用户注册页面，支持邮箱验证码、实时验证、密码强度检测
- **`js/app.js`** - 主要JavaScript逻辑，包含所有功能模块：前端交互、API调用、实时更新、数据管理、用户界面控制
- **`css/`** - 模块化样式文件，包含布局、组件、主题等分类样式，响应式设计，支持明暗主题切换
- **`xianyu_js_version_2.js`** - 闲鱼JavaScript工具库，加密解密、数据处理、API封装
- **`lib/`** - 前端依赖库，包含Bootstrap 5、Bootstrap Icons等第三方库
- **`uploads/images/`** - 图片上传目录，支持发货图片和其他媒体文件存储

### 🐳 部署配置
- **`Dockerfile`** - Docker镜像构建文件，基于Python 3.11-slim，包含Playwright浏览器、C编译器（支持Nuitka编译）、系统依赖，支持无头模式运行，优化构建层级，自动编译性能关键模块
- **`Dockerfile-cn`** - 国内优化版Docker镜像构建文件，使用国内镜像源加速构建，适合国内网络环境
- **`docker-compose.yml`** - Docker Compose配置，支持一键部署、完整环境变量配置、资源限制、健康检查、可选Nginx代理
- **`docker-compose-cn.yml`** - 国内优化版Docker Compose配置文件，使用国内镜像源
- **`docker-deploy.sh`** - Docker部署管理脚本，提供构建、启动、停止、重启、监控、日志查看等功能（Linux/macOS）
- **`docker-deploy.bat`** - Windows版本部署脚本，支持Windows环境一键部署和管理
- **`docs/github-actions-auto-deploy.md`** - GitHub Actions 自动部署说明，支持推送代码后服务器自动拉取并重启 Docker 容器
- **`entrypoint.sh`** - Docker容器启动脚本，增强版包含环境验证、依赖检查、目录创建、权限设置和详细启动日志
- **`nginx/nginx.conf`** - Nginx反向代理配置，支持负载均衡、SSL终端、WebSocket代理、静态文件服务
- **`requirements.txt`** - Python依赖包列表，精简版本无内置模块，按功能分类组织，包含详细版本说明和安装指南
- **`.gitignore`** - Git忽略文件配置，完整覆盖Python、Docker、前端、测试、临时文件等，2025年更新包含编译产物、浏览器缓存、统计数据等新规则
- **`.dockerignore`** - Docker构建忽略文件，优化构建上下文大小和构建速度，排除不必要的文件和目录，2025年更新包含浏览器数据等新规则
