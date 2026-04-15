import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { htmlSafe } from "@ember/template";
import { getIcon } from "./dwp-icons";

export default class DwpSectionCard extends Component {
  get iconHtml() {
    if (!this.args.icon) return null;
    return htmlSafe(getIcon(this.args.icon));
  }

  <template>
    <button class="dwp-section-card {{@colorClass}}" type="button" {{on "click" @onClick}}>
      {{#if this.iconHtml}}
        <span class="dwp-section-card__icon">{{this.iconHtml}}</span>
      {{/if}}
      <span class="dwp-section-card__label">{{@label}}</span>
      {{#if @desc}}
        <span class="dwp-section-card__desc">{{@desc}}</span>
      {{/if}}
      <span class="dwp-section-card__badge {{if @enabled 'dwp-section-card__badge--on' 'dwp-section-card__badge--off'}}">
        {{if @enabled "Enabled" "Disabled"}}
      </span>
    </button>
  </template>
}
