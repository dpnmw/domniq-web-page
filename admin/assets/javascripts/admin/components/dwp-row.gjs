import Component from "@glimmer/component";

export default class DwpRow extends Component {
  <template>
    <div class="dwp-row">
      <div class="dwp-row__label">
        <span class="dwp-row__title">{{@title}}</span>
        {{#if @desc}}<span class="dwp-row__desc">{{@desc}}</span>{{/if}}
      </div>
      <div class="dwp-row__control">
        {{yield}}
      </div>
    </div>
  </template>
}
