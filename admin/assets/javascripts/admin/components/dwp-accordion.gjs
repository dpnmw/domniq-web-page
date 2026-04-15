import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";

export default class DwpAccordion extends Component {
  @tracked isOpen = this.args.open ?? false;

  @action
  toggle() {
    this.isOpen = !this.isOpen;
  }

  <template>
    <div class="dwp-accordion {{if this.isOpen 'dwp-accordion--open'}}">
      <button class="dwp-accordion__header" type="button" {{on "click" this.toggle}}>
        <span class="dwp-accordion__title">{{@title}}</span>
        <span class="dwp-accordion__chevron">&#9662;</span>
      </button>
      {{#if this.isOpen}}
        <div class="dwp-accordion__body {{if @dimmed 'dwp-accordion__body--dimmed'}}">
          {{yield}}
        </div>
      {{/if}}
    </div>
  </template>
}

import { on } from "@ember/modifier";
