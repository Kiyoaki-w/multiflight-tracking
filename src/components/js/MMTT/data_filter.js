/**
 * 数据过滤，筛选出符合条件的数据，以作为MMTT的模拟输入。
 */


 function filter0() {

  // 初始化
  this.init = () => {
    this.whiteList = {};
    this.firstData = true;    
  }

  // 数据过滤
  this.filterData = (data, number = 10, returnInPoint = true) => {
    let filtered = [];

    // 对第一批数据，生成白名单
    if (this.firstData) {
      this.whiteList = setWhiteList(data, number);
      this.firstData = false;
    }

    for (let i in data) {
      let plane = data[i];
      if (this.whiteList[plane.hex]) {
        if (returnInPoint) {
          filtered.push([plane.lon, plane.lat, plane.altitude]);
        }
        else{
          filtered.push(plane);
        }
      }
    }
    return filtered;
  };

}


const setWhiteList = (planes, number = 7, center = [116.64, 39.9] /* [lon,lat] */) => {
  let whiteList = {}; // 用hex标识的白名单
  let whiteListLength = 0;
  for (let i in planes) {
    if (whiteListLength > number - 1) {
      break;
    }
    else{
      let plane = planes[i];
      let distance = Math.abs(plane.lat - center[1]); // 近似地以纬度差作为“距离”
      if (distance < (40.9 - center[1])) {
        whiteList[plane.hex] = true;
        whiteListLength += 1;
      }
    }
  }
  return whiteList;
}


export let dataFilter = new filter0();