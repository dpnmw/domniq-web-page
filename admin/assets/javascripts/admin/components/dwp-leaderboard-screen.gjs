import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpSaveBar from "./dwp-save-bar";

const BORDER_CHOICES = ["none", "solid", "dashed", "dotted"];

export default class DwpLeaderboardScreen extends Component {
  get c() { return this.args.controller; }
  val = (key) => this.c.getValue("leaderboard", key);
  update = (key, value) => this.c.updateValue("leaderboard", key, value);
  save = () => this.c.save("leaderboard");
  borderChoices = BORDER_CHOICES;

  <template>
    <button class="dwp-subscreen__back" type="button" {{on "click" this.c.closeSection}}>← Back to Sections</button>
    <div class="dwp-toggle-row"><span>Enable Leaderboard</span><DwpField @type="bool" @configKey="leaderboard_enabled" @value={{this.val "leaderboard_enabled"}} @onChange={{this.update}} /></div>

    <DwpAccordion @title="Title" @open={{true}} @icon="heading">
      <DwpRow @title="Title Enabled" @desc="Show or hide the section heading"><DwpField @type="bool" @configKey="leaderboard_title_enabled" @value={{this.val "leaderboard_title_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title" @desc="Heading text above the leaderboard cards"><DwpField @type="string" @configKey="leaderboard_title" @value={{this.val "leaderboard_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Size (px)" @desc="Custom font size, 0 uses the default"><DwpField @type="integer" @configKey="leaderboard_title_size" @value={{this.val "leaderboard_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Content" @icon="pen-to-square">
      <DwpRow @title="Bio Max Length" @desc="Maximum characters shown from each user's bio"><DwpField @type="integer" @configKey="leaderboard_bio_max_length" @value={{this.val "leaderboard_bio_max_length"}} @min="50" @max="500" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Topics Label" @desc="Label for the topics stat on each card"><DwpField @type="string" @configKey="leaderboard_topics_label" @value={{this.val "leaderboard_topics_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Posts Label" @desc="Label for the posts stat on each card"><DwpField @type="string" @configKey="leaderboard_posts_label" @value={{this.val "leaderboard_posts_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Likes Label" @desc="Label for the likes stat on each card"><DwpField @type="string" @configKey="leaderboard_likes_label" @value={{this.val "leaderboard_likes_label"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Colours" @icon="palette">
      <DwpRow @title="Accent Colour" @desc="Highlight colour for leaderboard elements"><DwpField @type="color" @configKey="leaderboard_accent_color" @value={{this.val "leaderboard_accent_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Bio Colour" @desc="Text colour for user bios"><DwpField @type="color" @configKey="leaderboard_bio_color" @value={{this.val "leaderboard_bio_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Dark)" @desc="Card background in dark mode"><DwpField @type="color" @configKey="leaderboard_card_bg_dark" @value={{this.val "leaderboard_card_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Light)" @desc="Card background in light mode"><DwpField @type="color" @configKey="leaderboard_card_bg_light" @value={{this.val "leaderboard_card_bg_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling" @icon="sliders">
      <DwpRow @title="Background (Dark)" @desc="Section background in dark mode"><DwpField @type="color" @configKey="leaderboard_bg_dark" @value={{this.val "leaderboard_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)" @desc="Section background in light mode"><DwpField @type="color" @configKey="leaderboard_bg_light" @value={{this.val "leaderboard_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height" @desc="Minimum section height in pixels, 0 for auto"><DwpField @type="integer" @configKey="leaderboard_min_height" @value={{this.val "leaderboard_min_height"}} @min="0" @max="2000" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style" @desc="Bottom border separating this section from the next"><DwpField @type="enum" @configKey="leaderboard_border_style" @value={{this.val "leaderboard_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}
