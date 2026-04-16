import Component from "@glimmer/component";
import DPageSubheader from "discourse/components/d-page-subheader";
import { i18n } from "discourse-i18n";
import APP_VERSION from "./dwp-version";

export default class DwpPageLayout extends Component {
  get currentYear() {
    return new Date().getFullYear();
  }

  <template>
    <section class="dwp-page">

      {{! Hero }}
      <div class="dwp-page__hero">
        <div class="dwp-page__hero-glow"></div>
        <div class="dwp-page__hero-content">
          <div class="dwp-page__icon">
            {{yield to="icon"}}
          </div>
          <DPageSubheader
            @titleLabel={{i18n @titleLabel}}
            @descriptionLabel={{i18n @descriptionLabel}}
          />
          <div class="dwp-page__version">
            <span class="dwp-page__version-badge">v{{APP_VERSION}}</span>
          </div>
        </div>
      </div>

      {{! Content }}
      <div class="dwp-page__content">
        {{yield to="content"}}
      </div>

      {{! Footer }}
      <div class="dwp-page__footer">
        <div class="dwp-page__footer-divider"></div>
        <p class="dwp-page__footer-text">
          Powered by <a href="https://domniq.app" target="_blank" rel="noopener noreferrer">Domniq</a> — A Premium Welcome Page Plugin
        </p>
        <p class="dwp-page__footer-copy">
          &copy; {{this.currentYear}} <a href="https://dpnmediaworks.com" target="_blank" rel="noopener noreferrer">DPN MEDIA WORKS</a>. All rights reserved.
        </p>
      </div>

    </section>
  </template>
}
