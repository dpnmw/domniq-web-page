import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import DwpPageLayout from "./dwp-page-layout";
import DwpSectionCard from "./dwp-section-card";
import DwpHeroScreen from "./dwp-hero-screen";
import DwpStatsScreen from "./dwp-stats-screen";
import DwpAboutScreen from "./dwp-about-screen";
import DwpLeaderboardScreen from "./dwp-leaderboard-screen";
import DwpTopicsScreen from "./dwp-topics-screen";
import DwpFaqScreen from "./dwp-faq-screen";
import DwpAppCtaScreen from "./dwp-app-cta-screen";

const SCREENS = {
  hero: DwpHeroScreen,
  stats: DwpStatsScreen,
  about: DwpAboutScreen,
  leaderboard: DwpLeaderboardScreen,
  topics: DwpTopicsScreen,
  faq: DwpFaqScreen,
  app_cta: DwpAppCtaScreen,
};

export default class DwpSections extends Component {
  get controller() { return this.args.controller; }

  get activeScreen() {
    const s = this.controller.activeSection;
    return s ? SCREENS[s] : null;
  }

  <template>
    <DwpPageLayout @titleLabel="dwp.admin.sections_title" @descriptionLabel="dwp.admin.sections_description">
      <:icon>
        <svg viewBox="0 -960 960 960" width="24" height="24" fill="white"><path d="M120-120v-320h320v320H120Zm0-400v-320h320v320H120Zm400 400v-320h320v320H520Zm0-400v-320h320v320H520Z"/></svg>
      </:icon>
      <:content>
        {{#if this.controller.activeSection}}
          {{#let this.activeScreen as |Screen|}}
            <Screen @controller={{this.controller}} />
          {{/let}}
        {{else}}
          <div class="dwp-sections-grid">
            <DwpSectionCard @label="Hero" @colorClass="dwp-card--branding" @enabled={{true}} @onClick={{fn this.controller.openSection "hero"}} />
            <DwpSectionCard @label="Stats" @colorClass="dwp-card--features" @enabled={{this.isEnabled "stats" "stats_enabled"}} @onClick={{fn this.controller.openSection "stats"}} />
            <DwpSectionCard @label="About" @colorClass="dwp-card--community" @enabled={{this.isEnabled "about" "about_enabled"}} @onClick={{fn this.controller.openSection "about"}} />
            <DwpSectionCard @label="Leaderboard" @colorClass="dwp-card--playground" @enabled={{this.isEnabled "leaderboard" "leaderboard_enabled"}} @onClick={{fn this.controller.openSection "leaderboard"}} />
            <DwpSectionCard @label="Topics" @colorClass="dwp-card--settings" @enabled={{this.isEnabled "topics" "topics_enabled"}} @onClick={{fn this.controller.openSection "topics"}} />
            <DwpSectionCard @label="FAQ" @colorClass="dwp-card--support" @enabled={{this.isEnabled "faq" "faq_enabled"}} @onClick={{fn this.controller.openSection "faq"}} />
            <DwpSectionCard @label="App CTA" @colorClass="dwp-card--admin" @enabled={{this.isEnabled "app_cta" "show_app_ctas"}} @onClick={{fn this.controller.openSection "app_cta"}} />
          </div>
        {{/if}}
      </:content>
    </DwpPageLayout>
  </template>

  isEnabled = (type, key) => {
    return this.controller.getValue(type, key) === "true";
  };
}
