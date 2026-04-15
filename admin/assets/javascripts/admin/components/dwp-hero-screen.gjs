import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpUploadNote from "./dwp-upload-note";
import DwpSaveBar from "./dwp-save-bar";

const BG_EFFECTS = ["none", "ken_burns", "pulse", "color_shift", "parallax", "grayscale", "frosted_glass"];
const BORDER_CHOICES = ["none", "solid", "dashed", "dotted"];
const VIDEO_POS = ["center", "bottom"];

export default class DwpHeroScreen extends Component {
  get c() { return this.args.controller; }
  val = (key) => this.c.getValue("hero", key);
  update = (key, value) => this.c.updateValue("hero", key, value);
  save = () => this.c.save("hero");

  bgEffects = BG_EFFECTS;
  borderChoices = BORDER_CHOICES;
  videoPos = VIDEO_POS;

  selectBgEffect = (effect) => this.update("hero_bg_effect", effect);
  selectAlignment = (align) => this.update("hero_content_alignment", align);
  selectContribAlignment = (align) => this.update("contributors_alignment", align);

  get showAccentWord() { return this.val("hero_accent_enabled") === "true"; }
  get showOverlay() { return this.val("hero_background_overlay") === "true"; }

  <template>
    <button class="dwp-subscreen__back" type="button" {{on "click" this.c.closeSection}}>← Back to Sections</button>

    <DwpAccordion @title="Content" @open={{true}} @icon="edit">
      <DwpRow @title="Hero Title"><DwpField @type="string" @configKey="hero_title" @value={{this.val "hero_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Accent Word Enabled"><DwpField @type="bool" @configKey="hero_accent_enabled" @value={{this.val "hero_accent_enabled"}} @onChange={{this.update}} /></DwpRow>
      {{#if this.showAccentWord}}
        <DwpRow @title="Accent Word Index" @desc="0 = last word, 1+ = specific word"><DwpField @type="integer" @configKey="hero_accent_word" @value={{this.val "hero_accent_word"}} @min="0" @max="50" @onChange={{this.update}} /></DwpRow>
      {{/if}}
      <DwpRow @title="Subtitle"><DwpField @type="string" @configKey="hero_subtitle" @value={{this.val "hero_subtitle"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Content Alignment">
        <div class="dwp-segmented">
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "hero_content_alignment") "left") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectAlignment "left")}}>Left</button>
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "hero_content_alignment") "center") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectAlignment "center")}}>Center</button>
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "hero_content_alignment") "right") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectAlignment "right")}}>Right</button>
        </div>
      </DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Title Style" @icon="heading">
      <DwpRow @title="Title Size (px)"><DwpField @type="integer" @configKey="hero_title_size" @value={{this.val "hero_title_size"}} @min="0" @max="120" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Letter Spacing (px)"><DwpField @type="integer" @configKey="hero_title_letter_spacing" @value={{this.val "hero_title_letter_spacing"}} @min="-5" @max="20" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Text Shadow"><DwpField @type="bool" @configKey="hero_text_shadow" @value={{this.val "hero_text_shadow"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Colour (Dark)"><DwpField @type="color" @configKey="hero_title_color_dark" @value={{this.val "hero_title_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Colour (Light)"><DwpField @type="color" @configKey="hero_title_color_light" @value={{this.val "hero_title_color_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Subtitle Colour (Dark)"><DwpField @type="color" @configKey="hero_subtitle_color_dark" @value={{this.val "hero_subtitle_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Subtitle Colour (Light)"><DwpField @type="color" @configKey="hero_subtitle_color_light" @value={{this.val "hero_subtitle_color_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Card" @icon="square">
      <DwpRow @title="Card Enabled"><DwpField @type="bool" @configKey="hero_card_enabled" @value={{this.val "hero_card_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card Opacity"><DwpField @type="string" @configKey="hero_card_opacity" @value={{this.val "hero_card_opacity"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Dark)"><DwpField @type="color" @configKey="hero_card_bg_dark" @value={{this.val "hero_card_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Card BG (Light)"><DwpField @type="color" @configKey="hero_card_bg_light" @value={{this.val "hero_card_bg_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Background" @icon="panorama">
      <DwpUploadNote @fieldName="hero_bg_image" />
      <DwpRow @title="Background Effect">
        <div class="dwp-tile-grid">
          {{#each this.bgEffects as |effect|}}
            <button type="button" class="dwp-tile {{if (eq effect (this.val "hero_bg_effect")) "dwp-tile--active"}}" {{on "click" (fn this.selectBgEffect effect)}}>{{effect}}</button>
          {{/each}}
        </div>
      </DwpRow>
      <DwpRow @title="Background Overlay"><DwpField @type="bool" @configKey="hero_background_overlay" @value={{this.val "hero_background_overlay"}} @onChange={{this.update}} /></DwpRow>
      {{#if this.showOverlay}}
        <DwpRow @title="Overlay Colour"><DwpField @type="color" @configKey="hero_overlay_color" @value={{this.val "hero_overlay_color"}} @onChange={{this.update}} /></DwpRow>
        <DwpRow @title="Overlay Opacity (0-100)"><DwpField @type="integer" @configKey="hero_overlay_opacity" @value={{this.val "hero_overlay_opacity"}} @min="0" @max="100" @onChange={{this.update}} /></DwpRow>
      {{/if}}
    </DwpAccordion>

    <DwpAccordion @title="Side Image" @icon="image">
      <DwpUploadNote @fieldName="hero_image" />
      <DwpRow @title="Image First"><DwpField @type="bool" @configKey="hero_image_first" @value={{this.val "hero_image_first"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Image Weight (1-3)"><DwpField @type="integer" @configKey="hero_image_weight" @value={{this.val "hero_image_weight"}} @min="1" @max="3" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Max Height (vh)"><DwpField @type="integer" @configKey="hero_image_max_height" @value={{this.val "hero_image_max_height"}} @min="10" @max="100" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Buttons" @icon="pointer">
      <DwpRow @title="Button Shadows"><DwpField @type="bool" @configKey="hero_buttons_shadow" @value={{this.val "hero_buttons_shadow"}} @onChange={{this.update}} /></DwpRow>
      <h4 class="dwp-subgroup-label">Primary Button</h4>
      <DwpRow @title="Enabled"><DwpField @type="bool" @configKey="hero_primary_button_enabled" @value={{this.val "hero_primary_button_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Label"><DwpField @type="string" @configKey="hero_primary_button_label" @value={{this.val "hero_primary_button_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="URL"><DwpField @type="string" @configKey="hero_primary_button_url" @value={{this.val "hero_primary_button_url"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Colour (Dark)"><DwpField @type="color" @configKey="hero_primary_btn_color_dark" @value={{this.val "hero_primary_btn_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Colour (Light)"><DwpField @type="color" @configKey="hero_primary_btn_color_light" @value={{this.val "hero_primary_btn_color_light"}} @onChange={{this.update}} /></DwpRow>
      <h4 class="dwp-subgroup-label">Secondary Button</h4>
      <DwpRow @title="Enabled"><DwpField @type="bool" @configKey="hero_secondary_button_enabled" @value={{this.val "hero_secondary_button_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Label"><DwpField @type="string" @configKey="hero_secondary_button_label" @value={{this.val "hero_secondary_button_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="URL"><DwpField @type="string" @configKey="hero_secondary_button_url" @value={{this.val "hero_secondary_button_url"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Colour (Dark)"><DwpField @type="color" @configKey="hero_secondary_btn_color_dark" @value={{this.val "hero_secondary_btn_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Colour (Light)"><DwpField @type="color" @configKey="hero_secondary_btn_color_light" @value={{this.val "hero_secondary_btn_color_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Video" @icon="play">
      <DwpRow @title="Video URL"><DwpField @type="string" @configKey="hero_video_url" @value={{this.val "hero_video_url"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Button Colour"><DwpField @type="color" @configKey="hero_video_button_color" @value={{this.val "hero_video_button_color"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Button Position"><DwpField @type="enum" @configKey="hero_video_button_position" @value={{this.val "hero_video_button_position"}} @choices={{this.videoPos}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Blur on Hover"><DwpField @type="bool" @configKey="hero_video_blur_on_hover" @value={{this.val "hero_video_blur_on_hover"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Contributors" @icon="users">
      <DwpRow @title="Enabled"><DwpField @type="bool" @configKey="contributors_enabled" @value={{this.val "contributors_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Enabled"><DwpField @type="bool" @configKey="contributors_title_enabled" @value={{this.val "contributors_title_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title"><DwpField @type="string" @configKey="contributors_title" @value={{this.val "contributors_title"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Count Label Enabled"><DwpField @type="bool" @configKey="contributors_count_label_enabled" @value={{this.val "contributors_count_label_enabled"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Count Label"><DwpField @type="string" @configKey="contributors_count_label" @value={{this.val "contributors_count_label"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Alignment">
        <div class="dwp-segmented">
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "contributors_alignment") "left") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectContribAlignment "left")}}>Left</button>
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "contributors_alignment") "center") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectContribAlignment "center")}}>Center</button>
        </div>
      </DwpRow>
      <DwpRow @title="Days"><DwpField @type="integer" @configKey="contributors_days" @value={{this.val "contributors_days"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Count"><DwpField @type="integer" @configKey="contributors_count" @value={{this.val "contributors_count"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Pill Max Width"><DwpField @type="integer" @configKey="contributors_pill_max_width" @value={{this.val "contributors_pill_max_width"}} @min="200" @max="600" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Pill BG (Dark)"><DwpField @type="color" @configKey="contributors_pill_bg_dark" @value={{this.val "contributors_pill_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Pill BG (Light)"><DwpField @type="color" @configKey="contributors_pill_bg_light" @value={{this.val "contributors_pill_bg_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling" @icon="sliders">
      <DwpRow @title="Background (Dark)"><DwpField @type="color" @configKey="hero_bg_dark" @value={{this.val "hero_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)"><DwpField @type="color" @configKey="hero_bg_light" @value={{this.val "hero_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height (vh)"><DwpField @type="integer" @configKey="hero_min_height" @value={{this.val "hero_min_height"}} @min="0" @max="100" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style"><DwpField @type="enum" @configKey="hero_border_style" @value={{this.val "hero_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}

function eq(a, b) { return a === b; }
