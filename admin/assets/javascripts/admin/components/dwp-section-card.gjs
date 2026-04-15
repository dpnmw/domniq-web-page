import Component from "@glimmer/component";
import { on } from "@ember/modifier";

export default class DwpSectionCard extends Component {
  <template>
    <button class="dwp-section-card {{@colorClass}}" type="button" {{on "click" @onClick}}>
      <span class="dwp-section-card__label">{{@label}}</span>
      <span class="dwp-section-card__badge {{if @enabled 'dwp-section-card__badge--on' 'dwp-section-card__badge--off'}}">
        {{if @enabled "Enabled" "Disabled"}}
      </span>
    </button>
  </template>
}
