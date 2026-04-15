import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { on } from "@ember/modifier";
import { fn } from "@ember/helper";

const SECTION_LABELS = {
  hero: "Hero",
  stats: "Stats",
  about: "About",
  leaderboard: "Leaderboard",
  topics: "Topics",
  faq: "FAQ",
  app_cta: "App CTA",
};

export default class DwpSortOrder extends Component {
  get items() {
    const val = this.args.value || "";
    return val.split("|").map((s) => s.trim()).filter(Boolean);
  }

  label(key) {
    return SECTION_LABELS[key] || key;
  }

  emit(newItems) {
    this.args.onChange?.(this.args.configKey, newItems.join("|"));
  }

  @action
  moveUp(index) {
    if (index === 0) return;
    const items = [...this.items];
    [items[index - 1], items[index]] = [items[index], items[index - 1]];
    this.emit(items);
  }

  @action
  moveDown(index) {
    const items = [...this.items];
    if (index >= items.length - 1) return;
    [items[index], items[index + 1]] = [items[index + 1], items[index]];
    this.emit(items);
  }

  <template>
    <div class="dwp-sort-order">
      {{#each this.items as |item index|}}
        <div class="dwp-sort-order__item">
          <div class="dwp-sort-order__arrows">
            <button
              type="button"
              class="dwp-sort-order__arrow {{if (eq index 0) 'dwp-sort-order__arrow--disabled'}}"
              aria-label="Move up"
              {{on "click" (fn this.moveUp index)}}
            >&#9650;</button>
            <button
              type="button"
              class="dwp-sort-order__arrow {{if (isLast index this.items) 'dwp-sort-order__arrow--disabled'}}"
              aria-label="Move down"
              {{on "click" (fn this.moveDown index)}}
            >&#9660;</button>
          </div>
          <span class="dwp-sort-order__position">{{add index 1}}</span>
          <span class="dwp-sort-order__label">{{this.label item}}</span>
        </div>
      {{/each}}
    </div>
  </template>
}

function eq(a, b) {
  return a === b;
}

function isLast(index, items) {
  return index >= items.length - 1;
}

function add(a, b) {
  return a + b;
}
