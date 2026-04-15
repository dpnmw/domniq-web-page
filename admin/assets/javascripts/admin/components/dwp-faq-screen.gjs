import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpUploadNote from "./dwp-upload-note";
import DwpListEditor from "./dwp-list-editor";
import DwpSaveBar from "./dwp-save-bar";

export default class DwpFaqScreen extends Component {
  get c() { return this.args.controller; }
  val = (key) => this.c.getValue("faq", key);
  update = (key, value) => this.c.updateValue("faq", key, value);
  save = () => this.c.save("faq");

  faqFields = [{ key: "q", label: "Question" }, { key: "a", label: "Answer", type: "textarea" }];

  <template>
    <button class="dwp-subscreen__back" type="button" {{on "click" this.c.closeSection}}>← Back to Sections</button>
    <div class="dwp-toggle-row"><span>Enable FAQ</span><DwpField @type="bool" @configKey="faq_enabled" @value={{this.val "faq_enabled"}} @onChange={{this.update}} /></div>

    <DwpAccordion @title="Content" @open={{true}} @icon="edit">
      <DwpRow @title="Title Enabled" @desc="Show or hide the section heading"><DwpField @type="bool" @configKey="faq_title_enabled" @value={{this.val "faq_title_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title" @desc="Heading text above the FAQ accordion"><DwpField @type="string" @configKey="faq_title" @value={{this.val "faq_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Size (px)" @desc="Custom font size, 0 uses the default"><DwpField @type="integer" @configKey="faq_title_size" @value={{this.val "faq_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="FAQ Items" @icon="list">
      <DwpListEditor @value={{this.val "faq_items"}} @configKey="faq_items" @fields={{this.faqFields}} @onChange={{this.update}} />
    </DwpAccordion>

    <DwpAccordion @title="Image" @icon="image">
      <DwpUploadNote @fieldName="faq_image" />
    </DwpAccordion>

    <DwpAccordion @title="Card Colours" @icon="palette">
      <DwpRow @title="Card BG (Dark)" @desc="FAQ card background in dark mode"><DwpField @type="color" @configKey="faq_card_bg_dark" @value={{this.val "faq_card_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Light)" @desc="FAQ card background in light mode"><DwpField @type="color" @configKey="faq_card_bg_light" @value={{this.val "faq_card_bg_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling" @icon="sliders">
      <DwpRow @title="Background (Dark)" @desc="Section background in dark mode"><DwpField @type="color" @configKey="faq_bg_dark" @value={{this.val "faq_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)" @desc="Section background in light mode"><DwpField @type="color" @configKey="faq_bg_light" @value={{this.val "faq_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height" @desc="Minimum section height in pixels, 0 for auto"><DwpField @type="integer" @configKey="faq_min_height" @value={{this.val "faq_min_height"}} @min="0" @max="800" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Mobile Max Height" @desc="Limit FAQ height on mobile screens to enable scrolling"><DwpField @type="integer" @configKey="faq_mobile_max_height" @value={{this.val "faq_mobile_max_height"}} @min="0" @max="1200" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}
