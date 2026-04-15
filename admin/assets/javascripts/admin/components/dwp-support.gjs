import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { on } from "@ember/modifier";
import { htmlSafe } from "@ember/template";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import DwpPageLayout from "./dwp-page-layout";
import DwpRow from "./dwp-row";
import { getIcon } from "./dwp-icons";

export default class DwpSupport extends Component {
  @service toasts;
  @tracked license = null;
  @tracked licenseKey = "";
  @tracked checking = false;
  @tracked activating = false;
  @tracked licenseError = null;

  constructor() {
    super(...arguments);
    this.fetchLicense();
  }

  async fetchLicense() {
    try {
      this.license = await ajax("/admin/plugins/domniq-web-page/license/status.json");
    } catch {
      this.license = { licensed: false };
    }
  }

  @action
  updateLicenseKey(event) {
    this.licenseKey = event.target.value;
    this.licenseError = null;
  }

  @action
  async activateLicense() {
    if (!this.licenseKey.trim()) return;
    this.activating = true;
    this.licenseError = null;
    try {
      const result = await ajax("/admin/plugins/domniq-web-page/license/activate.json", {
        type: "POST",
        data: { license_key: this.licenseKey.trim() },
      });
      this.license = result;
      if (result.licensed) {
        this.licenseKey = "";
        this.toasts.success({ data: { message: "Licence activated successfully" }, duration: 3000 });
        window.location.reload();
      }
    } catch (e) {
      const msg = e.jqXHR?.responseJSON?.error || "Activation failed. Please check your licence key.";
      this.licenseError = msg;
      this.toasts.error({ data: { message: msg }, duration: 5000 });
    } finally {
      this.activating = false;
    }
  }

  @action
  async checkLicense() {
    this.checking = true;
    this.licenseError = null;
    try {
      this.license = await ajax("/admin/plugins/domniq-web-page/license/check.json", { type: "POST" });
      if (this.license.licensed) {
        this.toasts.success({ data: { message: "Licence is valid and active" }, duration: 3000 });
      } else {
        const msg = this.license.error || "Licence is inactive.";
        this.licenseError = msg;
        this.toasts.error({ data: { message: msg }, duration: 5000 });
      }
    } catch {
      this.licenseError = "Unable to verify licence. Please try again later.";
      this.toasts.error({ data: { message: this.licenseError }, duration: 5000 });
      this.license = { licensed: false };
    } finally {
      this.checking = false;
    }
  }

  get isLicensed() {
    return this.license?.licensed === true;
  }

  get statusLabel() {
    if (!this.license) return "Loading...";
    if (this.license.licensed) return "Active";
    return "Inactive";
  }

  get statusClass() {
    if (!this.license) return "";
    return this.license.licensed ? "dwp-support__status--active" : "dwp-support__status--inactive";
  }

  get safeModeUrl() {
    const base = window.location.origin;
    return `${base}/?safe_mode=no_plugins`;
  }

  get telemetryEnabled() {
    return this.license?.telemetry_enabled ?? true;
  }

  @action
  async toggleTelemetry() {
    const newValue = !this.telemetryEnabled;
    try {
      await ajax("/admin/plugins/domniq-web-page/license/telemetry.json", {
        type: "PUT",
        data: { telemetry_enabled: newValue },
      });
      this.license = { ...this.license, telemetry_enabled: newValue };
    } catch (e) {
      popupAjaxError(e);
    }
  }

  iconHtml = (name) => htmlSafe(getIcon(name));

  <template>
    <DwpPageLayout @titleLabel="dwp.admin.support_title" @descriptionLabel="dwp.admin.support_description">
      <:icon>
        <svg viewBox="0 -960 960 960" width="24" height="24" fill="white"><path d="M480-80q-139.67-35-229.83-161.5Q160-368.67 160-520.67v-240l320-120 320 120v240q0 152-90.17 278.5Q619.67-115.67 480-80Z"/></svg>
      </:icon>
      <:content>
        <div class="dwp-card dwp-card--settings">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading"><span class="dwp-card__heading-icon">{{this.iconHtml "lock"}}</span>Licence Status</h3>
            <p class="dwp-card__desc">Your current Domniq Web Page licence status and activation.</p>

            <DwpRow @title="Status" @desc="Whether your licence is currently active">
              <span class="dwp-support__status {{this.statusClass}}">{{this.statusLabel}}</span>
            </DwpRow>

            {{#if this.isLicensed}}
              {{#if this.license.license_key}}
                <DwpRow @title="Licence Key" @desc="Your activated licence key">
                  <span class="dwp-support__key-display">{{this.license.license_key}}</span>
                </DwpRow>
              {{/if}}
              {{#if this.license.expires_at}}
                <DwpRow @title="Expires" @desc="When your licence expires">
                  <span class="dwp-support__expiry">{{this.license.expires_at}}</span>
                </DwpRow>
              {{/if}}
            {{else}}
              <DwpRow @title="Licence Key" @desc="Enter your licence key from DPN Media Works">
                <div class="dwp-support__key-wrapper">
                  <input
                    type="text"
                    value={{this.licenseKey}}
                    {{on "input" this.updateLicenseKey}}
                    placeholder="e.g. a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6"
                    class="dwp-field__input dwp-support__key-input {{if this.licenseError 'dwp-support__key-input--error'}}"
                  />
                  {{#if this.licenseError}}
                    <span class="dwp-support__hint dwp-support__hint--error">{{this.licenseError}}</span>
                  {{else}}
                    <span class="dwp-support__hint">Enter your licence key and click Activate, or click Check Licence to verify an existing key.</span>
                  {{/if}}
                </div>
              </DwpRow>
            {{/if}}

            <div class="dwp-support__actions">
              {{#unless this.isLicensed}}
                <button type="button" class="btn btn-primary btn-small" disabled={{this.activating}} {{on "click" this.activateLicense}}>
                  {{if this.activating "Activating..." "Activate Licence"}}
                </button>
              {{/unless}}
              <button type="button" class="btn btn-default btn-small" disabled={{this.checking}} {{on "click" this.checkLicense}}>
                {{if this.checking "Checking..." "Check Licence"}}
              </button>
            </div>
          </div>
        </div>

        <div class="dwp-card dwp-card--community">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading"><span class="dwp-card__heading-icon">{{this.iconHtml "stats"}}</span>Install Telemetry</h3>
            <p class="dwp-card__desc">Anonymous usage data sent weekly to DPN Media Works for licence verification and support.</p>

            <DwpRow @title="Send Anonymous Install Data" @desc="Shares your site URL, plugin version, and enabled features with DPN Media Works. No user data is collected.">
              <label class="dwp-toggle">
                <input type="checkbox" checked={{this.telemetryEnabled}} {{on "change" this.toggleTelemetry}} />
                <span class="dwp-toggle__track"></span>
              </label>
            </DwpRow>
          </div>
        </div>

        <div class="dwp-card dwp-card--community">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading"><span class="dwp-card__heading-icon">{{this.iconHtml "list"}}</span>Documentation</h3>
            <div class="dwp-support__links">
              <a href="https://domniq.app" target="_blank" rel="noopener noreferrer" class="dwp-support__link">
                <span>Getting Started</span>
                <span class="dwp-support__arrow">&rarr;</span>
              </a>
              <a href="https://domniq.app" target="_blank" rel="noopener noreferrer" class="dwp-support__link">
                <span>Settings Reference</span>
                <span class="dwp-support__arrow">&rarr;</span>
              </a>
              <a href="https://domniq.app" target="_blank" rel="noopener noreferrer" class="dwp-support__link">
                <span>Changelog</span>
                <span class="dwp-support__arrow">&rarr;</span>
              </a>
            </div>
          </div>
        </div>

        <div class="dwp-card dwp-card--support">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading"><span class="dwp-card__heading-icon">{{this.iconHtml "about"}}</span>Plugin Info</h3>
            <DwpRow @title="Version"><span>2.0.0</span></DwpRow>
            <DwpRow @title="Identifier"><span>domniq-web-page</span></DwpRow>
            <DwpRow @title="Safe Mode URL"><code>{{this.safeModeUrl}}</code></DwpRow>
          </div>
        </div>
      </:content>
    </DwpPageLayout>
  </template>
}
