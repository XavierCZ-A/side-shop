import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar"];

  connect() {
    setTimeout(() => {
      this.sidebarTarget.classList.remove("opacity-0", "scale-95");
      this.sidebarTarget.classList.add("opacity-100", "scale-100");
    }, 50);

    // this.element.addEventListener("turbo:submit-end", (event) => {
    //   if (event.detail.success) {
    //     Turbo.visit(event.detail.fetchResponse.response.url);
    //   }
    // });
  }

  close() {
    this.sidebarTarget.classList.remove("opacity-100", "scale-100");
    this.sidebarTarget.classList.add("opacity-0", "scale-95");

    setTimeout(() => {
      this.element.parentElement.removeAttribute("src");
      this.element.remove();
    }, 250);
  }
}
