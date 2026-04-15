import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpUploadNote from "./dwp-upload-note";
import DwpSaveBar from "./dwp-save-bar";

const BORDER_CHOICES = ["none", "solid", "dashed", "dotted"];

export default class DwpAppCtaScreen extends Component {
  get c() { return this.args.controller; }
  val = (key) => this.c.getValue("app_cta", key);
  update = (key, value) => this.c.updateValue("app_cta", key, value);
  save = () => this.c.save("app_cta");
  borderChoices = BORDER_CHOICES;

  selectBadgeStyle = (style) => this.update("app_badge_style", style);

  <template>
    <button class="dwp-subscreen__back" type="button" {{on "click" this.c.closeSection}}>← Back to Sections</button>
    <div class="dwp-toggle-row"><span>Enable App CTA</span><DwpField @type="bool" @configKey="show_app_ctas" @value={{this.val "show_app_ctas"}} @onChange={{this.update}} /></div>

    <DwpAccordion @title="Content" @open={{true}}>
      <DwpRow @title="Headline" @desc="Main heading for the app download section"><DwpField @type="string" @configKey="app_cta_headline" @value={{this.val "app_cta_headline"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Subtext" @desc="Supporting text below the headline"><DwpField @type="string" @configKey="app_cta_subtext" @value={{this.val "app_cta_subtext"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Size (px)" @desc="Custom font size for the headline, 0 uses the default"><DwpField @type="integer" @configKey="app_cta_title_size" @value={{this.val "app_cta_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Text Colours">
      <DwpRow @title="Headline Colour (Dark)" @desc="Headline text in dark mode"><DwpField @type="color" @configKey="app_cta_headline_color_dark" @value={{this.val "app_cta_headline_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Headline Colour (Light)" @desc="Headline text in light mode"><DwpField @type="color" @configKey="app_cta_headline_color_light" @value={{this.val "app_cta_headline_color_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Subtext Colour (Dark)" @desc="Subtext in dark mode"><DwpField @type="color" @configKey="app_cta_subtext_color_dark" @value={{this.val "app_cta_subtext_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Subtext Colour (Light)" @desc="Subtext in light mode"><DwpField @type="color" @configKey="app_cta_subtext_color_light" @value={{this.val "app_cta_subtext_color_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="App Badges">
      <DwpRow @title="iOS App URL" @desc="Full App Store link for your iOS app"><DwpField @type="string" @configKey="ios_app_url" @value={{this.val "ios_app_url"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Android App URL" @desc="Full Google Play link for your Android app"><DwpField @type="string" @configKey="android_app_url" @value={{this.val "android_app_url"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Badge Height" @desc="Height of the app store badge buttons in pixels"><DwpField @type="integer" @configKey="app_badge_height" @value={{this.val "app_badge_height"}} @min="30" @max="80" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Badge Style" @desc="Corner style of the app store badges">
        <div class="dwp-segmented">
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "app_badge_style") "rounded") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectBadgeStyle "rounded")}}>Rounded</button>
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "app_badge_style") "pill") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectBadgeStyle "pill")}}>Pill</button>
          <button type="button" class="dwp-segmented__option {{if (eq (this.val "app_badge_style") "square") "dwp-segmented__option--active"}}" {{on "click" (fn this.selectBadgeStyle "square")}}>Square</button>
        </div>
      </DwpRow>
      <DwpUploadNote @fieldName="ios_badge_image" />
      <DwpUploadNote @fieldName="android_badge_image" />
    </DwpAccordion>

    <DwpAccordion @title="Promotional Image">
      <DwpUploadNote @fieldName="cta_image" />
    </DwpAccordion>

    <DwpAccordion @title="Gradient Background">
      <DwpRow @title="Start (Dark)" @desc="First gradient stop in dark mode"><DwpField @type="color" @configKey="app_cta_gradient_start_dark" @value={{this.val "app_cta_gradient_start_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Start (Light)" @desc="First gradient stop in light mode"><DwpField @type="color" @configKey="app_cta_gradient_start_light" @value={{this.val "app_cta_gradient_start_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Mid (Dark)" @desc="Middle gradient stop in dark mode"><DwpField @type="color" @configKey="app_cta_gradient_mid_dark" @value={{this.val "app_cta_gradient_mid_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Mid (Light)" @desc="Middle gradient stop in light mode"><DwpField @type="color" @configKey="app_cta_gradient_mid_light" @value={{this.val "app_cta_gradient_mid_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="End (Dark)" @desc="Last gradient stop in dark mode"><DwpField @type="color" @configKey="app_cta_gradient_end_dark" @value={{this.val "app_cta_gradient_end_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="End (Light)" @desc="Last gradient stop in light mode"><DwpField @type="color" @configKey="app_cta_gradient_end_light" @value={{this.val "app_cta_gradient_end_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling">
      <DwpRow @title="Background (Dark)" @desc="Section background in dark mode"><DwpField @type="color" @configKey="app_cta_bg_dark" @value={{this.val "app_cta_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)" @desc="Section background in light mode"><DwpField @type="color" @configKey="app_cta_bg_light" @value={{this.val "app_cta_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height" @desc="Minimum section height in pixels, 0 for auto"><DwpField @type="integer" @configKey="app_cta_min_height" @value={{this.val "app_cta_min_height"}} @min="0" @max="2000" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style" @desc="Bottom border separating this section from the next"><DwpField @type="enum" @configKey="app_cta_border_style" @value={{this.val "app_cta_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}

function eq(a, b) { return a === b; }
