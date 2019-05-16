<template>
  <div id="map"></div>
</template>

<script>

/*========================== MMTT相关 ==========================*/
const exampleDatas = require('./js/data.json'); // 示例数据
import {dataFilter} from './js/MMTT/data_filter.js';
dataFilter.init();
import {MMTT} from './js/MMTT/MMTT.js';
MMTT.init();


/*========================== 按需引入ol组件 ==========================*/
import 'ol/ol.css';
import {Map, View} from 'ol';
const Projection = require('ol/proj');
import proj_Projection from 'ol/proj/Projection';
import {Tile as TileLayer, Vector as VectorLayer} from 'ol/layer.js';
import VectorSource from 'ol/source/Vector.js';
import XYZ from 'ol/source/XYZ';
import WMTS from 'ol/source/WMTS';
import WMTSTileGrid from 'ol/tilegrid/WMTS';
import {Circle as CircleStyle, Fill, Stroke, Style, Text} from 'ol/style.js';
import Feature from 'ol/Feature.js';
import Point from 'ol/geom/Point.js';
import { request } from 'http';
import LineString from 'ol/geom/LineString';
import axios from 'axios'


/*========================== 一些初始化相关函数 ==========================*/

/**
 * 初始化随机轨迹颜色样式
 */
const init_traceStyles = (number = 40) => {
  let styles = [];
  for (let i = 0; i < number; i++) {
    // 随机RGB颜色
    let rr = Math.floor(Math.random()*256);
    let bb = Math.floor(Math.random()*256);
    let gg = Math.floor(Math.random()*256);
    let alpha = 1;
    let style = [
      new Style({
        stroke: new Stroke({
          color: [rr, gg, bb, alpha],
          width: 4
        })
      })
    ];
    styles.push(style);
  }
  return styles;
};


/**
 * 构造WMTS图层源
 */
const constructSource = () => {
  // WMTS
  var gridsetName = 'EPSG:900913';
  var gridNames = ['EPSG:900913:0', 'EPSG:900913:1', 'EPSG:900913:2', 'EPSG:900913:3', 'EPSG:900913:4', 'EPSG:900913:5', 'EPSG:900913:6', 'EPSG:900913:7', 'EPSG:900913:8', 'EPSG:900913:9', 'EPSG:900913:10', 'EPSG:900913:11', 'EPSG:900913:12', 'EPSG:900913:13', 'EPSG:900913:14', 'EPSG:900913:15', 'EPSG:900913:16', 'EPSG:900913:17', 'EPSG:900913:18', 'EPSG:900913:19', 'EPSG:900913:20', 'EPSG:900913:21', 'EPSG:900913:22', 'EPSG:900913:23', 'EPSG:900913:24', 'EPSG:900913:25', 'EPSG:900913:26', 'EPSG:900913:27', 'EPSG:900913:28', 'EPSG:900913:29', 'EPSG:900913:30'];
  var basemap_link = 'http://219.224.161.159:18080';
  var baseUrl = basemap_link + '/geoserver/gwc/service/wmts';
  var style = '';
  var format = 'image/png';
  var layerName = 'China:world-dark'; //var layerName = 'China:t_world';
  var projection = new proj_Projection({
      code: 'EPSG:900913',
      units: 'm',
      axisOrientation: 'neu'
  });
  var resolutions = [156543.03390625, 78271.516953125, 39135.7584765625, 19567.87923828125, 9783.939619140625, 4891.9698095703125, 2445.9849047851562, 1222.9924523925781, 611.4962261962891, 305.74811309814453, 152.87405654907226, 76.43702827453613, 38.218514137268066, 19.109257068634033, 9.554628534317017, 4.777314267158508, 2.388657133579254, 1.194328566789627, 0.5971642833948135, 0.29858214169740677, 0.14929107084870338, 0.07464553542435169, 0.037322767712175846, 0.018661383856087923, 0.009330691928043961, 0.004665345964021981, 0.0023326729820109904, 0.0011663364910054952, 5.831682455027476E-4, 2.915841227513738E-4, 1.457920613756869E-4];
  var baseParams = ['VERSION','LAYER','STYLE','TILEMATRIX','TILEMATRIXSET','SERVICE','FORMAT'];
  var params = {
      'VERSION': '1.0.0',
      'LAYER': layerName,
      'STYLE': style,
      'TILEMATRIX': gridNames,
      'TILEMATRIXSET': gridsetName,
      'SERVICE': 'WMTS',
      'FORMAT': format
  };
  var url = baseUrl+'?'
  for (var param in params) {
      if (baseParams.indexOf(param.toUpperCase()) < 0) {
          url = url + param + '=' + params[param] + '&';
      }
  }
  url = url.slice(0, -1);
  var source = new WMTS({
      url: url,
      layer: params['LAYER'],
      matrixSet: params['TILEMATRIXSET'],
      format: params['FORMAT'],
      projection: projection,
      tileGrid: new WMTSTileGrid({
          tileSize: [256,256],
          extent: [-2.003750834E7,-2.003750834E7,2.003750834E7,2.003750834E7],
          origin: [-2.003750834E7, 2.003750834E7],
          resolutions: resolutions,
          matrixIds: params['TILEMATRIX']
      }),
      style: params['STYLE'],
      wrapX: true,
      attributions: '',
  });
  return source;
};


/*========================== 地图初始化 ==========================*/

let map;
let myView;
let wmtsLayer, googleTerLayer;

// 航迹图层相关
let traceSource = new VectorSource();
let traceLayer = new VectorLayer({
  source: traceSource
});
let traceStyles = init_traceStyles();

let feedTimer;

/*========================== 航迹显示相关 ==========================*/
const drawTrace = (trace) => {
  let points = trace.points;
  let traceStyle = traceStyles[trace.idx];
  let coors = [];
  for (let i in points) {
    let coor = Projection.transform(points[i], 'EPSG:4326', 'EPSG:3857');
    coors.push(coor);
  }
  let geometry = new LineString(coors);
  let feature = new Feature({
    geometry: geometry
  });
  feature.setStyle(traceStyle);
  // 若有同ID的，是同一航迹的上次渲染，删除
  let feature_old = traceSource.getFeatureById(trace.idx);
  if (feature_old) {
    traceSource.removeFeature(feature_old);
  }
  feature.setId(trace.idx);
  traceSource.addFeature(feature);
};

const removeTrace = (idx) => {
  let feature = traceSource.getFeatureById(idx);
  traceSource.removeFeature(feature);
};

const drawPoint = (point) => {
  let coor = Projection.transform(point, 'EPSG:4326', 'EPSG:3857');
  let feature = new Feature({
    geometry: new Point(coor),
  });
  let style = new Style({
    image: new CircleStyle({
      radius: 4,
      stroke: new Stroke({
        color: '#fff'
      }),
      fill: new Fill({
        color: '#3399CC'
      })
    }),
  });
  feature.setStyle(style);
  traceSource.addFeature(feature);
};

export default {

  methods: {

    // 切换底图
    switchMap(str) {
      let layersArray = map.getLayers();
      if (str === 'darkMap') {
        map.removeLayer(googleTerLayer);
        // layersArray.insertAt(1, wmtsLayer);
      }
      else if (str === 'googleMap') {
        // map.removeLayer(wmtsLayer);
        layersArray.insertAt(2, googleTerLayer);
        map.removeLayer(traceLayer);
        layersArray.insertAt(4, traceLayer);
      }
    },

    // 响应父组件的开始演示指令
    MMTTshow(config) {
      if (config.mode === 2) {
        // 实时数据渲染
        this.rtimeMMTT('http://219.224.161.159:28080/data.json', 1000, config.planeNumber);
      }
      if (config.mode === 1) {
        // 历史数据模拟渲染
        this.simulateMMTT(config.freq, config.hisLength, config.planeNumber);
      }
    },

    // 清除数据，初始化
    MMTTclear() {
      traceSource.clear();
      MMTT.init();
      feedTimer = null;
    },

    // 点迹与航迹模拟渲染
    simulateMMTT(freq = 400, hisLength = 120, planeNumber = 15) {
      let i = 0;
      feedTimer = setInterval(()=>{
        if (i < hisLength) {
          let data_raw = exampleDatas[i];
          let data = dataFilter.filterData(data_raw, planeNumber);
          MMTT.handleData(data, (cmd, traces, tempPoints, traceNumber, idxToDie) => {
            if (cmd === 'die') {
              removeTrace(idxToDie);
            }
            if (cmd === 'draw') {
              for (let i in traces) {
                let trace = traces[i];
                drawTrace(trace, i);
              }
            }
          });
          i++;
        }
        else{
          clearInterval(feedTimer); // 终止timer
          this.$emit('drawFinish');
        }
      }, freq)
    },

    // 点迹与航迹实时渲染
    rtimeMMTT(url = '/data.json', freq = 1000, planeNumber = 40) {
      let data_raw;
      feedTimer = setInterval(()=>{
        // 获取      
        axios.get(url, {
          responseType: 'json',
        })
        .then(function (response) {
          data_raw = response.data;
          let data = dataFilter.filterData(data_raw, planeNumber);
          MMTT.handleData(data, (cmd, traces, tempPoints, traceNumber, idxToDie) => {
            if (cmd === 'die') {
              removeTrace(idxToDie);
            }
            if (cmd === 'draw') {
              for (let i in traces) {
                let trace = traces[i];
                drawTrace(trace, i);
              }
            }
          });
        })
        .catch(function (error) {
          console.log(`数据获取错误！`);
          console.log(error);
        });
      }, freq);
    },


    
  },

  mounted() {
    // const __this = this;

    wmtsLayer = new TileLayer({
      title: "WMTS",
      source: constructSource()
    });

    googleTerLayer = new TileLayer({
      source: new XYZ({
        attributions: '',
        url: "http://www.google.cn/maps/vt/pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sm!3i380072576!3m8!2szh-CN!3scn!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0",
        tileSize: 256,
      })
    });

    myView = new View({
      extent: Projection.get('EPSG:3857').getExtent(),
      center: Projection.fromLonLat([116.35,39.9]),
      zoom: 10,
      minZoom: 2,
    });

    map = new Map({
      target: 'map',
      loadTilesWhileAnimating: true, //允许在动画中加载瓦片
      layers: [],
      view: myView
    });
    let layersArray = map.getLayers();
    layersArray.insertAt(1, wmtsLayer);
    layersArray.insertAt(4, traceLayer);

    // drawPoint([116.4,39.9]);
    // this.simulateMMTT()
  },
}
</script>

<style>
#map {
  height: 100%;
  width: 100%;
}
.ol-overlaycontainer-stopevent
{
  display:none;
}
</style>
