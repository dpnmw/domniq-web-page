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

    <DwpAccordion @title="Title" @open={{true}} @icon="heading" @locked={{this.c.isLocked}}>
      <DwpRow @title="Title Enabled" @desc="Show or hide the section heading"><DwpField @type="bool" @configKey="stats_title_enabled" @value={{this.val "stats_title_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title" @desc="Heading text above the stat cards"><DwpField @type="string" @configKey="stats_title" @value={{this.val "stats_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Size (px)" @desc="Custom font size, 0 uses the default"><DwpField @type="integer" @configKey="stats_title_size" @value={{this.val "stats_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Card Style" @icon="grid" @locked={{this.c.isLocked}}>
      <DwpRow @title="Card Style" @desc="Visual shape of each stat card">
        <div class="dwp-tile-grid">
          {{#each this.cardStyles as |style|}}
            <button type="button" class="dwp-tile {{if (eq style (this.val "stat_card_style")) "dwp-tile--active"}}" {{on "click" (fn this.selectCardStyle style)}}>{{style}}</button>
          {{/each}}
        </div>
      </DwpRow>
      <DwpRow @title="Icon Shape" @desc="Shape of the icon container inside each card">
        <div class="dwp-segmented">
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "stat_icon_shape") "circle") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectIconShape "circle")}}>Circle</button>
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "stat_icon_shape") "rounded") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectIconShape "rounded")}}>Rounded</button>
        </div>
      </DwpRow>
      <DwpRow @title="Icon Colour" @desc="Stroke colour of the stat icons"><DwpField @type="color" @configKey="stat_icon_color" @value={{this.val "stat_icon_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Icon BG Colour" @desc="Background behind each stat icon"><DwpField @type="color" @configKey="stat_icon_bg_color" @value={{this.val "stat_icon_bg_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Counter Colour" @desc="Colour of the animated number value"><DwpField @type="color" @configKey="stat_counter_color" @value={{this.val "stat_counter_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Dark)" @desc="Card background in dark mode"><DwpField @type="color" @configKey="stat_card_bg_dark" @value={{this.val "stat_card_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Light)" @desc="Card background in light mode"><DwpField @type="color" @configKey="stat_card_bg_light" @value={{this.val "stat_card_bg_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Labels & Data" @icon="tags" @locked={{this.c.isLocked}}>
      <DwpRow @title="Show Labels" @desc="Display text labels below each counter"><DwpField @type="bool" @configKey="stat_labels_enabled" @value={{this.val "stat_labels_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Round Numbers" @desc="Show 1.2K instead of 1,234"><DwpField @type="bool" @configKey="stat_round_numbers" @value={{this.val "stat_round_numbers"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Members Label" @desc="Text below the members counter"><DwpField @type="string" @configKey="stat_members_label" @value={{this.val "stat_members_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Topics Label" @desc="Text below the topics counter"><DwpField @type="string" @configKey="stat_topics_label" @value={{this.val "stat_topics_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Posts Label" @desc="Text below the posts counter"><DwpField @type="string" @configKey="stat_posts_label" @value={{this.val "stat_posts_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Likes Label" @desc="Text below the likes counter"><DwpField @type="string" @configKey="stat_likes_label" @value={{this.val "stat_likes_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Chats Label" @desc="Text below the chats counter"><DwpField @type="string" @configKey="stat_chats_label" @value={{this.val "stat_chats_label"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling" @icon="sliders" @locked={{this.c.isLocked}}>
      <DwpRow @title="Background (Dark)" @desc="Section background in dark mode"><DwpField @type="color" @configKey="stats_bg_dark" @value={{this.val "stats_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)" @desc="Section background in light mode"><DwpField @type="color" @configKey="stats_bg_light" @value={{this.val "stats_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height" @desc="Minimum section height in pixels, 0 for auto"><DwpField @type="integer" @configKey="stats_min_height" @value={{this.val "stats_min_height"}} @min="0" @max="2000" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style" @desc="Bottom border separating this section from the next"><DwpField @type="enum" @configKey="stats_border_style" @value={{this.val "stats_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}

function eq(a, b) { return a === b; }
