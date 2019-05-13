import Vue from "vue";
// import Button from "ant-design-vue/lib/button";
import Antd from 'ant-design-vue';
import "ant-design-vue/dist/antd.css";
import App from "./App";

Vue.use(Antd);
// Vue.component(Button.name, Button);

import './assets/fonts/loadMyFonts.css'; // 读取字体文件

Vue.config.productionTip = false;

new Vue({
  render: h => h(App)
}).$mount("#app");

