/**
 * 每秒一次地采样录制一定时间内的ADS-B数据，以JSON形式储存。
 */

const axios = require("axios");
const fs = require("fs");

const record = (url, period = 60, freq = 1000, path = './data.json') => {
  let datas = [];
  let timer = 0;
  let fetchTimer = setInterval(()=>{
    // 获取并存储
    if (timer < period) {
      axios.get(url, {
        responseType: 'json',
      })
      .then(function (response) {
        datas.push(response.data);
        console.log(`获取成功，当前长度${datas.length}`);
        timer += 1;
      })
      .catch(function (error) {
        console.log(error);
      });  
    }
    
    // 终止判断
    if (timer === period) {
      clearInterval(fetchTimer); // 终止timer
      let fd = fs.openSync(path, 'a');
      fs.writeSync(fd, JSON.stringify(datas));
      console.log(`文件写入完毕`);
    }
  }, freq);
}

record('http://219.224.161.159:28080/data.json', 180)
