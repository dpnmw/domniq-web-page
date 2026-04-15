import { tracked } from "@glimmer/tracking";
import Controller from "@ember/controller";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class DwpSectionsController extends Controller {
  @service toasts;
  @tracked activeSection = null;
  @tracked saving = false;
  @tracked saved = false;
  @tracked localConfigs = {};
  @tracked isLocked = true;

  constructor() {
    super(...arguments);
    this._fetchLicense();
  }

  async _fetchLicense() {
    try {
      const result = await ajax("/admin/plugins/domniq-web-page/license/status.json");
      this.isLocked = !result.licensed;
    } catch {
      this.isLocked = true;
    }
  }

  getConfigs(type) {
    return this.localConfigs[type] ?? this.model?.configs?.[type] ?? [];
  }

  getValue(type, key) {
    return this.getConfigs(type).find((c) => c.config_key === key)?.config_value ?? "";
  }

  @action
  updateValue(type, key, value) {
    if (this.isSectionLocked(type)) return;
    this.localConfigs = {
      ...this.localConfigs,
      [type]: this.getConfigs(type).map((c) =>
        c.config_key === key ? { ...c, config_value: String(value) } : c
      ),
    };
    this.saved = false;
  }

  static LOCKED_SECTIONS = ["stats", "about", "leaderboard", "topics", "faq", "app_cta"];

  isSectionLocked(section) {
    return this.isLocked && DwpSectionsController.LOCKED_SECTIONS.includes(section);
  }

  @action openSection(section)  {
    if (this.isSectionLocked(section)) return;
    this.activeSection = section;
    this.saved = false;
  }
  @action closeSection()        { this.activeSection = null; }

  @action
  async save(type) {
    if (this.isSectionLocked(type)) return;
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
      this.toasts.success({ data: { message: "Section settings saved" }, duration: 2000 });
    } catch (e) {
      popupAjaxError(e);
    } finally {
      this.saving = false;
    }
  }
}
