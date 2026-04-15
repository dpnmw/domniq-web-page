import Component from "@glimmer/component";
import DwpPageLayout from "./dwp-page-layout";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpUploadNote from "./dwp-upload-note";
import DwpListEditor from "./dwp-list-editor";
import DwpSaveBar from "./dwp-save-bar";

export default class DwpFooter extends Component {
  get controller() { return this.args.controller; }
  val = (key) => this.controller.getValue(key);
  update = (key, value) => this.controller.updateValue(key, value);

  borderChoices = ["none", "solid", "dashed", "dotted"];
  linkFields = [{ key: "label", label: "Label" }, { key: "url", label: "URL" }];

  <template>
    <DwpPageLayout @titleLabel="dwp.admin.footer_title" @descriptionLabel="dwp.admin.footer_description">
      <:icon>
        <svg viewBox="0 -960 960 960" width="24" height="24" fill="white"><path d="M120-120v-80h720v80H120Zm0-160v-480h720v480H120Z"/></svg>
      </:icon>
      <:content>
        <DwpAccordion @title="Content" @open={{true}} @icon="edit">
          <DwpRow @title="Footer Description" @desc="Short description shown above the footer links"><DwpField @type="string" @configKey="footer_description" @value={{this.val "footer_description"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Footer Text" @desc="Additional text or HTML displayed below the footer links"><DwpField @type="text_area" @configKey="footer_text" @value={{this.val "footer_text"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Footer Links" @desc="Add or remove navigation links">
            <DwpListEditor @value={{this.val "footer_links"}} @configKey="footer_links" @fields={{this.linkFields}} @onChange={{this.update}} />
          </DwpRow>
          <DwpUploadNote @fieldName="footer_logo" />
        </DwpAccordion>

        <DwpAccordion @title="Appearance" @icon="brush" @locked={{this.controller.isLocked}}>
          <DwpRow @title="Border Style" @desc="Top border line separating the footer from content"><DwpField @type="enum" @configKey="footer_border_style" @value={{this.val "footer_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Background (Dark)" @desc="Footer background in dark mode"><DwpField @type="color" @configKey="footer_bg_dark" @value={{this.val "footer_bg_dark"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Background (Light)" @desc="Footer background in light mode"><DwpField @type="color" @configKey="footer_bg_light" @value={{this.val "footer_bg_light"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Text Colour (Dark)" @desc="Footer text and link colour in dark mode"><DwpField @type="color" @configKey="footer_text_color_dark" @value={{this.val "footer_text_color_dark"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Text Colour (Light)" @desc="Footer text and link colour in light mode"><DwpField @type="color" @configKey="footer_text_color_light" @value={{this.val "footer_text_color_light"}} @onChange={{this.update}} /></DwpRow>
        </DwpAccordion>

        <DwpSaveBar @saving={{this.controller.saving}} @saved={{this.controller.saved}} @onSave={{this.controller.save}} />
      </:content>
    </DwpPageLayout>
  </template>
}
