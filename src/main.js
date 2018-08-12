import Vue from 'vue'
import App from './App.vue'
import './plugins/element.js'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faRandom, faPlay, faStop, faFastBackward, faFastForward } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

library.add(faRandom, faPlay, faStop, faFastBackward, faFastForward)

Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.config.productionTip = false

new Vue({
  render: h => h(App)
}).$mount('#app')
