/**
 * 用于实现MMTT的实例
 */


module.exports = function (data) {

  this.initFlag = true; // 标识是否为第一批数据
  this.traces = []; // 当前可靠航迹
  this.tempPoints = []; // 未匹配到任何航迹的暂存点迹

  this.traceNumber = 0; // 已生成的航迹数量

  this.startGate = {
    lon: 0.03,
    lat: 0.03,
    height: 1000
  };

  // 接收处理新到达数据
  this.handleData = (data, callback) => {
    if (this.initFlag) {
      this.tempPoints.push(...data); // 对第一批数据，直接暂存
      this.initFlag = false;
    }
    else{
      for (let i in data) {
        let newPoint = data[i];
        // 点迹-航迹关联

        // 航迹消亡

        // 航迹补点

        // 航迹起始
        for (let j in this.tempPoints) {
          if (this.tempPoints[j]) {
            let oldPoint = this.tempPoints[j];
            let dlon = Math.abs(newPoint[0] - oldPoint[0]);
            let dlat = Math.abs(newPoint[1] - oldPoint[1]);
            let dheight = Math.abs(newPoint[2] - oldPoint[2]);
            if (dlon < this.startGate.lon && dlat < this.startGate.lat && dheight < this.startGate.height) {
              // 均小于门限，起始成功
              this.traces.push(newTrace(oldPoint, newPoint, this.traceNumber)); // 将新轨迹存入
              this.traceNumber += 1;
              delete this.tempPoints[i];
              break;
            }
            else {
              // 起始失败
              this.tempPoints.push(newPoint); // 暂存
            }
          }
        }



      }
      
    }

    callback(this.traces, this.tempPoints, this.traceNumber);
  }








  
}


const newTrace = (point1, point2, traceNumber) => {
  let trace = {};
  trace.points = [point1, point2];
  trace.idx = traceNumber + 1;
  return trace;
}