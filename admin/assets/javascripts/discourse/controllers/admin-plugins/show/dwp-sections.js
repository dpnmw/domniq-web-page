import { tracked } from "@glimmer/tracking";
import Controller from "@ember/controller";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class DwpSectionsController extends Controller {
  @tracked activeSection = null;
  @tracked saving = false;
  @tracked saved = false;
  @tracked localConfigs = {};

  getConfigs(type) {
    return this.localConfigs[type] ?? this.model?.configs?.[type] ?? [];
  }

  getValue(type, key) {
    return this.getConfigs(type).find((c) => c.config_key === key)?.config_value ?? "";
  }

  @action
  updateValue(type, key, value) {
    this.localConfigs = {
      ...this.localConfigs,
      [type]: this.getConfigs(type).map((c) =>
        c.config_key === key ? { ...c, config_value: String(value) } : c
      ),
    };
    this.saved = false;
  }

  @action openSection(section)  { this.activeSection = section; this.saved = false; }
  @action closeSection()        { this.activeSection = null; }

  @action
  async save(type) {
    this.saving = true;
    this.saved = false;
    try {
      const payload = {};
      for (const c of this.getConfigs(type)) { payload[c.config_key] = c.config_value; }
      await ajax(`/admin/plugins/domniq-web-page/configs/${type}.json`, {
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
