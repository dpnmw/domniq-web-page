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
            <DwpSectionCard @label="Hero" @desc="Title, buttons, background, and contributors" @icon="hero" @colorClass="dwp-card--branding" @enabled={{true}} @onClick={{fn this.controller.openSection "hero"}} />
            <DwpSectionCard @label="Stats" @desc="Animated counters for community metrics" @icon="stats" @colorClass="dwp-card--features" @enabled={{this.isEnabled "stats" "stats_enabled"}} @onClick={{fn this.controller.openSection "stats"}} @locked={{this.controller.isLocked}} />
            <DwpSectionCard @label="About" @desc="Community description with image and quote" @icon="about" @colorClass="dwp-card--community" @enabled={{this.isEnabled "about" "about_enabled"}} @onClick={{fn this.controller.openSection "about"}} @locked={{this.controller.isLocked}} />
            <DwpSectionCard @label="Leaderboard" @desc="Top contributors with bios and stats" @icon="leaderboard" @colorClass="dwp-card--playground" @enabled={{this.isEnabled "leaderboard" "leaderboard_enabled"}} @onClick={{fn this.controller.openSection "leaderboard"}} @locked={{this.controller.isLocked}} />
            <DwpSectionCard @label="Topics" @desc="Trending discussions with engagement data" @icon="topics" @colorClass="dwp-card--settings" @enabled={{this.isEnabled "topics" "topics_enabled"}} @onClick={{fn this.controller.openSection "topics"}} @locked={{this.controller.isLocked}} />
            <DwpSectionCard @label="FAQ" @desc="Accordion Q&A with optional image" @icon="faq" @colorClass="dwp-card--support" @enabled={{this.isEnabled "faq" "faq_enabled"}} @onClick={{fn this.controller.openSection "faq"}} @locked={{this.controller.isLocked}} />
            <DwpSectionCard @label="App CTA" @desc="App download badges and gradient background" @icon="appcta" @colorClass="dwp-card--admin" @enabled={{this.isEnabled "app_cta" "show_app_ctas"}} @onClick={{fn this.controller.openSection "app_cta"}} @locked={{this.controller.isLocked}} />
          </div>
        {{/if}}
      </:content>
    </DwpPageLayout>
  </template>

  isEnabled = (type, key) => {
    return this.controller.getValue(type, key) === "true";
  };
}
