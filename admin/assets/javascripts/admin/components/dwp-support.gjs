import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { on } from "@ember/modifier";
import { ajax } from "discourse/lib/ajax";
import DwpPageLayout from "./dwp-page-layout";

export default class DwpSupport extends Component {
  @tracked license = null;
  @tracked checking = false;

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
  async checkLicense() {
    this.checking = true;
    try {
      this.license = await ajax("/admin/plugins/domniq-web-page/license/check.json", { type: "POST" });
    } catch {
      this.license = { licensed: false, error: "Check failed" };
    } finally {
      this.checking = false;
    }
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

  <template>
    <DwpPageLayout @titleLabel="dwp.admin.support_title" @descriptionLabel="dwp.admin.support_description">
      <:icon>
        <svg viewBox="0 -960 960 960" width="24" height="24" fill="white"><path d="M480-80q-139.67-35-229.83-161.5Q160-368.67 160-520.67v-240l320-120 320 120v240q0 152-90.17 278.5Q619.67-115.67 480-80Z"/></svg>
      </:icon>
      <:content>
        <div class="dwp-card dwp-card--settings">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading">Licence Status</h3>
            <div class="dwp-support__row">
              <span class="dwp-support__status {{this.statusClass}}">{{this.statusLabel}}</span>
              {{#if this.license.license_key}}
                <span class="dwp-support__key">{{this.license.license_key}}</span>
              {{/if}}
              {{#if this.license.expires_at}}
                <span class="dwp-support__expiry">Expires: {{this.license.expires_at}}</span>
              {{/if}}
            </div>
            <button type="button" class="btn btn-default btn-small" disabled={{this.checking}} {{on "click" this.checkLicense}}>
              {{if this.checking "Checking..." "Check Licence"}}
            </button>
          </div>
        </div>

        <div class="dwp-card dwp-card--community">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading">Documentation</h3>
            <div class="dwp-support__links">
              <a href="https://domniq.app" target="_blank" rel="noopener noreferrer">Getting Started</a>
              <a href="https://domniq.app" target="_blank" rel="noopener noreferrer">Settings Reference</a>
              <a href="https://domniq.app" target="_blank" rel="noopener noreferrer">Changelog</a>
            </div>
          </div>
        </div>

        <div class="dwp-card dwp-card--support">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading">Plugin Info</h3>
            <DwpRow @title="Version"><span>2.0.0</span></DwpRow>
            <DwpRow @title="Identifier"><span>domniq-web-page</span></DwpRow>
            <DwpRow @title="Safe Mode URL"><code>yourforum.com/?safe_mode=no_plugins</code></DwpRow>
          </div>
        </div>
      </:content>
    </DwpPageLayout>
  </template>
}

import DwpRow from "./dwp-row";
