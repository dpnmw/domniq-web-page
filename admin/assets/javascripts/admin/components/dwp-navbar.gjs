import Component from "@glimmer/component";
import DwpPageLayout from "./dwp-page-layout";
import DwpRow from "./dwp-row";
import DwpField from "./dwp-field";
import DwpAccordion from "./dwp-accordion";
import DwpSaveBar from "./dwp-save-bar";

export default class DwpNavbar extends Component {
  get controller() { return this.args.controller; }
  val = (key) => this.controller.getValue(key);
  update = (key, value) => this.controller.updateValue(key, value);

  borderChoices = ["none", "solid", "dashed", "dotted"];

  <template>
    <DwpPageLayout @titleLabel="dwp.admin.navbar_title" @descriptionLabel="dwp.admin.navbar_description">
      <:icon>
        <svg viewBox="0 -960 960 960" width="24" height="24" fill="white"><path d="M120-240v-80h720v80H120Zm0-200v-80h720v80H120Zm0-200v-80h720v80H120Z"/></svg>
      </:icon>
      <:content>
        <DwpAccordion @title="Buttons" @open={{true}}>
          <DwpRow @title="Sign In Enabled"><DwpField @type="bool" @configKey="navbar_signin_enabled" @value={{this.val "navbar_signin_enabled"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Sign In Label"><DwpField @type="string" @configKey="navbar_signin_label" @value={{this.val "navbar_signin_label"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Sign In Colour (Dark)"><DwpField @type="color" @configKey="navbar_signin_color_dark" @value={{this.val "navbar_signin_color_dark"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Sign In Colour (Light)"><DwpField @type="color" @configKey="navbar_signin_color_light" @value={{this.val "navbar_signin_color_light"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Join Enabled"><DwpField @type="bool" @configKey="navbar_join_enabled" @value={{this.val "navbar_join_enabled"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Join Label"><DwpField @type="string" @configKey="navbar_join_label" @value={{this.val "navbar_join_label"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Join Colour (Dark)"><DwpField @type="color" @configKey="navbar_join_color_dark" @value={{this.val "navbar_join_color_dark"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Join Colour (Light)"><DwpField @type="color" @configKey="navbar_join_color_light" @value={{this.val "navbar_join_color_light"}} @onChange={{this.update}} /></DwpRow>
        </DwpAccordion>

        <DwpAccordion @title="Appearance">
          <DwpRow @title="Background Colour"><DwpField @type="color" @configKey="navbar_bg_color" @value={{this.val "navbar_bg_color"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Border Style"><DwpField @type="enum" @configKey="navbar_border_style" @value={{this.val "navbar_border_style"}} @choices={{this.borderChoices}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Text Colour (Dark)"><DwpField @type="color" @configKey="navbar_text_color_dark" @value={{this.val "navbar_text_color_dark"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Text Colour (Light)"><DwpField @type="color" @configKey="navbar_text_color_light" @value={{this.val "navbar_text_color_light"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Icon Colour (Dark)"><DwpField @type="color" @configKey="navbar_icon_color_dark" @value={{this.val "navbar_icon_color_dark"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Icon Colour (Light)"><DwpField @type="color" @configKey="navbar_icon_color_light" @value={{this.val "navbar_icon_color_light"}} @onChange={{this.update}} /></DwpRow>
        </DwpAccordion>

        <DwpAccordion @title="Social Links">
          <DwpRow @title="Twitter / X"><DwpField @type="string" @configKey="social_twitter_url" @value={{this.val "social_twitter_url"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Facebook"><DwpField @type="string" @configKey="social_facebook_url" @value={{this.val "social_facebook_url"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="Instagram"><DwpField @type="string" @configKey="social_instagram_url" @value={{this.val "social_instagram_url"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="YouTube"><DwpField @type="string" @configKey="social_youtube_url" @value={{this.val "social_youtube_url"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="TikTok"><DwpField @type="string" @configKey="social_tiktok_url" @value={{this.val "social_tiktok_url"}} @onChange={{this.update}} /></DwpRow>
          <DwpRow @title="GitHub"><DwpField @type="string" @configKey="social_github_url" @value={{this.val "social_github_url"}} @onChange={{this.update}} /></DwpRow>
        </DwpAccordion>

        <DwpSaveBar @saving={{this.controller.saving}} @saved={{this.controller.saved}} @onSave={{this.controller.save}} />
      </:content>
    </DwpPageLayout>
  </template>
}
