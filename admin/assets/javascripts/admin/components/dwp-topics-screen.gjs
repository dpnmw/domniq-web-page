import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpSaveBar from "./dwp-save-bar";

const BORDER_CHOICES = ["none", "solid", "dashed", "dotted"];

export default class DwpTopicsScreen extends Component {
  get c() { return this.args.controller; }
  val = (key) => this.c.getValue("topics", key);
  update = (key, value) => this.c.updateValue("topics", key, value);
  save = () => this.c.save("topics");
  borderChoices = BORDER_CHOICES;

  <template>
    <button class="dwp-subscreen__back" type="button" {{on "click" this.c.closeSection}}>← Back to Sections</button>
    <div class="dwp-toggle-row"><span>Enable Topics</span><DwpField @type="bool" @configKey="topics_enabled" @value={{this.val "topics_enabled"}} @onChange={{this.update}} /></div>

    <DwpAccordion @title="Content" @open={{true}} @icon="edit" @locked={{this.c.isLocked}}>
      <DwpRow @title="Title Enabled" @desc="Show or hide the section heading"><DwpField @type="bool" @configKey="topics_title_enabled" @value={{this.val "topics_title_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title" @desc="Heading text above the topic cards"><DwpField @type="string" @configKey="topics_title" @value={{this.val "topics_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Size (px)" @desc="Custom font size, 0 uses the default"><DwpField @type="integer" @configKey="topics_title_size" @value={{this.val "topics_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Topic Count" @desc="Number of trending topics to display"><DwpField @type="integer" @configKey="topics_count" @value={{this.val "topics_count"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Card Colours" @icon="palette" @locked={{this.c.isLocked}}>
      <DwpRow @title="Card BG (Dark)" @desc="Topic card background in dark mode"><DwpField @type="color" @configKey="topics_card_bg_dark" @value={{this.val "topics_card_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Light)" @desc="Topic card background in light mode"><DwpField @type="color" @configKey="topics_card_bg_light" @value={{this.val "topics_card_bg_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling" @icon="sliders" @locked={{this.c.isLocked}}>
      <DwpRow @title="Background (Dark)" @desc="Section background in dark mode"><DwpField @type="color" @configKey="topics_bg_dark" @value={{this.val "topics_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)" @desc="Section background in light mode"><DwpField @type="color" @configKey="topics_bg_light" @value={{this.val "topics_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height" @desc="Minimum section height in pixels, 0 for auto"><DwpField @type="integer" @configKey="topics_min_height" @value={{this.val "topics_min_height"}} @min="0" @max="2000" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style" @desc="Bottom border separating this section from the next"><DwpField @type="enum" @configKey="topics_border_style" @value={{this.val "topics_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}
