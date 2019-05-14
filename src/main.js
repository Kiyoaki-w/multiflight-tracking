import Vue from "vue";
import App from "./App";

// ant-design
import Antd from 'ant-design-vue';
import "ant-design-vue/dist/antd.css";
Vue.use(Antd);

// font-awesome
import { library } from '@fortawesome/fontawesome-svg-core';
import { faLayerGroup } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
library.add(faLayerGroup);
Vue.component('font-awesome-icon', FontAwesomeIcon);

// 读取字体文件
import './assets/fonts/loadMyFonts.css';

Vue.config.productionTip = false;

new Vue({
  render: h => h(App)
}).$mount("#app");

