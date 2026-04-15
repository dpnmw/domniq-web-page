import { ajax } from "discourse/lib/ajax";
import DiscourseRoute from "discourse/routes/discourse";
export default class DwpFooterRoute extends DiscourseRoute {
  model() {
    return ajax("/admin/plugins/domniq-web-page/configs/footer.json");
  }
}
