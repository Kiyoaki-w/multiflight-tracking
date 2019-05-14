/**
 * 从JSON文件读取所录制的ADS-B数据，以x秒包的形式输出。
 */

const fs = require('fs');

const reader = (freq = 1, path = './data.json') => {
  let data_json = fs.readFileSync(path);
  let data = JSON.parse(data_json);
  
};

reader();