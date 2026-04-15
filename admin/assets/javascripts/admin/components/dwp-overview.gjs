import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import DwpPageLayout from "./dwp-page-layout";
import { getIcon } from "./dwp-icons";

const FEATURES = [
  { title: "Hero", desc: "Title, subtitle, buttons, background image, video, and contributor pills.", color: "--blue", icon: "hero" },
  { title: "Stats", desc: "Live member count, topics, posts, likes, and chats with animated counters.", color: "--teal", icon: "stats" },
  { title: "About", desc: "Community description with image, quote marks, and author card.", color: "--orange", icon: "about" },
  { title: "Leaderboard", desc: "Top contributors with bios, stats, and avatars.", color: "--pink", icon: "leaderboard" },
  { title: "Topics", desc: "Trending discussions with category badges and engagement stats.", color: "--purple", icon: "topics" },
  { title: "FAQ", desc: "Accordion Q&A with optional showcase image.", color: "--gold", icon: "faq" },
  { title: "App CTA", desc: "App download section with iOS/Android badges and gradient background.", color: "--blue", icon: "appcta" },
  { title: "Navbar", desc: "Logo, theme toggle, social icons, sign in and join buttons.", color: "--teal", icon: "navbar" },
  { title: "Footer", desc: "Links, description, copyright, and optional logo.", color: "--orange", icon: "footer" },
];

export default class DwpOverview extends Component {
  features = FEATURES;

  iconFor = (name) => htmlSafe(getIcon(name));

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
                {{this.iconFor feature.icon}}
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
