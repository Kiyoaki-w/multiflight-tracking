/**
 * 从JSON文件读取所录制的ADS-B数据，以x秒包的形式输出。
 */

const datas = require('./data.json');

const Filter = require('./MMTT/data_filter');
const dataFilter = new Filter();
dataFilter.init();

const myMMTT = require('./MMTT/MMTT');
const MMTT = new myMMTT();

for (let i = 0; i < 2; i++) {
  let data_raw = datas[i];
  let data = dataFilter.filterData(data_raw);
  MMTT.handleData(data, (traces, tempPoints, traceNumber) => {
    console.log(`=============== 循环次数${i} ===============`);
    console.log('trace:');
    console.log(traces);
    console.log('temp points:');
    console.log(tempPoints);
    console.log('\n');
    
  })
}
