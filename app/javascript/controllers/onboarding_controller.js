import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "step",
    "indicator",
    "progressLine",
    "slugPreview",
    "input",
    "colorPreview",
    "currentStep",
    "otherInput",
  ];
  static values = { step: { type: Number, default: 0 } };

  connect() {
    this.#safeUpdateSlug();
    this.#initializeColor();
    this.#updateIndicators();
    this.#updateProgressLines();
    this.#updateCurrentStepText();
    console.log("connect onboat");
  }

  stepValueChanged() {
    this.#updateVisibleStep();
    this.#updateIndicators();
    this.#updateProgressLines();
    this.#updateCurrentStepText();
  }

  updateSlug() {
    if (!this.hasInputTarget) return;

    const name = this.inputTarget.value;
    const slug = name.length > 0 ? this.slugify(name) : "tu-tienda";

    this.slugPreviewTargets.forEach((target) => {
      target.textContent = slug;
    });
  }

  updateColor(event) {
    const color = event.target.value;

    this.colorPreviewTargets.forEach((target) => {
      target.style.backgroundColor = color;
    });
  }

  updateIndustry(event) {
    const industry = event.target.value;

    if (industry === "Otro") {
      this.showOtherInput();
    } else {
      this.hideOtherInput();
    }
  }

  slugify(text) {
    return text
      .toString()
      .toLowerCase()
      .trim()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .replace(/\s+/g, "-")
      .replace(/[^\w\-]+/g, "")
      .replace(/\-\-+/g, "-");
  }

  showOtherInput() {
    this.otherInputTarget.classList.remove("hidden");
    this.otherInputTarget.classList.add("animate-fade-in");
  }

  hideOtherInput() {
    this.otherInputTarget.classList.add("hidden");
  }

  continue(event) {
    event.preventDefault();

    const currentStepElement = this.stepTargets[this.stepValue];

    // Add exit animation
    if (currentStepElement) {
      currentStepElement.classList.add("opacity-0", "scale-95");
    }

    // Validate current step fields
    const inputs = currentStepElement.querySelectorAll(
      "input, select, textarea",
    );
    let isValid = true;

    inputs.forEach((input) => {
      if (!input.reportValidity()) {
        isValid = false;
      }
    });

    if (!isValid) return;

    setTimeout(() => {
      this.stepValue = this.stepValue + 1;
    }, 150);
  }

  // Private methods

  #safeUpdateSlug() {
    if (this.hasInputTarget && this.hasSlugPreviewTarget) {
      this.updateSlug();
    }
  }

  #initializeColor() {
    const checkedRadio = this.element.querySelector(
      'input[name*="primary_color"]:checked',
    );

    if (checkedRadio && this.hasColorPreviewTarget) {
      const color = checkedRadio.value;
      this.colorPreviewTargets.forEach((target) => {
        target.style.backgroundColor = color;
      });
    }
  }

  #updateVisibleStep() {
    this.stepTargets.forEach((step, index) => {
      const isHidden = index !== this.stepValue;
      step.classList.toggle("hidden", isHidden);

      if (!isHidden) {
        // Reset animation classes for entrance
        step.classList.remove("opacity-0", "scale-95");
        step.classList.add("opacity-100", "scale-100");
      }
    });
  }

  #updateIndicators() {
    this.indicatorTargets.forEach((indicator, index) => {
      const isCompleted = index < this.stepValue;
      const isCurrent = index === this.stepValue;

      indicator.classList.remove(
        "bg-indigo-500",
        "bg-white",
        "bg-gray-100",
        "text-white",
        "text-gray-500",
        "ring-2",
        "ring-indigo-500",
        "ring-offset-2",
        "shadow-lg",
        "shadow-indigo-500/30",
      );

      if (isCompleted) {
        indicator.classList.add(
          "bg-indigo-500",
          "text-white",
          "shadow-lg",
          "shadow-indigo-500/30",
        );
      } else if (isCurrent) {
        indicator.classList.add(
          "bg-white",
          "ring-2",
          "ring-indigo-500",
          "ring-offset-2",
          "shadow-lg",
        );
      } else {
        indicator.classList.add("bg-gray-100", "text-gray-500");
      }
    });
  }

  #updateProgressLines() {
    if (!this.hasProgressLineTarget) return;

    this.progressLineTargets.forEach((line, index) => {
      const isCompleted = index < this.stepValue;
      line.style.width = isCompleted ? "100%" : "0%";
    });
  }

  #updateCurrentStepText() {
    if (this.hasCurrentStepTarget) {
      this.currentStepTarget.textContent = this.stepValue + 1;
    }
  }
}
