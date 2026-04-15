import { ajax } from "discourse/lib/ajax";
import DiscourseRoute from "discourse/routes/discourse";
export default class DwpSectionsRoute extends DiscourseRoute {
  async model() {
    const types = ["hero","stats","about","leaderboard","topics","faq","app_cta"];
    const results = await Promise.all(
      types.map((t) => ajax(`/admin/plugins/domniq-web-page/configs/${t}.json`))
    );
    const configs = {};
    types.forEach((t, i) => { configs[t] = results[i].configs; });
    return { configs };
  }
}
