import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { ajax } from "discourse/lib/ajax";
import DwpPageLayout from "./dwp-page-layout";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpUploadNote from "./dwp-upload-note";
import DwpSaveBar from "./dwp-save-bar";
import DwpSortOrder from "./dwp-sort-order";
import DwpLicenseLock from "./dwp-license-lock";
import { htmlSafe } from "@ember/template";
import { getIcon } from "./dwp-icons";

export default class DwpGeneral extends Component {
  @tracked showCurrentCss = false;
  @tracked currentCss = null;

  get controller() { return this.args.controller; }

  val = (key) => this.controller.getValue(key);

  update = (key, value) => this.controller.updateValue(key, value);

  iconHtml = (name) => htmlSafe(getIcon(name));

  @action
  async toggleCurrentCss() {
    if (this.showCurrentCss) {
      this.showCurrentCss = false;
      return;
    }
    if (!this.currentCss) {
      try {
        const result = await ajax("/admin/plugins/domniq-web-page/landing-css.json");
        this.currentCss = result.css;
      } catch {
        this.currentCss = "/* Failed to load CSS */";
      }
    }
    this.showCurrentCss = true;
  }

  <template>
    <DwpPageLayout @titleLabel="dwp.admin.general_title" @descriptionLabel="dwp.admin.general_description">
      <:icon>
        <svg viewBox="0 -960 960 960" width="24" height="24" fill="white"><path d="m370-80-16-128q-13-5-24.5-12T307-235l-119 50L84-369l103-78q-1-7-1-13v-26q0-6 1-13L84-577l104-186 119 50q11-8 23-15t24-12l16-128h208l16 128q13 5 24.5 12t22.5 15l119-50 104 186-103 78q1 7 1 13v26q0 6-2 13l103 78-104 186-119-50q-11 8-22.5 15T566-208L550-80H370Z"/></svg>
      </:icon>
      <:content>

        <div class="dwp-card dwp-card--settings">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading"><span class="dwp-card__heading-icon">{{this.iconHtml "toggle"}}</span>Plugin Status</h3>
            <DwpRow @title="Plugin Enabled" @desc="Master switch — also accessible in the Settings tab">
              <a href="/admin/plugins/domniq-web-page" class="btn btn-default btn-small">Open Settings</a>
            </DwpRow>
            <DwpRow @title="Section Order" @desc="Drag sections to reorder how they appear on the landing page">
              <DwpSortOrder @value={{this.val "section_order"}} @configKey="section_order" @onChange={{this.update}} />
            </DwpRow>
          </div>
        </div>

        <div class="dwp-card dwp-card--community">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading"><span class="dwp-card__heading-icon">{{this.iconHtml "search"}}</span>SEO & Meta</h3>
            <DwpRow @title="Meta Description" @desc="Description for search engines">
              <DwpField @type="text_area" @configKey="meta_description" @value={{this.val "meta_description"}} @onChange={{this.update}} />
            </DwpRow>
            <DwpRow @title="JSON-LD Enabled" @desc="Structured data for search engines">
              <DwpField @type="bool" @configKey="json_ld_enabled" @value={{this.val "json_ld_enabled"}} @onChange={{this.update}} />
            </DwpRow>
            <DwpUploadNote @fieldName="og_image and favicon" />
          </div>
        </div>

        <div class="dwp-card dwp-card--features {{if this.controller.isLocked 'dwp-card--locked'}}">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading"><span class="dwp-card__heading-icon">{{this.iconHtml "bolt"}}</span>Icons</h3>
            <DwpRow @title="Icon Library" @desc="Choose an icon set for buttons, titles, and stat labels">
              <DwpField @type="enum" @configKey="icon_library" @value={{this.val "icon_library"}} @choices={{this.iconChoices}} @onChange={{this.update}} />
            </DwpRow>
            <div class="dwp-icon-hint">
              <h4 class="dwp-icon-hint__title">How to use icons</h4>
              <p class="dwp-icon-hint__text">Add icons to any button label, section title, or stat label using the pipe syntax:</p>
              <div class="dwp-icon-hint__examples">
                <code class="dwp-icon-hint__code">icon-name | Button Text</code>
                <code class="dwp-icon-hint__code">Button Text | icon-name</code>
                <code class="dwp-icon-hint__code">icon-name | 20 | Text with size</code>
              </div>
              <p class="dwp-icon-hint__text">Icon goes before or after the pipe. Optional pixel size in the middle.</p>
              <div class="dwp-icon-hint__links">
                <a href="https://fontawesome.com/search?o=r&m=free&s=solid" target="_blank" rel="noopener noreferrer">Browse Font Awesome Icons &rarr;</a>
                <a href="https://fonts.google.com/icons?icon.set=Material+Symbols" target="_blank" rel="noopener noreferrer">Browse Google Material Icons &rarr;</a>
              </div>
            </div>
          </div>
          {{#if this.controller.isLocked}}<DwpLicenseLock />{{/if}}
        </div>

        <div class="dwp-card dwp-card--support {{if this.controller.isLocked 'dwp-card--locked'}}">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading"><span class="dwp-card__heading-icon">{{this.iconHtml "code"}}</span>Custom CSS</h3>
            <p class="dwp-card__desc">Add custom CSS to override the landing page styles. This is injected last so it takes priority over all built-in styles.</p>
            <textarea class="dwp-field__input dwp-field__textarea dwp-field__textarea--mono dwp-field__textarea--full" {{on "input" this.handleCssInput}}>{{this.val "custom_css"}}</textarea>
            <div class="dwp-css-ref">
              <button type="button" class="dwp-css-ref__toggle" {{on "click" this.toggleCurrentCss}}>
                {{if this.showCurrentCss "Hide" "View"}} current landing page CSS
              </button>
              {{#if this.showCurrentCss}}
                <pre class="dwp-css-ref__code">{{this.currentCss}}</pre>
              {{/if}}
            </div>
          </div>
          {{#if this.controller.isLocked}}<DwpLicenseLock />{{/if}}
        </div>

        <DwpSaveBar @saving={{this.controller.saving}} @saved={{this.controller.saved}} @onSave={{this.controller.save}} />
      </:content>
    </DwpPageLayout>
  </template>

  iconChoices = ["none", "fontawesome", "google"];

  handleCssInput = (event) => {
    this.controller.updateValue("custom_css", event.target.value);
  };
}
