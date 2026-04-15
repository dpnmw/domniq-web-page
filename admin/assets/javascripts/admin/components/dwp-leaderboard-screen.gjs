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

    <DwpAccordion @title="Title" @open={{true}}>
      <DwpRow @title="Title Enabled"><DwpField @type="bool" @configKey="leaderboard_title_enabled" @value={{this.val "leaderboard_title_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title"><DwpField @type="string" @configKey="leaderboard_title" @value={{this.val "leaderboard_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Size (px)"><DwpField @type="integer" @configKey="leaderboard_title_size" @value={{this.val "leaderboard_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Content">
      <DwpRow @title="Bio Max Length"><DwpField @type="integer" @configKey="leaderboard_bio_max_length" @value={{this.val "leaderboard_bio_max_length"}} @min="50" @max="500" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Topics Label"><DwpField @type="string" @configKey="leaderboard_topics_label" @value={{this.val "leaderboard_topics_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Posts Label"><DwpField @type="string" @configKey="leaderboard_posts_label" @value={{this.val "leaderboard_posts_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Likes Label"><DwpField @type="string" @configKey="leaderboard_likes_label" @value={{this.val "leaderboard_likes_label"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Colours">
      <DwpRow @title="Accent Colour"><DwpField @type="color" @configKey="leaderboard_accent_color" @value={{this.val "leaderboard_accent_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Bio Colour"><DwpField @type="color" @configKey="leaderboard_bio_color" @value={{this.val "leaderboard_bio_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Dark)"><DwpField @type="color" @configKey="leaderboard_card_bg_dark" @value={{this.val "leaderboard_card_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Light)"><DwpField @type="color" @configKey="leaderboard_card_bg_light" @value={{this.val "leaderboard_card_bg_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling">
      <DwpRow @title="Background (Dark)"><DwpField @type="color" @configKey="leaderboard_bg_dark" @value={{this.val "leaderboard_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)"><DwpField @type="color" @configKey="leaderboard_bg_light" @value={{this.val "leaderboard_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height"><DwpField @type="integer" @configKey="leaderboard_min_height" @value={{this.val "leaderboard_min_height"}} @min="0" @max="2000" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style"><DwpField @type="enum" @configKey="leaderboard_border_style" @value={{this.val "leaderboard_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}
