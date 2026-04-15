import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import { getIcon } from "./dwp-icons";

export default class DwpLicenseLock extends Component {
  get lockIcon() {
    return htmlSafe(getIcon("lock"));
  }

  <template>
    <div class="dwp-license-lock">
      <div class="dwp-license-lock__content">
        <span class="dwp-license-lock__icon">{{this.lockIcon}}</span>
        <span class="dwp-license-lock__text">Requires licence to unlock</span>
        <a href="/admin/plugins/domniq-web-page/dwp-support" class="dwp-license-lock__btn">Get a Licence</a>
      </div>
    </div>
  </template>
}
