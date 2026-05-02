module StorefrontsHelper
  VIBE_TOKENS = {
    "editorial" => {
      key:                 "editorial",
      label:               "Editorial",
      description:         "Serif elegante, alto contraste",
      primary:             "#111111",
      primary_foreground:  "#ffffff",
      bg:                  "#fafaf7",
      fg:                  "#111111",
      muted:               "#6b6b6b",
      surface:             "#f1efe9",
      font_heading:        '"Playfair Display", Georgia, serif',
      font_body:           '"DM Sans", system-ui, sans-serif',
      preview_font_class:  "font-serif"
    },
    "organic" => {
      key:                 "organic",
      label:               "Orgánico",
      description:         "Tonos cálidos y naturales",
      primary:             "#3a5a40",
      primary_foreground:  "#f6f3ec",
      bg:                  "#f6f1e7",
      fg:                  "#2c2a25",
      muted:               "#7a7468",
      surface:             "#ece4d2",
      font_heading:        '"Fraunces", Georgia, serif',
      font_body:           '"Nunito", system-ui, sans-serif',
      preview_font_class:  "font-serif font-medium"
    },
    "modern" => {
      key:                 "modern",
      label:               "Moderno",
      description:         "Geométrico y minimalista",
      primary:             "#2563eb",
      primary_foreground:  "#ffffff",
      bg:                  "#ffffff",
      fg:                  "#0a0a0a",
      muted:               "#737373",
      surface:             "#f4f4f5",
      font_heading:        '"Space Grotesk", system-ui, sans-serif',
      font_body:           '"Inter", system-ui, sans-serif',
      preview_font_class:  "font-sans"
    }
  }.freeze

  def vibe_tokens(store)
    VIBE_TOKENS.fetch(store.vibe, VIBE_TOKENS["editorial"])
  end

  def vibe_options
    VIBE_TOKENS.values.map do |t|
      {
        value:      t[:key],
        label:      t[:label],
        subtitle:   t[:description],
        swatch:     t[:bg],
        dot:        t[:primary],
        font_class: t[:preview_font_class]
      }
    end
  end

  def storefront_css_vars(store)
    t = vibe_tokens(store)
    [
      "--sp-radius: #{store.border_radius}px",
      "--sp-aspect: #{store.aspect_ratio.sub(':', ' / ')}",
      "--sp-font-heading: #{t[:font_heading]}",
      "--sp-font-body: #{t[:font_body]}",
      "--sp-color-primary: #{t[:primary]}",
      "--sp-color-primary-foreground: #{t[:primary_foreground]}",
      "--sp-color-bg: #{t[:bg]}",
      "--sp-color-fg: #{t[:fg]}",
      "--sp-color-muted: #{t[:muted]}",
      "--sp-color-surface: #{t[:surface]}"
    ].join("; ")
  end

  def storefront_classes(store)
    classes = [ "storefront-preview" ]
    classes << "storefront-grain" if store.grain_enabled
    classes.join(" ")
  end

  def storefront_body_attrs(store)
    {
      class: storefront_classes(store),
      style: "background-color: var(--sp-color-bg); font-family: var(--sp-font-body); color: var(--sp-color-fg);",
      data: {
        hero_layout: store.hero_layout,
        aspect_ratio: store.aspect_ratio
      }
    }
  end
end
