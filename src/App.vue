<template>
  <div id="app">
    <div class="main">
      <mapView style="background-color: #061922"/>
    </div>

    <a-row type="flex" justify="space-between" style="padding-top:15px; padding-right:15px; padding-left:20px">
      <a-popover trigger="click" title="Title" placement="bottomRight">
        <div class="myCard" style="width:40px; height:40px;">
          <a-icon style="vertical-align:middle" type="setting" />
        </div>
        <template slot="content">
          <p>Content</p>
          <p>Content</p>
        </template>
      </a-popover>
      
    </a-row>

    
    
    <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->
  </div>
</template>

<script>
// import HelloWorld from './components/HelloWorld.vue'
import mapView from './components/mapView.vue'

export default {
  name: 'app',
  components: {
    // HelloWorld
    mapView
  }
}
</script>

<style>
#app {
  font-family: myPingFangMedium, myConsola;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  /* background-color: #2c3e50 */
}
.main {
  position: absolute; 
  width: 100%; 
  height: 100%;
  text-align: center;
  vertical-align: middle;
}
.myCard {
  background-color: white;
  font-size: 24px;
  text-align: center;
  vertical-align: middle;
  /* display: block; */
  border-radius: 2px;
  min-width: 0;
  position: relative;
  text-decoration: none;
  -webkit-box-shadow: 0px 3px 2px -1px rgba(0,0,0,0.2), 0px 1px 1px 0px rgba(0,0,0,0.14), 0px 1px 4px 0px rgba(0,0,0,0.12);
          box-shadow: 0px 3px 2px -1px rgba(0,0,0,0.2), 0px 1px 1px 0px rgba(0,0,0,0.14), 0px 1px 4px 0px rgba(0,0,0,0.12);
}
.myCard:hover {
  cursor: pointer;
  -webkit-transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  -webkit-transition-property: -webkit-box-shadow;
  transition-property: -webkit-box-shadow;
  transition-property: box-shadow;
  transition-property: box-shadow, -webkit-box-shadow;
  -webkit-box-shadow: 0px 4px 2px -2px rgba(0,0,0,0.2), 0px 2px 2px 1px rgba(0,0,0,0.14), 0px 3px 14px 2px rgba(0,0,0,0.12);
          box-shadow: 0px 4px 2px -2px rgba(0,0,0,0.2), 0px 2px 2px 1px rgba(0,0,0,0.14), 0px 3px 14px 2px rgba(0,0,0,0.12);
}
</style>
