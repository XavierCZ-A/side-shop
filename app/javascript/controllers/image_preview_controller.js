import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "dropzone", "counter"]
  static values = { maxFiles: { type: Number, default: 2 } }

  connect() {
    this.files = new DataTransfer()
  }

  selectFiles(event) {
    const newFiles = Array.from(event.target.files)
    this.#addFiles(newFiles)
  }

  dragOver(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add("ring-purple-500", "bg-purple-50")
  }

  dragLeave(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("ring-purple-500", "bg-purple-50")
  }

  drop(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("ring-purple-500", "bg-purple-50")
    const newFiles = Array.from(event.dataTransfer.files)
    this.#addFiles(newFiles)
  }

  remove(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    const dt = new DataTransfer()
    const currentFiles = Array.from(this.files.files)

    currentFiles.forEach((file, i) => {
      if (i !== index) dt.items.add(file)
    })

    this.files = dt
    this.inputTarget.files = this.files.files
    this.#renderPreviews()
  }

  #addFiles(newFiles) {
    const allowedTypes = ["image/jpeg", "image/png", "image/webp"]

    for (const file of newFiles) {
      if (this.files.files.length >= this.maxFilesValue) break;
      if (!allowedTypes.includes(file.type)) continue;
      if (file.size > 10 * 1024 * 1024) continue;
      this.files.items.add(file);
    }

    this.inputTarget.files = this.files.files;
    this.#renderPreviews();
  }

  #renderPreviews() {
    this.previewTarget.innerHTML = "";

    const count = this.files.files.length
    this.counterTarget.textContent = `${count} / ${this.maxFilesValue}`
    this.counterTarget.classList.toggle("text-red-500", count >= this.maxFilesValue)
    this.counterTarget.classList.toggle("text-gray-400", count < this.maxFilesValue)

    const placeholder = this.dropzoneTarget.querySelector("[data-placeholder]")
    if (placeholder) {
      placeholder.style.display = count >= this.maxFilesValue ? "none" : ""
    }

    Array.from(this.files.files).forEach((file, index) => {
      const reader = new FileReader()
      reader.onload = (e) => {
        const card = document.createElement("div")
        card.className = "relative group"
        card.innerHTML = `
          <div class="relative w-20 h-20 rounded-xl overflow-hidden ring-1 ring-gray-200 shadow-sm">
            <img src="${e.target.result}" alt="${file.name}" class="w-full h-full object-cover" />
            <button type="button"
              data-action="image-preview#remove"
              data-index="${index}"
              class="absolute inset-0 flex items-center justify-center bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer">
              <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
              </svg>
            </button>
          </div>
          <p class="text-[10px] text-gray-400 mt-1 truncate w-20 text-center">${file.name}</p>
        `
        this.previewTarget.appendChild(card)
      }
      reader.readAsDataURL(file)
    })
  }
}
