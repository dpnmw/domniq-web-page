import Component from "@glimmer/component";
import DPageSubheader from "discourse/components/d-page-subheader";
import { i18n } from "discourse-i18n";
import DwpPageLayout from "./dwp-page-layout";

const FEATURES = [
  { title: "Hero", desc: "Title, subtitle, buttons, background image, video, and contributor pills.", color: "--blue" },
  { title: "Stats", desc: "Live member count, topics, posts, likes, and chats with animated counters.", color: "--teal" },
  { title: "About", desc: "Community description with image, quote marks, and author card.", color: "--orange" },
  { title: "Leaderboard", desc: "Top contributors with bios, stats, and avatars.", color: "--pink" },
  { title: "Topics", desc: "Trending discussions with category badges and engagement stats.", color: "--purple" },
  { title: "FAQ", desc: "Accordion Q&A with optional showcase image.", color: "--gold" },
  { title: "App CTA", desc: "App download section with iOS/Android badges and gradient background.", color: "--blue" },
  { title: "Navbar", desc: "Logo, theme toggle, social icons, sign in and join buttons.", color: "--teal" },
  { title: "Footer", desc: "Links, description, copyright, and optional logo.", color: "--orange" },
];

export default class DwpOverview extends Component {
  features = FEATURES;

  <template>
    <DwpPageLayout @titleLabel="dwp.admin.overview_title" @descriptionLabel="dwp.admin.overview_description">
      <:icon>
        <svg viewBox="0 -960 960 960" width="24" height="24" fill="white"><path d="M186.67-120q-27 0-46.84-19.83Q120-159.67 120-186.67v-586.66q0-27 19.83-46.84Q159.67-840 186.67-840h586.66q27 0 46.84 19.83Q840-800.33 840-773.33v586.66q0 27-19.83 46.84Q800.33-120 773.33-120H186.67Z"/></svg>
      </:icon>
      <:content>
        <div class="dwp-overview__intro">
          <p class="dwp-overview__intro-text">
            This plugin renders a premium landing page for logged-out visitors. Configure every section, colour, font, and animation from this admin panel. Image uploads are managed in the Settings tab.
          </p>
        </div>
        <div class="dwp-sections-grid">
          {{#each this.features as |feature|}}
            <div class="dwp-overview__feature">
              <div class="dwp-overview__feature-icon dwp-overview__feature-icon{{feature.color}}">
                <svg viewBox="0 -960 960 960" width="22" height="22" fill="white"><path d="M480-80q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-155.5t86-127Q252-817 325-848.5T480-880q83 0 155.5 31.5t127 86q54.5 54.5 86 127T880-480q0 82-31.5 155t-86 127.5q-54.5 54.5-127 86T480-80Z"/></svg>
              </div>
              <h3 class="dwp-overview__feature-title">{{feature.title}}</h3>
              <p class="dwp-overview__feature-desc">{{feature.desc}}</p>
            </div>
          {{/each}}
        </div>
      </:content>
    </DwpPageLayout>
  </template>
}
