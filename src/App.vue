<template>
  <div id="app">
    <div class="main">
      <mapView ref="mapView" style="background-color: #061922"
        @drawFinish='drawing = false'
      />
    </div>

    <a-row type="flex" justify="space-between" style="padding-top:15px; padding-left:20px; ">
      <a-popover trigger="click" title="设置" placement="bottomRight" style="max-width:240px">
        <div class="myCard" style="width:40px; height:40px;">
          <div style="font-size:18px;margin:auto;display:flex"> 
            <font-awesome-icon style="vertical-align:middle" icon="layer-group" /> 
          </div>
        </div>
        
        <template slot="content">
          <div class="subTitle" style="margin-top: -13px;">
            <p>底图选择</p>
          </div>
          <a-radio-group @change="mapChange" v-model="selectedMap">
            <a-radio :value="1">暗色底图</a-radio>
            <a-radio :value="2">Google地图</a-radio>
          </a-radio-group>



          <div class="subTitle">
            <p>数据演示</p>
          </div>
          <a-radio-group v-model="show.mode">
            <a-radio :disabled="drawing" @click="MMTTclear" :value="1">历史数据</a-radio>
            <a-radio :disabled="drawing" @click="MMTTclear" :value="2">实时数据</a-radio>
          </a-radio-group>
          <div style="padding-top:5px">
            <span>历史长度：<a-input-number :disabled="show.mode === 2 || drawing" size='small' :step='20' :min="30" :max="180" v-model="show.hisLength"/> 秒</span>
            <br>
            <span>刷新速度：<a-input-number :disabled="show.mode === 2 || drawing" size='small' :step='100' :min="200" :max="2000" v-model="show.freq"/> 毫秒</span>
            <br>
            <span>飞机数量：<a-input-number :disabled="drawing" size='small' :min="1" :max="40" v-model="show.planeNumber"/> 架</span>
          </div>
          <div style="padding-top:15px; text-align:end;">
            <a-button :disabled="drawing" size="small" type="primary" icon="caret-right" @click="MMTTshow">开始</a-button>
            <span style="padding:5px"> </span>
            <a-button :disabled="drawing" size="small" type="default" icon="delete" @click="MMTTclear">清除</a-button>
            <span style="padding:5px"> </span>
            <a-button :disabled="!(drawing & show.mode === 2)" size="small" type="danger" icon="close" @click="MMTTstop">停止</a-button>
          </div>
          
        </template>
      </a-popover>
      
    </a-row>
    
  </div>
</template>

<script>
import mapView from './components/mapView.vue'

export default {
  name: 'app',
  components: {
    mapView
  },
  data () {
    return {
      selectedMap: 1, // 底图风格
      show: {
        mode: 1,
        hisLength: 180,
        freq: 200,
        planeNumber: 20
      },
      loading: false,
      drawing: false,
    }
  },
  methods: {
    mapChange (event){
      let str = (event.target.value === 1 ? 'darkMap' : 'googleMap');
      this.$refs.mapView.switchMap(str);
    },
    MMTTshow() {
      this.$refs.mapView.MMTTshow(this.show);
      this.drawing = true;
    },
    MMTTclear() {
      this.$refs.mapView.MMTTclear();
    },
    MMTTstop() {
      this.drawing = false;
      this.$refs.mapView.rtimeStop();
    }
  }
}
</script>

<style>
#app {
  font-family: Microsoft YaHei, myPingFangMedium, myConsola;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
.main {
  position: absolute; 
  width: 100%; 
  height: 100%;
  text-align: center;
  vertical-align: middle;
}
.myCard {
  display: flex;
  background-color: white;
  text-align: center;
  vertical-align: middle;
  border-radius: 2px;
  min-width: 0;
  position: relative;
  font-weight: bold;
  text-decoration: none;
  -webkit-box-shadow: 0px 3px 2px -1px rgba(0,0,0,0.2), 0px 1px 1px 0px rgba(0,0,0,0.14), 0px 1px 4px 0px rgba(0,0,0,0.12);
          box-shadow: 0px 3px 2px -1px rgba(0,0,0,0.2), 0px 1px 1px 0px rgba(0,0,0,0.14), 0px 1px 4px 0px rgba(0,0,0,0.12);
}
.myCard:hover {
  cursor: pointer;
  background-color: rgb(240, 240, 240);
  -webkit-transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  -webkit-transition-property: -webkit-box-shadow;
  transition-property: -webkit-box-shadow;
  transition-property: box-shadow;
  transition-property: box-shadow, -webkit-box-shadow;
  -webkit-box-shadow: 0px 4px 2px -2px rgba(0,0,0,0.2), 0px 2px 2px 1px rgba(0,0,0,0.14), 0px 3px 14px 2px rgba(0,0,0,0.12);
          box-shadow: 0px 4px 2px -2px rgba(0,0,0,0.2), 0px 2px 2px 1px rgba(0,0,0,0.14), 0px 3px 14px 2px rgba(0,0,0,0.12);
}
.subTitle {
  margin-left: -8px;
  padding-top: 7px;
  font-size: 12px;
  margin-bottom: -10px;
  color: #000000;
  font-weight: lighter
}
/* .ant-popover-inner-content{
  zoom: 0.95;
  -ms-zoom: 0.95;
  user-zoom: 0.95
} */
.ant-radio-wrapper{
  color: rgba(0,0,0,1);
}
</style>
