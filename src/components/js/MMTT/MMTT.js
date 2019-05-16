/**
 * 用于实现MMTT的实例
 */


function MMTT0() {

  this.init = () => {
    this.initFlag = true; // 标识是否为第一批数据
    this.traces = []; // 当前可靠航迹
    this.tempPoints = []; // 未匹配到任何航迹的暂存点迹
  
    this.traceNumber = 0; // 已生成的航迹数量
  
    this.gate = {
      lon: 0.03,
      lat: 0.03,
      height: 1000
    };  
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
        let pointUsed = false;

        // 点迹-航迹关联
        // todo: 其他关联方法 如：CA、自适应
        if (!pointUsed && this.traces.length > 0) {
          for (let i in this.traces) {
            let trace = this.traces[i];
            let predictPoint = getPredictPoint(trace);
            let dlon = Math.abs(newPoint[0] - predictPoint[0]);
            let dlat = Math.abs(newPoint[1] - predictPoint[1]);
            let dheight = Math.abs(newPoint[2] - predictPoint[2]);
            if (dlon < this.gate.lon && dlat < this.gate.lat && dheight < this.gate.height) {
              // 均小于门限，匹配成功
              this.traces[i].points.push(newPoint); // 存入新点迹
              this.traces[i].notFreshed = 0;
              pointUsed = true;
              break;
            }
          }
        }


        // 航迹起始
        if (!pointUsed) {
          for (let j in this.tempPoints) {
            if (this.tempPoints[j]) {
              let oldPoint = this.tempPoints[j];
              let dlon = Math.abs(newPoint[0] - oldPoint[0]);
              let dlat = Math.abs(newPoint[1] - oldPoint[1]);
              let dheight = Math.abs(newPoint[2] - oldPoint[2]);
              if (dlon < this.gate.lon && dlat < this.gate.lat && dheight < this.gate.height) {
                // 均小于门限，起始成功
                this.traces.push(newTrace(oldPoint, newPoint, this.traceNumber)); // 将新轨迹存入
                this.traceNumber += 1;
                delete this.tempPoints[i];
                pointUsed = true;
                break;
              }
            }
          }
        }

        // 关联失败且起始失败的，暂存
        if (!pointUsed) {
          this.tempPoints.push(newPoint);
        }

      }

      // 对未被更新的航迹，消亡或补点
      for (let i in this.traces) {
        let trace = this.traces[i];
        trace.notFreshed += 1;
        if (trace.notFreshed === 1) {
          // 刚刚经历过更新的
          // console.log(`更新！${this.traces[i]}`);
        }
        else if (trace.notFreshed > 5) {
          // 超过N次未被更新的，消亡
          console.log(`消亡！${this.traces[i]}`);
          callback('die', null, null, null, trace.idx);
          delete this.traces[i];
        }
        else if (trace.notFreshed > 1 && trace.notFreshed < 6) {
          // 未被更新，补点
          this.traces[i].points.push(getPredictPoint(this.traces[i]));
          console.log(`补点！${this.traces[i]}`);
        }
      }
      
    }

    callback('draw', this.traces, this.tempPoints, this.traceNumber, null);
  }


}


const newTrace = (point1, point2, traceNumber) => {
  let trace = {};
  trace.points = [point1, point2];
  trace.idx = traceNumber + 1;
  trace.notFreshed = 0;
  return trace;
};

// 根据航迹当前信息预测下一点位置
const getPredictPoint = (trace) => {
  let len = trace.points.length;
  let point1 = trace.points[len - 2];
  let point2 = trace.points[len - 1];
  let predicPoint = [];
  let dlon = point2[0] - point1[0];
  let dlat = point2[1] - point1[1];
  let dheight = point2[2] - point1[2];
  predicPoint.push(point2[0] + dlon);
  predicPoint.push(point2[1] + dlat);
  predicPoint.push(point2[2] + dheight);
  return predicPoint;
}

export let MMTT = new MMTT0();