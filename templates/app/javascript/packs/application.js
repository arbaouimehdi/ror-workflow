/**==================================
 #
 #             + CSS File
 #
 ==================================*/
import '../../assets/stylesheets/application.scss'

/**==================================
 #
 #             + JS Files
 #
 ==================================*/

/*==================================
#       External Dependencies
==================================*/
import 'bootstrap';

/*==================================
#         Local dependencies
==================================*/
import Router from './util/Router';

/*==================================
 #              Pages
 ==================================*/
import home from './routes/home';

/*==================================
 #              Layout
 ==================================*/
import plugins from './layout/plugins';
import uis from './layout/uis';


/*==================================
 #    Populate Router instance
 #         with DOM routes
 ==================================*/
const routes = new Router({
  // Layouts
  plugins,
  uis,
  // Pages
  home
});

/*==================================
 #             Turbolinks
 ==================================*/
import Turbolinks from 'turbolinks';
Turbolinks.start();

document.addEventListener('turbolinks:load', function () {
  return routes.loadEvents();
});
