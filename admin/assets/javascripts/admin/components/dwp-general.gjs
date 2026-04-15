import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import DwpPageLayout from "./dwp-page-layout";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpUploadNote from "./dwp-upload-note";
import DwpSaveBar from "./dwp-save-bar";
import DwpSortOrder from "./dwp-sort-order";

export default class DwpGeneral extends Component {
  get controller() { return this.args.controller; }

  val = (key) => this.controller.getValue(key);

  update = (key, value) => this.controller.updateValue(key, value);

  <template>
    <DwpPageLayout @titleLabel="dwp.admin.general_title" @descriptionLabel="dwp.admin.general_description">
      <:icon>
        <svg viewBox="0 -960 960 960" width="24" height="24" fill="white"><path d="m370-80-16-128q-13-5-24.5-12T307-235l-119 50L84-369l103-78q-1-7-1-13v-26q0-6 1-13L84-577l104-186 119 50q11-8 23-15t24-12l16-128h208l16 128q13 5 24.5 12t22.5 15l119-50 104 186-103 78q1 7 1 13v26q0 6-2 13l103 78-104 186-119-50q-11 8-22.5 15T566-208L550-80H370Z"/></svg>
      </:icon>
      <:content>

        <div class="dwp-card dwp-card--settings">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading">Plugin Status</h3>
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
            <h3 class="dwp-card__heading">SEO & Meta</h3>
            <DwpRow @title="Meta Description" @desc="Description for search engines">
              <DwpField @type="text_area" @configKey="meta_description" @value={{this.val "meta_description"}} @onChange={{this.update}} />
            </DwpRow>
            <DwpRow @title="JSON-LD Enabled" @desc="Structured data for search engines">
              <DwpField @type="bool" @configKey="json_ld_enabled" @value={{this.val "json_ld_enabled"}} @onChange={{this.update}} />
            </DwpRow>
            <DwpUploadNote @fieldName="og_image and favicon" />
          </div>
        </div>

        <div class="dwp-card dwp-card--features">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading">Icons</h3>
            <DwpRow @title="Icon Library" @desc="Icon set for button labels and titles">
              <DwpField @type="enum" @configKey="icon_library" @value={{this.val "icon_library"}} @choices={{this.iconChoices}} @onChange={{this.update}} />
            </DwpRow>
          </div>
        </div>

        <div class="dwp-card dwp-card--support">
          <div class="dwp-card__body">
            <h3 class="dwp-card__heading">Custom CSS</h3>
            <textarea class="dwp-field__input dwp-field__textarea dwp-field__textarea--mono dwp-field__textarea--full" {{on "input" this.handleCssInput}}>{{this.val "custom_css"}}</textarea>
          </div>
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
