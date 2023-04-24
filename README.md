行情数据工具使用说明
===

***数据工具默认安装路径~/.quant1x***

***由于gitee仓库容量限制, 新版本不能保存在gitee了,建议clone代码到本地, 用publish.sh脚本自行编译***

## 1.工具列表, 按照数据依赖的顺序排列
***以下用${QUANT1X_HOME}代替数据根路径~/.quant1x***

| 序号  | 工具名      | 功能                    | 数据路径                      | 说明                          |
|:----|:---------|:----------------------|:--------------------------|:----------------------------|
| 1   | zxg      | 自选股, 从通达信客户端直接导出自选股列表 | ${QUANT1X_HOME}/zxg.csv   | 需要时执行                       |
| 2   | xdxr     | 除权除息更新工具              | ${QUANT1X_HOME}/xdxr/     | 每个交易日17:00定时执行              |
| 3   | kline    | 日线数据更新工具              | ${QUANT1X_HOME}/day/      | 每个交易日17:00定时执行              |
| 4   | realtime | 用实时数据更新K线数据           | ${QUANT1X_HOME}/day/      | 每个交易日盘中09:00~15:00每2分钟执行1次 |
| 5   | quant    | 策略执行主程序               | ${QUANT1X_HOME}/strategy/ | 执行策略,每天每个策略保留最后一次结果         |

## 2. 同步自选股到缓存目录
```shell
 zxg -path ~/workspace/data/tdx
```
## 3. *nix 定时任务设定
${INSTALL_PATH} 表示安装路径

```shell
*/1 9-15 * * 1-5 ${INSTALL_PATH}/realtime
* 9-15 * * 1-5 ${INSTALL_PATH}/snapshot
*/2 9-15 * * 1-5 ${INSTALL_PATH}/tick --today=true
30 16 * * 1-5 ${INSTALL_PATH}/kline
15 9,23 * * 1-5 ${INSTALL_PATH}/f10
30 9-23 * * 1-5 ${INSTALL_PATH}/xdxr
```