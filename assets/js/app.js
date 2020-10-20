// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";
import { Socket } from "phoenix";
import NProgress from "nprogress";
import { LiveSocket } from "phoenix_live_view";

let Hooks = {
  InfiniteScroll: {
    mounted() {
      console.log("Footer added to the DOM!", this.el);
      this.observer = new IntersectionObserver(entries => {
        const entry = entries[0];
        if (entry.isIntersecting) {
          console.log("Footer is visible");
          this.pushEvent("load-more");
        }
      }).observe(this.el);
    },

    updated() {
      // suppose we need to know the specific page number in our liveview (from data attr in the DOM)
      console.log("UPDATED - we're now on page:", this.el.dataset.pageNumber);
    },

    destroyed() {
      //this.observer.unobserve(this.el);
      this.observer.disconnect();
    }
  }
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start());
window.addEventListener("phx:page-loading-stop", info => NProgress.done());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;
