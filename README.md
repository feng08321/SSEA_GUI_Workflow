# SSEA GUI Workflow

**Companion software for ISO 24871-6** — clear-sky spectral error test method based on ISO 9060.

ISO 9060 晴空光谱误差测试方法（ISO 24871-6）配套分析软件，用于评估太阳辐射测量设备在晴空条件下的光谱误差。

## 功能 Features

- 六步工作流：Select DB → Refresh → Preprocess → Accept → Calculate → Export
- 支持探测器 / 吸收体 + 最多 4 级串联组件的光谱响应链建模
- 光谱误差计算（Spectral Error）、批量处理（Batch）、波段贡献分析（Band Contribution）
- Display Panel 分页显示 Preprocess / Calculate / Batch / Band Contribution 图表
- Analysis Panel 提供 Summary / Batch Table / Band Table / Log
- 结果可导出 CSV / MAT，支持出版级图表输出

## 运行 Usage

- 环境：MATLAB（需支持 `uifigure`，建议 R2020b 及以上）
- 入口：在 MATLAB 中运行 `Run_GUI_v1_0_beta3`

```matlab
Run_GUI_v1_0_beta3
```

## 数据库结构 Database

| 目录 | 内容 |
|---|---|
| `Database/Spectrum` | 参考 / 测试太阳光谱（CSV） |
| `Database/Example` | ISO 24871 DNI / GHI 示例光谱 |
| `Database/Detector` | 探测器光谱响应数据 |
| `Database/Coating` | 涂层光谱数据 |
| `Database/Window` | 窗口材料光谱数据 |
| `Database/Metadata` | 各数据文件对应的元数据（JSON） |

## 版本历史 Changelog

### v1.0-beta3（当前版本）
- Display Panel 的 Preprocess / Calculate / Batch / Band Contribution 大 Tab 正常显示
- Analysis Panel 的 Summary / Batch Table / Band Table / Log Tab 置顶并充满右侧面板
- 各阶段自动切换到对应 Display Tab
- Batch / Band 图区使用独立 axes，修复 axBatch1 / axBand1 字段错误
- 各阶段绘图前调用 ResetAxesClean，减少旧图 / 双坐标残留

### v1.0-beta2
- 修正 Tab 容器定位、Analysis Panel 置顶显示、Reset 字段错误

### v1.0-beta
- Display Panel 改为 Tab 分页：Preprocess / Calculate / Batch / Band Contribution
- Analysis Panel 改为 Tab 分页：Summary / Batch Table / Band Table / Log
- System response 与 Contribution 改为单坐标归一化叠加
- Reset 使用 ResetAxesClean，避免 yyaxis 双坐标残留
- Batch 与 Band 图不再相互覆盖

> 早期迭代版本 v0.4 ~ v0.9 未包含在本仓库中。

## 许可证 License

本项目采用 [MIT License](LICENSE)。
