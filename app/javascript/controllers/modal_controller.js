import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar", "overlay"];

  connect() {
    setTimeout(() => {
      this.overlayTarget.classList.remove("opacity-0");
      this.overlayTarget.classList.add("opacity-100");

      this.sidebarTarget.classList.remove("opacity-0", "translate-y-full", "md:translate-y-4", "md:scale-95");
      this.sidebarTarget.classList.add("opacity-100", "translate-y-0", "md:scale-100");
    }, 50);
  }

  close() {
    this.overlayTarget.classList.remove("opacity-100");
    this.overlayTarget.classList.add("opacity-0");

    this.sidebarTarget.classList.remove("opacity-100", "translate-y-0", "md:scale-100");
    this.sidebarTarget.classList.add("opacity-0", "translate-y-full", "md:translate-y-4", "md:scale-95");

    setTimeout(() => {
      this.element.parentElement.removeAttribute("src");
      this.element.remove();
    }, 250);
  }
}
