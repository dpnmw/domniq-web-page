import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { on } from "@ember/modifier";

export default class DwpAccordion extends Component {
  @tracked isOpen = this.args.open ?? false;

  @action
  toggle() {
    this.isOpen = !this.isOpen;
  }

  <template>
    <div class="dwp-accordion {{if this.isOpen 'dwp-accordion--open'}}">
      <button class="dwp-accordion__header" type="button" {{on "click" this.toggle}}>
        <span class="dwp-accordion__title">
          {{#if @icon}}
            <span class="dwp-accordion__icon"><i class="fa-solid fa-{{@icon}}"></i></span>
          {{/if}}
          {{@title}}
        </span>
        <span class="dwp-accordion__toggle">
          {{#if this.isOpen}}
            <i class="fa-solid fa-xmark"></i>
          {{else}}
            <i class="fa-solid fa-plus"></i>
          {{/if}}
        </span>
      </button>
      {{#if this.isOpen}}
        <div class="dwp-accordion__body {{if @dimmed 'dwp-accordion__body--dimmed'}}">
          {{yield}}
        </div>
      {{/if}}
    </div>
  </template>
}
