Quant1X量化交易系统使用说明
===


## 1. Quant1X量化系统软件模块清单

| 序号 | 工具名                | 功能      | 下载地址                   |
|:---|:-------------------|:--------|:-----------------------|
| 1  | stock          | 数据采集功能  | [stock](download.html) |
| 2  | quant              | 策略主程序 | [quant](download.html) |
| 3  | 旧版本 | 1.9.x开放版本 | [1.9.x](v1.9.html)     |

## 2. 数据采集(stock)

stock每一级指令都支持--help参数
```shell
stock --help
Usage:
  stock [command]

Available Commands:
  completion  Generate the autocompletion script for the specified shell
  help        Help about any command
  print       打印K线概要
  repair      修复历史数据
  service     守护进程/服务
  update      更新股市数据
  version     显示版本号

Flags:
  -h, --help   help for stock

Use "stock [command] --help" for more information about a command.

总耗时: 0.000s
```

### 2.1 基础数据路径

| 序号 | 操作系统     |  数据路径     | 说明 |
|:---|:---------|:-------------|:---------|
| 1  | windows  | c:\\.quant1x | 存放元数据和日志 |
| 2  | 非windows | ~/.quant1x   | 存放元数据和日志 |

***以下用${QUANT1X}表示基础数据路径***

### 2.2 策略数据路径
在${QUANT1X}下创建一个quant1x.yaml的配置文件，也可以由quant工具自动生成
```yaml
basedir: ~/.quant1x # 数据路径, 根据个人习惯调整
order:
  top_n: 3         # 最多输出前多少名个股
  have_etf: false  # 是否包含ETF交易
rules:
  sectors_filter: false                  # 是否启用板块过滤, false代表全市场扫描
  price_min: 2.00                        # 2.00 股价最低
  price_max: 30.00                       # 30.00 股价最高
  maximum_increase_within_5_days: 20.00  # 20.00 5日累计最大涨幅
  maximum_increase_within_10_days: 70.00 # 70.00 10日累计最大涨幅
  max_reduce_amount: -1000               # -1000 最大流出1000万
  turn_z_max: 200.00                     # 200.00 换手最大值
  turn_z_min: 1.50                       # 1.50 换手最小值
  open_rate_max: 2.00                    # 2.00 最大涨幅
  open_rate_min: -2.00                   # -1.00 最低涨幅
  quantity_ratio_max: 61.80              # 61.80 最大开盘量比
  quantity_ratio_min: 1.00               # 3.82 最小开盘量比
  safety_score_min: 0                    # 80 通达信安全分最小值
  volume_ratio_max: 3.82                 # 1.800 成交量放大不能超过1.8
  capital_min: 2                         # 2 亿 流通股本最小值
  capital_max: 200                       # 200 亿 流通股本最大值
```

### 2.3 stock服务(守护进程)

#### 2.3.1 安装服务
```shell
stock service install
```
#### 2.3.1 卸载服务

```shell
stock service uninstall
```
或
```shell
stock service remove
```
*windows服务卸载后需要重启电脑, 以清除windows注册表信息*

#### 2.3.3 启动服务
```shell
stock service start
```

#### 2.3.4 关闭服务
```shell
stock service start
```

### 2.4 手动更新全部数据
```shell
stock update --all
```
### 2.5 修复或还原历史策略数据
```shell
stock repair --all --start=开始日期
```

## 3. 策略主程序(quant)

### 3.1 执行策略, 输出默认的前几只个股
```shell
quant
```

### 3.2 执行策略, 指定输出默认的前10只个股
```shell
quant --top=10
```
top N的默认值在quant1x.yaml里面调整