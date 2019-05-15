<template>
  <div id="map"></div>
</template>

<script>
import 'ol/ol.css';
import {Map, View} from 'ol';
const Projection = require('ol/proj');
import proj_Projection from 'ol/proj/Projection';
import {Tile as TileLayer, Vector as VectorLayer} from 'ol/layer.js';
import XYZ from 'ol/source/XYZ';
import WMTS from 'ol/source/WMTS';
import WMTSTileGrid from 'ol/tilegrid/WMTS';

let map;
let myView;
let wmtsLayer, googleTerLayer;



export default {

  methods: {
    constructSource() {
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
    },

    switchMap(str) {
      let layersArray = map.getLayers();
      if (str === 'darkMap') {
        map.removeLayer(googleTerLayer);
        layersArray.insertAt(1, wmtsLayer);
      }
      else if (str === 'googleMap') {
        map.removeLayer(wmtsLayer);
        layersArray.insertAt(1, googleTerLayer);
      }
    },
  },

  mounted() {
    const __this = this;

    wmtsLayer = new TileLayer({
      title: "WMTS",
      source: __this.constructSource()
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
      minZoom:2,
    });

    map = new Map({
      target: 'map',
      loadTilesWhileAnimating: true, //允许在动画中加载瓦片
      layers: [],
      view: myView
    });
    let layersArray = map.getLayers();
    layersArray.insertAt(1, wmtsLayer);

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
