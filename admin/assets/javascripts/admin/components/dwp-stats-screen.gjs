import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpSaveBar from "./dwp-save-bar";

const CARD_STYLES = ["rectangle", "rounded", "pill", "minimal"];
const BORDER_CHOICES = ["none", "solid", "dashed", "dotted"];

export default class DwpStatsScreen extends Component {
  get c() { return this.args.controller; }
  val = (key) => this.c.getValue("stats", key);
  update = (key, value) => this.c.updateValue("stats", key, value);
  save = () => this.c.save("stats");
  cardStyles = CARD_STYLES;
  borderChoices = BORDER_CHOICES;
  selectCardStyle = (style) => this.update("stat_card_style", style);
  selectIconShape = (shape) => this.update("stat_icon_shape", shape);

  <template>
    <button class="dwp-subscreen__back" type="button" {{on "click" this.c.closeSection}}>← Back to Sections</button>
    <div class="dwp-toggle-row"><span>Enable Stats</span><DwpField @type="bool" @configKey="stats_enabled" @value={{this.val "stats_enabled"}} @onChange={{this.update}} /></div>

    <DwpAccordion @title="Title" @open={{true}}>
      <DwpRow @title="Title Enabled"><DwpField @type="bool" @configKey="stats_title_enabled" @value={{this.val "stats_title_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title"><DwpField @type="string" @configKey="stats_title" @value={{this.val "stats_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Size (px)"><DwpField @type="integer" @configKey="stats_title_size" @value={{this.val "stats_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Card Style">
      <DwpRow @title="Card Style">
        <div class="dwp-tile-grid">
          {{#each this.cardStyles as |style|}}
            <button type="button" class="dwp-tile {{if (eq style (this.val "stat_card_style")) "dwp-tile--active"}}" {{on "click" (fn this.selectCardStyle style)}}>{{style}}</button>
          {{/each}}
        </div>
      </DwpRow>
      <DwpRow @title="Icon Shape">
        <div class="dwp-segmented">
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "stat_icon_shape") "circle") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectIconShape "circle")}}>Circle</button>
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "stat_icon_shape") "rounded") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectIconShape "rounded")}}>Rounded</button>
        </div>
      </DwpRow>
      <DwpRow @title="Icon Colour"><DwpField @type="color" @configKey="stat_icon_color" @value={{this.val "stat_icon_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Icon BG Colour"><DwpField @type="color" @configKey="stat_icon_bg_color" @value={{this.val "stat_icon_bg_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Counter Colour"><DwpField @type="color" @configKey="stat_counter_color" @value={{this.val "stat_counter_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Dark)"><DwpField @type="color" @configKey="stat_card_bg_dark" @value={{this.val "stat_card_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Light)"><DwpField @type="color" @configKey="stat_card_bg_light" @value={{this.val "stat_card_bg_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Labels & Data">
      <DwpRow @title="Show Labels"><DwpField @type="bool" @configKey="stat_labels_enabled" @value={{this.val "stat_labels_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Round Numbers"><DwpField @type="bool" @configKey="stat_round_numbers" @value={{this.val "stat_round_numbers"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Members Label"><DwpField @type="string" @configKey="stat_members_label" @value={{this.val "stat_members_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Topics Label"><DwpField @type="string" @configKey="stat_topics_label" @value={{this.val "stat_topics_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Posts Label"><DwpField @type="string" @configKey="stat_posts_label" @value={{this.val "stat_posts_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Likes Label"><DwpField @type="string" @configKey="stat_likes_label" @value={{this.val "stat_likes_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Chats Label"><DwpField @type="string" @configKey="stat_chats_label" @value={{this.val "stat_chats_label"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling">
      <DwpRow @title="Background (Dark)"><DwpField @type="color" @configKey="stats_bg_dark" @value={{this.val "stats_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)"><DwpField @type="color" @configKey="stats_bg_light" @value={{this.val "stats_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height"><DwpField @type="integer" @configKey="stats_min_height" @value={{this.val "stats_min_height"}} @min="0" @max="2000" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style"><DwpField @type="enum" @configKey="stats_border_style" @value={{this.val "stats_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}

function eq(a, b) { return a === b; }
