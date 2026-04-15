import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import DwpPageLayout from "./dwp-page-layout";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpUploadNote from "./dwp-upload-note";
import DwpSaveBar from "./dwp-save-bar";

const ANIM_TILES = ["fade_up", "fade_in", "slide_left", "slide_right", "zoom_in", "flip_up", "none"];

export default class DwpDesign extends Component {
  get controller() { return this.args.controller; }
  val = (key) => this.controller.getValue(key);
  update = (key, value) => this.controller.updateValue(key, value);

  animTiles = ANIM_TILES;

  get preloaderDisabled() {
    return this.val("preloader_enabled") !== "true";
  }

  selectAnim = (anim) => {
    this.update("scroll_animation", anim);
  };

  handleBodyFont = (event) => {
    this.update("google_font_name", event.target.value);
  };

  handleTitleFont = (event) => {
    this.update("title_font_name", event.target.value);
  };

  <template>
    <DwpPageLayout @titleLabel="dwp.admin.design_title" @descriptionLabel="dwp.admin.design_description">
      <:icon>
        <svg viewBox="0 -960 960 960" width="24" height="24" fill="white"><path d="M480-80q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Z"/></svg>
      </:icon>
      <:content>

        <DwpAccordion @title="Colours" @open={{true}}>
          <DwpRow @title="Accent Colour" @desc="Primary accent across the landing page"><DwpField @type="color" @configKey="accent_color" @value={{this.val "accent_color"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Accent Hover Colour" @desc="Colour when hovering over accent elements"><DwpField @type="color" @configKey="accent_hover_color" @value={{this.val "accent_hover_color"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Dark Background" @desc="Page background in dark mode"><DwpField @type="color" @configKey="dark_bg_color" @value={{this.val "dark_bg_color"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Light Background" @desc="Page background in light mode"><DwpField @type="color" @configKey="light_bg_color" @value={{this.val "light_bg_color"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Orb Colour" @desc="Background orb gradient colour"><DwpField @type="color" @configKey="orb_color" @value={{this.val "orb_color"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Orb Opacity" @desc="0-100"><DwpField @type="integer" @configKey="orb_opacity" @value={{this.val "orb_opacity"}} @min="0" @max="100" @onChange={{this.update}} /></DwpRow>
        </DwpAccordion>

        <DwpAccordion @title="Typography">
          <DwpRow @title="Google Font" @desc="Body font used across the entire landing page">
            <div class="dwp-font-field">
              <div class="dwp-font-field__input-wrap">
                <span class="dwp-font-field__icon">Aa</span>
                <input type="text" value={{this.val "google_font_name"}} class="dwp-field__input dwp-font-field__input" placeholder="e.g. Outfit, Inter, Poppins" {{on "input" this.handleBodyFont}} />
              </div>
              <a href="https://fonts.google.com" target="_blank" rel="noopener noreferrer" class="dwp-font-field__link">Browse Google Fonts &rarr;</a>
            </div>
          </DwpRow>
          <DwpRow @title="Title Font" @desc="Optional separate font for headings and titles">
            <div class="dwp-font-field">
              <div class="dwp-font-field__input-wrap">
                <span class="dwp-font-field__icon">Tt</span>
                <input type="text" value={{this.val "title_font_name"}} class="dwp-field__input dwp-font-field__input" placeholder="Leave empty to use body font" {{on "input" this.handleTitleFont}} />
              </div>
              <a href="https://fonts.google.com/?category=Serif,Display" target="_blank" rel="noopener noreferrer" class="dwp-font-field__link">Browse Display &amp; Serif Fonts &rarr;</a>
            </div>
          </DwpRow>
        </DwpAccordion>

        <DwpAccordion @title="Logo">
          <DwpRow @title="Logo Height" @desc="16-80px"><DwpField @type="integer" @configKey="logo_height" @value={{this.val "logo_height"}} @min="16" @max="80" @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Use Accent Colour" @desc="Tint the logo with the accent colour using a CSS mask"><DwpField @type="bool" @configKey="logo_use_accent_color" @value={{this.val "logo_use_accent_color"}} @onChange={{this.update}} /></DwpRow>
          <DwpUploadNote @fieldName="logo_dark, logo_light, footer_logo" />
        </DwpAccordion>

        <DwpAccordion @title="Animations & Effects">
          <DwpRow @title="Scroll Animation" @desc="Animation style for sections entering viewport">
            <div class="dwp-tile-grid">
              {{#each this.animTiles as |tile|}}
                <button type="button" class="dwp-tile {{if (eq tile (this.val "scroll_animation")) "dwp-tile--active"}}" {{on "click" (fn this.selectAnim tile)}}>{{tile}}</button>
              {{/each}}
            </div>
          </DwpRow>
          <DwpRow @title="Staggered Reveal" @desc="Animate cards and grid items in sequence instead of all at once"><DwpField @type="bool" @configKey="staggered_reveal_enabled" @value={{this.val "staggered_reveal_enabled"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Dynamic Background" @desc="Show floating gradient orbs behind the page content"><DwpField @type="bool" @configKey="dynamic_background_enabled" @value={{this.val "dynamic_background_enabled"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Mouse Parallax" @desc="Elements shift subtly as the cursor moves"><DwpField @type="bool" @configKey="mouse_parallax_enabled" @value={{this.val "mouse_parallax_enabled"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Scroll Progress Bar" @desc="Show a thin progress bar at the top of the navbar"><DwpField @type="bool" @configKey="scroll_progress_enabled" @value={{this.val "scroll_progress_enabled"}} @onChange={{this.update}} /></DwpRow>
        </DwpAccordion>

        <DwpAccordion @title="Preloader">
          <DwpRow @title="Enable Preloader" @desc="Show a loading screen with progress bar before the page appears"><DwpField @type="bool" @configKey="preloader_enabled" @value={{this.val "preloader_enabled"}} @onChange={{this.update}} /></DwpRow>
          <div class={{if this.preloaderDisabled "dwp-accordion__body--dimmed"}}>
            <DwpRow @title="Min Duration (ms)" @desc="Minimum time the preloader is shown, even if content loads faster"><DwpField @type="integer" @configKey="preloader_min_duration" @value={{this.val "preloader_min_duration"}} @min="0" @max="5000" @onChange={{this.update}} /></DwpRow>
            <DwpRow @title="Bar Colour" @desc="Progress bar fill colour"><DwpField @type="color" @configKey="preloader_bar_color" @value={{this.val "preloader_bar_color"}} @onChange={{this.update}} /></DwpRow>
            <DwpRow @title="Background Dark" @desc="Preloader screen background in dark mode"><DwpField @type="color" @configKey="preloader_bg_dark" @value={{this.val "preloader_bg_dark"}} @onChange={{this.update}} /></DwpRow>
            <DwpRow @title="Background Light" @desc="Preloader screen background in light mode"><DwpField @type="color" @configKey="preloader_bg_light" @value={{this.val "preloader_bg_light"}} @onChange={{this.update}} /></DwpRow>
            <DwpRow @title="Text Colour Dark" @desc="Percentage counter colour in dark mode"><DwpField @type="color" @configKey="preloader_text_color_dark" @value={{this.val "preloader_text_color_dark"}} @onChange={{this.update}} /></DwpRow>
            <DwpRow @title="Text Colour Light" @desc="Percentage counter colour in light mode"><DwpField @type="color" @configKey="preloader_text_color_light" @value={{this.val "preloader_text_color_light"}} @onChange={{this.update}} /></DwpRow>
            <DwpUploadNote @fieldName="preloader_logo_dark, preloader_logo_light" />
          </div>
        </DwpAccordion>

        <DwpSaveBar @saving={{this.controller.saving}} @saved={{this.controller.saved}} @onSave={{this.controller.save}} />
      </:content>
    </DwpPageLayout>
  </template>
}

import { on } from "@ember/modifier";

function eq(a, b) { return a === b; }
