import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpUploadNote from "./dwp-upload-note";
import DwpSaveBar from "./dwp-save-bar";

const BORDER_CHOICES = ["none", "solid", "dashed", "dotted"];

export default class DwpAboutScreen extends Component {
  get c() { return this.args.controller; }
  val = (key) => this.c.getValue("about", key);
  update = (key, value) => this.c.updateValue("about", key, value);
  save = () => this.c.save("about");
  borderChoices = BORDER_CHOICES;

  <template>
    <button class="dwp-subscreen__back" type="button" {{on "click" this.c.closeSection}}>← Back to Sections</button>
    <div class="dwp-toggle-row"><span>Enable About</span><DwpField @type="bool" @configKey="about_enabled" @value={{this.val "about_enabled"}} @onChange={{this.update}} /></div>

    <DwpAccordion @title="Content" @open={{true}}>
      <DwpRow @title="Heading Enabled"><DwpField @type="bool" @configKey="about_heading_enabled" @value={{this.val "about_heading_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Heading"><DwpField @type="string" @configKey="about_heading" @value={{this.val "about_heading"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Community Name"><DwpField @type="string" @configKey="about_title" @value={{this.val "about_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Role"><DwpField @type="string" @configKey="about_role" @value={{this.val "about_role"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Body"><DwpField @type="text_area" @configKey="about_body" @value={{this.val "about_body"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Title Style">
      <DwpRow @title="Title Size (px)"><DwpField @type="integer" @configKey="about_title_size" @value={{this.val "about_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Images">
      <DwpUploadNote @fieldName="about_image" />
      <DwpUploadNote @fieldName="about_bg_image" />
    </DwpAccordion>

    <DwpAccordion @title="Card Colours">
      <DwpRow @title="Card Colour (Dark)"><DwpField @type="color" @configKey="about_card_color_dark" @value={{this.val "about_card_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card Colour (Light)"><DwpField @type="color" @configKey="about_card_color_light" @value={{this.val "about_card_color_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling">
      <DwpRow @title="Background (Dark)"><DwpField @type="color" @configKey="about_bg_dark" @value={{this.val "about_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)"><DwpField @type="color" @configKey="about_bg_light" @value={{this.val "about_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height"><DwpField @type="integer" @configKey="about_min_height" @value={{this.val "about_min_height"}} @min="0" @max="2000" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style"><DwpField @type="enum" @configKey="about_border_style" @value={{this.val "about_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}
