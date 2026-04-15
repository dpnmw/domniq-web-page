import { tracked } from "@glimmer/tracking";
import Controller from "@ember/controller";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class DwpDesignController extends Controller {
  @tracked saving = false;
  @tracked saved = false;
  @tracked localConfigs = null;

  get configs() {
    return this.localConfigs ?? this.model?.configs ?? [];
  }

  getValue(key) {
    return this.configs.find((c) => c.config_key === key)?.config_value ?? "";
  }

  @action
  updateValue(key, value) {
    this.localConfigs = this.configs.map((c) =>
      c.config_key === key ? { ...c, config_value: String(value) } : c
    );
    this.saved = false;
  }

  @action
  async save() {
    this.saving = true;
    this.saved = false;
    try {
      const payload = {};
      for (const c of this.configs) { payload[c.config_key] = c.config_value; }
      await ajax("/admin/plugins/domniq-web-page/configs/design.json", {
        type: "PUT",
        data: { configs: payload },
      });
      this.saved = true;
    } catch (e) {
      popupAjaxError(e);
    } finally {
      this.saving = false;
    }
  }
}
