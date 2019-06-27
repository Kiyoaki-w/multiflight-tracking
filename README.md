# 飞行多目标跟踪演示平台

基于[Vue.js](https://vuejs.org/)、[Openlayers](https://openlayers.org/)、[Ant Design Vue](https://vue.ant.design)的飞行多目标跟踪演示平台，使用[Vue CLI](https://cli.vuejs.org/)构建。

## 主要特性
- [x] 地图显示
- [x] 航迹渲染
- [x] 历史数据回放
- [x] 实时数据演示
- [x] 点迹-航迹关联方法
- [x] 点迹-点迹关联方法
- [x] 航迹起始逻辑
- [x] 航迹消亡逻辑

## 安装与测试

### 安装Node.js

前往[Node.js官网](https://nodejs.org/zh-cn/)下载并安装。

### 安装工程依赖包

```bash
$ cd /dir/to/project
$ npm install
```

### 开发环境下编译测试
```bash
$ npm run serve
```

### 生产环境下编译构建
```bash
$ npm run build
```

## TODO
- [ ] 模拟生成噪声
- [ ] 卡尔曼滤波等滤波器
- [ ] 其他目标机动模型
- [ ] 其他跟踪门