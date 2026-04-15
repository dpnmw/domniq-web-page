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

    <DwpAccordion @title="Content" @open={{true}} @icon="edit" @locked={{this.c.isLocked}}>
      <DwpRow @title="Heading Enabled" @desc="Show the section heading above the about card"><DwpField @type="bool" @configKey="about_heading_enabled" @value={{this.val "about_heading_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Heading" @desc="Section heading text"><DwpField @type="string" @configKey="about_heading" @value={{this.val "about_heading"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Community Name" @desc="Author name shown below the quote"><DwpField @type="string" @configKey="about_title" @value={{this.val "about_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Role" @desc="Author role or title shown below the name"><DwpField @type="string" @configKey="about_role" @value={{this.val "about_role"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Body" @desc="Main description text, supports basic HTML"><DwpField @type="text_area" @configKey="about_body" @value={{this.val "about_body"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Title Style" @icon="heading" @locked={{this.c.isLocked}}>
      <DwpRow @title="Title Size (px)" @desc="Custom font size for the heading, 0 uses the default"><DwpField @type="integer" @configKey="about_title_size" @value={{this.val "about_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Images" @icon="image" @locked={{this.c.isLocked}}>
      <DwpUploadNote @fieldName="about_image" />
      <DwpUploadNote @fieldName="about_bg_image" />
    </DwpAccordion>

    <DwpAccordion @title="Card Colours" @icon="palette" @locked={{this.c.isLocked}}>
      <DwpRow @title="Card Colour (Dark)" @desc="About card background in dark mode"><DwpField @type="color" @configKey="about_card_color_dark" @value={{this.val "about_card_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card Colour (Light)" @desc="About card background in light mode"><DwpField @type="color" @configKey="about_card_color_light" @value={{this.val "about_card_color_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling" @icon="sliders" @locked={{this.c.isLocked}}>
      <DwpRow @title="Background (Dark)" @desc="Section background in dark mode"><DwpField @type="color" @configKey="about_bg_dark" @value={{this.val "about_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)" @desc="Section background in light mode"><DwpField @type="color" @configKey="about_bg_light" @value={{this.val "about_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height" @desc="Minimum section height in pixels, 0 for auto"><DwpField @type="integer" @configKey="about_min_height" @value={{this.val "about_min_height"}} @min="0" @max="2000" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style" @desc="Bottom border separating this section from the next"><DwpField @type="enum" @configKey="about_border_style" @value={{this.val "about_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}
