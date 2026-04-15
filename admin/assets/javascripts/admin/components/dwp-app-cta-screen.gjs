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
      <DwpRow @title="Headline"><DwpField @type="string" @configKey="app_cta_headline" @value={{this.val "app_cta_headline"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Subtext"><DwpField @type="string" @configKey="app_cta_subtext" @value={{this.val "app_cta_subtext"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Title Size (px)"><DwpField @type="integer" @configKey="app_cta_title_size" @value={{this.val "app_cta_title_size"}} @min="0" @max="80" @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Text Colours">
      <DwpRow @title="Headline Colour (Dark)"><DwpField @type="color" @configKey="app_cta_headline_color_dark" @value={{this.val "app_cta_headline_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Headline Colour (Light)"><DwpField @type="color" @configKey="app_cta_headline_color_light" @value={{this.val "app_cta_headline_color_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Subtext Colour (Dark)"><DwpField @type="color" @configKey="app_cta_subtext_color_dark" @value={{this.val "app_cta_subtext_color_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Subtext Colour (Light)"><DwpField @type="color" @configKey="app_cta_subtext_color_light" @value={{this.val "app_cta_subtext_color_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="App Badges">
      <DwpRow @title="iOS App URL"><DwpField @type="string" @configKey="ios_app_url" @value={{this.val "ios_app_url"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Android App URL"><DwpField @type="string" @configKey="android_app_url" @value={{this.val "android_app_url"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Badge Height"><DwpField @type="integer" @configKey="app_badge_height" @value={{this.val "app_badge_height"}} @min="30" @max="80" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Badge Style">
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
      <DwpRow @title="Start (Dark)"><DwpField @type="color" @configKey="app_cta_gradient_start_dark" @value={{this.val "app_cta_gradient_start_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Start (Light)"><DwpField @type="color" @configKey="app_cta_gradient_start_light" @value={{this.val "app_cta_gradient_start_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Mid (Dark)"><DwpField @type="color" @configKey="app_cta_gradient_mid_dark" @value={{this.val "app_cta_gradient_mid_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Mid (Light)"><DwpField @type="color" @configKey="app_cta_gradient_mid_light" @value={{this.val "app_cta_gradient_mid_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="End (Dark)"><DwpField @type="color" @configKey="app_cta_gradient_end_dark" @value={{this.val "app_cta_gradient_end_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="End (Light)"><DwpField @type="color" @configKey="app_cta_gradient_end_light" @value={{this.val "app_cta_gradient_end_light"}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpAccordion @title="Section Styling">
      <DwpRow @title="Background (Dark)"><DwpField @type="color" @configKey="app_cta_bg_dark" @value={{this.val "app_cta_bg_dark"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Background (Light)"><DwpField @type="color" @configKey="app_cta_bg_light" @value={{this.val "app_cta_bg_light"}} @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Min Height"><DwpField @type="integer" @configKey="app_cta_min_height" @value={{this.val "app_cta_min_height"}} @min="0" @max="2000" @onChange={{this.update}} /></DwpRow>
      <DwpRow @title="Border Style"><DwpField @type="enum" @configKey="app_cta_border_style" @value={{this.val "app_cta_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
    </DwpAccordion>

    <DwpSaveBar @saving={{this.c.saving}} @saved={{this.c.saved}} @onSave={{this.save}} />
  </template>
}

function eq(a, b) { return a === b; }
